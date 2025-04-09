resource "aws_ecr_repository" "demo_ecr" {
  name                 = "demo-ecr"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}
