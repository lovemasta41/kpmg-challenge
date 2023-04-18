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

    $dictTable = @{}

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
                                $hashSubChildKeyObject = @{
            
                                    $subChildKey =  $subchildkeyResponse.Content
                                }
                                if($dictTable[$key] -ne $null -and $dictTable[$key].ContainsKey($subkey)){
                                    
                                    if($dictTable[$key][$subkey].Contains($childKey)){
                                        
                                        $dictTable[$key][$subkey][$childKey] += $hashSubChildKeyObject
                                    }
                                    else{
                                        
                                        $dictTable[$key][$subkey] = @{
                                            
                                            $childKey = $hashSubChildKeyObject
                                        }
                                    }
                                }
                                else{
                                    
                                    $dictTable[$key] = @{
                                        
                                        $subkey = @{
                                            
                                            $childKey = $hashSubChildKeyObject
                                        }
                                    }
                                }
                            }
                        }
                        else{
                        
                            $childkeyResponse = Invoke-WebRequest -method Get -uri "$url$key$subkey$childkey" -Headers $headers -UseBasicParsing
                            $hashChildKeyObject = @{
            
                                $childKey =  $childkeyResponse.Content
                            }
                            if($dictTable[$key] -ne $null -and $dictTable[$key].ContainsKey($subkey)){
                                
                                $dictTable[$key][$subkey] += $hashChildKeyObject
                            }
                            else{
                                $dictTable[$key] += @{
                                
                                    $subkey = $hashChildKeyObject
                                }
                            }

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
                        $subKeyObject = @{
            
                            $subkey =  $subkeyResponse.Content
                        }
                        if($dictTable[$key] -ne $null -and $dictTable[$key].ContainsKey($subkey)){
                                
                            $dictTable[$key][$subkey] = $subkeyResponse.Content
                        }
                        else{
                            
                            $dictTable[$key] += $subKeyObject
                            
                        }
                    }

                    if($keyList){
                        
                        $subKeyObject = @{
            
                            $subkey =  $keyList
                        }
                        if($dictTable[$key] -ne $null -and $dictTable[$key].ContainsKey($subkey)){
                                
                            $dictTable[$key][$subkey] += $keyList
                        }
                        else{
                            $dictTable[$key] += $subKeyObject
                        }

                    }
                }
            }
            #>
        }
        else{
        
            $keyResponse = Invoke-WebRequest -method Get -uri "$url$key" -Headers $headers -UseBasicParsing
        
            $hashObject = @{
            
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

    foreach($key in $metadata.Keys){
    
        if(($key -eq $metaKey) -or ($key.split("/")[0] -eq $metaKey)){
        
            $metaData[$key]
            break
        }
        else{
        
            foreach($subkey in $metaData[$key].Keys){
                
                    if(($subkey -eq $metaKey) -or ($subkey.split("/")[0] -eq $metaKey)){
                    
                        $metaData[$key][$subkey]
                        break
                    }
                    else{
                    
                        foreach($childkey in $metaData[$key][$subkey].keys){
                    
                            if(($childkey -eq $metaKey) -or ($childkey.split("/")[0] -eq $metaKey)){
                            
                                $metaData[$key][$subkey][$childkey]
                                break
                            }
                        }
                    }
            }
        
        
        }
    }
}
else{
    
    $metaData | ConvertTo-Json
}