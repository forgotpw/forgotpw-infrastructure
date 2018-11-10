resource "aws_s3_bucket" "deploy" {
  bucket = "forgotpw-deploy-${var.environment}"
  acl    = "private"

  versioning {
    enabled = false
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "userdata" {
  bucket = "forgotpw-userdata-${var.environment}"
  acl    = "private"

  versioning {
    enabled = false
  }

  # SSE-C encryption used for userdata bucket, which is enforced
  # in code but can't be enforced with a rule or bucket policy

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "usertokens" {
  bucket = "forgotpw-usertokens-${var.environment}"
  acl    = "private"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm     = "AES256"
        }
      }
    }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_policy" "usertokens" {
  bucket = "${aws_s3_bucket.usertokens.id}"
  policy =<<POLICY
{
    "Version": "2012-10-17",
    "Id": "PutObjPolicy",
    "Statement": [
          {
              "Sid": "DenyIncorrectEncryptionHeader",
              "Effect": "Deny",
              "Principal": "*",
              "Action": "s3:PutObject",
              "Resource": "arn:aws:s3:::${aws_s3_bucket.usertokens.bucket}/*",
              "Condition": {
                      "StringNotEquals": {
                              "s3:x-amz-server-side-encryption": "AES256"
                        }
              }
          },
          {
              "Sid": "DenyUnEncryptedObjectUploads",
              "Effect": "Deny",
              "Principal": "*",
              "Action": "s3:PutObject",
              "Resource": "arn:aws:s3:::${aws_s3_bucket.usertokens.bucket}/*",
              "Condition": {
                      "Null": {
                              "s3:x-amz-server-side-encryption": true
                      }
              }
          }
    ]
}
POLICY
}
