variable "aws_region"{
   default = "ap-south-2"
}
variable "secret_name"{
    description = "AWS Secret Manager secret name"
    type = string
}