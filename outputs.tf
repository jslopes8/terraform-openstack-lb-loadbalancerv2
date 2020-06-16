output "lb_vip" {
  value = "${openstack_networking_floatingip_v2.lb_vip.address}"
}


