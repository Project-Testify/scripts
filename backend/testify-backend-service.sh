#!/bin/bash

# Define variables
SERVICE_NAME="testify"
JAR_PATH="/opt/testify/backend/Testify-Backend.jar"
JAVA_PATH="/usr/bin/java"
ENV_FILE="/opt/testify/backend/.env"

# Create the systemd service file
cat <<EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=Testify Spring Boot Application
After=syslog.target

[Service]
EnvironmentFile=$ENV_FILE
ExecStart=$JAVA_PATH -jar $JAR_PATH
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to read new service file
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable $SERVICE_NAME.service

# Add sudo rules for testify user
echo "$SERVICE_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl start $SERVICE_NAME.service, /usr/bin/systemctl stop $SERVICE_NAME.service, /usr/bin/systemctl restart $SERVICE_NAME.service" | sudo tee /etc/sudoers.d/$SERVICE_USER

# Output instructions
echo "Service $SERVICE_NAME setup complete. Environment variables set. $SERVICE_USER can manage the service without a password."



# Define the rule content
POLKIT_RULE_CONTENT='
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units" &&
        (action.lookup("unit") == "$SERVICE_NAME.service") &&
        subject.isInGroup($SERVICE_NAME)) {
        return polkit.Result.YES;
    }
});
'

# Define the destination path for the polkit rule
POLKIT_RULE_PATH="/etc/polkit-1/rules.d/10-testify.rules"

# Create the polkit rule file with the defined content
echo "$POLKIT_RULE_CONTENT" | sudo tee "$POLKIT_RULE_PATH" > /dev/null

# Set the correct permissions for the rule file
sudo chmod 644 "$POLKIT_RULE_PATH"

# Notify the user
echo "Polkit rule for $SERVICE_NAME.service has been added at $POLKIT_RULE_PATH."
