# Application Migration Service's POC
It's a lift & shift based solution used to expedite the migration of applications to aws. It is used to reduce the cost of migrating physical, virtual and cloud based applications to aws without having compatibility or performance issues.


## Architecture 
![mgn architecture](https://github.com/pi-square-io/mgn-poc/blob/main/images/MGN.vpd.png)


## Usage
### Why not using cloudEndure 
CloudEndure Migration will continue to be available for use in AWS GovCloud and China Regions, it will no longer be available in other AWS Regions as of December 30, 2022
The new alternative is using aws application migration service (mgn)

### Uses cases
1. Data center to cloud migration
Move virtual and physical servers to AWS. The automated rehosting capabilities of Application Migration Service helps to avoid complications that can be caused by manual replication, reconfiguration, and rebuilds.
2. Cross-cloud migration
Migrate workloads running on another public or private cloud to AWS.
3. Cross-region migration
Migration between different AWS accounts, Availability Zones, or regions.

### How it works
1. Install Agent
2. Replicate to AWS
3. Perform tests
4. Execute cutover

### MGN with Ansible
Ansible is agentless, that means it uses SSH to push changes from a single machine source to multiple remote resources.
The commands in Ansible can be invoked either ad hoc on the command line or via "playbooks" written in YAML.

#### When to use ad hoc commands & playbooks 
- Ansible-playbook is used for configuration management and deployment.
- The ad-hoc commands are not used for configuration management and deployment, because these commands are of one time usage. They can be run individually to perform quick functions such as rebooting all of the company servers.

#### Debrieving the Ansible code source
Ansible uses playbook to describe automation jobs
- the inventory file (in our case: hosts)
Ansible works against multiple systems in the infrastructure at the same time. It does this by selecting portions of systems listed in Ansible’s inventory file. An inventory file can contain multiple systems which we can classify based on its group. 
- the Playbook file: In our playbook, which is agent.yaml file, we created two plays, one for the linux servers and the other for windows servers (both ssh and winmr).


#### Linux target Hosts

##### Ping Linux Servers
To test the connectivity between ansible and hosts in the linux group, we can use the module ping.

```sh
ansible linux -m ping -i hosts -vvv
```


##### Run playbook on linux Servers
To Run the playbook on the linux group, we specify the group name, the inventory file, and the extra vars which are the user that we will connect to ssh with, the target region where to deploy the migration and the location of the private key.

```sh
ansible-playbook -l linux -i hosts agent.yaml --extra-vars "user_linux=user region=region key=key_location" -vvv
```



#### Windows target Hosts

Windows servers can be managed with Ansible through two methods:
- SSH (just like linux)
- WinRM (Windows Remote Management) which is the Microsoft implementation of WS-Management Protocol, a standard Simple Object Access Protocol (SOAP)-based, firewall-friendly protocol that allows hardware and operating systems, from different vendors, to interoperate.)

> Note: Windows supports Openssh, but only `openssh client` is installed, you need to install `openssh server` to be able to manage windows server with Ansible. You can check configuration down below.


##### Ping Windows Servers
To test the connectivity between ansible and hosts in the linux group, we can use the module ping :

```sh
ansible win_ssh -m win_ping -i hosts -vvv
```

#### Run playbook on windows servers
To Run the playbook on windows group, we specify the group name, the inventory file, and the extra vars which are the target region where to deploy the migration and the credentials of the user that we will authentificate with.

```sh
ansible-playbook -l win_winrm -i hosts agent.yaml --extra-vars "region=region user_win=user pwd_win=pwd" -vvv
```



## Extra target hosts Configurations

#### WINRM installation command on windows host
Installing winRM on windows targets.

```sh
iex(iwr https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1).Content
```

#### OpenSSH installation commands on windows host

```sh
url: https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
```

###### This should return the following output if neither are already installed:
```sh
Name  : OpenSSH.Client~~~~0.0.1.0
State : NotPresent

Name  : OpenSSH.Server~~~~0.0.1.0
State : NotPresent
```
##### Install the OpenSSH Client

```sh
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

##### Install the OpenSSH Server

```sh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

##### Start the sshd service

```sh
Start-Service sshd
```

##### OPTIONAL but recommended:

```sh
Set-Service -Name sshd -StartupType 'Automatic'
```

##### Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify

```sh
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
```