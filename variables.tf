variable "ec2_ami" {
  description = "The AMI for the machine"
}

variable "ec2_count" {
  description = "Number of instances to create"
  default     = "1"
}

variable "ec2_instance_type" {
  default     = "t2.micro"
  description = "The instance type"
}

variable "ec2_user_data" {
  description = "The user_data filename for the instances, keep a copy in the control repo, default name is userdata.sh"
  default     = "userdata.sh"
}

variable "ec2_hostrecord" {
  description = "The DNS name the server should answer on"
}

variable "global_phz_id" {
  description = "The domain ID of this VPC's domain"
}

variable "global_phz_domain" {
  description = "The domain for this VPC"
}

variable "ec2_rootvol_size" {
  default     = "10"
  description = "The size of the Root Volume in GB"
}

variable "cidr_blocks" {
  default     = ""
}

variable "alb_cidr_blocks" {
  description = "Access to the ALB, this can be internal or external IP addresses"
  default     = ""
}

variable "ec2_alb_internal" {
  description = "Set the ALB to be internal or external to the network, default internal"
  default     = "true"
}

variable "global_key_name" {
  description = "SSH key name in your AWS account for AWS instances"
}

variable "global_subnet_id" {
  description = "The ID of the subnet to deploy the OSSEC Server into"
}

variable "global_vpc_id" {
  description = "The ID of the VPC where the bastion stack is being deployed"
}

variable "global_product" {
  description = "The overarching Product (everything in this VPC will be named after it)"
}

variable "global_environment" {
  description = "The Application environment (dev, uat, sit, prod, etc)"
}

variable "ec2_role" {
  description = "The Role (mgmt, db, web, etc)"
}

variable "orchestration" {
  description = "git address of control repo"
}

variable "global_costcode" {
  description = "The costcentre label to tag resources"
}

variable "global_contact" {
  description = "The contact label to tag resources"
  default     = "rmathialagan@gmail.com"
}

variable "global_businessunit" {

}

variable "listener_lb_port" {
  description = "port ALB will listen on"
  default     = ""
}

variable "listener_lb_protocol" {
  description = "ALB listenr protocol, tcp, udp, https"
  default     = "https"
}

variable "idle_timeout" {
  description = "idle timeout for alb"
  default     = ""
}

variable "ssl_cert_arn" {
  description = "The SSL Cert for your ALB, if using ssl"
  default     = ""
}

variable "alb_subnets" {
  description = "subnest you want your alb to live in"
  default     = ""
}

variable "ec2_alb_cname" {
  description = "Set your route53 entry for your ALB"
  default     = ""
}

variable "enable_alb" {
  description = "Default setting is on, set to 0 to disable the ALB and related security groups"
  default     = "1"
}

variable "tag_product" {
  description = "Tag for product the resource is used by)"

}

variable "deployed_service" {
  description = "deployment service"
}
variable "aws_region" {
  default = "eu-west-1"
}



