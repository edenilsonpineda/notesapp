#!/bin/sh

echo "Updating and installing Docker"
sudo apt update -y
sudo apt upgrade -y

# Remove older versions of docker and make a fresh installation
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt update -y

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add the Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


# Set Up the stable repository of docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install docker engine
sudo apt update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo "Starting and enabling Docker"
sudo systemctl start docker
sudo systemctl enable docker

# Verify the docker installation running the Hello-World container
echo "Starting Hello World container to test the installation of Docker Engine..."
sudo docker run hello-world

echo "Docker was installed successfully, installing PostgresDB."

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
