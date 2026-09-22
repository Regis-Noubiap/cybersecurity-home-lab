# Project Name 
22/09/2026

Deployed and configured 3 VMs; 2 using the GUI and one from the terminal. 
The linux machine was deployed using a .vbox file. 
I had major issues in the beginning with slow performance but after 
transitioning to the 13th Gen i9 with a 64RAM processor, everything went very
smoothly and I was very please. 
I faced issues copying and pasting from the host to the guest OSes even 
after enabling Guest Additions. I am still to figure out how to make it work.

Finally, I installed git and setup repositories both locally and on GitHub.

Lessons Learned: 
In order to install a VM via the terminal, you should :
1) Have the .iso file downloaded. 
2) Setup the VM folder as a path within the PATH variable. 
3) Create and register a VM using the VboxManage utility. 
4) Modify the VM to set its RAM, and number of CPUs and set the boot order.
5) Create a disk using createhd and allocate a space to it. This creates 
a .vdi file within the VM folder. 
6) Create a storage controller. 
7) Attach the storage controller to the .vdi storage file.
8) Repeat 6 and 7 to create an .ide storage controller and attach it to
the .iso file you have downloaded. This is important for the initial installa
tion of the OS.
9) Start the VM. 
10) After the installation is complete. Make sure to change the boot order 
from Optical to Hard Disk. So that you do not have to reinstall the VM on 
every boot.
