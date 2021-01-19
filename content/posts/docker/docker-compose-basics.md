---
title: "Docker Compose Basics"
date: 2021-01-19T10:14:58+08:00
draft: true
toc: false
images:
tags:
  - docker
  - docker-compose
---

First of all, we need to install `docker-compose`. We can check installation by running `docker-compose -v`, If you installed `docker-compose`, something like below will be printed.
```shell
$ docker-compose -v
docker-compose version 1.17.1 ...
```

If not, you can easily download `docker-compose` in Ubuntu like this:
```shell
$ sudo apt install docker-compose
```
## Write a simple Compose file
The compose file is a **YAML** file defining services, networks and volumes.

```yaml
// Simple example of a docker-compose.yaml file to start two docker containers.
version: "3.8"
services:

  etcd:
    container_name: etcd
    image: quay.io.coreos.etcd:v3.4.13
    volumes: // mount volumes
    ports:   // mount ports
      - "2379:2379"
      - "2380:2380"
    command: >
      /usr/local/bin/etcd                                                  
      --name s1
      --data-dir /etcd-data
      --listen-client-urls http://0.0.0.0:2379
      --advertise-client-urls http://0.0.0.0:2379
      --listen-peer-urls http://0.0.0.0:2380
      --initial-advertise-peer-urls http://0.0.0.0:2380
      --initial-cluster s1=http://0.0.0.0:2380
      --initial-cluster-token tkn
      --initial-cluster-state new
      --log-level info --logger zap --log-outputs stderr

  pulsar:
    container_name: pulsar
    image: apachepulsar/pulsar:2.6.1
    ports:
      - "6650:6650"
      - "8080:8080"
    command: bin/pulsar standalone
```

After we write compose file, we can run `docker-compose` in the `docker-compose.yaml` directory

```shell
$ docker-compose up -d
```
- `up` means to start all containers in the compose file.
- `-d` means to start these docker containers in the background.

If we want to stop the docker we've started, we can use `docker-compose down`, the container will be automaticly deleted, and we can safely `re-up` the compose file.
```shell
$ docker-compose down
```

**Reference**
: [1] [*Compose file version 3 reference*. https://docs.docker.com/compose/compose-file/](https://docs.docker.com/compose/compose-file/)
