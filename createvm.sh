# Add VirtualBox to PATH for this Powershell session
$env:Path += ";C:/Program Files/Oracle/VirtualBox"

#VM Configuration

$VM = "DC01"
$ISO = ""
$RAM = 4096
$CPUs = 6
$DISK = 25000
$OS = "Windows2025_64"
$Diskpath = "$env:USERPROFILE/VirtualBox VMs/$VM/$VM.vdi"

#Create VM 

VBoxManage createvm --name "$VM" --ostype "$OS" --register
VBoxManage modifyvm "$VM" --memory "$RAM" --cpus "$CPUs" --boot1 dvd --boot2 disk --boot3 none --boot4 none  --nic1 intnet

VBoxManage createhd --filename "$Diskpath" --size "$DISK" --format VDI 

VBoxManage storagectl "$VM" --name "SATA" --add sata 
VBoxManage storageattach "$VM" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$Diskpath"

VBoxManage storagectl "$VM" --name "IDE" --add ide
VBoxManage storageattach "$VM" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "$ISO"


## Start VM only after running the following commands 
# VBoxManage showvminfo "$VM" 
# VBoxManage startvm "$VM" --type gui
