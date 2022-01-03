variable "instance_count" {
  default = "3"
}

# variable "instance_tags" {
#   type = list
#   default = ["Terraform-1", "Terraform-2", "Terraform-3"]
# }


variable "project_tags" {
  description = "Project tags to be attached to resources"
  type = object({
    PROJECT_NAME = string
    OWNER        = string
    COSTCENTER   = string
  })
}


variable "project_name" {
  type = string
}


variable "region" {
  type    = string
  default = "eu-central-1"
}