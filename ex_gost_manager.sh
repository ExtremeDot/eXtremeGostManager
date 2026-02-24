#!/bin/bash

# =====================================================
# GOST Tunnel Manager
# Version: 2.2.1 .
# =====================================================

VERSION="2.2.1"
CONFIG_FILE="/etc/gost-manager.conf"
SERVICE_FILE="/usr/lib/systemd/system/gost.service"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[38;5;208m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Default Values
DEFAULT_GOST_PORT=2053
DEFAULT_FORWARD_PORTS="443 33000 80 2087"
DEFAULT_USER="smart2026"
DEFAULT_PASS="never2026"

# -----------------------------------------------------
# Logo
# -----------------------------------------------------
show_logo() {
clear
echo -e "${CYAN}"
echo "███████╗██╗  ██╗████████╗██████╗ ███████╗███╗   ███╗███████╗"
echo "██╔════╝╚██╗██╔╝╚══██╔══╝██╔══██╗██╔════╝████╗ ████║██╔════╝"
echo "█████╗   ╚███╔╝    ██║   ██████╔╝█████╗  ██╔████╔██║█████╗  "
echo "██╔══╝   ██╔██╗    ██║   ██╔══██╗██╔══╝  ██║╚██╔╝██║██╔══╝  "
echo "███████╗██╔╝ ██╗   ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗"
echo "╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝"
echo -e "    ${ORANGE}eXtreme Gost Manager    ${GREEN}Version: $VERSION${NC}"

#echo ""
}

# -----------------------------------------------------
# Load Config
# -----------------------------------------------------
load_config() {
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    SERVER_ROLE="iran"
    IRAN_IP=""
    FOREIGN_IP=""
    GOST_PORT=$DEFAULT_GOST_PORT
    FORWARD_PORTS="$DEFAULT_FORWARD_PORTS"
    TUNNEL_USER=$DEFAULT_USER
    TUNNEL_PASS=$DEFAULT_PASS
fi
}

# -----------------------------------------------------
# Save Config
# -----------------------------------------------------
save_config() {
cat > $CONFIG_FILE <<EOF
SERVER_ROLE="$SERVER_ROLE"
IRAN_IP="$IRAN_IP"
FOREIGN_IP="$FOREIGN_IP"
GOST_PORT="$GOST_PORT"
FORWARD_PORTS="$FORWARD_PORTS"
TUNNEL_USER="$TUNNEL_USER"
TUNNEL_PASS="$TUNNEL_PASS"
EOF
}

# -----------------------------------------------------
# Show Network Interfaces
# -----------------------------------------------------
show_interfaces() {

PUBLIC_IP=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n1)
echo -e "    ${CYAN}Server IPv4: ${GREEN}$PUBLIC_IP${NC}"
}

# -----------------------------------------------------
# Help / Architecture Guide
# -----------------------------------------------------
show_help_en() {

clear
echo -e "${CYAN}"
echo "================= eXtreme Gost Manager - Help ================="
echo -e "${NC}"

echo "ARCHITECTURE OVERVIEW:"
echo ""
echo "In this design:"
echo "  - The MAIN VPN server is deployed on the FOREIGN server."
echo "  - The IRAN server works as a FORWARDER / ENTRY NODE."
echo "  - GOST is used as a secure relay tunnel between IRAN and FOREIGN."
echo ""

echo "Network Flow:"
echo ""
echo "     [ Client Inside Iran ]"
echo "               |"
echo "               v"
echo "        +------------------+"
echo "        |   IRAN SERVER    |"
echo "        |  (Forward Node)  |"
echo "        +------------------+"
echo "               |"
echo "      Encrypted GOST Tunnel"
echo "               |"
echo "               v"
echo "        +------------------+"
echo "        | FOREIGN SERVER   |"
echo "        |  (VPN + Relay)   |"
echo "        +------------------+"
echo "               |"
echo "               v"
echo "            Internet"
echo ""

echo "ROLE EXPLANATION:"
echo ""
echo "IRAN Server:"
echo "  - Does NOT run the main VPN."
echo "  - Forwards selected TCP ports to the FOREIGN server."
echo "  - Uses GOST in Direct mode."
echo "  - Acts as entry point for domestic traffic."
echo ""

echo "FOREIGN Server:"
echo "  - Hosts the actual VPN service (Xray, OpenVPN, etc)."
echo "  - Runs GOST in Reverse (bind) mode."
echo "  - Accepts tunnel connections from IRAN."
echo ""

echo "TUNNEL MODES:"
echo ""
echo "Direct Mode:"
echo "  IRAN binds and FOREIGN connects."
echo ""
echo "Reverse Mode:"
echo "  FOREIGN binds and IRAN connects."
echo ""
echo "Reverse mode is recommended when the FOREIGN server"
echo "has a public static IP and open firewall."
echo ""

echo "PORT FLOW EXAMPLE:"
echo ""
echo "Client ---> IRAN:443"
echo "              |"
echo "              ---> Encrypted Tunnel ---> FOREIGN:443"
echo "                                         |"
echo "                                         ---> VPN Service"
echo ""

echo "SECURITY NOTES:"
echo ""
echo "  - Always use authentication (username/password)."
echo "  - Prefer TLS, mTLS, WSS or HTTP2 for DPI resistance."
echo "  - QUIC is useful for high latency links."
echo "  - KCP+RAW helps in unstable packet environments."
echo ""

echo -e "${CYAN}===============================================================${NC}"
echo ""
read -p "Press Enter to return to menu..."
}

# -----------------------------------------------------
# Help - Finglish
# -----------------------------------------------------
show_help_fa() {

clear
echo -e "${CYAN}"
echo "================= eXtreme Gost Manager - Help ================="
echo -e "${NC}"

echo "TOZIH MEMARI:"
echo ""
echo "Dar in architecture:"
echo "  - VPN asli rooye FOREIGN server run mishavad."
echo "  - IRAN server be onvan Forward Node kar mikonad."
echo "  - GOST yek tunnel amn beyn do server ijad mikonad."
echo ""

echo "Jaryan Traffic:"
echo ""
echo "     [ Client dar Iran ]"
echo "               |"
echo "               v"
echo "        +------------------+"
echo "        |   IRAN SERVER    |"
echo "        |  (Forward Node)  |"
echo "        +------------------+"
echo "               |"
echo "         Tunnel RAMZ shode"
echo "               |"
echo "               v"
echo "        +------------------+"
echo "        | FOREIGN SERVER   |"
echo "        |  (VPN + Relay)   |"
echo "        +------------------+"
echo "               |"
echo "               v"
echo "             Internet"
echo ""

echo "TOZIH ROLE HA:"
echo ""
echo "IRAN:"
echo "  - VPN asli ro nadarad."
echo "  - Port ha ra forward mikonad."
echo "  - Dar mode client kar mikonad."
echo ""

echo "FOREIGN:"
echo "  - Service VPN ro host mikonad."
echo "  - Tunnel ra ghabool mikonad."
echo ""

echo "NOKAT AMNIATI:"
echo "  - Authentication ra faal kon."
echo "  - Az TLS, WSS, HTTP2 baraye DPI estefade kon."
echo "  - QUIC baraye latency bala mofid ast."
echo ""

echo -e "${CYAN}===============================================================${NC}"
echo ""
read -p "Enter bezan baraye bazgasht..."
}

# -----------------------------------------------------
# Show Current Config
# -----------------------------------------------------
show_config() {

PUBLIC_IP=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n1)
echo -e "    ${CYAN} - Configuration Info for this Server -------------------------- [  ${GREEN}$PUBLIC_IP ${CYAN} ]${NC} "
#echo -e "${CYAN}    Configuration Data ----------------------------------------------- ${NC}"
#show_interfaces
printf "      - %-15s %-20s\n" \
"Server Role:" "$SERVER_ROLE"

printf "      - %-15s %-20s  - %-15s %-20s\n" \
"Iran IP:" "$IRAN_IP" \
"Foreign IP:" "$FOREIGN_IP"

printf "      - %-15s %-20s  - %-15s %-20s\n" \
"Tunnel Port:" "$GOST_PORT" \
"Forward Ports:" "$FORWARD_PORTS"

printf "      - %-15s %-20s  - %-15s %-20s\n" \
"Username:" "${TUNNEL_USER:-Disabled}" \
"Password:" "${TUNNEL_PASS:-Disabled}"
#echo -e "    ${CYAN}------------------------------------------------------------------ ${NC}"

}

# -----------------------------------------------------
# Install GOST and iperf3
# -----------------------------------------------------
install_gost() {
echo "Installing GOST..."
apt-get update && bash <(curl -fsSL https://github.com/go-gost/gost/raw/master/install.sh) --install


# Check if iperf3 is installed
if ! command -v iperf3 &> /dev/null
then
    echo "iperf3 is not installed. Installing..."
    sudo apt update && sudo apt install -y iperf3
else
    echo "iperf3 is already installed."
fi

echo "Installation Complete"
}


# -----------------------------------------------------
# Configure Data
# -----------------------------------------------------
configure_data() {
#SIDE Select
echo "Is this server IRAN or KAHREJ?"
echo "  1 = IRAN"
echo "  2 = KAHREJ"
read -p "Enter number (1 or 2): " SERVER_ROLE_NUM

case $SERVER_ROLE_NUM in
    1)
        SERVER_ROLE="iran"
        ;;
    2)
        SERVER_ROLE="foreign"
        ;;
    *)
        echo "Invalid choice!" >&2
        SERVER_ROLE_NUM=0
        SERVER_ROLE="unknown"
        ;;
esac

echo "Selected: $SERVER_ROLE (number: $SERVER_ROLE_NUM)"
##

read -p "Enter Iran IP: " IRAN_IP
read -p "Enter Foreign IP: " FOREIGN_IP
read -p "Tunnel Port [$DEFAULT_GOST_PORT]: " GOST_PORT
GOST_PORT=${GOST_PORT:-$DEFAULT_GOST_PORT}
read -p "Forward Ports (space separated) [$DEFAULT_FORWARD_PORTS]: " FORWARD_PORTS
FORWARD_PORTS=${FORWARD_PORTS:-$DEFAULT_FORWARD_PORTS}

read -p "Use authentication? (yes/no): " AUTH
if [ "$AUTH" == "yes" ]; then
read -p "Username [$DEFAULT_USER]: " TUNNEL_USER
TUNNEL_USER=${TUNNEL_USER:-$DEFAULT_USER}
read -p "Password [$DEFAULT_PASS]: " TUNNEL_PASS
TUNNEL_PASS=${TUNNEL_PASS:-$DEFAULT_PASS}
else
TUNNEL_USER=""
TUNNEL_PASS=""
fi

save_config
}

# -----------------------------------------------------
# Ping Test
# -----------------------------------------------------
ping_test() {
if [ "$SERVER_ROLE" == "iran" ]; then
TARGET=$FOREIGN_IP
else
TARGET=$IRAN_IP
fi

echo "Testing connection to $TARGET"
ping -c 4 $TARGET
}

# -----------------------------------------------------
# Gost Service File Generation
# -----------------------------------------------------
create_first_gost_servicefile() {
cat > $SERVICE_FILE <<EOF
[Unit]
Description=GO Simple Tunnel
After=network.target
Wants=network.target

[Service]
Type=simple
EOF
}

create_end_gost_servicefile() {
cat >> $SERVICE_FILE <<EOF
Restart=always
RestartSec=5
Environment="GOMAXPROCS=4"

[Install]
WantedBy=multi-user.target
EOF
}

# -----------------------------------------------------
# GOST RELOAD
# -----------------------------------------------------
gost_service_reload() {
systemctl stop gost
systemctl daemon-reload
sleep 1
systemctl start gost
systemctl enable gost
}


# -----------------------------------------------------
# 1- Create WSS Direct
# -----------------------------------------------------
create_wss_direct() {
echo -e "${ORANGE}Creating WSS Direct Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+wss://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

else

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L rtcp://:$PORT/:$PORT -F relay+wss://$TUNNEL_USER:$TUNNEL_PASS@$IRAN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 2- relay+wss (Reverse) - Foreign / Direct - IRAN
# -----------------------------------------------------
create_wss_reverse() {
echo -e "${ORANGE}Creating WSS Reverse Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F relay+wss://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+wss://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 3- Create relay+ws (Direct) - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_ws_direct() {
echo -e "${ORANGE}Creating WS Direct Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+ws://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

else

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L rtcp://:$PORT/:$PORT -F relay+ws://$TUNNEL_USER:$TUNNEL_PASS@$IRAN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 4- Create relay+ws (Reverse) - Foreign / Direct - IRAN
# -----------------------------------------------------
create_ws_reverse() {
echo -e "${ORANGE}Creating WS Reverse Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F relay+ws://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+ws://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF
fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 5) Create relay+tls (Direct) - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_tls_direct() {
echo -e "${ORANGE}Creating relay+tls (Relay over TLS) (Direct) Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+tls://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

else

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L rtcp://:$PORT/:$PORT -F relay+tls://$TUNNEL_USER:$TUNNEL_PASS@$IRAN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 6) Create relay+tls (Reverse) - Foreign / Direct - IRAN
# -----------------------------------------------------
create_tls_reverse() {
echo -e "${ORANGE}Creating relay+tls (Reverse) Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then
CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F relay+tls://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+tls://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 7) Create relay+mtls (Direct) - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_mtls_direct() {
echo -e "${ORANGE}Creating relay+mtls (Direct) - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+mtls://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

else

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L rtcp://:$PORT/:$PORT -F relay+mtls://$TUNNEL_USER:$TUNNEL_PASS@$IRAN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 8) relay+mtls (Reverse) - Foreign / Direct - IRAN
# -----------------------------------------------------
create_mtls_reverse() {
echo -e "${ORANGE}Creating relay+mtls (Reverse) - Foreign / Direct - IRAN Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F relay+mtls://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+mtls://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 9) relay+http2 - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_http2_reverse() {
echo -e "${ORANGE}Creating relay+http2 - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F relay+http2://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+http2://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 10) grpc (gRPC) - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_gRPC_reverse() {
echo -e "${ORANGE}Creating grpc (gRPC) - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F grpc://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L grpc://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 11) quic - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_quic_reverse() {
echo -e "${ORANGE}Creating 11) quic - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F quic://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L quic://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 12) kcp+raw - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_kcpraw_reverse() {
echo -e "${ORANGE}Creating kcp+raw - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F kcp+raw://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L kcp+raw://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 13) relay+mtcp - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_mtcp_direct() {
echo -e "${ORANGE}Creating relay+mtcp - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+mtcp://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

else

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L rtcp://:$PORT/:$PORT -F relay+mtcp://$TUNNEL_USER:$TUNNEL_PASS@$IRAN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 14) relay+mtcp (Reverse) - Foreign / Direct - IRAN
# -----------------------------------------------------
create_mtcp_reverse() {
echo -e "${ORANGE}Creating relay+mtcp (Reverse) - Foreign / Direct - IRAN Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F relay+mtcp://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+mtcp://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 15) obfs+tls - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_obfstls_reverse() {
echo -e "${ORANGE}Creating obfs+tls - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F obfs+tls://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L obfs+tls://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 16) obfs+http - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_obfshttp_reverse() {
echo -e "${ORANGE}Creating obfs+http - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

#IRAN

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F obfs+http://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L obfs+http://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 17) relay+pht - IRAN / Reverse - Foreign
# -----------------------------------------------------
create_relaypht_direct() {
echo -e "${ORANGE}Creating relay+pht - IRAN / Reverse - Foreign Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+pht://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

else

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L rtcp://:$PORT/:$PORT -F relay+pht://$TUNNEL_USER:$TUNNEL_PASS@$IRAN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# 18) relay+pht (Reverse) - Foreign / Direct - IRAN
# -----------------------------------------------------
create_relaypht_reverse() {
echo -e "${ORANGE}Creating relay+pht (Reverse) - Foreign / Direct - IRAN Tunnel${NC}"
create_first_gost_servicefile
if [ "$SERVER_ROLE" == "iran" ]; then

CMD=""
for PORT in $FORWARD_PORTS; do
CMD="$CMD -L tcp://:$PORT/:$PORT -F relay+pht://$TUNNEL_USER:$TUNNEL_PASS@$FOREIGN_IP:$GOST_PORT"
done

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost $CMD
EOF

else

cat >> $SERVICE_FILE <<EOF
ExecStart=/usr/local/bin/gost -L relay+pht://$TUNNEL_USER:$TUNNEL_PASS@:${GOST_PORT}?bind=true
EOF

fi
create_end_gost_servicefile
sleep 1
gost_service_reload
}

# -----------------------------------------------------
# Manual Edit
# -----------------------------------------------------
manual_edit() {
nano $SERVICE_FILE
}

# -----------------------------------------------------
# Service Control
# -----------------------------------------------------



service_start() {
systemctl start gost
}

service_stop() {
systemctl stop gost
}

service_restart() {
systemctl restart gost
}

service_status() {
systemctl status gost
}

service_log() {
journalctl -u gost -f
}


# -----------------------------------------------------
# Speed Test
# -----------------------------------------------------
speed_test() {
if [ "$SERVER_ROLE" == "foreign" ]; then
iperf3 -s -p 33000 -i 2
else
iperf3 -c 127.0.0.1 -p 33000 -t 4 -P 2
fi
}



# -----------------------------------------------------
# Main Menu
# -----------------------------------------------------
main_menu() {
while true
do
show_logo

load_config
show_config

echo ""
echo -e "${ORANGE}==== Basic Operations =========================================================================================${NC}"
printf "%-55s %-55s\n" \
"1)  Install GOST & Dependencies" \
"2)  Configure Server Data"


echo ""
echo -e "${ORANGE}==== Transport Modes ==========================================================================================${NC}"

printf "%-55s %-55s\n" \
"21) WSS-D  | WebSocket Secure - Direct (Iran Bind)" \
"22) WSS-R  | WebSocket Secure - Reverse (Foreign Bind)"

printf "%-55s %-55s\n" \
"23) WS-D   | WebSocket Plain - Direct (Iran Bind)" \
"24) WS-R   | WebSocket Plain - Reverse"

echo ""
printf "%-55s %-55s\n" \
"31) TLS-D  | Relay over TLS - Direct Mode" \
"32) TLS-R  | Relay over TLS - Reverse Mode"

printf "%-55s %-55s\n" \
"33) mTLS-D | Mutual TLS Auth - Direct Mode" \
"34) mTLS-R | Mutual TLS Auth - Reverse Mode"
echo ""
printf "%-55s %-55s\n" \
"41) H2-R   | HTTP/2 Relay - Reverse" \
"42) gRPC-R | gRPC Transport - Reverse"

printf "%-55s %-55s\n" \
"43) QUIC-R | QUIC (UDP Based) - Reverse" \
"44) KCP-R  | KCP+RAW (High Latency Optimized)"

printf "%-55s %-55s\n" \
"45) MTCP-D | Multiplex TCP - Direct" \
"46) MTCP-R | Multiplex TCP - Reverse"

printf "%-55s %-55s\n" \
"47) OBFS-T | TLS Obfuscation Layer" \
"48) OBFS-H | HTTP Obfuscation Layer"

printf "%-55s %-55s\n" \
"49) PHT-D  | PHT Protocol - Direct" \
"50) PHT-R  | PHT Protocol - Reverse"


echo ""
echo -e "${ORANGE}==== Service Control ==========================================================================================${NC}"

printf "%-35s %-35s\n" \
"91) Start Service" \
"92) Stop Service"

printf "%-35s %-35s\n" \
"93) Restart Service" \
"94) Service Status"

printf "%-35s %-35s\n" \
"95) Service Logs" \
"96) Manual Edit Service File"
echo ""

printf "%-35s %-35s\n" \
"88) Speed Test using iperf3"  \
"89) Ping Test "

printf "%-35s %-35s\n" \
"99) Help (English)" \
"98) Help (Finglish)"

echo -e "${RED} 0) Exit ${NC}"

echo ""
# Select Option Menu
read -p "Select Option: " OPTION

case $OPTION in
1) install_gost ;;
2) configure_data ;;


21) create_wss_direct ;;
22) create_wss_reverse ;;
23) create_ws_direct ;;
24) create_ws_reverse ;;

31) create_tls_direct ;;
32) create_tls_reverse ;;
33) create_mtls_direct ;;
34) create_mtls_reverse ;;

41) create_http2_reverse ;;
42) create_gRPC_reverse ;;
43) create_quic_reverse ;;
44) create_kcpraw_reverse ;;
45) create_mtcp_direct ;;
46) create_mtcp_reverse ;;
47) create_obfstls_reverse ;;
48) create_obfshttp_reverse ;;
49) create_relaypht_direct ;;
50) create_relaypht_reverse ;;

88) speed_test ;;
89) ping_test ;;

91) service_start ;;
92) service_stop ;;
93) service_restart ;;
94) service_status ;;
95) service_log ;;
96) manual_edit ;;

99) show_help_en ;;
98) show_help_fa ;;

0) exit 0 ;;

*) echo -e "${RED}Invalid Option!${NC}" ;;
esac

read -p "Press Enter to continue..."
done
}

main_menu
