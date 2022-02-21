# Application Migration Service's POC
it is a lift & shift based solution used to expedite the migration of applications to aws. It is used to reduce the cost of migrating physical, virtual and cloud based applications to aws without having compatibility or performance issues.


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
Ansible is an agentless, that means it uses SSH to push changes from a single machine source to multiple remote resources.
The commands in Ansible can be invoked either ad hoc on the command line or via "playbooks" written in YAML.

#### When to use ad hoc commands & playbooks 
- Ansible-playbook is used for configuration management and deployment.
- The ad-hoc commands are not used for configuration management and deployment, because these commands are of one time usage. They can be run individually to perform quick functions such as rebooting all of the company servers.

#### Debrieving the Ansible code source
Ansible uses playbook to describe automation jobs
- the inventory file
Ansible works against multiple systems in the infrastructure at the same time. It does this by selecting portions of systems listed in Ansible’s inventory file.
An inventory file can contain multiple systems which we can classify based on its group 
- the Playbook file

#### WINRM installation command
iex(iwr https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1).Content

#### OpenSSH installation commands
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
###### This should return the following output if neither are already installed:
Name  : OpenSSH.Client~~~~0.0.1.0
State : NotPresent

Name  : OpenSSH.Server~~~~0.0.1.0
State : NotPresent

##### Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

##### Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
##### Start the sshd service
Start-Service sshd

##### OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

##### Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

#### Ping Linux Servers
ansible linux -m ping -i hosts -vvv

#### Ping Windows Servers
ansible win_ssh -m win_ping -i hosts -vvv

#### Run playbook on specific group
ansible-playbook -l win_winrm -i hosts agent.yaml --extra-vars "region=<region> user_win=<user> pwd_win=<pwd>" -vvv
