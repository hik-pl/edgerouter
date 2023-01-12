
#ISP Orange PL IPv6 + TV
configure
set interfaces ethernet eth0 description WAN_ORANGE
set interfaces ethernet eth0 duplex auto
set interfaces ethernet eth0 mtu 1564
set interfaces ethernet eth0 poe output off
set interfaces ethernet eth0 speed auto
set interfaces ethernet eth0 vif 35 mtu 1556
set interfaces ethernet eth0 vif 35 pppoe 0 default-route none
set interfaces ethernet eth0 vif 35 pppoe 0 firewall in name WAN_IN
set interfaces ethernet eth0 vif 35 pppoe 0 firewall local name WAN_LOCAL
set interfaces ethernet eth0 vif 35 pppoe 0 mtu 1492
set interfaces ethernet eth0 vif 35 pppoe 0 name-server auto
set interfaces ethernet eth0 vif 35 pppoe 0 password USER-PASSWORD
set interfaces ethernet eth0 vif 35 pppoe 0 user-id USER-LOGIN@neostrada.pl

set interfaces ethernet eth0 vif 35 pppoe 1 default-route auto
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 prefix-length /56
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd prefix-only
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd rapid-commit enable
set interfaces ethernet eth0 vif 35 pppoe 1 firewall in ipv6-name WANv6_IN
set interfaces ethernet eth0 vif 35 pppoe 1 firewall local ipv6-name WANv6_LOCAL
set interfaces ethernet eth0 vif 35 pppoe 1 ipv6 address autoconf
set interfaces ethernet eth0 vif 35 pppoe 1 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth0 vif 35 pppoe 1 ipv6 enable
set interfaces ethernet eth0 vif 35 pppoe 1 mtu 1492
set interfaces ethernet eth0 vif 35 pppoe 1 name-server auto
set interfaces ethernet eth0 vif 35 pppoe 1 password USER-PASSWORD
set interfaces ethernet eth0 vif 35 pppoe 1 user-id USER-LOGIN@neostrada.pl/ipv6

#ipv6 pd for interface for defailt LAN on eth0
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth1 host-address '::1'
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth1 no-dns
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth1 prefix-id ':1'
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth1 service slaac

#example ipv6 pd for vlan 8 on eth4
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth4.8 host-address '::1'
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth4.8 no-dns
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth4.8 prefix-id ':08'
set interfaces ethernet eth0 vif 35 pppoe 1 dhcpv6-pd pd 0 interface eth4.8 service slaac

set interfaces ethernet eth0 vif 838 address 172.16.83.8/32
set interfaces ethernet eth0 vif 838 dhcp-options client-option 'send vendor-class-identifier &quot;sagemcom&quot;;'
#PUT LIVEBOX MAC address after 1:
set interfaces ethernet eth0 vif 838 dhcp-options client-option 'send dhcp-client-identifier 1:MAC:MAC:MAC:CH:AN:GE;'
set interfaces ethernet eth0 vif 838 dhcp-options client-option 'send user-class &quot;\047FSVDSL_funbox2.MLTV.softathome.Funbox2&quot;;'
set interfaces ethernet eth0 vif 838 dhcp-options client-option 'request subnet-mask, routers, rfc3442-classless-static-routes;'
set interfaces ethernet eth0 vif 838 dhcp-options default-route update
set interfaces ethernet eth0 vif 838 dhcp-options default-route-distance 210
set interfaces ethernet eth0 vif 838 dhcp-options name-server update
set interfaces ethernet eth0 vif 838 egress-qos '0:4 1:4 2:4 3:4 4:4 5:4 6:4 7:4'
set interfaces ethernet eth0 vif 838 mtu 1500
set interfaces ethernet eth0 vif 838 traffic-policy out neo_upload
set interfaces ethernet eth0 vif 839 address 172.16.83.9/32
set interfaces ethernet eth0 vif 839 description ORANGE_MULTICAST
set interfaces ethernet eth0 vif 839 egress-qos '0:4 1:4 2:4 3:4 4:4 5:4 6:4 7:4'

set interfaces ethernet eth1 address 172.16.0.1/24
set interfaces ethernet eth1 description Local
set interfaces ethernet eth1 duplex auto
set interfaces ethernet eth1 ipv6 dup-addr-detect-transmits 1
set interfaces ethernet eth1 poe output off
set interfaces ethernet eth1 speed auto 

set firewall options mss-clamp6 interface-type pppoe
set firewall options mss-clamp6 mss 1432

set firewall ipv6-name WANv6_IN default-action drop
set firewall ipv6-name WANv6_IN description 'WAN inbound traffic forwarded to LAN'
set firewall ipv6-name WANv6_IN rule 10 action accept
set firewall ipv6-name WANv6_IN rule 10 description 'Allow established/related sessions'
set firewall ipv6-name WANv6_IN rule 10 state established enable
set firewall ipv6-name WANv6_IN rule 10 state related enable
set firewall ipv6-name WANv6_IN rule 20 action drop
set firewall ipv6-name WANv6_IN rule 20 description 'Drop invalid state'
set firewall ipv6-name WANv6_IN rule 20 state invalid enable
set firewall ipv6-name WANv6_IN rule 301 action accept
set firewall ipv6-name WANv6_IN rule 301 description 'icmpv6 destination-unreachable'
set firewall ipv6-name WANv6_IN rule 301 icmpv6 type destination-unreachable
set firewall ipv6-name WANv6_IN rule 301 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 302 action accept
set firewall ipv6-name WANv6_IN rule 302 description 'icmpv6 packet-too-big'
set firewall ipv6-name WANv6_IN rule 302 icmpv6 type packet-too-big
set firewall ipv6-name WANv6_IN rule 302 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 303 action accept
set firewall ipv6-name WANv6_IN rule 303 description 'icmpv6 time-exceeded'
set firewall ipv6-name WANv6_IN rule 303 icmpv6 type time-exceeded
set firewall ipv6-name WANv6_IN rule 303 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 304 action accept
set firewall ipv6-name WANv6_IN rule 304 description 'icmpv6 parameter-problem'
set firewall ipv6-name WANv6_IN rule 304 icmpv6 type parameter-problem
set firewall ipv6-name WANv6_IN rule 304 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 305 action accept
set firewall ipv6-name WANv6_IN rule 305 description 'icmpv6 echo-request'
set firewall ipv6-name WANv6_IN rule 305 icmpv6 type echo-request
set firewall ipv6-name WANv6_IN rule 305 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 306 action accept
set firewall ipv6-name WANv6_IN rule 306 description 'icmpv6 echo-reply'
set firewall ipv6-name WANv6_IN rule 306 icmpv6 type echo-reply
set firewall ipv6-name WANv6_IN rule 306 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 307 action accept
set firewall ipv6-name WANv6_IN rule 307 description 'icmpv6 neighbor-advertisement'
set firewall ipv6-name WANv6_IN rule 307 icmpv6 type neighbor-advertisement
set firewall ipv6-name WANv6_IN rule 307 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 308 action accept
set firewall ipv6-name WANv6_IN rule 308 description 'icmpv6 neighbor-solicitation'
set firewall ipv6-name WANv6_IN rule 308 icmpv6 type neighbor-solicitation
set firewall ipv6-name WANv6_IN rule 308 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 309 action accept
set firewall ipv6-name WANv6_IN rule 309 description 'icmpv6 redirect'
set firewall ipv6-name WANv6_IN rule 309 icmpv6 type redirect
set firewall ipv6-name WANv6_IN rule 309 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 310 action accept
set firewall ipv6-name WANv6_IN rule 310 description 'icmpv6 router-advertisement'
set firewall ipv6-name WANv6_IN rule 310 icmpv6 type router-advertisement
set firewall ipv6-name WANv6_IN rule 310 protocol ipv6-icmp
set firewall ipv6-name WANv6_IN rule 311 action accept
set firewall ipv6-name WANv6_IN rule 311 description 'icmpv6 router-solicitation'
set firewall ipv6-name WANv6_IN rule 311 icmpv6 type router-solicitation
set firewall ipv6-name WANv6_IN rule 311 protocol ipv6-icmp

set firewall ipv6-name WANv6_LOCAL default-action drop
set firewall ipv6-name WANv6_LOCAL description 'WAN inbound traffic to the router'
set firewall ipv6-name WANv6_LOCAL rule 10 action accept
set firewall ipv6-name WANv6_LOCAL rule 10 description 'Allow established/related sessions'
set firewall ipv6-name WANv6_LOCAL rule 10 state established enable
set firewall ipv6-name WANv6_LOCAL rule 10 state related enable
set firewall ipv6-name WANv6_LOCAL rule 20 action drop
set firewall ipv6-name WANv6_LOCAL rule 20 description 'Drop invalid state'
set firewall ipv6-name WANv6_LOCAL rule 20 state invalid enable
set firewall ipv6-name WANv6_LOCAL rule 30 action accept
set firewall ipv6-name WANv6_LOCAL rule 30 description 'Allow IPv6 icmp'
set firewall ipv6-name WANv6_LOCAL rule 30 protocol ipv6-icmp
set firewall ipv6-name WANv6_LOCAL rule 40 action accept
set firewall ipv6-name WANv6_LOCAL rule 40 description 'allow dhcpv6'
set firewall ipv6-name WANv6_LOCAL rule 40 destination port 546
set firewall ipv6-name WANv6_LOCAL rule 40 protocol udp
set firewall ipv6-name WANv6_LOCAL rule 40 source port 547 


set interfaces ethernet eth4 vif 71 address 172.16.71.1/24
set interfaces ethernet eth4 vif 71 description TV

set protocols igmp-proxy interface eth0.839 alt-subnet 0.0.0.0/0
set protocols igmp-proxy interface eth0.839 role upstream
set protocols igmp-proxy interface eth0.839 threshold 1
set protocols igmp-proxy interface eth1 role disabled
set protocols igmp-proxy interface eth1 threshold 1
set protocols igmp-proxy interface eth4.71 alt-subnet 0.0.0.0/0
set protocols igmp-proxy interface eth4.71 role downstream
set protocols igmp-proxy interface eth4.71 threshold 1

set service nat rule 5012 description tv
set service nat rule 5012 log disable
set service nat rule 5012 outbound-interface eth0.838
set service nat rule 5012 protocol all
set service nat rule 5012 type masquerade
commit
save
exit

cat <<'EOF' > /config/scripts/rfc3442-classless-routes.sh
# set classless routes based on the format specified in RFC3442
# e.g.:
#   new_rfc3442_classless_static_routes='24 192 168 10 192 168 1 1 8 10 10 17 66 41'
# specifies the routes:
#   192.168.10.0/24 via 192.168.1.1
#   10.0.0.0/8 via 10.10.17.66.41

RUN="yes"


if [ "$RUN" = "yes" ]; then
        if [ -n "$new_rfc3442_classless_static_routes" ]; then
                if [ "$reason" = "BOUND" ] || [ "$reason" = "REBOOT" ]; then

                        set -- $new_rfc3442_classless_static_routes

                        while [ $# -gt 0 ]; do
                                net_length=$1
                                via_arg=''

                                case $net_length in
                                        32|31|30|29|28|27|26|25)
                                                net_address="${2}.${3}.${4}.${5}"
                                                gateway="${6}.${7}.${8}.${9}"
                                                shift 9
                                                ;;
                                        24|23|22|21|20|19|18|17)
                                                net_address="${2}.${3}.${4}.0"
                                                gateway="${5}.${6}.${7}.${8}"
                                                shift 8
                                                ;;
                                        16|15|14|13|12|11|10|9)
                                                net_address="${2}.${3}.0.0"
                                                gateway="${4}.${5}.${6}.${7}"
                                                shift 7
                                                ;;
                                        8|7|6|5|4|3|2|1)
                                                net_address="${2}.0.0.0"
                                                gateway="${3}.${4}.${5}.${6}"
                                                shift 6
                                                ;;
                                        0)      # default route
                                                net_address="0.0.0.0"
                                                gateway="${2}.${3}.${4}.${5}"
                                                shift 5
                                                ;;
                                        *)      # error
                                                return 1
                                                ;;
                                esac

                                # take care of link-local routes
                                if [ "${gateway}" != '0.0.0.0' ]; then
                                        via_arg="via ${gateway}"
                                fi

                                # set route (ip detects host routes automatically)
                                ip -4 route add "${net_address}/${net_length}" \
                                        ${via_arg} dev "${interface}" >/dev/null 2>&1
                        done
                fi
        fi
fi
EOF

cat <<'EOF' > /config/scripts/post-config.d/rfc3442.sh
#!/bin/sh
/bin/cp /config/scripts/rfc3442-classless-routes.sh /etc/dhcp3/dhclient-exit-hooks.d/rfc3442-classless-routes
EOF

chmod +x /config/scripts/rfc3442-classless-routes.sh
chmod +x /config/scripts/post-config.d/rfc3442.sh

