

#!/bin/bash



# Define variables

APACHE_PORT=${APACHE_PORT} # replace with the actual port number used by Apache HTTP server

ALLOWED_IP=${ALLOWED_IP_RANGE} # replace with the IP range that should be allowed to access the server



# Add firewall rules to restrict access to Apache HTTP server

sudo iptables -A INPUT -p tcp --dport $APACHE_PORT -s $ALLOWED_IP -j ACCEPT

sudo iptables -A INPUT -p tcp --dport $APACHE_PORT -j DROP

sudo iptables -A OUTPUT -p tcp --sport $APACHE_PORT -d $ALLOWED_IP -j ACCEPT

sudo iptables -A OUTPUT -p tcp --sport $APACHE_PORT -j DROP