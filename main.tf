resource "openstack_lb_loadbalancer_v2" "lb" {
    name                = "${var.name}"
    admin_state_up      = "${var.admin_state_up}"
    vip_subnet_id       = "${var.network_id}"
    security_group_ids  = "${var.security_group_ids}"
}
resource "openstack_networking_floatingip_v2" "lb_vip" {
    pool    = "${var.floatingip_pool}"
    port_id = "${openstack_lb_loadbalancer_v2.lb.vip_port_id}"

    depends_on = [
        "openstack_lb_loadbalancer_v2.lb",
    ]
}
resource "openstack_lb_listener_v2" "lb_listener" {
    count = var.create ? length(var.lb_listener) : 0
    
    protocol        = var.lb_listener[count.index]["protocol"]
    protocol_port   = var.lb_listener[count.index]["protocol_port"]
    loadbalancer_id = "${openstack_lb_loadbalancer_v2.lb.id}"
}
resource "openstack_lb_pool_v2" "lb_pool" {
    count   = var.create ? length(var.lb_pool) : 0
    
    protocol    = var.lb_pool[count.index]["protocol"]
    lb_method   = var.lb_pool[count.index]["lb_method"]
    listener_id = "${openstack_lb_listener_v2.lb_listener.0.id}"
}
resource "openstack_lb_member_v2" "lb_member" {
    count         = var.number_nodes

    name          = "${var.name}-lb-member"
    pool_id       = "${openstack_lb_pool_v2.lb_pool.0.id}"
    subnet_id     = "${var.network_id}"
    address       = "${element(var.vm_private_ips, count.index)}"
    protocol_port = "${var.protocol_port}"

    depends_on = [
        "openstack_lb_loadbalancer_v2.lb",
  ]
}
resource "openstack_lb_monitor_v2" "health_check" {
    count   = var.create ? length(var.health_check) : 0

    pool_id        = "${openstack_lb_pool_v2.lb_pool.0.id}"

    type           = var.health_check[count.index]["type"]
    delay          = var.health_check[count.index]["delay"]
    timeout        = var.health_check[count.index]["timeout"]
    max_retries    = var.health_check[count.index]["max_retries"]
    url_path       = var.health_check[count.index]["url_path"]
    expected_codes = var.health_check[count.index]["expected_codes"]
}
