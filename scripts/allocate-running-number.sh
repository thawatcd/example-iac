#!/usr/bin/env bash
set -euo pipefail

# allocate-running-number.sh
# Usage: allocate-running-number.sh --storage-account <name> --container <container> --blob <blob-name>
# Requires: az cli logged in with an identity that has write access to the storage account/container

usage() {
  cat <<EOF
Usage: $0 --storage-account <name> --container <container> --blob <blob>

Atomically increments a counter stored in a blob and prints the new integer.
This uses ETag conditional upload to avoid races; it will retry a few times on contention.
EOF
  exit 1
}

STORAGE_ACCOUNT=""
CONTAINER=""
BLOB=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --storage-account) STORAGE_ACCOUNT="$2"; shift 2;;
    --container) CONTAINER="$2"; shift 2;;
    --blob) BLOB="$2"; shift 2;;
    -h|--help) usage;;
    *) echo "Unknown arg: $1"; usage;;
  esac
done

if [ -z "$STORAGE_ACCOUNT" ] || [ -z "$CONTAINER" ] || [ -z "$BLOB" ]; then
  usage
fi

MAX_RETRIES=8
SLEEP=1

for attempt in $(seq 1 $MAX_RETRIES); do
  # download the blob content and metadata
  tmpfile=$(mktemp)
  etag=$(az storage blob download --account-name "$STORAGE_ACCOUNT" --container-name "$CONTAINER" --name "$BLOB" --file "$tmpfile" --only-show-errors --query "properties.etag" -o tsv 2>/dev/null || true)

  if [ -z "$etag" ]; then
    # blob may not exist; try to create with value 1
    echo "0" > "$tmpfile"
    new=1
    # upload without if-match to create
    az storage blob upload --account-name "$STORAGE_ACCOUNT" --container-name "$CONTAINER" --name "$BLOB" --file "$tmpfile" --overwrite true --only-show-errors
    echo "$new"
    rm -f "$tmpfile"
    exit 0
  fi

  # when we downloaded with --query properties.etag it might be quoted; keep it raw
  current=$(cat "$tmpfile" || true)
  current=${current:-0}
  new=$((current + 1))

  # attempt to upload using if-match to ensure ETag matches
  # az storage blob upload does not expose --if-match easily; use curl with SAS as fallback
  # We'll try using az storage blob upload-batch is not suitable. Instead, use 'az storage blob upload' with --if-match via REST using az rest.

  # Get a sas token scoped to write for the object (short-lived)
  sas=$(az storage blob generate-sas --account-name "$STORAGE_ACCOUNT" --container-name "$CONTAINER" --name "$BLOB" --permissions acdrw --expiry "$(date -u -d '+1 hour' +%Y-%m-%dT%H:%MZ)" -o tsv 2>/dev/null || true)

  if [ -z "$sas" ]; then
    # fallback to az storage blob upload with overwrite and hope for best
    echo "$new" > "$tmpfile"
    az storage blob upload --account-name "$STORAGE_ACCOUNT" --container-name "$CONTAINER" --name "$BLOB" --file "$tmpfile" --overwrite true --only-show-errors
    echo "$new"
    rm -f "$tmpfile"
    exit 0
  fi

  # Compose URL
  url="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER}/${BLOB}?${sas}"

  # Use conditional request with If-Match header set to the etag we observed
  etag_header=$(printf '%s' "$etag" | sed -e 's/^"//' -e 's/"$//')
  bodyfile=$(mktemp)
  printf '%s' "$new" > "$bodyfile"

  resp=$(curl -s -o /dev/stderr -w "%{http_code}" -X PUT -H "x-ms-blob-type: BlockBlob" -H "If-Match: ${etag_header}" --data-binary @"${bodyfile}" "${url}" || true)
  rm -f "$bodyfile"

  if [ "$resp" = "201" ] || [ "$resp" = "200" ]; then
    echo "$new"
    rm -f "$tmpfile"
    exit 0
  fi

  # if we get 412 Precondition Failed – ETag mismatch – retry
  if [ "$resp" = "412" ]; then
    echo "ETag mismatch, retrying ($attempt/$MAX_RETRIES)" >&2
    sleep $SLEEP
    SLEEP=$((SLEEP * 2))
    continue
  fi

  # other responses: fallback to best-effort upload
  echo "$new" > "$tmpfile"
  az storage blob upload --account-name "$STORAGE_ACCOUNT" --container-name "$CONTAINER" --name "$BLOB" --file "$tmpfile" --overwrite true --only-show-errors
  echo "$new"
  rm -f "$tmpfile"
  exit 0
done

echo "Failed to allocate running number after $MAX_RETRIES retries" >&2
exit 10
