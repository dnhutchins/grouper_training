#! /bin/bash
docker run -d -p 15672:15672 --env RABBITMQ_NODENAME=docker-rabbit --hostname rabbitmq --name=rabbitmq rabbitmq:management

