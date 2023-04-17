$region = "us-east-1"
$instance_id = (Invoke-RestMethod "http://169.254.169.254/latest/meta-data/instance-id")
$url = "http://169.254.169.254/latest/meta-data/"
$headers = @{
    "X-aws-ec2-metadata-token" = (Invoke-RestMethod "http://169.254.169.254/latest/api/token")
}

# Retrieve the metadata
$response = Invoke-RestMethod -Method Get -Uri $url -Headers $headers

# Convert the metadata to a PowerShell object
$metadata = $response | ConvertFrom-StringData

# Convert the metadata to JSON
$metadata_json = $metadata | ConvertTo-Json

# Print the metadata JSON to the console
Write-Host $metadata_json
