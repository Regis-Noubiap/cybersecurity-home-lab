# Part 1 : Virtual Machine Deployment and Git Setup

Date: 22/09/2026

# Part Summary

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
  - Oracle VirtualBox
  - VBoxManage
  - Linux
  - Windows
  - Git
  - GitHub
  - VirtualBox Guest Additions
# Issues / Future Work
  Troubleshoot shared clipboard functionality between the host and guest operating systems.
  Verify that VirtualBox Guest Additions are correctly installed and running on each VM.
  Explore additional VBoxManage automation to make VM deployments repeatable.
  Consider storing VM deployment scripts in GitHub for version control and reuse.

  # Part 2 : Git Setup
  # Part Summary
  This part of the project involved the setting up of a GitHub account and local git repository for the regular committing of updates and project work. After signing up for a GitHub account, 
  a local git repository was installed on the Ubuntu VM using the following commands:

  sudo apt update 
  sudo apt install git -y 

  With git installed, the confirmation of this was done with: 

  git --version

  This was followed by configuring account information : 

  git config --global user.name "Regis-Noubiap"
  git config --global user.email "regisnoubiap@gmail.com" 

  With the local repository and the remote github account setup, I cloned the remote repository locally :

  git clone https://github.com/Regis-Noubiap/cybersecurity-home-lab.git

  With access to the repository, I created screenshot folder and the Readme.md file. 

  mkdir -p 01-home-lab-foundation/screenshots
  nano 01-home-lab-foundation/README.md

  With all these confirgurations setup, I committed the changes: 

  git add . 
  git commit -m "Adding home lab foundation write up"
  git push origin main
  
  # Lessons Learned
  - It is very important to have an access token with write privileges. Access tokens without specific write privileges will not grant the push privileges required.
  - Using git add [file] sends the file to the staging area. In order to push it, one needs to use git push.
  - Commit and push are very different in the sense that commit tracks directory and file changes while push sends a specific update to the remote GitHub repository. 
  
  # Technologies Used 
  Git
  # Issues / Future Work 
  - At the first try, Git would not push files because the token did not have write privileges. This was fixed by adding write privileges to the token.


  # Part 3 : Building the Active Directory Environment
  # Part 3: Active Directory Domain Lab

## Part Summary

In this part of the cybersecurity home lab, I built a small Windows Active Directory environment using VirtualBox. The objective was to gain hands-on experience with Windows Server administration, Active Directory Domain Services (AD DS), DNS, user and organizational unit management, domain joining, and Group Policy.

I created a Windows Server virtual machine named DC01 and allocated:

- 2 vCPUs
- 4096 MB RAM
- Windows Server with Desktop Experience

The server was configured with a static IPv4 address:

```text
IP Address:      192.168.1.10
Subnet Mask:     255.255.255.0
Default Gateway: 192.168.1.1
DNS Server:      192.168.1.10
```

Using a static IP is especially important for a domain controller because domain clients must be able to consistently locate DNS and Active Directory services.

I installed the Active Directory Domain Services role through Server Manager and promoted DC01 to a domain controller by creating a new Active Directory forest:

```text
lab.local
```

The equivalent PowerShell command for the forest deployment is:

```powershell
Install-ADDSForest -DomainName "lab.local" -InstallDNS
```

After the promotion and automatic reboot, DC01 became the first domain controller and DNS server for the `lab.local` domain.

I then opened Active Directory Users and Computers (ADUC) and created an Organizational Unit called:

```text
Staff
```

Several test user accounts were created inside the Staff OU. This allowed me to experiment with how Active Directory objects are logically organized and centrally managed.

A Windows 11 client VM was then configured on the same virtual network. Its DNS configuration pointed directly to the domain controller:

```text
Preferred DNS: 192.168.1.10
```

This was necessary because Active Directory relies heavily on DNS for locating domain controllers and services.

After confirming network connectivity and DNS resolution, I joined the Windows 11 computer to:

```text
lab.local
```

I rebooted the client and successfully authenticated using an Active Directory domain user instead of a local Windows account.

I also began experimenting with Group Policy Management on DC01. Policies were linked to the appropriate Active Directory scope so that settings could be centrally pushed to domain users and computers.

Examples included experimenting with:

- Password policies
- User configuration policies
- Desktop settings
- Group Policy inheritance
- Policy enforcement

This helped demonstrate how organizations can centrally control hundreds or thousands of Windows endpoints through Active Directory rather than configuring each system individually.

---

## Lessons Learned

One of the biggest lessons from this exercise was understanding how closely Active Directory and DNS are connected.

Simply having network connectivity between the client and domain controller is not enough. The Windows client must use the Active Directory DNS server to successfully discover services associated with the domain.

I also developed a better understanding of the relationship between:

```text
Domain
  Organizational Units
    Users
    Computers
    Groups
  Group Policies
```

Organizational Units are not simply folders. They provide an administrative structure that can be used to delegate permissions and determine where Group Policy Objects are applied.

Another important lesson was understanding the difference between local accounts and domain accounts. Once the Windows 11 machine joined the domain, authentication could be centrally managed by the domain controller.

This also demonstrated why Active Directory is so important from a cybersecurity perspective. Active Directory contains the identities, groups, permissions, authentication mechanisms, and administrative privileges used throughout many enterprise Windows environments.

If an attacker gains privileged access to Active Directory, the impact can extend far beyond a single workstation.

The lab therefore helped connect system administration concepts with cybersecurity concepts such as:

- Identity and Access Management
- Authentication
- Authorization
- Privilege management
- Least privilege
- Credential attacks
- Account lockouts
- Enterprise security policy enforcement

I also learned that Group Policy troubleshooting requires understanding both the Active Directory structure and the distinction between User Configuration and Computer Configuration.

A GPO existing in Group Policy Management does not automatically mean the settings will apply. The GPO must be linked to the correct domain or OU, the relevant user or computer must be within its scope, and the policy must successfully refresh on the endpoint.

Useful commands for troubleshooting included:

```cmd
gpupdate /force
```

and:

```cmd
gpresult /r
```

These commands allow me to force a Group Policy refresh and verify which policies have actually been applied to the client.

Another useful networking lesson came from configuring the VirtualBox lab network. The domain controller and Windows client could communicate directly on the same subnet without requiring a default gateway because communication between devices on the same IP subnet occurs at Layer 2.

The virtual Host-Only network essentially behaved like a virtual Ethernet switch connecting the lab machines together.

---

## Technologies Used

- **Oracle VirtualBox**
- **Windows Server**
- **Windows 11**
- **Active Directory Domain Services (AD DS)**
- **Active Directory Users and Computers (ADUC)**
- **Active Directory Administrative Tools**
- **DNS**
- **Group Policy Management Console (GPMC)**
- **Group Policy Objects (GPO)**
- **PowerShell**
- **Windows Command Prompt**
- **TCP/IP**
- **IPv4**
- **VirtualBox Host-Only Networking**

Key Windows administrative commands used or explored included:

```powershell
Install-ADDSForest -DomainName "lab.local" -InstallDNS
```

```cmd
ipconfig /all
```

```cmd
ping 192.168.1.10
```

```cmd
nslookup lab.local
```

```cmd
gpupdate /force
```

```cmd
gpresult /r
```

---

## Issues / Future Work

One of the main challenges encountered during the lab involved networking between the Windows Server domain controller and the Windows 11 client.

I configured the machines to communicate over a VirtualBox Host-Only network. At one point, the Windows 11 client could ping the domain controller, but communication in the opposite direction was unsuccessful.

This demonstrated that successful communication in one direction does not necessarily mean communication is unrestricted in the other direction. Windows Firewall rules, network profiles, and ICMP settings can affect connectivity.

Troubleshooting this reinforced the importance of checking:

```text
IP configuration
    ↓
Subnet configuration
    ↓
VirtualBox network adapter
    ↓
Windows network profile
    ↓
Windows Firewall
    ↓
DNS
    ↓
Active Directory
```

I also encountered issues while testing Group Policy. For example, a configured desktop wallpaper policy did not immediately appear on the Windows 11 domain client.

This became an opportunity to investigate:

- Whether the GPO was linked to the correct OU
- Whether the user or computer was located inside that OU
- Whether the policy was a User or Computer configuration
- Whether the GPO was enabled
- Whether security filtering allowed the policy to apply
- Whether `gpupdate /force` had successfully refreshed the policy
- Whether the policy appeared in `gpresult`

  
