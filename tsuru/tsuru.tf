provider "aws" {
    access_key = "XXXXXXXXXXX"
    secret_key = "XXXXXXXXXXX"
    region     = "us-west-2"
}
resource "aws_instance" "web"{
    ami           = "ami-00f7c900d2e7133e1"
    instance_type = "t2.micro"
    key_name      = "chave"
    associate_public_ip_address = "true"
tags {
    Name = "Conductor-lab"
}
connection {
    type = "ssh"
    user = "centos"
    private_key = "${file("[PATH OF YOUR KEY]")}"
    timeout = "2m"
}
## INSTALLING THE DOCKER ##
provisioner "remote-exec"  {
    inline = [
     "sudo apt-get update",
     "sudo apt-get install apt-transport-https ca-certificates  curl software-properties-common",
     "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
     "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'",
     "sudo apt-get update",
     "sudo apt-get install docker-ce",
     "sudo systemctl start docker",
     "sudo usermod -aG docker centos"
 ]
}
## INSTALLING AND CONFIGURING TSURU ##
provisioner "remote-exec"  {
    inline = [
     "git clone https://github.com/VictorGabriel56/Tsuru-Docker.git",
     "./build-compose.sh",
     "sudo docker restart tsuru_api ",
     "sudo docker exec -it gandalf chown git:git /var/lib/gandalf/repositories/ && sudo docker exec -it gandalf apk update -y && sudo docker exec -it gandalf apk add python -y"
    ]
}

## CREATING HOST FILE FOR USE OF THE ANSIBLE ##
provisioner "local-exec" {
    command = "echo [conductorLab:vars] >> /etc/ansible/hosts"
}
provisioner "local-exec" {
    command = "sudo echo ansible_ssh_user=centos >> /etc/ansible/hosts"
    }
provisioner "local-exec" {
    command = "sudo echo ansible_ssh_private_key_file = /etc/ansible/chave.pem >> /etc/ansible/hosts"
}
provisioner "local-exec" {
    command = "sudo echo >> /etc/ansible/hosts"
    }
provisioner "local-exec" {
    command = "sudo echo [conductorLab] >> /etc/ansible/hosts"
    }
provisioner "local-exec" {
    command = "sudo echo ${aws_instance.web.public_ip} >> /etc/ansible/hosts"   
  }
provisioner "local-exec" {
    command = "sudo echo >> /etc/ansible/hosts"
    }

}

resource "aws_security_group" "security_group" {
  ingress {
      protocol = "0"
      from_port = 22
      to_port = 22
      cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
      protocol = "0"
      from_port = 0
      to_port = 65535
      cidr_blocks = ["10.0.0.0/24"]
  }
  ingress {
      protocol = "0"
      from_port = 8443
      to_port = 8443
      cidr_blocks = ["10.0.0.0/24"]
 }
  ingress {
         protocol = "0"
         from_port = 10022
         to_port = 10022
         cidr_blocks = ["10.0.0.0/24"]
     }
  ingress {
         protocol = "0"
         from_port = 10080
         to_port = 10080
         cidr_blocks = ["10.0.0.0/24"]
     }
  ingress {
         protocol = "0"
         from_port = 53
         to_port = 53
         cidr_blocks = ["10.0.0.0/24"]
     }
  ingress {
         protocol = "0"
         from_port = 80
         to_port = 80
         cidr_blocks = ["10.0.0.0/24"]
     }
  ingress {
         protocol = "0"
         from_port = 443
         to_port = 443
         cidr_blocks = ["10.0.0.0/24"]
     }
  egress {
         protocol = "0"
         from_port = 8443
         to_port = 8443
         cidr_blocks = ["10.0.0.0/24"]
     }
  egress {
         protocol = "0"
         from_port = 10022
         to_port = 10022
         cidr_blocks = ["10.0.0.0/24"]
     }
  egress {
         protocol = "0"
         from_port = 10080
         to_port = 10080
         cidr_blocks = ["10.0.0.0/24"]
     }
  egress {
         protocol = "0"
         from_port = 53
         to_port = 53
         cidr_blocks = ["10.0.0.0/24"]
     }
  egress {
         protocol = "0"
         from_port = 80
         to_port = 80
         cidr_blocks = ["10.0.0.0/24"]
     }
  egress {
         protocol = "0"
         from_port = 443
         to_port = 443
         cidr_blocks = ["10.0.0.0/24"]
     }
}