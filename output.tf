output "Elastic_IP" {
  value = "${aws_eip.bastion.public_ip}"
}

output "min_size" {
  value = "${aws_autoscaling_group.bastion_asg.min_size}"
}

output "max_size" {
  value = "${aws_autoscaling_group.bastion_asg.max_size}"
}
