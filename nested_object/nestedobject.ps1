#Param block to accept object and key from calling
param(

    $object,
    $key

)


#Variables
$split_keys = $key -split ("/")
$new_object = ConvertFrom-Json -InputObject $object

Function converter(){
    
    foreach($key in $split_keys){

        if($new_object.$key){
            $new_object = $new_object.$key
        }
        
    }
    
    write-host $($new_object | ConvertTo-Json)
}

#Main
converter