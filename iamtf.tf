provider "aws" {
region = "us-east-1"
}
#create IAM group
resource "aws_iam_group" "ec2_group" {
name = "EC2-Only-GRP"
}
#attach EC2 policy to group
resource "aws_iam_group_policy_attachment" "ec2_attach" {
  group      = aws_iam_group.ec2_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
#create EC2 user
resource "aws_iam_user" "ec2_user" {
  name = "ec2user"
}
#attach user with group
resource "aws_iam_user_group_membership" "membership" {
  user = aws_iam_user.ec2_user.name

  groups = [
    aws_iam_group.ec2_group.name
  ]
}

