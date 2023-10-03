

#!/bin/bash



# Stop the Apache HTTP server

sudo systemctl stop apache2



# Create a new user account for the Apache HTTP server

sudo useradd -r -s /sbin/nologin apache



# Set the ownership of the Apache HTTP server files to the new user account

sudo chown -R apache:apache ${PATH_TO_APACHE_HTTP_SERVER_FILES}



# Modify the Apache HTTP server configuration file to run as the new user account

sudo sed -i 's/User www-data/User apache/g' ${PATH_TO_APACHE_HTTP_SERVER_CONFIGURATION_FILE}

sudo sed -i 's/Group www-data/Group apache/g' ${PATH_TO_APACHE_HTTP_SERVER_CONFIGURATION_FILE}



# Restart the Apache HTTP server

sudo systemctl start apache2