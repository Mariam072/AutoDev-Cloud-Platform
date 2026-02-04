resource "aws_ecr_repository" "this" {
  name = "${var.env}-db-check"

  image_scanning_configuration {
    scan_on_push = true
  }
}
