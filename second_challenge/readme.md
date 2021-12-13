<h2>PROBLEM STATEMENT</h2>

We need to write code that will query the meta data of an instance within AWS and provide a json formatted output. The choice of language and implementation is up to you.
Bonus Points:
The code allows for a particular data key to be retrieved individually

<h2>SOLUTION</h2>

I have written this script in powershell using Az and Az.ResourceGraph Module.


    .SYNOPSIS
        A script to query metadate of an azure virtual machine.

    .DESCRIPTION
        This script utilizes Az.ResoruceGraph powershell module to query the meatadata of an azure virtual machine of your choice and returns the data in the JSON format.
        It can also print the specific properties metadata of the virtual machine.

    .PARAMETER subscriptionId
        Id of the Subscription where resource is deployed.

    .PARAMETER resourceGroupName
        Resource group where your machine is deployed.

    .PARAMETER hostname
        Host for which metadata needs to be gathered.
    
    .PARAMETER propertyKey
        Meta data of specific property of the virtual machine.

    .INPUTS
        NA

    .OUTPUTS
        JSON Metadata of the virtual machine.

    .EXAMPLE
        To get the complete metadata, use 
        explore-metadata.ps1 -subscriptionid "434535-3534534-cxxx-xxxxxxx" -resourceGroupName "demo_rg" -hostname "demo_vm"

        To get the meta data of a specific property of the VM, use
        explore-metadata.ps1 -subscriptionid "434535-3534534-cxxx-xxxxxxx" -resourceGroupName "demo_rg" -hostname "demo_vm" -propertyKey "osProfile"

