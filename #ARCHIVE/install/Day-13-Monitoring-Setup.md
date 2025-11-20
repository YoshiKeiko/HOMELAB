---
title: Volume 11: Monitoring Stack (Day 12)
tags: [homelab, monitoring, grafana, prometheus, observability]
created: 2025-11-11
type: homelab-guide
---

# Volume 11: Monitoring Stack (Day 12)

**Complete Observability with Grafana + Prometheus**

This volume covers comprehensive monitoring and alerting.

## What You'll Complete

- Prometheus (metrics collection)
- Grafana (visualization)
- Loki (log aggregation)
- Promtail (log shipping)
- Node Exporter (system metrics)
- cAdvisor (container metrics)
- Uptime Kuma (uptime monitoring)
- Alertmanager (notifications)

## Prerequisites

- Volumes 01-10 complete
- All services running
- ntfy.sh account for alerts

---

# Guide 71: Prometheus

## Deploy Prometheus

```bash
docker compose -f docker-compose-master.yml up -d prometheus
```

Access: http://192.168.50.10:9090

## Configuration

Create: ~/HomeLab/Docker/Configs/prometheus/prometheus.yml

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
        labels:
          instance: 'm4-mac-mini'

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'docker'
    static_configs:
      - targets: ['192.168.50.10:9323']

  - job_name: 'proxmox'
    static_configs:
      - targets: ['192.168.50.50:9100']
        labels:
          instance: 'proxmox'
```

## Verify Targets

1. Prometheus UI → Status → Targets
2. All should show "UP"

---

# Guide 72: Grafana

## Deploy Grafana

```bash
docker compose -f docker-compose-master.yml up -d grafana
```

Access: http://192.168.50.10:3010

## Initial Setup

**Default login:**
- Username: admin
- Password: admin

**Change immediately!**

Save to 1Password:
```
Title: Grafana
URL: http://192.168.50.10:3010
Username: admin
Password: [new password]
```

## Add Prometheus Data Source

1. Configuration → Data Sources → Add
2. Type: Prometheus
3. URL: http://prometheus:9090
4. Save & Test

## Add Loki Data Source

1. Add data source
2. Type: Loki
3. URL: http://loki:3100
4. Save & Test

---

# Guide 73: Import Dashboards

## System Dashboard

1. Dashboards → Import
2. ID: 1860 (Node Exporter Full)
3. Prometheus data source: Prometheus
4. Import

Shows:
- CPU usage
- Memory usage
- Disk I/O
- Network traffic
- System load

## Docker Dashboard

1. Import dashboard ID: 893
2. Shows all container metrics:
   - CPU per container
   - Memory per container
   - Network per container
   - Disk per container

## Proxmox Dashboard

1. Import dashboard ID: 10347
2. Shows VM metrics:
   - VM CPU/RAM
   - VM disk usage
   - VM network
   - Host resources

---

# Guide 74: Loki + Promtail

## Deploy Loki

```bash
docker compose -f docker-compose-master.yml up -d loki
```

## Deploy Promtail

```bash
docker compose -f docker-compose-master.yml up -d promtail
```

## Configuration

Create: ~/HomeLab/Docker/Configs/promtail/config.yml

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log

  - job_name: docker
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        target_label: 'container'
```

## View Logs in Grafana

1. Explore → Select Loki
2. Query: `{container="plex"}`
3. See live logs!

---

# Guide 75: Uptime Kuma

## Deploy Uptime Kuma

```bash
docker compose -f docker-compose-master.yml up -d uptime-kuma
```

Access: http://192.168.50.10:3001

## Setup

1. Create admin account
2. Save to 1Password

## Add Monitors

**HTTP Monitors:**
```
Name: Plex
Type: HTTP(s)
URL: http://192.168.50.10:32400/web
Interval: 60s

Name: Home Assistant
URL: http://192.168.50.10:8123
Interval: 60s

[Add all services...]
```

**Ping Monitors:**
```
Name: Proxmox
Type: Ping
Hostname: 192.168.50.50
Interval: 60s

Name: Router
Hostname: 192.168.50.1
Interval: 60s
```

**Port Monitors:**
```
Name: SSH
Type: Port
Hostname: 192.168.50.10
Port: 22
```

---

# Guide 76: Alertmanager

## Deploy Alertmanager

```bash
docker compose -f docker-compose-master.yml up -d alertmanager
```

## Configuration

Create: ~/HomeLab/Docker/Configs/alertmanager/config.yml

```yaml
global:
  resolve_timeout: 5m

route:
  receiver: 'ntfy'
  group_by: ['alertname', 'cluster']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h

receivers:
  - name: 'ntfy'
    webhook_configs:
      - url: 'https://ntfy.sh/stevehomelab-alerts-x7k9m2'
        send_resolved: true
```

## Alert Rules

Add to prometheus.yml:

```yaml
rule_files:
  - "/etc/prometheus/rules/*.yml"
```

Create: ~/HomeLab/Docker/Configs/prometheus/rules/alerts.yml

```yaml
groups:
  - name: homelab
    interval: 30s
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
          description: "CPU usage is above 80%"

      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage"
          description: "Memory usage is above 90%"

      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service is down"
          description: "{{ $labels.job }} is down"

      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Disk space low"
          description: "Less than 10% disk space remaining"
```

---

# Guide 77: Custom Dashboards

## Create HomeLab Overview

1. Grafana → Create → Dashboard
2. Add panels:

**Panel 1: Services Status**
```
Query: up{job=~".*"}
Visualization: Stat
Thresholds: 
  0: Red
  1: Green
```

**Panel 2: CPU Usage**
```
Query: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
Visualization: Time series
```

**Panel 3: Memory Usage**
```
Query: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
Visualization: Gauge
```

**Panel 4: Docker Containers**
```
Query: count(container_last_seen{})
Visualization: Stat
```

**Panel 5: Network Traffic**
```
Query: rate(node_network_receive_bytes_total[5m])
Visualization: Time series
```

**Panel 6: Disk Usage**
```
Query: 100 - ((node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100)
Visualization: Bar gauge
```

3. Save dashboard: "HomeLab Overview"
4. Set as home dashboard

---

# Guide 78: Mobile Access

## Grafana Mobile App

1. Install Grafana app (iOS/Android)
2. Add server: http://192.168.50.10:3010
3. Or via Tailscale: http://100.x.x.x:3010
4. View dashboards on phone!

## Uptime Kuma Status Page

1. Uptime Kuma → Status Page
2. Create public status page
3. Share URL with family
4. Shows all services status

---

# Guide 79: Log Analysis

## Useful Loki Queries

**View Plex logs:**
```
{container="plex"}
```

**Find errors:**
```
{container=~".*"} |= "error"
```

**Count errors per service:**
```
sum by (container) (count_over_time({container=~".*"} |= "error" [1h]))
```

**Failed login attempts:**
```
{container="authelia"} |= "failed"
```

**High response times:**
```
{container="nginx"} | json | response_time > 1000
```

---

# Guide 80: Maintenance Dashboard

## Create Maintenance Checklist

**Grafana Dashboard with:**
- Last backup time
- Container update status
- Disk space trends
- Certificate expiry dates
- Uptime stats
- Error rates
- Performance trends

**Alerts for:**
- Backup failures
- Updates available
- Certificate expiring soon
- Disk space low
- High error rates

---

## Volume 11 Complete!

You now have:
- ✅ Prometheus collecting all metrics
- ✅ Grafana visualizing everything
- ✅ Loki aggregating all logs
- ✅ Uptime Kuma monitoring availability
- ✅ Alertmanager sending notifications
- ✅ Custom dashboards for overview
- ✅ Mobile access to monitoring
- ✅ Complete observability!

**Monitoring Stack:**
```
Data Collection:
├─ Prometheus (metrics)
├─ Loki (logs)
├─ Node Exporter (system)
├─ cAdvisor (containers)
└─ Promtail (log shipping)

Visualization:
├─ Grafana (dashboards)
└─ Uptime Kuma (status pages)

Alerting:
├─ Alertmanager (routing)
└─ ntfy.sh (notifications)

Access:
- Grafana: http://192.168.50.10:3010
- Prometheus: http://192.168.50.10:9090
- Uptime Kuma: http://192.168.50.10:3001
```

**Next: Volume 12 - Backup Strategy**



---

#homelab #monitoring #grafana #prometheus #observability
