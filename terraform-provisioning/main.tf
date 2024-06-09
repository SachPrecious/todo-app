resource "aws_instance" "jenkins-server" {
  ami = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  key_name = ""
  subnet_id = ""

  tags = {
    Name = "Jenkins_Server"
    ApplicationName= "Jenkins"
  }
}

