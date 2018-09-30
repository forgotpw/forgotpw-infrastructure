resource "aws_iam_role" "ops-devops" {
  name = "role-ops-devops"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
            "arn:aws:iam::${var.aws-master-account-id}:root"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
