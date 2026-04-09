#!/bin/bash
# ============================================================
# Script deploy Magistrala lên K8s cluster GreenIQ
# Namespace: magistrala
# Domain: iot.greeniq.vn
# ============================================================

set -e

echo "=============================="
echo "  Deploy Magistrala on K8s"
echo "  GreenIQ IoT Platform"
echo "=============================="

# Bước 1: Tạo namespace và secrets
echo ""
echo ">>> Bước 1: Tạo namespace và secrets..."
kubectl apply -f base/00-namespace-secrets.yaml
echo "✅ Namespace và secrets đã tạo"

# Bước 2: Deploy PostgreSQL
echo ""
echo ">>> Bước 2: Deploy PostgreSQL..."
kubectl apply -f base/01-postgresql.yaml
echo "⏳ Chờ PostgreSQL sẵn sàng..."
kubectl -n magistrala rollout status statefulset/magistrala-postgres --timeout=120s
echo "✅ PostgreSQL ready"

# Bước 3: Deploy Redis
echo ""
echo ">>> Bước 3: Deploy Redis..."
kubectl apply -f base/02-redis.yaml
echo "⏳ Chờ Redis sẵn sàng..."
kubectl -n magistrala rollout status statefulset/magistrala-redis --timeout=60s
echo "✅ Redis ready"

# Bước 4: Deploy NATS
echo ""
echo ">>> Bước 4: Deploy NATS..."
kubectl apply -f base/03-nats.yaml
echo "⏳ Chờ NATS sẵn sàng..."
kubectl -n magistrala rollout status statefulset/magistrala-nats --timeout=60s
echo "✅ NATS ready"

# Bước 5: Deploy Core services
echo ""
echo ">>> Bước 5: Deploy Core services (auth, users, clients, channels, groups, domains)..."
kubectl apply -f core/01-core-services.yaml
echo "⏳ Chờ Auth service (quan trọng nhất)..."
kubectl -n magistrala rollout status deployment/magistrala-auth --timeout=120s
echo "✅ Core services deploying..."

# Bước 6: Deploy Adapters
echo ""
echo ">>> Bước 6: Deploy MQTT/HTTP/WS adapters..."
kubectl apply -f core/02-adapters.yaml
echo "✅ Adapters deployed"

# Bước 7: Deploy HPA
echo ""
echo ">>> Bước 7: Cấu hình Auto Scaling..."
kubectl apply -f core/03-hpa.yaml
echo "✅ HPA configured"

# Bước 8: Deploy Addons
echo ""
echo ">>> Bước 8: Deploy Addons (timescale, bootstrap, journal)..."
kubectl apply -f addons/01-addons.yaml
echo "✅ Addons deployed"

# Bước 9: Deploy UI và Ingress
echo ""
echo ">>> Bước 9: Deploy UI và Ingress..."
kubectl apply -f ingress/01-ui-ingress.yaml
echo "✅ UI và Ingress deployed"

# Kiểm tra tổng thể
echo ""
echo "=============================="
echo "  Kiểm tra trạng thái"
echo "=============================="
sleep 10
kubectl -n magistrala get pods
echo ""
echo ">>> Nhớ thêm DNS record:"
echo "    iot.greeniq.vn → A → 89.117.54.100"
echo "    iot.greeniq.vn → A → 75.119.140.171"
echo "    iot.greeniq.vn → A → 185.217.125.138"
echo ""
echo ">>> Sau khi pods Running, truy cập: https://iot.greeniq.vn"
