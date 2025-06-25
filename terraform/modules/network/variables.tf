variable "vpc_name" {
    description = "Nome da VPC criada para o Redis"
}
variable "subnet_name" {
    description = "Subrede da VPC criada para o Redis"
}
variable "subnet_cidr" {
    description = "CIDR da subnet criada para o Redis"
}
variable "connector_cidr" {
    description = "CIDR utilizado pelo Connector utilizado pelo Cloud Run"
}
variable "region" {
    description = "Região do Projeto"
}
variable "project_id" {
    description = "ID do projeto"
}