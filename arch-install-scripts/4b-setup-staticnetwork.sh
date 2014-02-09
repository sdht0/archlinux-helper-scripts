
devname=enp19s0
ip=192.168.102.199/24
gateway=192.168.100.1
nameserver=192.168.5.20

cd /etc/netctl
cp examples/ethernet-static my_network
sed -i \
    -e "s|\(Interface=\).*|\1$devname|" \
    -e "s|\(Address=\).*|\1('$ip')|" \
    -e "s|\(Gateway=\).*|\1'$gateway'|" \
    -e "s|\(DNS=\).*|\1('$nameserver')|" my_network
netctl enable my_network