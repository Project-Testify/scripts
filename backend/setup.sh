sudo dnf update
sudo dnf install java-21-openjdk-devel

./config-java.sh

mkdir /opt/testify
adduser testify
setfacl -m u:testify:rwx /opt/testify


./testify-backend-service.sh
./testify-db.sh