param(
    $metaKey
)

##### region VARIABLES

$url = "http://169.254.169.254/latest/meta-data/"
$token = (Invoke-WebRequest "http://169.254.169.254/latest/api/token" -Method PUT -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" =  "21600"}).content
$headers = @{
    "X-aws-ec2-metadata-token" = $token
}

##### region FUNCTIONS
Function metadata(){  

    # Retrieve the metadata
    $response = Invoke-WebRequest -Method Get -Uri $url -Headers $headers -UseBasicParsing -ErrorAction SilentlyContinue
    $keys = $response.Content.Split([Environment]::NewLine)

    $dictTable = @()

    foreach($key in $keys){
    

        if($key -like "*/"){
        
            $subkeys = (Invoke-WebRequest -method Get -uri "$url$key" -Headers $headers -UseBasicParsing -ErrorAction SilentlyContinue).Content.Split([Environment]::NewLine)
            foreach($subkey in $subkeys){
            
                if($subkey -like "*/"){
                
                    $childKeys = (Invoke-WebRequest -method Get -uri "$url$key$subkey" -Headers $headers -UseBasicParsing -ErrorAction SilentlyContinue).Content.Split([Environment]::NewLine)
                
                    foreach($childkey in $childKeys){
                    
                        if($childkey -like "*/"){
                        
                            $subChildKeys = (Invoke-WebRequest -method Get -uri "$url$key$subkey$childKey" -Headers $headers -UseBasicParsing -ErrorAction SilentlyContinue).Content.Split([Environment]::NewLine)
                            foreach($subchildKey in $subChildKeys){
                            
                                $subchildKeyResponse = Invoke-WebRequest -method Get -uri "$url$key$subkey$childkey$subchildKey" -Headers $headers -UseBasicParsing -ErrorAction SilentlyContinue
                                $hashSubChildKeyObject = [pscustomobject]@{
            
                                    $subChildKey =  $subchildkeyResponse.Content
                                }
                                $dictTable += $hashSubChildKeyObject
                            }
                        }
                        else{
                        
                            $childkeyResponse = Invoke-WebRequest -method Get -uri "$url$key$subkey$childkey" -Headers $headers -UseBasicParsing
                            $hashChildKeyObject = [pscustomobject]@{
            
                                $childkey =  $childkeyResponse.Content
                            }
                            $dictTable += $hashChildKeyObject


                        }
                    }

                }
                else{
                    
                    $keyList = @()
                    if($subkey -like "*=*"){
                        
                        $keyList += $subkey

                    }
                    else{

                        $subkeyResponse = Invoke-WebRequest -method Get -uri "$url$key$subkey" -Headers $headers -UseBasicParsing -ErrorAction SilentlyContinue
                        $subKeyObject = [pscustomobject]@{
            
                            $subkey =  $subkeyResponse.Content
                        }
                        $dictTable += $subKeyObject
                    }

                    if($keyList){
                        
                        $subKeyObject = [pscustomobject]@{
            
                            $key.split("/")[0] =  $keyList
                        }
                        $dictTable += $subKeyObject

                    }
                }
            }
            #>
        }
        else{
        
            $keyResponse = Invoke-WebRequest -method Get -uri "$url$key" -Headers $headers -UseBasicParsing
        
            $hashObject = [pscustomobject]@{
            
                $key =  $keyResponse.Content
            }
            $dictTable += $hashObject

        }

    }
        
return $dictTable

}


##### Region MAIN

$metaData = metadata

if($metaKey){

    if($metaData.$metaKey){    
        $metaData.$metaKey 
    }
    else{
        "Provided key does not exist."
    }
}
else{
    
    $metadata | ConvertTo-Json
}