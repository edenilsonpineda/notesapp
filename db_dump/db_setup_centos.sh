#!/bin/sh

echo "Updating and installing Docker"
sudo apt update -y
sudo apt upgrade -y

sudo apt remove -y docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo apt install docker-ce docker-ce-cli containerd.io

echo "Starting and enabling Docker"
sudo systemctl start docker
sudo systemctl enable docker

echo "Configure database user"
read -p "Postgres user name: " name
read -s -p "Postgres user password: " password

export POSTGRES_USER=$name
export POSTGRES_PASSWORD=$password

sudo docker rm --force postgres || true

echo "Creating database container (and seed 'sample' database)"
sudo docker volume create pg-data
sudo docker run -d \
  --name postgres \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=sample \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v "pg-data:/var/lib/postgresql/data" \
  -p "80:5432" \
  --restart always \
  postgres:9.6-alpine

sleep 20 # Ensure enough time for postgres database to initialize and create role

sudo docker exec -i postgres psql postgres -U $POSTGRES_USER -c <<-EOF
CREATE DATABASE notes;
EOF
