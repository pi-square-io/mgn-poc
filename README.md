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


