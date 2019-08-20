

# ADMIN GROUP
resource "aws_iam_group" "admins" {
  name = "admins"
  path = "/users/"
}

resource "aws_iam_group_membership" "admin-users-group-memebership" {
  name = "admin-users-group-membership"
  users = "${aws_iam_user.admin-users.*.name}"
  group = "${aws_iam_group.admins.name}"
}

# ADMIN POLICY
data "aws_iam_policy_document" "admin-group-policy-document" {
  statement {
    actions = [
      "*"]
    resources = [
      "*"]
  }
}

resource "aws_iam_policy" "admin-policy" {
  name = "admin-policy"
  policy = "${data.aws_iam_policy_document.admin-group-policy-document.json}"
}

resource "aws_iam_group_policy_attachment" "admin-group-policy-attachment" {
  group      = "${aws_iam_group.admins.name}"
  policy_arn = "${aws_iam_policy.admin-policy.arn}"
}

# ADMIN USERS
resource "aws_iam_user" "admin-users" {
  count = "${length(var.users)}"
  name  = "${element(var.users,count.index)}-admin"
}



