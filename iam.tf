#--------------------------------------------------------------
# IAM Instance Profile
#--------------------------------------------------------------
resource "aws_iam_instance_profile" "ec2_profile" {
  depends_on = ["aws_iam_role.ec2_role"]
  name       = "${var.global_product}.${var.global_environment}.${var.ec2_role}.ec2-profile"
  role       = "${aws_iam_role.ec2_role.name}"
}

#--------------------------------------------------------------
# IAM Role
#--------------------------------------------------------------
resource "aws_iam_role" "ec2_role" {
  name = "${var.global_product}.${var.global_environment}.${var.ec2_role}.ec2-role"
  path = "/"

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


#--------------------------------------------------------------
# S3 Policy
#--------------------------------------------------------------
resource "aws_iam_role_policy" "s3_policy" {
  depends_on = ["aws_iam_role.ec2_role"]
  name       = "s3_policy"
  role       = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:GetBucketLocation",
              "s3:ListBucket",
              "s3:ListAllMyBuckets"
          ],
          "Resource": [
              "arn:aws:s3:::*"
          ]
      },
      {
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:GetObject"
          ],
          "Resource": [
              "arn:aws:s3:::webstack-env-*"

          ]
      }
  ]
}
EOF
}

#--------------------------------------------------------------
# iam Policy
#--------------------------------------------------------------
resource "aws_iam_role_policy" "iam_policy" {
  depends_on = ["aws_iam_role.ec2_role"]
  name       = "iam_policy"
  role       = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies"
            ],
            "Resource": [
                "arn:aws:iam::*:policy/*",
                "arn:aws:iam::*:role/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "iam:ListPolicies",
                "iam:ListServerCertificates",
                "iam:ListRoles",
                "iam:ListVirtualMFADevices",
                "iam:GetServerCertificate"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:GetInstanceProfile",
                "iam:PutRolePolicy",
                "iam:GetRolePolicy"
            ],
            "Resource": [
                "arn:aws:iam::*:instance-profile/*",
                "arn:aws:iam::*:role/*"
            ]
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        }
    ]
}
EOF
}

#--------------------------------------------------------------
# EC2 Policy
#--------------------------------------------------------------
resource "aws_iam_role_policy" "ec2_policy" {
  depends_on = ["aws_iam_role.ec2_role"]
  name       = "ec2_policy"
  role       = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DeleteTags",
                "ec2:DescribeLaunchTemplates",
                "ec2:CreateTags",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:DescribePlacementGroups",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeImages",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeSubnets",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeAddresses",
                "ec2:AllocateAddress",
                "ec2:DescribeInstances",
                "ec2:AssociateAddress",
                "ec2:DisassociateAddress"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#--------------------------------------------------------------
# SSM Policy
#--------------------------------------------------------------
resource "aws_iam_role_policy" "ssm_policy" {
  depends_on = ["aws_iam_role.ec2_role"]
  name       = "ssm_policy"
  role       = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:GetParametersByPath",
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
