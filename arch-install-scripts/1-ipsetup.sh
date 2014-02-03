echo "Stopping dhcpd service..."
systemctl stop dhcpcd@enp19s0
echo "Setting link up..." && \
ip link set enp19s0 up && \
echo "Adding ip..." && \
ip addr flush dev enp19s0 && \
ip addr add 192.168.102.104/24 dev enp19s0 && \
echo "Adding gateway..." && \
ip route flush dev enp19s0 && \
ip route add 192.168.100.1 dev enp19s0 && \
ip route add default via 192.168.100.1 dev enp19s0 && \
echo "Adding nameserver..." && \
echo "nameserver 192.168.5.20" > /etc/resolv.conf && \
echo "Done." && \
ping -c3 172.16.32.222
