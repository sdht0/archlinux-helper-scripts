devname=eno1
ip=172.31.131.5/22
gateway=172.31.128.1
nameserver=172.31.100.7

echo "Stopping dhcpd service..."
systemctl stop dhcpcd@$devname
echo "Setting link=$devname up..." && \
ip link set $devname up && \
echo "Adding ip=$ip..." && \
ip addr flush dev $devname && \
ip addr add $ip dev $devname && \
echo "Adding gateway=$gateway..." && \
ip route flush dev $devname && \
ip route add $gateway dev $devname && \
ip route add default via $gateway dev $devname && \
echo "Adding nameserver=$nameserver..." && \
echo "nameserver $nameserver" > /etc/resolv.conf && \
echo "Done." && \
ping -c2 $gateway
