# Virtual Machine Deployment and Git Setup

Date: 22/09/2026

# Project Summary

Deployed and configured three VMs using Oracle VirtualBox. Two VMs were deployed through the VirtualBox GUI, while the third was created and configured entirely from the terminal using VBoxManage.

The Linux virtual machine was deployed using VirtualBox configuration files and associated virtual disk resources.

Initially, I experienced significant performance issues while running the VMs. After migrating the environment to a system equipped with a 13th-generation Intel Core i9 processor and 64 GB of RAM, VM performance improved considerably and the deployment process became much smoother.

I also encountered issues with copying and pasting content between the host system and guest operating systems, even after installing and enabling VirtualBox Guest Additions. This issue remains unresolved and will require further troubleshooting.

Finally, I installed Git, configured local Git repositories, and connected them to remote repositories hosted on GitHub.

# Lessons Learned

To deploy a virtual machine from the terminal using VirtualBox, the following general process can be followed:

  Download the operating system ISO file.
    The ISO file will be used as the installation media for the guest operating system.
  Add VirtualBox to the system PATH.
    Ensure that the VirtualBox installation directory is included in the PATH environment variable so that the VBoxManage command can be     executed directly from the terminal.
  Create and register the virtual machine.
    Use the VBoxManage createvm command to create the VM and register it with VirtualBox.
  Configure the virtual machine resources.
    Use VBoxManage modifyvm to configure settings such as:
      RAM
      Number of virtual CPUs
      Network configuration
      Boot order
  Create the virtual hard disk.
    Use VBoxManage createhd to create and allocate storage for the virtual machine. This generates a .vdi virtual disk file within the       VM directory.
  Create a storage controller.
    Configure a storage controller, such as a SATA controller, for the virtual machine.
  Attach the virtual hard disk.
    Attach the .vdi file created earlier to the storage controller.

  Create an optical/IDE storage controller and attach the ISO.
    Create an IDE or optical storage controller and attach the downloaded .iso file to it.
    This step is necessary because the ISO acts as the installation media during the initial operating system installation.

  Start the virtual machine.
  Boot the VM and complete the operating system installation.

  Change the boot order after installation.
    Once the operating system has been successfully installed, configure the VM to boot from the virtual hard disk before the optical        drive.

  This prevents the virtual machine from booting from the installation ISO and potentially restarting the installation process each time   the VM is launched.

# Technologies Used
  Oracle VirtualBox
  VBoxManage
  Linux
  Windows
  Git
  GitHub
  VirtualBox Guest Additions
# Issues / Future Work
  Troubleshoot shared clipboard functionality between the host and guest operating systems.
  Verify that VirtualBox Guest Additions are correctly installed and running on each VM.
  Explore additional VBoxManage automation to make VM deployments repeatable.
  Consider storing VM deployment scripts in GitHub for version control and reuse.
