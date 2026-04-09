# Magistrala UI Endpoint Matrix

This file aggregates endpoint mappings for `magistrala-ui` to help debug endpoint mismatch issues.

Generated: 2026-04-08 15:11:22 +07:00

## Quick Summary

- UI-related OpenAPI operations in this file: **201**
- Default UI service URLs are taken from `docker/.env` and `docker/docker-compose.yaml` (ui service env).
- Public route behavior is based on `docker/nginx/nginx-key.conf` (same path rules as `nginx-x509.conf`).
- `MG_BACKEND_URL` (`ui-backend`) is part of UI runtime but is excluded from endpoint count because this repo does not expose an OpenAPI spec for it.

## UI URL to Backend Mapping

| Service | UI env var | Default URL | OpenAPI | Ops | Routed by nginx | Gateway path rule | Notes |
|---|---|---|---|---:|---|---|---|
| ui-backend | `MG_BACKEND_URL` | `http://ui-backend:9097` | `N/A` | 0 | NO | `No route in nginx-key.conf` | Internal UI helper service, expose separately if UI accesses it externally. |
| auth | `MG_AUTH_URL` | `http://auth:9001` | `apidocs/openapi/auth.yaml` | 17 | PARTIAL | `^/(pats)` | `/keys` is not routed by nginx-key.conf. |
| domains | `MG_DOMAINS_URL` | `http://domains:9003` | `apidocs/openapi/domains.yaml` | 29 | YES | `^/(domains|invitations)` | No domain UUID prefix in path. |
| users | `MG_USERS_URL` | `http://users:9002` | `apidocs/openapi/users.yaml` | 24 | YES | `^/(users|password|verify-email|authorize|oauth/callback/[^/]+)` | OAuth callback and password routes are routed. |
| clients | `MG_CLIENTS_URL` | `http://clients:9006` | `apidocs/openapi/clients.yaml` | 28 | PARTIAL | `^/{domainID}/clients` | Only domain-scoped routes are routed, `/health` is not. |
| channels | `MG_CHANNELS_URL` | `http://channels:9005` | `apidocs/openapi/channels.yaml` | 16 | PARTIAL | `^/{domainID}/channels` | Only domain-scoped routes are routed, `/health` is not. |
| groups | `MG_GROUPS_URL` | `http://groups:9004` | `apidocs/openapi/groups.yaml` | 31 | PARTIAL | `^/{domainID}/groups` | Only domain-scoped routes are routed, `/health` is not. |
| bootstrap | `MG_BOOTSTRAP_URL` | `http://bootstrap:9013` | `apidocs/openapi/bootstrap.yaml` | 11 | NO | `No route in nginx-key.conf` | Must be exposed by separate ingress/service. |
| certs | `MG_CERTS_URL` | `http://certs:9019` | `apidocs/openapi/certs.yaml` | 14 | NO | `No route in nginx-key.conf` | Must be exposed by separate ingress/service. |
| journal | `MG_JOURNAL_URL` | `http://journal:9021` | `apidocs/openapi/journal.yaml` | 4 | NO | `No route in nginx-key.conf` | Must be exposed by separate ingress/service. |
| timescale-reader | `MG_READER_URL` | `http://timescale-reader:9011` | `apidocs/openapi/readers.yaml` | 2 | NO | `No route in nginx-key.conf` | Must be exposed by separate ingress/service. |
| re (rules) | `MG_RE_URL` | `http://re:9008` | `apidocs/openapi/rules.yaml` | 8 | PARTIAL | `^/{domainID}/rules` | Only domain-scoped routes are routed, `/health` is not. |
| alarms | `MG_ALARMS_URL` | `http://alarms:8050` | `apidocs/openapi/alarms.yaml` | 5 | PARTIAL | `^/{domainID}/alarms` | Only domain-scoped routes are routed, `/health` is not. |
| reports | `MG_REPORTS_URL` | `http://reports:9017` | `apidocs/openapi/reports.yaml` | 10 | PARTIAL | `^/{domainID}/reports` | Only domain-scoped routes are routed, `/health` is not. |
| http-adapter | `MG_HTTP_ADAPTER_URL` | `http://nginx:80/http` | `apidocs/openapi/http.yaml` | 2 | YES | `/http/ -> FluxMQ HTTP API` | UI should use `/http/m/{domainPrefix}/c/{channelPrefix}`. |

## Mismatch Checklist (Most Common)

1. Domain-scoped APIs must include `/{domainID}` in the path: `clients`, `channels`, `groups`, `rules`, `alarms`, `reports`.
2. `auth` via nginx only routes `/pats`; `auth /keys` is not routed in current nginx config.
3. `bootstrap`, `certs`, `journal`, `timescale-reader` have no default nginx route in `nginx-key.conf`.
4. Health endpoints (`/health`) are usually available on service direct URL, but not always through nginx public routes.
5. `MG_HTTP_ADAPTER_URL` should point to nginx `/http` prefix (e.g. `http://<gateway>/http`).

## Detailed Endpoint List (for UI-related services)

### auth (17)
- POST /keys
- GET /keys/{keyID}
- DELETE /keys/{keyID}
- POST /pats
- GET /pats
- DELETE /pats
- GET /pats/{patID}
- DELETE /pats/{patID}
- PATCH /pats/{patID}/name
- PATCH /pats/{patID}/description
- PATCH /pats/{patID}/secret/reset
- PATCH /pats/{patID}/secret/revoke
- GET /pats/{patID}/scope
- DELETE /pats/{patID}/scope
- PATCH /pats/{patID}/scope/add
- PATCH /pats/{patID}/scope/remove
- GET /health

### domains (29)
- POST /domains
- GET /domains
- GET /domains/{domainID}
- PATCH /domains/{domainID}
- POST /domains/{domainID}/enable
- POST /domains/{domainID}/disable
- POST /domains/{domainID}/freeze
- POST /domains/{domainID}/roles
- GET /domains/{domainID}/roles
- GET /domains/{domainID}/roles/{roleID}
- PUT /domains/{domainID}/roles/{roleID}
- DELETE /domains/{domainID}/roles/{roleID}
- GET /domain/{domainID}/roles/members
- POST /domains/{domainID}/roles/{roleID}/actions
- GET /domains/{domainID}/roles/{roleID}/actions
- POST /domains/{domainID}/roles/{roleID}/actions/delete
- POST /domains/{domainID}/roles/{roleID}/actions/delete-all
- POST /domains/{domainID}/roles/{roleID}/members
- GET /domains/{domainID}/roles/{roleID}/members
- POST /domains/{domainID}/roles/{roleID}/members/delete
- POST /domains/{domainID}/roles/{roleID}/members/delete-all
- GET /domains/roles/available-actions
- POST /domains/{domainID}/invitations
- GET /domains/{domainID}/invitations
- DELETE /domains/{domainID}/invitations
- GET /invitations
- POST /invitations/accept
- POST /invitations/reject
- GET /health

### users (24)
- POST /users
- GET /users
- GET /users/profile
- GET /users/{userID}
- PATCH /users/{userID}
- DELETE /users/{userID}
- PATCH /users/{userID}/username
- PATCH /users/{userID}/tags
- PATCH /users/{userID}/picture
- PATCH /users/{userID}/email
- PATCH /users/{userID}/role
- POST /users/{userID}/disable
- POST /users/{userID}/enable
- PATCH /users/secret
- GET /users/search
- POST /password/reset-request
- PUT /password/reset
- POST /users/tokens/issue
- POST /users/tokens/refresh
- POST /users/tokens/revoke
- GET /users/tokens/refresh-tokens
- POST /users/send-verification
- GET /verify-email
- GET /health

### clients (28)
- POST /{domainID}/clients
- GET /{domainID}/clients
- POST /{domainID}/clients/bulk
- GET /{domainID}/clients/{clientID}
- PATCH /{domainID}/clients/{clientID}
- DELETE /{domainID}/clients/{clientID}
- PATCH /{domainID}/clients/{clientID}/tags
- PATCH /{domainID}/clients/{clientID}/secret
- POST /{domainID}/clients/{clientID}/disable
- POST /{domainID}/clients/{clientID}/enable
- POST /{domainID}/clients/{clientID}/parent
- DELETE /{domainID}/clients/{clientID}/parent
- POST /{domainID}/clients/{clientID}/roles
- GET /{domainID}/clients/{clientID}/roles
- GET /{domainID}/clients/{clientID}/roles/members
- GET /{domainID}/clients/{clientID}/roles/{roleID}
- PUT /{domainID}/clients/{clientID}/roles/{roleID}
- DELETE /{domainID}/clients/{clientID}/roles/{roleID}
- POST /{domainID}/clients/{clientID}/roles/{roleID}/actions
- GET /{domainID}/clients/{clientID}/roles/{roleID}/actions
- POST /{domainID}/clients/{clientID}/roles/{roleID}/actions/delete
- POST /{domainID}/clients/{clientID}/roles/{roleID}/actions/delete-all
- POST /{domainID}/clients/{clientID}/roles/{roleID}/members
- GET /{domainID}/clients/{clientID}/roles/{roleID}/members
- POST /{domainID}/clients/{clientID}/roles/{roleID}/members/delete
- POST /{domainID}/clients/{clientID}/roles/{roleID}/members/delete-all
- GET /{domainID}/clients/roles/available-actions
- GET /health

### channels (16)
- POST /{domainID}/channels
- GET /{domainID}/channels
- POST /{domainID}/channels/bulk
- GET /{domainID}/channels/{chanID}
- PATCH /{domainID}/channels/{chanID}
- DELETE /{domainID}/channels/{chanID}
- PATCH /{domainID}/channels/{chanID}/tags
- POST /{domainID}/channels/{chanID}/enable
- POST /{domainID}/channels/{chanID}/disable
- POST /{domainID}/channels/{chanID}/parent
- DELETE /{domainID}/channels/{chanID}/parent
- POST /{domainID}/channels/connect
- POST /{domainID}/channels/disconnect
- POST /{domainID}/channels/{chanID}/connect
- POST /{domainID}/channels/{chanID}/disconnect
- GET /health

### groups (31)
- POST /{domainID}/groups
- GET /{domainID}/groups
- GET /{domainID}/groups/{groupID}
- PUT /{domainID}/groups/{groupID}
- DELETE /{domainID}/groups/{groupID}
- PATCH /{domainID}/groups/{groupID}/tags
- POST /{domainID}/groups/{groupID}/enable
- POST /{domainID}/groups/{groupID}/disable
- GET /{domainID}/groups/{groupID}/hierarchy
- POST /{domainID}/groups/{groupID}/parent
- DELETE /{domainID}/groups/{groupID}/parent
- POST /{domainID}/groups/{groupID}/children
- DELETE /{domainID}/groups/{groupID}/children
- GET /{domainID}/groups/{groupID}/children
- DELETE /{domainID}/groups/{groupID}/children/all
- POST /{domainID}/groups/{groupID}/roles
- GET /{domainID}/groups/{groupID}/roles
- GET /{domainID}/groups/{groupID}/roles/members
- GET /{domainID}/groups/{groupID}/roles/{roleID}
- PUT /{domainID}/groups/{groupID}/roles/{roleID}
- DELETE /{domainID}/groups/{groupID}/roles/{roleID}
- POST /{domainID}/groups/{groupID}/roles/{roleID}/actions
- GET /{domainID}/groups/{groupID}/roles/{roleID}/actions
- POST /{domainID}/groups/{groupID}/roles/{roleID}/actions/delete
- POST /{domainID}/groups/{groupID}/roles/{roleID}/actions/delete-all
- POST /{domainID}/groups/{groupID}/roles/{roleID}/members
- GET /{domainID}/groups/{groupID}/roles/{roleID}/members
- POST /{domainID}/groups/{groupID}/roles/{roleID}/members/delete
- POST /{domainID}/groups/{groupID}/roles/{roleID}/members/delete-all
- GET /{domainID}/groups/roles/available-actions
- GET /health

### bootstrap (11)
- POST /{domainID}/clients/configs
- GET /{domainID}/clients/configs
- GET /{domainID}/clients/configs/{configID}
- PUT /{domainID}/clients/configs/{configID}
- DELETE /{domainID}/clients/configs/{configID}
- PATCH /{domainID}/clients/configs/certs/{configID}
- PUT /{domainID}/clients/configs/connections/{configID}
- GET /clients/bootstrap/{externalId}
- GET /clients/bootstrap/secure/{externalId}
- PUT /{domainID}/clients/state/{configID}
- GET /health

### certs (14)
- POST /{domainID}/certs/issue/{entityID}
- PATCH /{domainID}/certs/{id}/renew
- PATCH /{domainID}/certs/{id}/revoke
- DELETE /{domainID}/certs/{entityID}/delete
- GET /{domainID}/certs
- GET /{domainID}/certs/{id}
- POST /{domainID}/certs/csrs/{entityID}
- POST /certs/csrs/{entityID}
- POST /certs/ocsp
- GET /certs/crl
- GET /certs/view-ca
- GET /certs/download-ca
- GET /health
- GET /metrics

### journal (4)
- GET /journal/user/{userID}
- GET /{domainID}/journal/client/{clientID}/telemetry
- GET /{domainID}/journal/{entityType}/{id}
- GET /health

### timescale-reader (2)
- GET /{domainID}/channels/{chanId}/messages
- GET /health

### re (rules) (8)
- POST /{domainID}/rules
- GET /{domainID}/rules
- GET /{domainID}/rules/{ruleID}
- PUT /{domainID}/rules/{ruleID}
- DELETE /{domainID}/rules/{ruleID}
- PUT /{domainID}/rules/{ruleID}/enable
- PUT /{domainID}/rules/{ruleID}/disable
- GET /health

### alarms (5)
- GET /{domainID}/alarms
- GET /{domainID}/alarms/{alarmID}
- PUT /{domainID}/alarms/{alarmID}
- DELETE /{domainID}/alarms/{alarmID}
- GET /health

### reports (10)
- POST /{domainID}/reports
- POST /{domainID}/reports/configs
- GET /{domainID}/reports/configs
- GET /{domainID}/reports/configs/{reportID}
- PATCH /{domainID}/reports/configs/{reportID}
- DELETE /{domainID}/reports/configs/{reportID}
- PATCH /{domainID}/reports/configs/{reportID}/schedule
- POST /{domainID}/reports/configs/{reportID}/enable
- POST /{domainID}/reports/configs/{reportID}/disable
- GET /health

### http-adapter (2)
- POST /m/{domainPrefix}/c/{channelPrefix}
- GET /health

