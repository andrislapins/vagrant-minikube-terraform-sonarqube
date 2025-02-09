
# Postgres specific

variable "postgres_ns" {
  type        = string
  description = "Namespace for the PostgreSQL database"
  default     = "postgres"
}

variable "postgres_port" {
  type        = string
  description = "Port for the PostgreSQL database"
  default     = "5432"
}

variable "postgres_password" {
  type        = string
  description = "Password for the PostgreSQL database"
  sensitive   = true
}

# SonarQube specific

variable "sonar_ns" {
  type        = string
  description = "Namespace for SonarQube"
  default     = "sonarqube"
}

variable "sonar_db_name" {
  type        = string
  description = "Name of the Postgres SonarQube database"
  default     = "sonar"
}

variable "sonar_db_username" {
  type        = string
  description = "Username for the Postgres SonarQube database"
  default     = "sonar"
}

variable "sonar_db_password" {
  type        = string
  description = "Pasword for the Postgres SonarQube database user"
  sensitive   = true
}

variable "sonar_hostname" {
  type    = string
  default = "sonarqube.local"
}

# Jenkins

variable "jenkins_ns" {
  type        = string
  description = "Namespace for Jenkins"
  default     = "jenkins"
}

variable "jenkins_hostname" {
  type    = string
  default = "jenkins.local"
}

# Prometheus

variable "prometheus_ns" {
  type        = string
  description = "Namespace for Prometheus"
  default     = "prometheus"
}

variable "prometheus_hostname" {
  type    = string
  default = "prometheus.local"
}

# K8s metrics

variable "metrics_ns" {
  type        = string
  description = "Namespace for K8s metrics server"
  default     = "metrics"
}