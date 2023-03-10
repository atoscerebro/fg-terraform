output "aws_instance_ids" {
  value       = [for s in aws_instance.test_instance : s.id]
  description = "The ids of the aws ec2 instances."
}

