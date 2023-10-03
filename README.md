
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Apache HTTP Server - SSRF Attempts
---

A server-side request forgery (SSRF) is a type of attack that exploits vulnerabilities in web applications to gain unauthorized access to resources on the server. In the context of Apache HTTP Server, this incident type refers to attempts to exploit SSRF vulnerabilities in the server. Attackers can use SSRF to bypass security controls, access sensitive information, and launch further attacks on the system. This incident type requires immediate attention and remediation to prevent further unauthorized access and data breaches.

### Parameters
```shell
export PATH_TO_ERROR_LOGS="PLACEHOLDER"

export PATH_TO_ACCESS_LOGS="PLACEHOLDER"

export PATH_TO_APACHE_CONFIG="PLACEHOLDER"

export APACHE_PORT="PLACEHOLDER"

export ALLOWED_IP_RANGE="PLACEHOLDER"

export PATH_TO_APACHE_HTTP_SERVER_FILES="PLACEHOLDER"

export PATH_TO_APACHE_HTTP_SERVER_CONFIGURATION_FILE="PLACEHOLDER"
```

## Debug

### Check the list of enabled Apache HTTP Server modules
```shell
apachectl -M
```

### Check Apache HTTP Server error logs for any related errors or warnings
```shell
grep -iE "(error|warning).*SSRF" ${PATH_TO_ERROR_LOGS}
```

### Check if mod_proxy is enabled
```shell
apachectl -M | grep -i "proxy"
```

### Check Apache HTTP Server version
```shell
httpd -v
```

### Check Apache HTTP Server configuration file syntax
```shell
apachectl configtest
```

### Check Apache HTTP Server access logs for suspicious requests
```shell
grep -i "SSRF" ${PATH_TO_ACCESS_LOGS}
```

### Check the Apache HTTP Server proxy-related configuration settings
```shell
grep -iE "(proxy_pass|proxy_set_header)" ${PATH_TO_APACHE_CONFIG}
```

### Check the network connections on the server
```shell
netstat -anp | grep -iE "apache|httpd" | grep -iE "ESTABLISHED|TIME_WAIT"
```

## Repair

### Restrict access to the vulnerable Apache HTTP server by adding a firewall that filters incoming and outgoing traffic to only allow necessary traffic.
```shell


#!/bin/bash



# Define variables

APACHE_PORT=${APACHE_PORT} # replace with the actual port number used by Apache HTTP server

ALLOWED_IP=${ALLOWED_IP_RANGE} # replace with the IP range that should be allowed to access the server



# Add firewall rules to restrict access to Apache HTTP server

sudo iptables -A INPUT -p tcp --dport $APACHE_PORT -s $ALLOWED_IP -j ACCEPT

sudo iptables -A INPUT -p tcp --dport $APACHE_PORT -j DROP

sudo iptables -A OUTPUT -p tcp --sport $APACHE_PORT -d $ALLOWED_IP -j ACCEPT

sudo iptables -A OUTPUT -p tcp --sport $APACHE_PORT -j DROP


```

### Configure the Apache HTTP server to run as a non-privileged user with restricted access to system resources to limit the impact of any successful SSRF attacks.
```shell


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


```