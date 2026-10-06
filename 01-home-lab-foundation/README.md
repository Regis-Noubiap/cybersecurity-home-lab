# Part 1 : Virtual Machine Deployment and Git Setup

Date: 22/09/2026

## Part Summary

Deployed and configured three VMs using Oracle VirtualBox. Two VMs were deployed through the VirtualBox GUI, while the third was created and configured entirely from the terminal using VBoxManage.

The Linux virtual machine was deployed using VirtualBox configuration files and associated virtual disk resources.

Initially, I experienced significant performance issues while running the VMs. After migrating the environment to a system equipped with a 13th-generation Intel Core i9 processor and 64 GB of RAM, VM performance improved considerably and the deployment process became much smoother.

I also encountered issues with copying and pasting content between the host system and guest operating systems, even after installing and enabling VirtualBox Guest Additions. This issue remains unresolved and will require further troubleshooting.

Finally, I installed Git, configured local Git repositories, and connected them to remote repositories hosted on GitHub.

## Lessons Learned

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

## Technologies Used
  - Oracle VirtualBox
  - VBoxManage
  - Linux
  - Windows
  - Git
  - GitHub
  - VirtualBox Guest Additions
## Issues / Future Work
  Troubleshoot shared clipboard functionality between the host and guest operating systems.
  Verify that VirtualBox Guest Additions are correctly installed and running on each VM.
  Explore additional VBoxManage automation to make VM deployments repeatable.
  Consider storing VM deployment scripts in GitHub for version control and reuse.

  # Part 2 : Git Setup
  ## Part Summary
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
  
  ## Lessons Learned
  - It is very important to have an access token with write privileges. Access tokens without specific write privileges will not grant the push privileges required.
  - Using git add [file] sends the file to the staging area. In order to push it, one needs to use git push.
  - Commit and push are very different in the sense that commit tracks directory and file changes while push sends a specific update to the remote GitHub repository. 
  
  ## Technologies Used 
  Git
  ## Issues / Future Work 
  - At the first try, Git would not push files because the token did not have write privileges. This was fixed by adding write privileges to the token.


  # Part 3 : Building the Active Directory Environment
  
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
- IP Configuration
- Subnet Configuration
- VirtualBox network adapter
- Windows Network Profile
- Windows Firewall
- DNS
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

# Part 4: Splunk setup and Log Ingestion

## Part Summary

In this part of the project, I deployed **Splunk Enterprise** as the central SIEM platform for the lab environment and configured Windows systems to forward event logs to it using the **Splunk Universal Forwarder**.

The objective was to move beyond simply building the Active Directory environment and begin collecting security telemetry that could later be used for monitoring, investigation, detection engineering, and SOC-style analysis.

Splunk was installed on a dedicated Ubuntu virtual machine, while the Windows machines from the Active Directory lab were configured as log sources. The Splunk server was configured to listen for forwarded events on **TCP port 9997**, and the Universal Forwarder was installed on the Windows systems to transmit the **Application, Security, and System** event logs.

After configuring log forwarding, I validated ingestion through Splunk Search using queries such as:

```spl
index=* sourcetype=WinEventLog:Security
```

This confirmed that Windows security events were successfully being centralized in the SIEM.

I also began working with important Windows Event IDs such as:

```text
4624 - Successful account logon
4625 - Failed account logon
4720 - User account created
```

Rather than stopping after log ingestion, I used the collected data to begin building SOC-focused searches and dashboard components for authentication monitoring.

---

## Lessons Learned

This part of the project helped me understand the complete flow of log data from an endpoint into a SIEM.

One of the most important concepts was understanding that Splunk is composed of different components with different responsibilities. In this lab, the **Universal Forwarder** runs on the Windows endpoint and collects the configured logs, while the Splunk server receives, indexes, and makes those events searchable.

The basic data flow became:

```text
Windows Event Logs
        |
        v
Splunk Universal Forwarder
        |
        | TCP 9997
        v
Splunk Enterprise
        |
        v
Indexer / Search
        |
        v
Searches / Reports / Dashboards
```

I also learned that simply installing Splunk does not mean logs will automatically appear. Several pieces must be configured correctly:

- The Splunk server must be listening on a receiving port.
- The forwarder must know the Splunk server's IP address.
- Network connectivity between the endpoint and server must exist.
- The correct Windows event logs must be selected for monitoring.
- The Splunk services must be running.
- Searches must use the appropriate index, source, host, and sourcetype.

Working with Windows Event IDs also reinforced how valuable native Windows telemetry is for security monitoring. For example, Event ID **4625** can be used to identify failed authentication attempts, while Event ID **4720** can be used to detect newly created accounts.

I also became more comfortable with **Splunk Processing Language (SPL)**. Even simple searches demonstrated how raw logs can quickly be transformed into useful security information.

For example:

```spl
index=* sourcetype=WinEventLog:Security EventCode=4625
```

can be used to identify failed authentication events.

The project also demonstrated an important SOC principle: collecting logs is only the first step. The real value of a SIEM comes from building detections, reports, dashboards, and alerts on top of the data.

---

## Technologies Used

**Splunk Enterprise**  
Used as the central SIEM platform for collecting, indexing, searching, and analysing security logs.

**Splunk Universal Forwarder**  
Installed on the Windows systems to forward Windows Event Logs to the Splunk server.

**Ubuntu Linux**  
Used as the operating system hosting the Splunk Enterprise server.

**Windows Server / Domain Controller**  
Provided Active Directory and Windows security events for ingestion into Splunk.

**Windows 11**  
Used as a domain-connected endpoint and additional source of Windows event telemetry.

**Windows Event Viewer / Event Logs**  
Provided Application, Security, and System events that could be centrally analysed.

**Splunk Processing Language (SPL)**  
Used to search and analyse ingested events.

Example:

```spl
index=* sourcetype=WinEventLog:Security
```

**TCP Port 9997**  
Configured as the Splunk receiving port for Universal Forwarder traffic.

**TCP Port 8000**  
Used to access the Splunk Enterprise web interface.

**VirtualBox**  
Used to host the Splunk, Windows Server, and Windows client virtual machines within the cybersecurity lab environment.

---

## Issues / Future Work

One of the main challenges during this part of the project was establishing connectivity between the Windows systems and the Splunk server.

Because the lab uses multiple virtual network adapters, including **Host-Only** and **NAT** interfaces, the virtual machines had to be configured carefully so that they could both communicate internally and access the Internet when necessary.

I also encountered difficulties downloading the Splunk Universal Forwarder directly from one of the Windows virtual machines because Internet connectivity was initially unavailable. Configuring the secondary network adapter to use DHCP through NAT restored connectivity and allowed the required software to be obtained.

Another important troubleshooting area was ensuring that the correct Splunk destination address and receiving port were configured. The Windows Universal Forwarder needed to send data to:

```text
Splunk Server IP:9997
```

rather than the Splunk web interface on port `8000`.

Future improvements to this part of the lab will include expanding the number of security searches and creating a more complete SOC monitoring dashboard.

Planned searches include:

```spl
EventCode=4625
```

for failed authentication attempts,

```spl
EventCode=4624
```

for successful authentication,

```spl
EventCode=4720
```

for newly created user accounts,

and additional searches covering:

```text
4726 - User account deleted
4732 - User added to local security group
4740 - Account locked out
7045 - New Windows service installed
4688 - New process created
```

The next major improvement will be to correlate these events rather than simply viewing them individually.

For example, repeated failed logons followed by a successful authentication could potentially indicate password guessing:

```text
Multiple 4625 Events
        |
        v
Successful 4624
        |
        v
Potential Brute-Force / Password Guessing Investigation
```

I also plan to expand the Splunk dashboard with panels covering:

- Failed logins
- Successful logins
- Account lockouts
- Newly created accounts
- Administrative group membership changes
- New Windows services
- Suspicious process execution
- PowerShell activity
- Authentication activity by host and user

This will transform the Splunk deployment from a basic log collection server into a more realistic **SOC monitoring and detection platform**.

# Part 5: Reading Windows Event Logs

## Part Summary

In this part of the project, I focused on learning how to read and interpret **Windows Security Event Logs** in Splunk from an analyst's perspective.

The previous part of the lab established the SIEM pipeline and confirmed that Windows logs were successfully being forwarded into Splunk. This section moved beyond log collection and focused on understanding what those logs actually mean during an investigation.

The objective was to learn a small set of high-value Windows Event IDs and use them to distinguish normal authentication activity from suspicious behaviour.

The main Event IDs analysed were:

```text
4624 - Successful logon
4625 - Failed logon
4720 - User account created
4728 - Member added to a global security group
4732 - Member added to a local security group
4688 - New process created
4672 - Special privileges assigned to a new logon
```

I first created a baseline of successful logins using:

```spl
index=* sourcetype=WinEventLog:Security EventCode=4624
| stats count by Account_Name, Logon_Type
```

This allowed me to understand which accounts were authenticating normally and which logon types were commonly appearing in the environment.

I then generated suspicious activity by intentionally attempting several incorrect logins before successfully authenticating with the correct password.

This created a simple brute-force-style pattern:

```text
Failed Login
    ↓
Failed Login
    ↓
Failed Login
    ↓
Failed Login
    ↓
Successful Login
```

I searched for failed authentication attempts with:

```spl
index=* sourcetype=WinEventLog:Security EventCode=4625
| stats count by Account_Name, Workstation_Name
| sort -count
```

The results allowed me to identify the account that had generated multiple failed authentication attempts.

This completed the basic analyst workflow:

```text
Understand Normal Activity
        ↓
Generate Suspicious Activity
        ↓
Search the Logs
        ↓
Identify the Pattern
        ↓
Investigate the Relevant Events
```

---

# Lessons Learned

One of the most important lessons from this project was that identifying suspicious behaviour requires understanding what **normal behaviour looks like first**.

A single failed login is not necessarily suspicious. Users mistype passwords regularly.

However, a pattern such as:

```text
4625
4625
4625
4625
4625
4624
```

within a short period of time can tell a very different story.

This could indicate that an attacker repeatedly attempted passwords and eventually succeeded.

That means the important part is not just the presence of an Event ID, but the **relationship between multiple events**.

---

## Understanding Event ID 4624

Event ID `4624` represents a successful logon.

One of the most important fields in this event is:

```text
Logon_Type
```

The logon type explains **how the authentication occurred**.

Some common values include:

| Logon Type | Meaning |
|---|---|
| 2 | Interactive login at the keyboard |
| 3 | Network authentication |
| 5 | Service logon |
| 7 | Workstation unlock |
| 10 | Remote Desktop / Remote Interactive |
| 11 | Cached interactive login |

For example:

```text
EventCode=4624
Account_Name=user1
Logon_Type=10
```

could indicate that `user1` authenticated through Remote Desktop.

This context is important because the same account logging in through different mechanisms may have very different security implications.

---

## Understanding Event ID 4625

Event ID `4625` represents a failed authentication attempt.

Important fields include:

```text
Account_Name
Workstation_Name
Source_Network_Address
Logon_Type
Failure_Reason
Status
Sub_Status
```

A single event may be harmless.

However:

```text
Many 4625 events
        +
Same account
        +
Same source
        +
Short time period
```

can indicate:

```text
Password guessing
Brute force
Misconfigured service
Expired credentials
Automated authentication failure
```

This showed me why an analyst cannot simply classify every failed login as malicious.

Context matters.

---

## Correlating 4625 and 4624

The most useful concept from this project was correlating failed and successful authentication events.

For example:

```text
10:15:01   4625   user1   Failed
10:15:05   4625   user1   Failed
10:15:09   4625   user1   Failed
10:15:15   4625   user1   Failed
10:15:22   4625   user1   Failed
10:15:30   4624   user1   Successful
```

This is more interesting than either Event ID in isolation.

It tells a potential story:

```text
Repeated password guessing
        ↓
Correct password found
        ↓
Successful authentication
        ↓
Potential account compromise
```

This is the beginning of **event correlation**, which is one of the core capabilities of a SIEM.

---

## Event ID 4672

Event ID `4672` represents:

```text
Special privileges assigned to new logon
```

This is often associated with privileged or administrative accounts.

Privileges may include:

```text
SeDebugPrivilege
SeBackupPrivilege
SeRestorePrivilege
SeTakeOwnershipPrivilege
SeSecurityPrivilege
```

The event itself does not automatically indicate malicious behaviour, but when correlated with other events it becomes useful.

For example:

```text
Multiple 4625 failures
        ↓
4624 successful login
        ↓
4672 privileged logon
```

could deserve immediate investigation.

---

## Event IDs 4728 and 4732

These events indicate that an account has been added to a security group.

```text
4728 - Member added to global security group
4732 - Member added to local security group
```

The important security question is:

```text
Which group?
```

Adding a normal account to a standard group may be legitimate.

Adding that account to:

```text
Domain Admins
Enterprise Admins
Administrators
Remote Desktop Users
```

may be much more important.

This reinforced the importance of understanding both the Event ID and the fields within the event.

---

## Event ID 4720

Event ID `4720` indicates:

```text
A user account was created
```

This can be completely legitimate during routine administration.

However, an unexpected account creation can also be associated with:

```text
Persistence
Privilege escalation
Unauthorized administration
Compromised administrator credentials
```

A useful investigation would therefore correlate:

```text
Who created the account?
When was it created?
Which host generated the event?
Was the new account later added to a privileged group?
Did the new account authenticate shortly afterwards?
```

---

## Event ID 4688

Event ID `4688` represents:

```text
A new process was created
```

This provides visibility into programs being executed on Windows.

Examples might include:

```text
powershell.exe
cmd.exe
whoami.exe
net.exe
rundll32.exe
certutil.exe
wmic.exe
```

A process name alone does not necessarily indicate malicious activity.

For example:

```text
powershell.exe
```

is widely used by legitimate administrators.

The analyst must consider fields such as:

```text
Process name
Command line
Parent process
User
Host
Time
```

This concept becomes even more important in the next part of the project when Sysmon is introduced for deeper process telemetry.

---

# Technologies Used

### Splunk Enterprise

Splunk was used as the primary platform for searching and analysing Windows Security Event Logs.

It allowed me to:

- Search authentication events
- Group activity by account
- Identify repeated failures
- Compare successful and unsuccessful logons
- Investigate suspicious authentication patterns

---

### Windows Security Event Logs

The Windows Security log was the primary data source.

Important events analysed included:

```text
4624 - Successful authentication
4625 - Failed authentication
4672 - Administrative privileges assigned
4688 - Process creation
4720 - User created
4728 - User added to global group
4732 - User added to local group
```

---

### Splunk Processing Language

SPL was used to search and summarise Windows event data.

Baseline query:

```spl
index=* sourcetype=WinEventLog:Security EventCode=4624
| stats count by Account_Name, Logon_Type
```

Failed authentication search:

```spl
index=* sourcetype=WinEventLog:Security EventCode=4625
| stats count by Account_Name, Workstation_Name
| sort -count
```

A more detailed failed login search can also be used:

```spl
index=* sourcetype=WinEventLog:Security EventCode=4625
| table _time, Account_Name, Workstation_Name, Source_Network_Address, Logon_Type
| sort _time
```

This provides more useful information during an investigation because it preserves the event timeline.

---

### Active Directory Lab

The Windows domain environment from the previous project provided realistic authentication activity.

The lab environment allowed me to safely generate both:

```text
Normal authentication traffic
```

and:

```text
Controlled suspicious authentication activity
```

without affecting any production systems.

---

# Issues / Future Work

One challenge during this project was understanding that the field names displayed by Splunk may vary depending on how Windows events are ingested.

For example, account information may appear under fields such as:

```text
Account_Name
TargetUserName
SubjectUserName
user
```

Because of this, it is important to inspect the raw event before assuming which fields should be used in an SPL query.

---

## Reducing False Positives

One of the biggest challenges when analysing authentication failures is distinguishing attacks from normal operational noise.

Failed logins can be generated by:

```text
Users typing incorrect passwords
Expired passwords
Old saved credentials
Scheduled tasks
Windows services
Mapped drives
Mobile devices
Applications using stored credentials
```

A search that simply alerts on:

```spl
EventCode=4625
```

would therefore generate too many alerts.

A better approach is to introduce thresholds.

For example:

```spl
index=* sourcetype=WinEventLog:Security EventCode=4625
| stats count by Account_Name, Workstation_Name
| where count >= 5
| sort -count
```

This identifies accounts with at least five failed logins.

---

## Adding Time-Based Detection

A future improvement is to detect multiple failures occurring within a short period.

For example:

```text
5 failed logins
within
5 minutes
```

is more suspicious than:

```text
5 failed logins
over
3 weeks
```

This introduces an important concept:

```text
Frequency + Time = Better Context
```

---

## Detecting Failure Followed by Success

Another improvement will be to build a detection that looks for:

```text
Multiple 4625 events
        ↓
Same account
        ↓
Same source
        ↓
Followed by 4624
```

This is more useful than monitoring authentication failures alone because it may indicate a successful brute-force attack.

The investigation logic would look like:

```text
Step 1
Identify accounts with repeated 4625 events

        ↓

Step 2
Identify the source workstation or IP

        ↓

Step 3
Search for a subsequent 4624

        ↓

Step 4
Check the Logon Type

        ↓

Step 5
Check for privileged activity

        ↓

Step 6
Investigate additional events
```

---

## Hiding the Attack in Normal Activity

To make the lab more realistic, future testing will introduce background activity.

For example:

```text
UserA → Successful login
UserB → Successful login
UserC → Failed login
UserA → Logout
UserB → Failed login
Attacker → Multiple failed logins
UserC → Successful login
Attacker → Successful login
```

The objective will be to tune the SPL search so that the attack remains visible despite normal authentication noise.

This reflects a real SOC environment where analysts rarely investigate clean datasets.

---

## Future Correlation

Future investigations will correlate authentication events with additional security telemetry.

For example:

```text
4625 - Multiple failed logins
        ↓
4624 - Successful login
        ↓
4672 - Administrative privileges
        ↓
4688 - Suspicious process executed
        ↓
Sysmon network connection
```

# Part 6: Adding Sysmon and Writing my First Detection

## Part Summary

In this part of the project, I expanded the lab's endpoint visibility by installing **Microsoft Sysmon** on the Windows client and forwarding its telemetry into **Splunk**.

The default Windows event logs provide useful authentication and system activity, but they do not always provide enough detail for deeper endpoint investigation. Sysmon adds richer telemetry such as:

- Process creation
- Network connections
- File creation
- Registry activity
- Process access
- Driver and image loading
- DNS queries

To avoid relying on the default Sysmon configuration, I deployed Sysmon using the widely used **SwiftOnSecurity Sysmon configuration** as a starting point.

The installation was performed from an elevated Command Prompt:

```cmd
cd C:\Users\<username>\Downloads\Sysmon
sysmon64.exe -accepteula -i sysmonconfig-export.xml
```

After installation, Sysmon began writing events to:

```text
Microsoft-Windows-Sysmon/Operational
```

I then configured the **Splunk Universal Forwarder** to collect this event channel and forward the logs to the Splunk server.

Once Sysmon events were visible in Splunk, I generated a controlled test event using PowerShell:

```powershell
powershell -nop -c "(New-Object Net.WebClient).DownloadString('http://example.com')"
```

This command was used only in my isolated lab environment to simulate a common malware behavior: using PowerShell to retrieve remote content.

I then created my first Sysmon-based detection in Splunk:

```spl
index=* sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational"
EventCode=1
Image="*powershell.exe*"
CommandLine="*DownloadString*"
```

The search successfully identified the simulated activity.

I saved the search as an alert, turning raw endpoint telemetry into an actual security detection.

This part of the project introduced the full detection engineering workflow:

```text
Generate Activity
      |
      v
Collect Endpoint Telemetry
      |
      v
Ingest into Splunk
      |
      v
Search for Suspicious Behaviour
      |
      v
Create Detection
      |
      v
Test and Tune
```

---

# Lessons Learned

One of the main lessons from this project was understanding the difference between **log collection and detection engineering**.

Collecting Sysmon events does not automatically make an environment secure. The telemetry needs to be analysed and turned into meaningful detections.

Sysmon Event ID `1` became particularly important because it records **process creation**.

A Sysmon process creation event can contain information such as:

```text
Image
CommandLine
ParentImage
ParentCommandLine
User
ProcessId
ParentProcessId
Hashes
IntegrityLevel
Computer
```

This provides significantly more context than simply knowing that PowerShell executed.

For example, a detection may show:

```text
Process:
powershell.exe

Command Line:
powershell -nop -c "(New-Object Net.WebClient).DownloadString(...)"

Parent Process:
cmd.exe

User:
LAB\user
```

This kind of information allows an analyst to understand not only **what happened**, but also how the process was launched.

I also learned that a good detection should focus on **behaviour**, rather than relying only on exact command strings.

My original search was:

```spl
Image="*powershell.exe*"
CommandLine="*DownloadString*"
```

This successfully detected the test command, but it was also very specific.

An attacker could modify the command slightly and potentially evade the detection.

For example, other PowerShell download methods include:

```powershell
Invoke-WebRequest
```

```powershell
iwr
```

```powershell
curl
```

or:

```powershell
(New-Object Net.WebClient).DownloadFile()
```

This demonstrated one of the fundamental challenges in detection engineering:

```text
Detection too specific
        |
        v
Low false positives
        |
        v
Easy to evade
```

versus:

```text
Detection too broad
        |
        v
More coverage
        |
        v
Potentially many false positives
```

The goal is therefore to create detections that provide useful coverage while remaining manageable for analysts.

---

# Technologies Used

### Microsoft Sysmon

Sysmon was used to generate detailed endpoint telemetry from the Windows client.

Important Sysmon Event IDs explored during this project include:

| Event ID | Description |
|---|---|
| 1 | Process creation |
| 3 | Network connection |
| 7 | Image loaded |
| 8 | CreateRemoteThread |
| 10 | Process access |
| 11 | File creation |
| 12/13/14 | Registry activity |
| 22 | DNS query |

For this detection, **Event ID 1 – Process Creation** was the main telemetry source.

---

### SwiftOnSecurity Sysmon Configuration

The SwiftOnSecurity Sysmon configuration was used as the baseline configuration for Sysmon.

Rather than logging every possible event, the configuration provides filtering rules intended to collect security-relevant activity while reducing unnecessary noise.

The configuration was installed using:

```cmd
sysmon64.exe -accepteula -i sysmonconfig-export.xml
```

---

### Splunk Enterprise

Splunk was used to:

- Ingest Sysmon logs
- Search endpoint telemetry
- Investigate PowerShell activity
- Build detections
- Save searches
- Create alerts

---

### Splunk Universal Forwarder

The Universal Forwarder was responsible for sending Sysmon telemetry from the Windows endpoint to the Splunk server.

The Sysmon channel added to the forwarder configuration was:

```text
Microsoft-Windows-Sysmon/Operational
```

The data flow was therefore:

```text
Windows Client
      |
      v
Sysmon
      |
      v
Windows Event Log
      |
      v
Splunk Universal Forwarder
      |
      | TCP 9997
      v
Splunk Enterprise
```

---

### PowerShell

PowerShell was used to generate benign activity that simulated a commonly observed attacker technique.

The controlled test command was:

```powershell
powershell -nop -c "(New-Object Net.WebClient).DownloadString('http://example.com')"
```

This allowed the detection to be validated against a known test event.

---

### Splunk Processing Language

SPL was used to identify suspicious PowerShell process creation.

Initial detection:

```spl
index=* sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational"
EventCode=1
Image="*powershell.exe*"
CommandLine="*DownloadString*"
```

This search detects PowerShell processes containing `DownloadString` in their command line.

---

# Issues / Future Work

The first challenge was confirming that Sysmon had installed correctly and was actively generating telemetry.

This could be validated locally through:

```text
Event Viewer
    >
Applications and Services Logs
    >
Microsoft
    >
Windows
    >
Sysmon
    >
Operational
```

The next challenge was ensuring that the **Splunk Universal Forwarder** was collecting the Sysmon channel.

Installing Sysmon alone does not automatically cause the events to appear in Splunk.

The forwarder must explicitly monitor:

```text
Microsoft-Windows-Sysmon/Operational
```

Once the data began arriving in Splunk, another challenge became apparent: **event formatting and sourcetype selection matter**.

Sysmon logs may appear under a sourcetype similar to:

```text
XmlWinEventLog:Microsoft-Windows-Sysmon/Operational
```

Depending on the Splunk configuration, field names and sourcetypes may differ slightly. This made it important to first search broadly and inspect the incoming events before creating a detection.

For example:

```spl
index=* Sysmon
```

or:

```spl
index=* EventCode=1
```

can help locate the telemetry before building a more specific search.

---

## Detection Evasion Testing

The first version of the detection was intentionally simple:

```spl
Image="*powershell.exe*"
CommandLine="*DownloadString*"
```

I then considered how the same behaviour could be performed without using the exact `DownloadString` keyword.

For example:

```powershell
Invoke-WebRequest http://example.com
```

This command could bypass the original detection even though the behaviour remains similar.

That highlighted an important limitation:

```text
Exact string detection
        ↓
Easy to build
        ↓
Easy to understand
        ↓
Potentially easy to evade
```

A more robust version can search for multiple suspicious PowerShell download methods:

```spl
index=* sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational"
EventCode=1
Image="*powershell.exe*"
(
    CommandLine="*DownloadString*"
    OR CommandLine="*DownloadFile*"
    OR CommandLine="*Invoke-WebRequest*"
    OR CommandLine="*iwr *"
)
```

This provides broader coverage while still focusing on suspicious PowerShell download behaviour.

---

## Future Detection Improvements

A future improvement will be to move away from detecting only specific command names and instead combine several behavioural indicators.

For example:

```spl
index=* sourcetype="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational"
EventCode=1
Image="*powershell.exe*"
(
    CommandLine="*DownloadString*"
    OR CommandLine="*DownloadFile*"
    OR CommandLine="*Invoke-WebRequest*"
    OR CommandLine="*EncodedCommand*"
    OR CommandLine="*-enc *"
    OR CommandLine="*-nop*"
)
```

Additional investigation could then be performed using:

```text
User
Host
Parent Process
Command Line
Destination IP
Destination Domain
Process Hash
```

Future detections I plan to build include:

```text
Suspicious PowerShell execution
Encoded PowerShell commands
PowerShell downloads
Office applications spawning PowerShell
Command shells launched from unusual parents
Credential dumping behaviour
Remote process execution
Suspicious service creation
Persistence through registry keys
Unexpected outbound connections
```

These detections can eventually be correlated with Windows authentication events collected in previous parts of the project.

For example:

```text
Failed Logins
      |
      v
Successful Login
      |
      v
PowerShell Execution
      |
      v
External Network Connection
      |
      v
Potential Security Incident
```
