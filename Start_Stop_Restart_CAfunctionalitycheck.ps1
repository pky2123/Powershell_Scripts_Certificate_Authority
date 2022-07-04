<##-------------------------------------------------------------------------------------
Source is from below github. 
https://github.com/subhamproject/Powershell/blob/master/strart_stop_service_pwrshell.txt

New Feature added : CA functionlaty Check
Additionally the script will check Certificate Authority Functionlity
#>


param (
[Parameter(Mandatory=$true)]
[string] $ServiceName,
[string] $Action
)
 
#Checks if ServiceName exists and provides ServiceStatus
function CheckMyService ($ServiceName)
{
	if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
	{
		$ServiceStatus = (Get-Service -Name $ServiceName).Status
		Write-Host $ServiceName "-" $ServiceStatus
	}
	else
	{
		Write-Host "$ServiceName not found"
	}
}
 


#Function to check CA is functional or not
#-----------------------------------------


Function CAfunctionality(){

    $dump = certutil.exe -ping
    $CAvalidaton = ($dump -join " ").contains("ping command completed successfully")
    if($CAvalidaton -eq $true){
                write-host "Certificate Authority is Functional and $ServcieName is running"
                Write-Output $dump[1]
                }else{
                Write-Host "Certificate Authority is not Functional and $Servicename is Not Running"
            }
        }


#Checks if service exists
#-------------------------
if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
{	#Condition if user wants to stop a service
	if ($Action -eq 'Stop')
	{
		if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		{
			Write-Host $ServiceName "is running, preparing to stop..."
			Get-Service -Name $ServiceName | Stop-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
		elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		{
			Write-Host $ServiceName "already stopped!"
		}
		else
		{
			Write-Host $ServiceName "-" $ServiceStatus
		}
	}
 
	#Condition if user wants to start a service
    #------------------------------------------

	elseif ($Action -eq 'Start')
	{
		if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		{
			Write-Host $ServiceName "already running!"
		}
		elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		{
			Write-Host $ServiceName "is stopped, preparing to start..."
			Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
		else
		{
			Write-Host $ServiceName "-" $ServiceStatus
		}
	}
 
	#Condition if user wants to restart a service
    #---------------------------------------------

	elseif ($Action -eq 'Restart')
	{
		if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		{
			Write-Host $ServiceName "is running, preparing to restart..."
			Get-Service -Name $ServiceName | Stop-Service -ErrorAction SilentlyContinue
			Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
		elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		{
			Write-Host $ServiceName "is stopped, preparing to start..."
			Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			CheckMyService $ServiceName
		}
	}
 
	#Condition if action is anything other than stop, start, restart
    #---------------------------------------------------------------

	else
	{
		Write-Host "Action parameter is missing or invalid!"
	}
}
 
#Condition if provided ServiceName is invalid
#--------------------------------------------

else
{
	Write-Host "$ServiceName not found"
}