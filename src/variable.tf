variable "instance_count" {
  default = "3"
}


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
  default = "us-west-2"
}