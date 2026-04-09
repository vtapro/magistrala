#!/usr/bin/env bash
set -euo pipefail

# Build and optionally push Magistrala images for Kubernetes deployments.
#
# Example:
#   REGISTRY=registry.example.com/magistrala TAG=v0.18.0 PUSH=true ./docker/k8s/build-images.sh
#   PROFILE=core TAG=staging ./docker/k8s/build-images.sh

REGISTRY="${REGISTRY:-ghcr.io/absmach/magistrala}"
TAG="${TAG:-latest}"
PROFILE="${PROFILE:-api}" # api | core | full
PUSH="${PUSH:-false}"      # true | false
INCLUDE_CLI="${INCLUDE_CLI:-false}"

GOARCH="${GOARCH:-amd64}"
GOARM="${GOARM:-}"

MG_MESSAGE_BROKER_TYPE="${MG_MESSAGE_BROKER_TYPE:-msg_fluxmq}"
MG_ES_TYPE="${MG_ES_TYPE:-es_fluxmq}"
BUILD_TAGS="${BUILD_TAGS:-${MG_MESSAGE_BROKER_TYPE} ${MG_ES_TYPE}}"

VERSION="${VERSION:-${TAG}}"
COMMIT="${COMMIT:-$(git rev-parse HEAD)}"
TIME="${TIME:-$(date +%F_%T)}"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker command not found in PATH"
  exit 1
fi

CORE_SERVICES=(
  auth
  users
  clients
  groups
  channels
  domains
  notifications
  notifiers-api
  journal
  re
  alarms
  reports
  certs
  fluxmq
)

API_SERVICES=(
  auth
  users
  clients
  groups
  channels
  domains
  notifications
  notifiers-api
  journal
  re
  alarms
  reports
  certs
  bootstrap
  timescale-reader
)

ADDON_SERVICES=(
  bootstrap
  provision
  postgres-writer
  postgres-reader
  timescale-writer
  timescale-reader
)

case "${PROFILE}" in
  api)
    SERVICES=("${API_SERVICES[@]}")
    ;;
  core)
    SERVICES=("${CORE_SERVICES[@]}")
    ;;
  full)
    SERVICES=("${CORE_SERVICES[@]}" "${ADDON_SERVICES[@]}")
    ;;
  *)
    echo "Unsupported PROFILE='${PROFILE}'. Use 'api', 'core' or 'full'."
    exit 1
    ;;
esac

if [[ "${INCLUDE_CLI}" == "true" ]]; then
  SERVICES+=("cli")
fi

echo "Registry      : ${REGISTRY}"
echo "Tag           : ${TAG}"
echo "Profile       : ${PROFILE}"
echo "Push          : ${PUSH}"
echo "Include CLI   : ${INCLUDE_CLI}"
echo "GOARCH/GOARM  : ${GOARCH}/${GOARM}"
echo "Build tags    : ${BUILD_TAGS}"
echo "Services (${#SERVICES[@]}): ${SERVICES[*]}"
echo

for svc in "${SERVICES[@]}"; do
  image="${REGISTRY}/${svc}:${TAG}"
  echo "==> Building ${image}"

  docker build \
    --build-arg "SVC=${svc}" \
    --build-arg "GOARCH=${GOARCH}" \
    --build-arg "GOARM=${GOARM}" \
    --build-arg "VERSION=${VERSION}" \
    --build-arg "COMMIT=${COMMIT}" \
    --build-arg "TIME=${TIME}" \
    --build-arg "BUILD_TAGS=${BUILD_TAGS}" \
    --tag "${image}" \
    -f docker/Dockerfile .

  if [[ "${PUSH}" == "true" ]]; then
    echo "==> Pushing ${image}"
    docker push "${image}"
  fi
done

echo
echo "Done. Built ${#SERVICES[@]} image(s)."
