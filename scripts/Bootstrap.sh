#!/usr/bin/env bash
# ==================================================
# Team Jargon CHPC Bootstrap Script
# Rocky Linux OpenStack VM
# Base HPC Node Preparation
# ==================================================

set -Eeuo pipefail

# Print the line number if an error occurs
trap 'echo "Error: Bootstrap failed at line $LINENO."; exit 1' ERR

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    echo "Please rerun using sudo or as the root user."
    exit 1
fi

echo "================================="
echo "Starting CHPC Node Bootstrap"
echo "================================="

########################################
# 1. System Update
########################################
echo "[1/10] Updating system..."
dnf update -y

########################################
# 2. Enable Repositories
########################################
echo "[2/10] Enabling repositories..."
dnf config-manager --set-enabled crb
dnf install -y epel-release
dnf makecache

########################################
# 3. Development Tools
########################################
echo "[3/10] Installing development tools..."
dnf groupinstall -y "Development Tools"

dnf install -y \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    make \
    cmake \
    git \
    wget \
    curl \
    tar \
    gzip \
    bzip2 \
    unzip \
    vim \
    nano

########################################
# 4. HPC Development Dependencies
########################################
echo "[4/10] Installing HPC dependencies..."

# ATLAS and OpenBLAS are both installed deliberately.
# Later tutorials build and benchmark HPL against both,
# so we want both providers available.
dnf install -y \
    openmpi \
    openmpi-devel \
    atlas \
    atlas-devel \
    openblas \
    openblas-devel \
    numactl \
    numactl-devel \
    hwloc \
    hwloc-devel

########################################
# 5. Performance Monitoring Tools
########################################
echo "[5/10] Installing monitoring tools..."
dnf install -y \
    btop \
    sysstat

########################################
# 6. Network Administration Tools
########################################
echo "[6/10] Installing networking tools..."
dnf install -y \
    iproute \
    tcpdump \
    traceroute \
    bind-utils \
    nftables \
    NetworkManager

########################################
# 7. Storage / Filesystem Tools
########################################
echo "[7/10] Installing storage tools..."
dnf install -y \
    nfs-utils \
    lvm2 \
    rsync

########################################
# 8. Headless Administration
########################################
echo "[8/10] Installing administration tools..."

# firewalld is deliberately omitted.
# We manage nftables rules directly as part of the CHPC
# tutorials. Since firewalld also manages nftables,
# running both would introduce unnecessary conflicts.
dnf install -y \
    openssh-server \
    openssh-clients \
    tmux \
    sudo \
    chrony

########################################
# 9. Python / Automation
########################################
echo "[9/10] Installing automation tools..."
dnf install -y \
    python3 \
    python3-pip \
    ansible

pip3 install pip

########################################
# 10. Disable firewalld (must happen before nftables starts)
########################################
echo "[10/11] Disabling firewalld..."
systemctl stop firewalld
systemctl disable firewalld
systemctl mask firewalld

########################################
# 11. Enable Services
########################################
echo "[11/11] Enabling services..."
systemctl enable --now sshd
systemctl enable --now chronyd
systemctl enable --now NetworkManager
systemctl enable --now nftables


########################################
# 12. Validation Phase
########################################
echo "Checking installed tools..."
gcc --version
cmake --version
rpm -q openmpi
python3 --version
ansible --version
echo "Confirming firewalld is disabled..."
systemctl is-active firewalld && echo "WARNING: firewalld is still active!" || echo "firewalld is not active (expected)"

echo "Validation complete."
echo
echo "================================="
echo "Bootstrap Complete!"
echo "Node is ready for HPC configuration."
echo "================================="
