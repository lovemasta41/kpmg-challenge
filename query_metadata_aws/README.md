# Problem Statement
We need to write a code that will query the metadata of an instance within AWS or Azure or GCP and provide a json formatted output. 

*Bonus Points:  *
The code allows for a particular data key to be retrieved individually.

# Solution
A powershell script is created that prints meta data as json if no individual key is provided.   
If a correct key is provided, its value will be printed ont he screen.  
If incorrect key is provided then error will be printed on the scren stating provided key does not exists.  

# Outputs
Output for multiple test cases are attached in the form of an image.