variable "create" {
    type    = bool
    default = true
}
variable "number_nodes" {
    type    = number
}
variable "name" {
    type    = string
}
variable "admin_state_up" {
    type    = string
}
variable "security_group_ids" {
    type    = list(string)
    default = []
}
variable "floatingip_pool" {
    type    = string
}
variable "lb_listener" {
    type    = list(map(string))
    default = []
}
variable "lb_pool" {
    type    = list(map(string))
    default = []
}
variable "network_id" {
    type    = string
}
variable "vm_private_ips" {
    #type    = string
}
variable "health_check" {
    type    = list(map(string))
    default =  []
}
variable "protocol_port" {
    type    = string
}
