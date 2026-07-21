#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
env_file=${1:-"$script_dir/.env"}
secret_dir="$script_dir/secrets"

if [ ! -f "$env_file" ]; then
  echo "ntfy secret rendering failed: $env_file does not exist" >&2
  exit 1
fi

read_env_value() {
  key=$1
  value=$(sed -n "s/^${key}=//p" "$env_file" | tail -n 1 | tr -d '\r')

  case "$value" in
    \"*\") value=${value#\"}; value=${value%\"} ;;
    \'*\') value=${value#\'}; value=${value%\'} ;;
  esac

  printf '%s' "$value"
}

ntfy_topic=$(read_env_value NTFY_TOPIC)
ntfy_token=$(read_env_value NTFY_TOKEN)

case "$ntfy_topic" in
  ""|replace-*|*[!A-Za-z0-9_-]*)
    echo "ntfy secret rendering failed: set a private alphanumeric NTFY_TOPIC" >&2
    exit 1
    ;;
esac

case "$ntfy_token" in
  ""|tk_replace-*)
    echo "ntfy secret rendering failed: set NTFY_TOKEN" >&2
    exit 1
    ;;
esac

umask 077
mkdir -p "$secret_dir"
chmod 700 "$secret_dir"

printf '%s\n' "https://ntfy.sh/${ntfy_topic}?template=alertmanager" \
  > "$secret_dir/ntfy_webhook_url"
printf '%s\n' "$ntfy_token" > "$secret_dir/ntfy_token"

# Local Compose secrets use bind mounts. The enclosing 0700 directory protects
# the source files on the host; read permission is needed by Alertmanager's
# non-root container user.
chmod 644 "$secret_dir/ntfy_webhook_url" "$secret_dir/ntfy_token"

echo "Rendered ntfy secret files under $secret_dir"
