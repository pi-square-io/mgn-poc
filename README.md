# Application Migration Service's POC
it is a lift & shift based solution used to expedite the migration of applications to aws. It is used to reduce the cost of migrating physical, virtual and cloud based applications to aws without having compatibility or performance issues.


## Architecture 
![mgn architecture](https://github.com/pi-square-io/mgn-poc/blob/main/images/MGN.vpd.png)


## Usage
### Why not using cloudEndure ? 
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