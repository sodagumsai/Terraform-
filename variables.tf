variable "instance-type" {
  type    = string
  default = "t3.micro"
  #  validation {
  #    condition     = can(regex("[^t2]", var.instance-type))
  #    error_message = "Instance type cannot be anything other than t2 or t3 type and also not t3a.micro."
  #  }
}
variable "instance-type-wl" {
  type    = string
  default = "t3.medium"
  #  validation {
  #    condition     = can(regex("[^t2]", var.instance-type))
  #    error_message = "Instance type cannot be anything other than t2 or t3 type and also not t3a.micro."
  #  }
}


variable "master" {
  type    = string
  default = "us-east-1"
}
variable "http_port" {
  default = 80
}
variable "ssh_port" {
  default = 45
}
variable "my_system" {
    default = "98.207.180.245/32"
}

#variable "ami" {
#  default = "ami-0df8a4618091cf24c"
#}

#variable "ami-wl" {
#  default = "ami-0904faeca57934199"
#}
variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}