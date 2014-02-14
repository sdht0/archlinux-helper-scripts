devname=enp19s0
ip=192.168.102.199/24
gateway=192.168.100.1
nameserver=192.168.5.20

echo "Stopping dhcpd service..."
systemctl stop dhcpcd@$devname
echo "Setting link up..." && \
ip link set $devname up && \
echo "Adding ip..." && \
ip addr flush dev $devname && \
ip addr add $ip dev $devname && \
echo "Adding gateway..." && \
ip route flush dev $devname && \
ip route add $gateway dev $devname && \
ip route add default via $gateway dev $devname && \
echo "Adding nameserver..." && \
echo "nameserver $nameserver" > /etc/resolv.conf && \
echo "Done." && \
ping -c3 $gateway
