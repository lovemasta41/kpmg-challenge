<h2>PROBLEM STATEMENT</h2>

We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you.
Example Inputs
object = {“a”:{“b”:{“c”:”d”}}}
key = a/b/c
object = {“x”:{“y”:{“z”:”a”}}}
key = x/y/z
value = a
Hints:
We would like to see some tests. A quick read to help you along the way

<h2>SOLUTION</h2>

<b>I have written this script in powershell using ordered hashtable or dictionary. Object and Key are provided as input for demo.</b>

<h3>Test Case 1</h3>

<b>Input Object:</b>
"
$customObject = [ordered]@{
    
    "a" = [ordered]@{
            "b" = [ordered]@{
                    "c" = "d"
                  }
          }
}
"
<b>Input Key</b>
"a"

<b>Output:</b>

{
    "b":  {
              "c":  "d"
          }
}

<h3>Test Case 4</h3>

<b>Input Object:</b>
"
$customObject = [ordered]@{
    
    "a" = [ordered]@{
            "b" = [ordered]@{
                    "c" = "d"
                  }
          }
}
"
<b>Input Key</b>
"c"

<b>Output:</b>

"d"


<h3>Test Case 3</h3>

<b>Input Object:</b>
"
$customObject = [ordered]@{
    
    "a" = [ordered]@{
            "b" = [ordered]@{
                    "c" = "d"
                  }
          }
}
"
<b>Input Key</b>
"d"

<b>Output:</b>

"Required key not found in the object."
