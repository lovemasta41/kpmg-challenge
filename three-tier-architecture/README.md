# Problem Statement
A 3-tier environment is a common setup. Use a tool of your familiarity create these resources on a cloud environment.

# Solution
1. A 3 tier architecture is created with the help of terraform in AWS.  
2. It comprises of a Web layer, Application Layer and Database Layer.  
3. Each layer contains instances in two different subnets for high availability.  
4. Web and application layer holds load balancer for routing traffic between instances.
5. Application layer routes traffic to primary RDS database. 
6. Some default values are selected for testing purpose only, else this architecture can be re created in other accounts and region with same PATTERN as most of the required values are parameterized.  

# Output
Terraform plan output is attached for your reference.
