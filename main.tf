
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}



resource "aws_security_group" "terraform-security-group" {
  name = "terraform-security-group"

  #Incoming traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #replace it with your ip address
  }

  #Outgoing traffic
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-security-group"
  }
}




resource "aws_launch_template" "terraform-launch-template" {
  name_prefix   = "terraform-launch-template"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_pair
  #   security_groups = [aws_security_group.terraform-security-group.name]
  vpc_security_group_ids = [aws_security_group.terraform-security-group.id]


  # Tag specifications for the instance
  tag_specifications {
    # Specifies the resource type as "instance"
    resource_type = "instance"

    # Tags to apply to the instance
    tags = {
      Name = "first template"
    }
  }
}



resource "aws_autoscaling_group" "autoscaling-group" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.terraform-launch-template.id
    version = "$Latest"
  }

}


