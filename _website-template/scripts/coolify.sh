#!/usr/bin/env bash
# Coolify API helper — wraps the endpoints used by /niche-launch.
#
# Usage:
#   source scripts/coolify.sh
#   coolify_create_project   "rf-site" "Rafter Elite niche site"
#   coolify_create_static_app --project-uuid "..." --server-uuid "..." --repo "github.com/org/rafterelite" --branch "main" --name "rf-site"
#   coolify_add_domain       --app-uuid "..." --domains "https://rafterelite.com,https://www.rafterelite.com"
#   coolify_deploy           --app-uuid "..."
#
# Expects these env vars (sourced from ~/.claude/env.local):
#   COOLIFY_API_TOKEN
#   COOLIFY_BASE_URL
#
# Every function echoes the raw API response on stderr and the parsed UUID (if any) on stdout.

set -euo pipefail

# shellcheck disable=SC1091
[[ -f "$HOME/.claude/env.local" ]] && source "$HOME/.claude/env.local"

: "${COOLIFY_API_TOKEN:?COOLIFY_API_TOKEN not set — check ~/.claude/env.local}"
: "${COOLIFY_BASE_URL:?COOLIFY_BASE_URL not set — check ~/.claude/env.local}"

_coolify_curl() {
  local method="$1"; shift
  local path="$1"; shift
  local body="${1:-}"

  local url="${COOLIFY_BASE_URL%/}${path}"
  if [[ -n "$body" ]]; then
    curl -sS -X "$method" "$url" \
      -H "Authorization: Bearer $COOLIFY_API_TOKEN" \
      -H "Content-Type: application/json" \
      -d "$body"
  else
    curl -sS -X "$method" "$url" \
      -H "Authorization: Bearer $COOLIFY_API_TOKEN" \
      -H "Content-Type: application/json"
  fi
}

coolify_list_servers() {
  _coolify_curl GET /api/v1/servers
}

coolify_list_projects() {
  _coolify_curl GET /api/v1/projects
}

coolify_create_project() {
  local name="$1"
  local description="${2:-}"
  local payload
  payload=$(printf '{"name":"%s","description":"%s"}' "$name" "$description")
  local response
  response=$(_coolify_curl POST /api/v1/projects "$payload")
  echo "$response" >&2
  echo "$response" | jq -r '.uuid // .project.uuid // empty'
}

coolify_create_static_app() {
  # Create a public-repo static application using nixpacks' staticfile provider.
  #
  # CRITICAL: do NOT pass `custom_nginx_configuration` on create. Coolify's API
  # requires that field to be base64-encoded on submit but does NOT decode it
  # at deploy time — the raw base64 string ends up written to nginx's config
  # file and nginx crashes in a restart loop with "unexpected end of file".
  # Nixpacks' default staticfile nginx config already supports `.html` extension
  # fallback (pretty URLs like /contact resolve to /contact.html), so there is
  # nothing to customize here. Leave the field alone.
  #
  # Required: --project-uuid, --server-uuid, --repo, --branch, --name
  # Optional: --domains (comma-separated "https://a.com,https://www.a.com")
  local project_uuid="" server_uuid="" repo="" branch="main" name="" domains=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --project-uuid) project_uuid="$2"; shift 2;;
      --server-uuid)  server_uuid="$2";  shift 2;;
      --repo)         repo="$2";         shift 2;;
      --branch)       branch="$2";       shift 2;;
      --name)         name="$2";         shift 2;;
      --domains)      domains="$2";      shift 2;;
      *) echo "Unknown arg: $1" >&2; return 1;;
    esac
  done

  local payload
  payload=$(jq -nc \
    --arg project_uuid "$project_uuid" \
    --arg server_uuid "$server_uuid" \
    --arg environment_name "production" \
    --arg git_repository "$repo" \
    --arg git_branch "$branch" \
    --arg build_pack "nixpacks" \
    --arg static_image "nginx:alpine" \
    --arg name "$name" \
    --arg domains "$domains" \
    --arg ports_exposes "80" \
    --arg base_directory "/" \
    --arg publish_directory "/" \
    '{
      project_uuid: $project_uuid,
      server_uuid: $server_uuid,
      environment_name: $environment_name,
      git_repository: $git_repository,
      git_branch: $git_branch,
      build_pack: $build_pack,
      static_image: $static_image,
      name: $name,
      domains: $domains,
      ports_exposes: $ports_exposes,
      base_directory: $base_directory,
      publish_directory: $publish_directory,
      is_static: true,
      instant_deploy: false
    }')
  local response
  response=$(_coolify_curl POST /api/v1/applications/public "$payload")
  echo "$response" >&2
  echo "$response" | jq -r '.uuid // empty'
}

coolify_add_domain() {
  local app_uuid="" domains=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --app-uuid) app_uuid="$2"; shift 2;;
      --domains)  domains="$2";  shift 2;;
      *) echo "Unknown arg: $1" >&2; return 1;;
    esac
  done
  local payload
  payload=$(jq -nc --arg d "$domains" '{fqdn: $d}')
  _coolify_curl PATCH "/api/v1/applications/$app_uuid" "$payload"
}

coolify_deploy() {
  local app_uuid=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --app-uuid) app_uuid="$2"; shift 2;;
      *) echo "Unknown arg: $1" >&2; return 1;;
    esac
  done
  _coolify_curl POST "/api/v1/deploy?uuid=$app_uuid&force=false"
}

# Simple smoke test: `bash scripts/coolify.sh check`
if [[ "${1:-}" == "check" ]]; then
  echo "Coolify base URL: $COOLIFY_BASE_URL"
  echo "--- Servers ---"
  coolify_list_servers | jq '.'
  echo "--- Projects ---"
  coolify_list_projects | jq '.'
fi
