# I- Example
# Request a spot instance at ~$0.03

resource "aws_spot_instance_request" "cheap_worker" {
  ami           = "ami-1234"
  spot_price    = "0.03"
  instance_type = "c4.xlarge"

  tags = {
    Name = "CheapWorker"
  }
}



################################

# II- Second Example

resource "aws_security_group" "ingress-ssh-test" {
  name   = "allow-ssh-sg"
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-http-test" {
  name   = "allow-http-sg"
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-https-test" {
  name   = "allow-https-sg"
  vpc_id = "${aws_vpc.test-env.id}"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_spot_instance_request" "test_worker" {
  ami                    = "ami-66a7871c"
  spot_price             = "0.016"
  instance_type          = "t3.small"
  spot_type              = "one-time"
  block_duration_minutes = "120"
  wait_for_fulfillment   = "true"
  key_name               = "spot_key"

  security_groups = ["${aws_security_group.ingress-ssh-test.id}", "${aws_security_group.ingress-http-test.id}",
  "${aws_security_group.ingress-https-test.id}"]
  subnet_id = "${aws_subnet.subnet-uno.id}"
  }

