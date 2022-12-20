provider "aws" { #encrypted in S3
  access_key = "*************************" 
  secret_key = "*************************"
  region = var.region
}

resource "aws_launch_configuration" "bastion_lc" {
  name                        = "Bastion-LC"              # OR name_prefix = "Highly-Available-LC-"
  image_id                    = "ami-0b0dcb5067f052a63"   # doest work with Ubuntu.... works only with AWS-Linux. Why?  Ubuntu AMI: "ami-061dbd1209944525c".
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.ssh_key_pair
  security_groups             = [aws_security_group.bastion-server.id]
  iam_instance_profile        = "${aws_iam_instance_profile.bastion-node.name}"  
  
    user_data = templatefile("user_data.sh", {
    eip    = "${aws_eip.bastion.id}",
    region = "${var.region}"
  })
}

resource "aws_autoscaling_group" "bastion_asg" {
 vpc_zone_identifier         = var.subnets
  desired_capacity           = 1
  min_size                   = 1
  max_size                   = 1
  name                       = "ASG-Bastion"              # OR ${aws_launch_configuration.bastion_lc.name}"
  launch_configuration       = aws_launch_configuration.bastion_lc.name

  tags = [
    {
      key                 = "Name",
      value               = "Bastion Instance",
      propagate_at_launch = true
    }
  ]  
}

data "aws_subnet_ids" "subnet_ids" {                      # !Warning: Deprecated Resource
  vpc_id = "${var.vpc}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_default_subnet" "primary" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.available.names[1]
}









#data "aws_subnet" "subnets" {
  #count = "${length(data.aws_subnet_ids.subnet_ids.ids)}"
  #id    = "${tolist(data.aws_subnet_ids.subnet_ids.ids)[count.index[0]]}"
#}

/* ------check
tags = "${merge(map("Name", "${var.env_name} EIP"),
  var.tags_all)}"
  
   
   tags = "${concat(var.tags_ec2,
    list(
      map("key", "Name",
        "value", "${var.env_name}",
      "propagate_at_launch", "true")
  ))}"

  depends_on = [
      aws_instance.my_server_bd
   ]

*/

