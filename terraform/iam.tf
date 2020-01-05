# ACCOUNT PASSWORD POLICY
resource "aws_iam_account_password_policy" "root-account-password-policy" {
  minimum_password_length        = 10
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}

# ADMIN GROUP
resource "aws_iam_group" "admins" {
  name = "admins"
  path = "/users/"
}

resource "aws_iam_group_membership" "admin-users-group-memebership" {
  name  = "admin-users-group-membership"
  users = aws_iam_user.admin-users.*.name
  group = aws_iam_group.admins.name
}

# ADMIN POLICY
data "aws_iam_policy_document" "admin-group-policy-document" {
  statement {
    actions = [
      "*",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "admin-policy" {
  name   = "admin-policy"
  policy = data.aws_iam_policy_document.admin-group-policy-document.json
}

resource "aws_iam_group_policy_attachment" "admin-group-policy-attachment" {
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.admin-policy.arn
}

# ADMIN USERS
resource "aws_iam_user" "admin-users" {
  count = length(var.users)
  name  = "${element(var.users, count.index)}-admin"
}

# EC2 ROLE 
resource "aws_iam_role" "ec2-s3-admin" {
  name = "ec2-s3-admin"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "ec2-s3-admin-policy" {
  name = "ec2-s3-admin-policy"
  role = aws_iam_role.ec2-s3-admin.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

