provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_key_pair" "app_ssh" {
  key_name   = "id-rsa-name"
  public_key = var.vm_ssh_public_key
  tags = {
    Name      = "id-rsa"
    Project   = "TechM-CFS-CaseStudy"
  }
}

resource "aws_instance" "pl1" {
  # Ubuntu Pipeline 1 VM
  ami                         = var.ami
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  key_name                    = aws_key_pair.app_ssh.key_name
  associate_public_ip_address = true

  tags = {
    Name      = "pipeline-1-vm"
    Project   = "TechM-CFS-CaseStudy"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install openjdk-11-jre -y",
      "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install jenkins",
      "sudo systemctl enable jenkins",
      "sudo systemctl start jenkins",
      "sudo apt-get update",
    ]
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("C:\\Users\\Administrator\\.ssh\\id_rsa")
      timeout     = "4m"
   }
}

resource "aws_instance" "pl2" {
  # Ubuntu Pipeline 2 VM
  ami                         = var.ami
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  key_name                    = aws_key_pair.app_ssh.key_name
  associate_public_ip_address = true

  tags = {
    Name      = "pipeline-2-vm"
    Project   = "TechM-CFS-CaseStudy"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install openjdk-11-jre -y",
      "sudo apt-get update",
      "sudo apt-get install -y maven",
      "sudo apt-get install -y docker*",
      "sudo apt install -y gnupg2 pass",
      "sudo chmod 666 /var/run/docker.sock",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install git",
      "sudo apt-get update -y",
      "sudo apt-get install awscli -y",
    ]
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("C:\\Users\\Administrator\\.ssh\\id_rsa")
      timeout     = "4m"
   }

}

resource "aws_security_group" "vm_sg" {
  name        = "vm-security-group"
  description = "Allow incoming connections."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
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

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}