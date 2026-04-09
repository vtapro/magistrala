# Magistrala Service and Endpoint Inventory (K8s Build Scope)

This inventory summarizes what is currently in this repository and what should be built as container images for Kubernetes.

## 1) Service Inventory

### 1.1 Buildable Magistrala binaries in this repo (`cmd/*`)

Total: **20** binaries

1. `alarms`
2. `auth`
3. `bootstrap`
4. `certs`
5. `channels`
6. `cli`
7. `clients`
8. `domains`
9. `fluxmq`
10. `groups`
11. `journal`
12. `notifications`
13. `postgres-reader`
14. `postgres-writer`
15. `provision`
16. `re`
17. `reports`
18. `timescale-reader`
19. `timescale-writer`
20. `users`

### 1.2 Services in default `docker/docker-compose.yaml`

Total: **46** services (application + infrastructure + UI).

Of these, `ghcr.io/absmach/magistrala/*` application images referenced in default compose are **17**:

1. `auth`
2. `domains`
3. `journal`
4. `clients`
5. `channels`
6. `users`
7. `notifications`
8. `groups`
9. `fluxmq`
10. `ui-mg` (external image source, not built from `cmd/*` here)
11. `ui-backend` (external image source, not built from `cmd/*` here)
12. `timescale-reader`
13. `timescale-writer`
14. `re`
15. `alarms`
16. `reports`
17. `certs`

### 1.3 Recommended K8s image build profiles (from this repo)

- `api` profile: 14 images  
  `auth users clients groups channels domains notifications journal re alarms reports certs bootstrap timescale-reader`
- `core` profile: 13 images  
  `auth users clients groups channels domains notifications journal re alarms reports certs fluxmq`
- `full` profile: 19 images  
  `core` + `bootstrap provision postgres-writer postgres-reader timescale-writer timescale-reader`
- Optional: add `cli` when needed for debugging/admin tasks in cluster jobs.

## 2) Endpoint Inventory

### 2.1 HTTP REST endpoints (from `apidocs/openapi/*.yaml`)

Counting rule: number of OpenAPI path+method operations (`get|post|put|patch|delete|head|options|trace`) per file.

Total REST endpoints: **206**

1. `alarms.yaml`: 5
2. `auth.yaml`: 17
3. `bootstrap.yaml`: 11
4. `certs.yaml`: 14
5. `channels.yaml`: 16
6. `clients.yaml`: 28
7. `domains.yaml`: 29
8. `groups.yaml`: 31
9. `http.yaml`: 2
10. `journal.yaml`: 4
11. `notifiers.yaml`: 5
12. `readers.yaml`: 2
13. `reports.yaml`: 10
14. `rules.yaml`: 8
15. `users.yaml`: 24

### 2.2 gRPC API endpoints (from `internal/proto/*.proto`)

Total gRPC services: **9**  
Total RPC methods: **26**

1. `auth/v1/auth.proto`: 1 service, 2 RPCs
2. `certs/v1/certs.proto`: 1 service, 2 RPCs
3. `channels/v1/channels.proto`: 1 service, 5 RPCs
4. `clients/v1/clients.proto`: 1 service, 7 RPCs
5. `domains/v1/domains.proto`: 1 service, 3 RPCs
6. `groups/v1/groups.proto`: 1 service, 1 RPC
7. `readers/v1/readers.proto`: 1 service, 1 RPC
8. `token/v1/token.proto`: 1 service, 4 RPCs
9. `users/v1/users.proto`: 1 service, 1 RPC

## 3) K8s Image Build Files Added

1. `docker/k8s/build-images.sh`
2. `docker/k8s/build-images.ps1`

Both scripts:

- use `docker/Dockerfile`
- support per-profile build (`api`, `core`, `full`)
- support custom registry and tag
- support optional push
- pass `SVC`, `GOARCH`, `GOARM`, `VERSION`, `COMMIT`, `TIME`, `BUILD_TAGS` build args

## 4) Quick Start

### Linux/macOS

```bash
REGISTRY=registry.example.com/magistrala TAG=v1.0.0 PROFILE=full PUSH=true ./docker/k8s/build-images.sh
```

### Windows PowerShell

```powershell
.\docker\k8s\build-images.ps1 -Registry registry.example.com/magistrala -Tag v1.0.0 -Profile full -Push
```