#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Create a Windows Server 2022 VirtualBox VM named DC01
# Intended for Git Bash on Windows.
# ============================================================

VM="DC01"
RAM="4096"
CPUS="6"
DISK_MB="60000"
INTNET="LABNET"

# CHANGE THIS to the location of your Windows Server 2022 ISO.
ISO="/c/Users/cegen/Downloads/SERVER_EVAL_x64FRE_en-us.iso"

# VirtualBox executable
VBOX="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"

# ---- Checks -------------------------------------------------

if [[ ! -x "$VBOX" ]]; then
    echo "ERROR: VBoxManage.exe not found at:"
    echo "  $VBOX"
    exit 1
fi

if [[ ! -f "$ISO" ]]; then
    echo "ERROR: Windows Server ISO not found at:"
    echo "  $ISO"
    echo
    echo "Edit the ISO variable at the top of this script."
    exit 1
fi

if ! command -v cygpath >/dev/null 2>&1; then
    echo "ERROR: cygpath was not found."
    echo "Run this script from Git Bash on Windows."
    exit 1
fi

# Convert Git Bash paths to Windows paths for VirtualBox.
ISO_WIN="$(cygpath -w "$ISO")"
VM_DIR_POSIX="/c/Users/${USERNAME}/VirtualBox VMs/${VM}"
DISK_POSIX="${VM_DIR_POSIX}/${VM}.vdi"
DISK_WIN="$(cygpath -w "$DISK_POSIX")"

echo "Creating VirtualBox VM: $VM"
echo "ISO: $ISO_WIN"
echo "Disk: $DISK_WIN"
echo

# ---- Create VM ----------------------------------------------

"$VBOX" createvm \
    --name "$VM" \
    --ostype "Windows2025_64" \
    --register

# ---- Configure VM -------------------------------------------

"$VBOX" modifyvm "$VM" \
    --memory "$RAM" \
    --cpus "$CPUS" \
    --vram 128 \
    --ioapic on \
    --boot1 dvd \
    --boot2 disk \
    --boot3 none \
    --boot4 none \
    --nic1 intnet \
    --intnet1 "$INTNET" \
    --nictype1 82540EM

# ---- Create virtual disk ------------------------------------

"$VBOX" createmedium disk \
    --filename "$DISK_WIN" \
    --size "$DISK_MB" \
    --format VDI

# ---- SATA controller + disk ---------------------------------

"$VBOX" storagectl "$VM" \
    --name "SATA" \
    --add sata \
    --controller IntelAhci

"$VBOX" storageattach "$VM" \
    --storagectl "SATA" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium "$DISK_WIN"

# ---- IDE controller + Windows ISO ---------------------------

"$VBOX" storagectl "$VM" \
    --name "IDE" \
    --add ide

"$VBOX" storageattach "$VM" \
    --storagectl "IDE" \
    --port 0 \
    --device 0 \
    --type dvddrive \
    --medium "$ISO_WIN"

# ---- Display configuration ----------------------------------

echo
echo "============================================================"
echo "DC01 created successfully."
echo "============================================================"
echo

"$VBOX" showvminfo "$VM"

echo
echo "Starting $VM..."
"$VBOX" startvm "$VM" --type gui

echo
echo "Windows Server installer should now start."
