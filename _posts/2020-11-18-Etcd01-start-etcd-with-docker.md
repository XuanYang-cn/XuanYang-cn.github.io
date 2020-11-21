---
layout: single
title:  "Etcd01: Run Etcd with Docker"
categories: etcd docker
author: "Yang Xuan"
excerpt: "How to run etcd."
---

[Etcd](https://github.com/etcd-io/etcd) is a distributed reliable key-value store for the most critical data of a distributed system.

## Run etcd with docker:

### Local standalone cluster

Run the following to deploy an etcd cluster as a standalone cluster:
```shell
docker run --rm \
  -p 2379:2379 \
  -p 2380:2380 \
  quay.io/coreos/etcd:v3.4.13 \
  /usr/local/bin/etcd \
  --name s1 \
  --data-dir /etcd-data \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --initial-cluster s1=http://0.0.0.0:2380 \
  --initial-cluster-token tkn \
  --initial-cluster-state new \
  --log-level info \
  --logger zap \
  --log-outputs stderr
```

### Local multi-member cluster
TODO
