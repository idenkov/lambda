resource "aws_db_instance" "rds" {
    allocated_storage       = 10
    storage_type            = "gp2"
    engine                  = "postgres"
    engine_version          = "11.5"
    instance_class          = "db.t2.micro"
    name                    = "lambda"
    username                = data.aws_ssm_parameter.postgre_user.value
    password                = data.aws_ssm_parameter.postgre_password.value
    vpc_security_group_ids  = [aws_security_group.allow_rds_remote.id]
    publicly_accessible     = true
    apply_immediately       = true
    skip_final_snapshot     = true
}
resource "aws_security_group" "allow_rds_remote" {
  name        = "allow_rds_remote"
  description = "Allow connections to RDS"

  ingress {
    description = "Allow postgres ingress"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "random_string" "db_pass" {
  length            = 40
  special           = true
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}
resource "aws_ssm_parameter" "rds_user" {
  name  = "/lambda/postgresql/user/master"
  type  = "String"
  value = "lambda"
}
resource "aws_ssm_parameter" "rds_secret" {
  name        = "/lambda/postgresql/password/master"
  description = "Master password for RDS instance"
  type        = "SecureString"
  value       = random_string.db_pass.result
}
data "aws_ssm_parameter" "postgre_user" {
  name       = "/lambda/postgresql/user/master"
  depends_on = [aws_ssm_parameter.rds_user]
}
data "aws_ssm_parameter" "postgre_password" {
  name       = "/lambda/postgresql/password/master"
  depends_on = [aws_ssm_parameter.rds_secret]
}