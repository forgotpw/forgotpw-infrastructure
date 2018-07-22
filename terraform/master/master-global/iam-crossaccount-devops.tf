# https://signin.aws.amazon.com/switchrole?account=478543871670&roleName=role-ops-devops&displayName=FPW_dev_devops

resource "aws_iam_policy" "env-assumerole-ops-devops" {
  count = "${length(var.aws-account-abbrevs)}"

  name = "policy-assumerole-ops-${element(var.aws-account-abbrevs, count.index)}-devops"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["sts:AssumeRole"],
    "Resource": "arn:aws:iam::${var.aws-accounts["${element(var.aws-account-abbrevs, count.index)}"]}:role/role-ops-devops"
  }]
}
EOF
}

resource "aws_iam_group" "env-devops" {
  count = "${length(var.aws-account-abbrevs)}"

  name = "${element(var.aws-account-abbrevs, count.index)}-devops"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "env-devops-attach-assumerole" {
  count = "${length(var.aws-account-abbrevs)}"

  group      = "${aws_iam_group.env-devops.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.env-assumerole-ops-devops.*.arn[count.index]}"
}
