#!/bin/bash

# Prompt the user to select the desired Java version
sudo update-alternatives --config java

# Get the currently selected Java version path
JAVA_PATH=$(sudo update-alternatives --display java | grep "link currently points to" | awk '{print $5}')
JAVA_HOME=$(dirname $(dirname $JAVA_PATH))

# Check if the JAVA_HOME was found
if [ -z "$JAVA_HOME" ]; then
  echo "Failed to determine JAVA_HOME. Exiting."
  exit 1
fi

# Add JAVA_HOME and PATH to /etc/profile
sudo sh -c "echo 'export JAVA_HOME=$JAVA_HOME' >> /etc/profile"
sudo sh -c "echo 'export PATH=\$JAVA_HOME/bin:\$PATH' >> /etc/profile"

# Apply the changes
source /etc/profile

# Confirm the configuration
echo "Java has been configured. JAVA_HOME is set to $JAVA_HOME."
java -version
