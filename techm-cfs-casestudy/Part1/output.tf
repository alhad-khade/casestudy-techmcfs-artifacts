output "vm_public_ip_pl1" {
    value = aws_instance.pl1.public_ip
}

 output "vm_public_ip_pl2" {
    value = aws_instance.pl2.public_ip
}