sudo dnf update -y
sudo dnf install java-21-openjdk-devel -y

./config-java.sh

mkdir /opt/testify
adduser testify
setfacl -m u:testify:rwx /opt/testify


./testify-backend-service.sh
./testify-db.sh