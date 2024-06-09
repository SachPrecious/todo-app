resource "aws_security_group" "allow_ssh" {
  vpc_id = ""
  name = "allow-ssh-for-jenkins-server"
  description = "This security group allows ssh"

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    Name = "allow-ssh"
}

}