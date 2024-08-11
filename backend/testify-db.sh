#!/bin/bash

# Variables
DB_NAME="testify"
DB_USER="testify"
DB_PASS="12345"

# Install the PostgreSQL repository
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Enable the PostgreSQL 16 repository
sudo dnf -qy module disable postgresql

# Install PostgreSQL 16 server
sudo dnf install -y postgresql16-server

# Initialize the database and enable automatic start
sudo /usr/pgsql-16/bin/postgresql-16-setup initdb
sudo systemctl enable postgresql-16
sudo systemctl start postgresql-16

# Switch to PostgreSQL user and create user and database
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"

# Grant all privileges to user on database
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# Print success message
echo "PostgreSQL 16 has been installed and the database $DB_NAME with user $DB_USER has been created."
