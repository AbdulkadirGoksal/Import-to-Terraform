variable "web_ingress" {
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr_block  = list(string)
  }))
  default = {
    "80" = {
      description = "Port 80"
      port        = 80
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    }
    "443" = {
      description = "Port 443"
      port        = 443
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    }
  }
}