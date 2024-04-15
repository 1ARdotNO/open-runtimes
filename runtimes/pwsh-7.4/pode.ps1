Start-PodeServer {
    Add-PodeEndpoint -Address localhost -Port 3000 -Protocol Http

    Add-PodeRoute -Method POST -Path '/' -ScriptBlock {
        #Check for auth
        if((Get-PodeHeader -name 'x-internal-challenge') -eq $ENV:INTERNAL_RUNTIME_KEY){
            #proceed with script
            #$result=. /usr/local/server/src/function/function.ps1
            $result=. example/function.ps1

            if($result | test-json){
                Write-PodeTextResponse -Value $result -ContentType "application/json"
            }else {
                Write-PodeTextResponse -Value $result -ContentType "text/plain"
            }
            "hello world"
        }
        else{
            Set-PodeResponseStatus -Code 401 -Exception "unauthorized"
            Write-PodeTextResponse -Value "unauthorized" -ContentType "text/plain"

        }
    }
        
        
}