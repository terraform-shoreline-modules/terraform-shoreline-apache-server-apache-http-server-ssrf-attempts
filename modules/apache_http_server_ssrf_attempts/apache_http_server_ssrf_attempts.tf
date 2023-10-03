resource "shoreline_notebook" "apache_http_server_ssrf_attempts" {
  name       = "apache_http_server_ssrf_attempts"
  data       = file("${path.module}/data/apache_http_server_ssrf_attempts.json")
  depends_on = [shoreline_action.invoke_apache_firewall_rules,shoreline_action.invoke_apache_setup]
}

resource "shoreline_file" "apache_firewall_rules" {
  name             = "apache_firewall_rules"
  input_file       = "${path.module}/data/apache_firewall_rules.sh"
  md5              = filemd5("${path.module}/data/apache_firewall_rules.sh")
  description      = "Restrict access to the vulnerable Apache HTTP server by adding a firewall that filters incoming and outgoing traffic to only allow necessary traffic."
  destination_path = "/agent/scripts/apache_firewall_rules.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "apache_setup" {
  name             = "apache_setup"
  input_file       = "${path.module}/data/apache_setup.sh"
  md5              = filemd5("${path.module}/data/apache_setup.sh")
  description      = "Configure the Apache HTTP server to run as a non-privileged user with restricted access to system resources to limit the impact of any successful SSRF attacks."
  destination_path = "/agent/scripts/apache_setup.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_apache_firewall_rules" {
  name        = "invoke_apache_firewall_rules"
  description = "Restrict access to the vulnerable Apache HTTP server by adding a firewall that filters incoming and outgoing traffic to only allow necessary traffic."
  command     = "`chmod +x /agent/scripts/apache_firewall_rules.sh && /agent/scripts/apache_firewall_rules.sh`"
  params      = ["ALLOWED_IP_RANGE","APACHE_PORT"]
  file_deps   = ["apache_firewall_rules"]
  enabled     = true
  depends_on  = [shoreline_file.apache_firewall_rules]
}

resource "shoreline_action" "invoke_apache_setup" {
  name        = "invoke_apache_setup"
  description = "Configure the Apache HTTP server to run as a non-privileged user with restricted access to system resources to limit the impact of any successful SSRF attacks."
  command     = "`chmod +x /agent/scripts/apache_setup.sh && /agent/scripts/apache_setup.sh`"
  params      = ["PATH_TO_APACHE_HTTP_SERVER_FILES","PATH_TO_APACHE_HTTP_SERVER_CONFIGURATION_FILE"]
  file_deps   = ["apache_setup"]
  enabled     = true
  depends_on  = [shoreline_file.apache_setup]
}

