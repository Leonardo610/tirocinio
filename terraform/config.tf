#provider "aws" {
#   credentials_provider = "iam"
#   iam_role = "http://169.254.169.254:80/latest/meta-data/iam/security-credentials/jenkins-server"
# }


# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "eu-west-1"
}

# #Configurazione del Load Balancer
# resource "aws_elb" "xpepper_lb" {
# 	name = "xpeppers-terraform-elb"
# 	availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

# 	listener {
# 		instance_port = 80
# 		instance_protocol = "http"
# 		lb_port = 80
# 		lb_protocol = "http"
# 	}

# 	health_check {
# 		healthy_threshold = 2
# 		unhealthy_threshold = 2
# 		target = "HTTP:8000/"
# 		interval = 30
# 		timeout = 3
# 	}

# 	#Aggiungere le istanze
# 	#instances = ["${aws_instance.first_instance.id}", "${aws_instance.second_instance.id}"]
# 	#cross_zone_load_balancing = true
# 	#idle_timeout = 60 di default
# 	#connection_draining = true
# 	#connection_draining_timeout = 400

# 	tags {
# 		Name = "xpeppers-terraform-elb"
# 	}
# }

#Prima istanza
resource "aws_instance" "first_instance" {
	ami = "ami-bd2f57ce"
	instance_type = "t2.small"
	security_groups = ["test-terraform"]
	key_name = "${var.key}"

    tags {
        Name = "slave"
    }

	provisioner "file" {
        source = "../provision.sh"
        destination = "/home/centos/provision.sh"
        connection {
            user = "centos"
            key_file = "${var.key_file}"
            timeout = "60s"
        }
    }

    provisioner "remote-exec" {
        inline = [
          	"chmod +x /home/centos/provision.sh",
          	"/home/centos/provision.sh"
        ]
        connection {
            user = "centos"
            key_file = "${var.key_file}"
            timeout = "60s"
        }
    }
}

# resource "aws_eip" "ip1" {
# 	instance = "${aws_instance.first_instance.id}"
#     lifecycle {
#         prevent_destroy = false
#     }
# }
	
# Seconda istanza
# resource "aws_instance" "second_instance" {
# 	ami = "ami-7abd0209"
# 	instance_type = "t2.micro"
# 	security_groups = ["test-terraform"]
# 	key_name = "${var.key}"

# 	provisioner "file" {
#       source = "./provision.sh"
#        destination = "/home/centos"
#        connection {
#            user = "centos"
#            key_file = "/Users/orione-#team/terraformWork/terraformTirocinio/keyterraform.pem"
#            timeout = "60s"
#        }
#    }

#    provisioner "remote-exec" {
#        inline = [
#          	"chmod +x /home/centos/chef/provision.sh",
#          	"/home/centos/chef/provision.sh"
#        ]
#        connection {
#            user = "centos"
#            key_file = "/Users/orione-#team/terraformWork/terraformTirocinio/keyterraform.pem"
#            timeout = "60s"
#        }
#    }
# }

#resource "aws_eip" "ip2" {
#	instance = "${aws_instance.second_instance.id}"
#}