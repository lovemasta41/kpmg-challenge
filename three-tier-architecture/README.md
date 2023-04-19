# Problem Statement
A 3-tier environment is a common setup. Use a tool of your familiarity create these resources on a cloud environment.

# Solution
A 3 tier architecture is created with the help of terraform in AWS.  
It comprises of a Web layer, Application Layer and Database Layer.  
Each layer contains instances in two different subnets for high availability.
Web and application layer holds load balancer for routing traffic between instances.
Application layer routes traffic to primary RDS database. 
Some default values are selected for testing purpose only, else this architecture can be re created with same code in any other region as most of the required values are parameterized.  

# Output
Terraform plan output is attached for your reference.
