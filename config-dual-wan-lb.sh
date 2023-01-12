#dual WAN LB + port forward
#ISP1 pppoe0 ORANGE PL (backup)
#ISP2 pppoe2 Fiber (pirmary)
#eth1 LAN

configure

set load-balance group A exclude-local-dns disable
set load-balance group A flush-on-active enable
set load-balance group A gateway-update-interval 30
set load-balance group A interface pppoe0 failover-only
set load-balance group A interface pppoe2 route-test initial-delay 1
set load-balance group A interface pppoe2 route-test interval 10
set load-balance group A interface pppoe2 route-test type ping target 8.8.8.8
set load-balance group A lb-local disable
set load-balance group A lb-local-metric-change disable

set load-balance group B exclude-local-dns disable
set load-balance group B flush-on-active enable
set load-balance group B gateway-update-interval 30
set load-balance group B interface pppoe0 route-test initial-delay 3
set load-balance group B interface pppoe0 route-test interval 10
set load-balance group B interface pppoe0 route-test type
set load-balance group B interface pppoe2 failover-only
set load-balance group B interface pppoe2 route-test initial-delay 1
set load-balance group B interface pppoe2 route-test interval 10
set load-balance group B interface pppoe2 route-test type ping target 8.8.8.8
set load-balance group B lb-local disable
set load-balance group B lb-local-metric-change disable

#group for static client ip enforce to use ISP1
set firewall group address-group WAN_ORANGE address 172.16.71.22

set firewall group network-group PRIVATE_NET network 172.16.0.0/12

set firewall modify PBR_WAN_LB rule 10 action modify
set firewall modify PBR_WAN_LB rule 10 destination group network-group PRIVATE_NET
set firewall modify PBR_WAN_LB rule 10 modify table main
set firewall modify PBR_WAN_LB rule 20 action modify
set firewall modify PBR_WAN_LB rule 20 destination group address-group ADDRv4_pppoe2
set firewall modify PBR_WAN_LB rule 20 modify table main
set firewall modify PBR_WAN_LB rule 21 action modify
set firewall modify PBR_WAN_LB rule 21 destination group address-group ADDRv4_pppoe0
set firewall modify PBR_WAN_LB rule 21 modify table main
set firewall modify PBR_WAN_LB rule 90 action modify
set firewall modify PBR_WAN_LB rule 90 modify lb-group A
set firewall modify PBR_WAN_LB rule 90 source group address-group '!WAN_ORANGE'
set firewall modify PBR_WAN_LB rule 91 action modify
set firewall modify PBR_WAN_LB rule 91 modify lb-group B
set firewall modify PBR_WAN_LB rule 91 source group address-group WAN_ORANGE

set interfaces ethernet eth1 address 172.16.0.1/24
set interfaces ethernet eth1 description Local
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 firewall in modify PBR_WAN_LB
set interfaces ethernet eth1 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth1 poe output off
set interfaces ethernet eth1 speed auto

set protocols static interface-route 0.0.0.0/0 next-hop-interface pppoe0 distance 20
set protocols static interface-route 0.0.0.0/0 next-hop-interface pppoe2 distance 10

set service nat rule 5010 description Fiber
set service nat rule 5010 log disable
set service nat rule 5010 outbound-interface pppoe2
set service nat rule 5010 protocol all
set service nat rule 5010 type masquerade
set service nat rule 5011 description Orange
set service nat rule 5011 log disable
set service nat rule 5011 outbound-interface pppoe0
set service nat rule 5011 protocol all
set service nat rule 5011 type masquerade


set port-forward auto-firewall enable
set port-forward hairpin-nat enable
set port-forward lan-interface eth1
set port-forward rule 1 description http/s
set port-forward rule 1 forward-to address 172.16.3.11
set port-forward rule 1 original-port 80,443
set port-forward rule 1 protocol tcp
set port-forward wan-interface pppoe2 

commit
save
exit

# fix iptables for forward port ( in my case pppoe2 is primary, pppoe0 backup )
cat <<'EOF' >> /config/scripts/post-config.d/fix-iptables-dualwan.sh
#!/bin/sh
/sbin/iptables -t nat -A UBNT_PFOR_DNAT_HOOK -i pppoe0 -m set --match-set ADDRv4_pppoe0 dst -j UBNT_PFOR_DNAT_RULES
/sbin/iptables -t nat -A UBNT_PFOR_DNAT_HOOK -i eth1 -m set --match-set ADDRv4_pppoe0 dst -j UBNT_PFOR_DNAT_RULES
/sbin/iptables -A UBNT_PFOR_FW_HOOK -i pppoe0 -j UBNT_PFOR_FW_RULES
EOF

chmod +x /config/scripts/post-config.d/fix-iptables-dualwan.sh
