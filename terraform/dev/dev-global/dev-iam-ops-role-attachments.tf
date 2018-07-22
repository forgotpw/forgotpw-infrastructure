resource "aws_iam_role_policy_attachment" "ops-devops-attach-admin" {
  role       = "${aws_iam_role.ops-devops.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
