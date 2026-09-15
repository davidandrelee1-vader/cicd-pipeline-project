variable "vpc_cidr_block" {
  description = "the VPC cidr"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "the cidr of pulic subnet a"
  type        = string
  default     = "10.20.1.0/24"


}

variable "public_subnet_2_cidr" {
  description = "the cidr of pulic subnet 2"
  type        = string
  default     = "10.20.2.0/24"

}

variable "private_subnet_1_cidr" {
  description = "the cidr of private subnet 1"
  type        = string
  default     = "10.20.11.0/24"


}

variable "private_subnet_2_cidr" {
  description = "the cidr of private subnet 2"
  type        = string
  default     = "10.20.12.0/24"

}

variable "availability_zone_1" {
  description = "value"
  type        = string
  default     = "us-east-1a"

}

variable "availability_zone_2" {
  description = "value"
  type        = string
  default     = "us-east-1b"

}