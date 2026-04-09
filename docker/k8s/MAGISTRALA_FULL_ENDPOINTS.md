# Magistrala Full Endpoint Catalog

This file contains the full REST endpoint inventory from all OpenAPI specs under `apidocs/openapi/*.yaml`.

Generated: 2026-04-08 15:20:00 +07:00

## Summary

- Total REST endpoints: **206**
- OpenAPI files included: **15**
- CSV export: `docker/k8s/MAGISTRALA_FULL_ENDPOINTS.csv`

## Endpoint Count by Service

| Service | OpenAPI File | Count |
|---|---|---:|
| alarms | `apidocs/openapi/alarms.yaml` | 5 |
| auth | `apidocs/openapi/auth.yaml` | 17 |
| bootstrap | `apidocs/openapi/bootstrap.yaml` | 11 |
| certs | `apidocs/openapi/certs.yaml` | 14 |
| channels | `apidocs/openapi/channels.yaml` | 16 |
| clients | `apidocs/openapi/clients.yaml` | 28 |
| domains | `apidocs/openapi/domains.yaml` | 29 |
| groups | `apidocs/openapi/groups.yaml` | 31 |
| http | `apidocs/openapi/http.yaml` | 2 |
| journal | `apidocs/openapi/journal.yaml` | 4 |
| notifiers | `apidocs/openapi/notifiers.yaml` | 5 |
| readers | `apidocs/openapi/readers.yaml` | 2 |
| reports | `apidocs/openapi/reports.yaml` | 10 |
| rules | `apidocs/openapi/rules.yaml` | 8 |
| users | `apidocs/openapi/users.yaml` | 24 |

## Full Endpoint List

### alarms (5)
- GET /{domainID}/alarms
- DELETE /{domainID}/alarms/{alarmID}
- GET /{domainID}/alarms/{alarmID}
- PUT /{domainID}/alarms/{alarmID}
- GET /health

### auth (17)
- GET /health
- POST /keys
- DELETE /keys/{keyID}
- GET /keys/{keyID}
- DELETE /pats
- GET /pats
- POST /pats
- DELETE /pats/{patID}
- GET /pats/{patID}
- PATCH /pats/{patID}/description
- PATCH /pats/{patID}/name
- DELETE /pats/{patID}/scope
- GET /pats/{patID}/scope
- PATCH /pats/{patID}/scope/add
- PATCH /pats/{patID}/scope/remove
- PATCH /pats/{patID}/secret/reset
- PATCH /pats/{patID}/secret/revoke

### bootstrap (11)
- GET /{domainID}/clients/configs
- POST /{domainID}/clients/configs
- DELETE /{domainID}/clients/configs/{configID}
- GET /{domainID}/clients/configs/{configID}
- PUT /{domainID}/clients/configs/{configID}
- PATCH /{domainID}/clients/configs/certs/{configID}
- PUT /{domainID}/clients/configs/connections/{configID}
- PUT /{domainID}/clients/state/{configID}
- GET /clients/bootstrap/{externalId}
- GET /clients/bootstrap/secure/{externalId}
- GET /health

### certs (14)
- GET /{domainID}/certs
- DELETE /{domainID}/certs/{entityID}/delete
- GET /{domainID}/certs/{id}
- PATCH /{domainID}/certs/{id}/renew
- PATCH /{domainID}/certs/{id}/revoke
- POST /{domainID}/certs/csrs/{entityID}
- POST /{domainID}/certs/issue/{entityID}
- GET /certs/crl
- POST /certs/csrs/{entityID}
- GET /certs/download-ca
- POST /certs/ocsp
- GET /certs/view-ca
- GET /health
- GET /metrics

### channels (16)
- GET /{domainID}/channels
- POST /{domainID}/channels
- DELETE /{domainID}/channels/{chanID}
- GET /{domainID}/channels/{chanID}
- PATCH /{domainID}/channels/{chanID}
- POST /{domainID}/channels/{chanID}/connect
- POST /{domainID}/channels/{chanID}/disable
- POST /{domainID}/channels/{chanID}/disconnect
- POST /{domainID}/channels/{chanID}/enable
- DELETE /{domainID}/channels/{chanID}/parent
- POST /{domainID}/channels/{chanID}/parent
- PATCH /{domainID}/channels/{chanID}/tags
- POST /{domainID}/channels/bulk
- POST /{domainID}/channels/connect
- POST /{domainID}/channels/disconnect
- GET /health

### clients (28)
- GET /{domainID}/clients
- POST /{domainID}/clients
- DELETE /{domainID}/clients/{clientID}
- GET /{domainID}/clients/{clientID}
- PATCH /{domainID}/clients/{clientID}
- POST /{domainID}/clients/{clientID}/disable
- POST /{domainID}/clients/{clientID}/enable
- DELETE /{domainID}/clients/{clientID}/parent
- POST /{domainID}/clients/{clientID}/parent
- GET /{domainID}/clients/{clientID}/roles
- POST /{domainID}/clients/{clientID}/roles
- DELETE /{domainID}/clients/{clientID}/roles/{roleID}
- GET /{domainID}/clients/{clientID}/roles/{roleID}
- PUT /{domainID}/clients/{clientID}/roles/{roleID}
- GET /{domainID}/clients/{clientID}/roles/{roleID}/actions
- POST /{domainID}/clients/{clientID}/roles/{roleID}/actions
- POST /{domainID}/clients/{clientID}/roles/{roleID}/actions/delete
- POST /{domainID}/clients/{clientID}/roles/{roleID}/actions/delete-all
- GET /{domainID}/clients/{clientID}/roles/{roleID}/members
- POST /{domainID}/clients/{clientID}/roles/{roleID}/members
- POST /{domainID}/clients/{clientID}/roles/{roleID}/members/delete
- POST /{domainID}/clients/{clientID}/roles/{roleID}/members/delete-all
- GET /{domainID}/clients/{clientID}/roles/members
- PATCH /{domainID}/clients/{clientID}/secret
- PATCH /{domainID}/clients/{clientID}/tags
- POST /{domainID}/clients/bulk
- GET /{domainID}/clients/roles/available-actions
- GET /health

### domains (29)
- GET /domain/{domainID}/roles/members
- GET /domains
- POST /domains
- GET /domains/{domainID}
- PATCH /domains/{domainID}
- POST /domains/{domainID}/disable
- POST /domains/{domainID}/enable
- POST /domains/{domainID}/freeze
- DELETE /domains/{domainID}/invitations
- GET /domains/{domainID}/invitations
- POST /domains/{domainID}/invitations
- GET /domains/{domainID}/roles
- POST /domains/{domainID}/roles
- DELETE /domains/{domainID}/roles/{roleID}
- GET /domains/{domainID}/roles/{roleID}
- PUT /domains/{domainID}/roles/{roleID}
- GET /domains/{domainID}/roles/{roleID}/actions
- POST /domains/{domainID}/roles/{roleID}/actions
- POST /domains/{domainID}/roles/{roleID}/actions/delete
- POST /domains/{domainID}/roles/{roleID}/actions/delete-all
- GET /domains/{domainID}/roles/{roleID}/members
- POST /domains/{domainID}/roles/{roleID}/members
- POST /domains/{domainID}/roles/{roleID}/members/delete
- POST /domains/{domainID}/roles/{roleID}/members/delete-all
- GET /domains/roles/available-actions
- GET /health
- GET /invitations
- POST /invitations/accept
- POST /invitations/reject

### groups (31)
- GET /{domainID}/groups
- POST /{domainID}/groups
- DELETE /{domainID}/groups/{groupID}
- GET /{domainID}/groups/{groupID}
- PUT /{domainID}/groups/{groupID}
- DELETE /{domainID}/groups/{groupID}/children
- GET /{domainID}/groups/{groupID}/children
- POST /{domainID}/groups/{groupID}/children
- DELETE /{domainID}/groups/{groupID}/children/all
- POST /{domainID}/groups/{groupID}/disable
- POST /{domainID}/groups/{groupID}/enable
- GET /{domainID}/groups/{groupID}/hierarchy
- DELETE /{domainID}/groups/{groupID}/parent
- POST /{domainID}/groups/{groupID}/parent
- GET /{domainID}/groups/{groupID}/roles
- POST /{domainID}/groups/{groupID}/roles
- DELETE /{domainID}/groups/{groupID}/roles/{roleID}
- GET /{domainID}/groups/{groupID}/roles/{roleID}
- PUT /{domainID}/groups/{groupID}/roles/{roleID}
- GET /{domainID}/groups/{groupID}/roles/{roleID}/actions
- POST /{domainID}/groups/{groupID}/roles/{roleID}/actions
- POST /{domainID}/groups/{groupID}/roles/{roleID}/actions/delete
- POST /{domainID}/groups/{groupID}/roles/{roleID}/actions/delete-all
- GET /{domainID}/groups/{groupID}/roles/{roleID}/members
- POST /{domainID}/groups/{groupID}/roles/{roleID}/members
- POST /{domainID}/groups/{groupID}/roles/{roleID}/members/delete
- POST /{domainID}/groups/{groupID}/roles/{roleID}/members/delete-all
- GET /{domainID}/groups/{groupID}/roles/members
- PATCH /{domainID}/groups/{groupID}/tags
- GET /{domainID}/groups/roles/available-actions
- GET /health

### http (2)
- GET /health
- POST /m/{domainPrefix}/c/{channelPrefix}

### journal (4)
- GET /{domainID}/journal/{entityType}/{id}
- GET /{domainID}/journal/client/{clientID}/telemetry
- GET /health
- GET /journal/user/{userID}

### notifiers (5)
- GET /health
- GET /subscriptions
- POST /subscriptions
- DELETE /subscriptions/{id}
- GET /subscriptions/{id}

### readers (2)
- GET /{domainID}/channels/{chanId}/messages
- GET /health

### reports (10)
- POST /{domainID}/reports
- GET /{domainID}/reports/configs
- POST /{domainID}/reports/configs
- DELETE /{domainID}/reports/configs/{reportID}
- GET /{domainID}/reports/configs/{reportID}
- PATCH /{domainID}/reports/configs/{reportID}
- POST /{domainID}/reports/configs/{reportID}/disable
- POST /{domainID}/reports/configs/{reportID}/enable
- PATCH /{domainID}/reports/configs/{reportID}/schedule
- GET /health

### rules (8)
- GET /{domainID}/rules
- POST /{domainID}/rules
- DELETE /{domainID}/rules/{ruleID}
- GET /{domainID}/rules/{ruleID}
- PUT /{domainID}/rules/{ruleID}
- PUT /{domainID}/rules/{ruleID}/disable
- PUT /{domainID}/rules/{ruleID}/enable
- GET /health

### users (24)
- GET /health
- PUT /password/reset
- POST /password/reset-request
- GET /users
- POST /users
- DELETE /users/{userID}
- GET /users/{userID}
- PATCH /users/{userID}
- POST /users/{userID}/disable
- PATCH /users/{userID}/email
- POST /users/{userID}/enable
- PATCH /users/{userID}/picture
- PATCH /users/{userID}/role
- PATCH /users/{userID}/tags
- PATCH /users/{userID}/username
- GET /users/profile
- GET /users/search
- PATCH /users/secret
- POST /users/send-verification
- POST /users/tokens/issue
- POST /users/tokens/refresh
- GET /users/tokens/refresh-tokens
- POST /users/tokens/revoke
- GET /verify-email

