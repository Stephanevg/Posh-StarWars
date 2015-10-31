Function Get-SWObject {

<#
.SYNOPSIS

Use "Get-Help Get-SWObject -Online" to get the latest help.

.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 

 .LINK
http://powershelldistrict.com/posh-starwars/
 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>

[CmdletBinding(
        HelpURI='http://powershelldistrict.com/posh-starwars/'
    )]
Param(
    
        [Parameter(Mandatory=$false)]
        $Name,

        [Parameter(Mandatory=$false)]
        [switch]
        $Schema,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter(Mandatory=$false)]
        [ValidateSet('JSON','Wookiee')]
        [String]
        $Encoding = "JSON",

        [ValidateSet('people','planets','species','starships','vehicles','films')]
        $Type = "",

        $Filter = ""
)
begin{

    $Url = "http://swapi.co/api/"



    if($Type){
        $Url = $Url + $Type.tolower() + "/" 
    }

    if ($Schema){
        $Url = $Url + "schema/"
    }else{

        if ($Filter){
            $Url = $Url + $Filter + "/"
        }
    }


}
Process{

    if ($Encoding -eq 'Wookiee'){
        write-verbose "Retrieving data in Wookie : Baaaa!!!"
        $Url = $Url + "?format=wookiee"
    }

     $REturn = @()
     Write-Verbose "Invoking rest: $($url)"
     $Data = Invoke-RestMethod -Method Get -Uri $Url -Credential $Credentials
     

     if (!($id)){
        $REturn += $Data.results
         while ($Data.next){
            $Data = Invoke-RestMethod -Method Get -uri $Data.next
            $Return += $Data.results
         }

         if ($name){
            #bug? page1 doesn't seem to return the first 3 records.
            $Return = $Data | Where-Object {$_.name -like "*$Name"}

          }
          
     }else{
            $Return = $Data
     }


}end{

   return $Return
}


}

Function Get-SWPeople{
<#
.SYNOPSIS

Use "Get-Help Get-SWPeople -Online" to get the latest help.

.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 

 .LINK
http://powershelldistrict.com/posh-starwars/
 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>

    [cmdletBinding(
        DefaultParameterSetName = 'all'
    )]
    Param(
    
        [Parameter(ParameterSetName='id',Mandatory=$false)]
        [int]
        $id,

        [Parameter(ParameterSetName='name',Mandatory=$false)]
        $Name,

        [Parameter(ParameterSetName='schema',Mandatory=$false)]
        [switch]
        $Schema,

        [Parameter(ParameterSetName='filter',Mandatory=$false)]
        [switch]
        $filter,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter(Mandatory=$false)]
        [ValidateSet('JSON','Wookiee')]
        [String]
        $Encoding = 'JSON',

        [Parameter(ParameterSetName='all',Mandatory=$false)]
        [switch]
        $All

        
    )


  
  $BaseArguments = @{Type = 'People';Encoding=$Encoding}
  $AdditionalArguments = @{}
  if($PSCmdlet.ParameterSetName.Contains('id')){
    $AdditionalArguments = @{filter = $id; }
    
  }if($PSCmdlet.ParameterSetName.Contains('schema')){
    $AdditionalArguments = @{schema = $true}
    
  }if($PSCmdlet.ParameterSetName.Contains('all')){
    #$AdditionalArguments = @{ Type = "people";}
    
  }
  
  $HashArguments = $BaseArguments + $AdditionalArguments
  $Return = @()
  $Data = Get-SWObject @HashArguments #-Type $Type -Encoding $Encoding

      if ($name){
        #bug? page1 doesn't seem to return the first 3 records.
        $Return = $Data | Where-Object {$_.name -like "*$Name"}

      }elseif($id){
        $Return = $Data
      }
      else{
        $Return = $Data
      }
   
   
  return $Return

}

Function Get-SWSpecies{
<#
.SYNOPSIS

Use "Get-Help Get-SWSpecies -Online" to get the latest help.

.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 

 .LINK
http://powershelldistrict.com/posh-starwars/
 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>

    [cmdletBinding(
        DefaultParameterSetName = 'all'
    )]
    Param(
    
        [Parameter(ParameterSetName='id',Mandatory=$false)]
        [int]
        $id,

        [Parameter(ParameterSetName='name',Mandatory=$false)]
        $Name,

        [Parameter(ParameterSetName='schema',Mandatory=$false)]
        [switch]
        $Schema,

        [Parameter(ParameterSetName='filter',Mandatory=$false)]
        [switch]
        $filter,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter(Mandatory=$false)]
        [ValidateSet('JSON','Wookiee')]
        [String]
        $Encoding = 'JSON',

        [Parameter(ParameterSetName='all',Mandatory=$false)]
        [switch]
        $All

        
    )

    #9pages
  
  $BaseArguments = @{Type = 'Species';Encoding=$Encoding}
  $AdditionalArguments = @{}
  if($PSCmdlet.ParameterSetName.Contains('id')){
    $AdditionalArguments = @{filter = $id; }
    
  }if($PSCmdlet.ParameterSetName.Contains('schema')){
    $AdditionalArguments = @{schema = $true}
    
  }if($PSCmdlet.ParameterSetName.Contains('all')){
    #$AdditionalArguments = @{ Type = "people";}
    
  }
  
  $HashArguments = $BaseArguments + $AdditionalArguments
  $Return = @()
  $Data = Get-SWObject @HashArguments #-Type $Type -Encoding $Encoding
  #$Return += $Data
<#
  if($PSCmdlet.ParameterSetName.Contains('all')){
    
     do {
        $Data = Invoke-RestMethod -Method Get -uri $Data.next
        $Return += $Data.results
     }while ($Data.next)
  }
#>

      if ($name){
        #bug? page1 doesn't seem to return the first 3 records.
        $Return = $Data | Where-Object {$_.name -like "*$Name"}

      }elseif($id){
        $Return = $Data
      }
      else{
        $Return = $Data
      }
   
   
  return $Return

}

Function Get-SWPlanet{
<#
.SYNOPSIS

Use "Get-Help Get-SWPlanet -Online" to get the latest help.

.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 

 .LINK
http://powershelldistrict.com/posh-starwars/
 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>
    [cmdletBinding(
        DefaultParameterSetName = 'all'
    )]
    Param(
    
        [Parameter(ParameterSetName='id',Mandatory=$false)]
        [int]
        $id,

        [Parameter(ParameterSetName='name',Mandatory=$false)]
        $Name,

        [Parameter(ParameterSetName='schema',Mandatory=$false)]
        [switch]
        $Schema,

        [Parameter(ParameterSetName='filter',Mandatory=$false)]
        [switch]
        $filter,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter(Mandatory=$false)]
        [ValidateSet('JSON','Wookiee')]
        [String]
        $Encoding = 'JSON',

        [Parameter(ParameterSetName='all',Mandatory=$false)]
        [switch]
        $All

        
    )

    #9pages
  
  $BaseArguments = @{Type = 'Planets';Encoding=$Encoding}
  $AdditionalArguments = @{}
  if($PSCmdlet.ParameterSetName.Contains('id')){
    $AdditionalArguments = @{filter = $id; }
    
  }if($PSCmdlet.ParameterSetName.Contains('schema')){
    $AdditionalArguments = @{schema = $true}
    
  }if($PSCmdlet.ParameterSetName.Contains('all')){
    #$AdditionalArguments = @{ Type = "people";}
    
  }
  
  $HashArguments = $BaseArguments + $AdditionalArguments
  $Return = @()
  $Data = Get-SWObject @HashArguments #-Type $Type -Encoding $Encoding

      if ($name){
        #bug? page1 doesn't seem to return the first 3 records.
        $Return = $Data | Where-Object {$_.name -like "*$Name"}

      }elseif($id){
        $Return = $Data
      }
      else{
        $Return = $Data
      }
   
   
  return $Return

}

Function Get-SWstarship{
<#
.SYNOPSIS

Use "Get-Help Get-SWStarShip -Online" to get the latest help.

.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 

 .LINK
http://powershelldistrict.com/posh-starwars/
 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>
    [cmdletBinding(
       DefaultParameterSetName = 'all'
    )]
    Param(
    
        [Parameter(ParameterSetName='id',Mandatory=$false)]
        [int]
        $id,

        [Parameter(ParameterSetName='name',Mandatory=$false)]
        [string]
        $Name,

        [Parameter(ParameterSetName='schema',Mandatory=$false)]
        [switch]
        $Schema,

        [Parameter(ParameterSetName='filter',Mandatory=$false)]
        [switch]
        $filter,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter(Mandatory=$false)]
        [ValidateSet('JSON','Wookiee')]
        [String]
        $Encoding = 'JSON',

        [Parameter(Mandatory=$false)]
        [switch]
        $All

        
    )


  
  $BaseArguments = @{Type = 'starships';Encoding=$Encoding}
  $AdditionalArguments = @{}
  if($PSCmdlet.ParameterSetName.Contains('id')){
    $AdditionalArguments = @{filter = $id; }
    
  }if($PSCmdlet.ParameterSetName.Contains('schema')){
    $AdditionalArguments = @{schema = $true}
    
  }if($PSCmdlet.ParameterSetName.Contains('all')){
    #$AdditionalArguments = @{ Type = "people";}
    
  }
  if($PSCmdlet.ParameterSetName.Contains('filter')){
    $AdditionalArguments = @{filter = $filter; }
    
  }
  
  $HashArguments = $BaseArguments + $AdditionalArguments
  $Return = @()
  $Data = Get-SWObject @HashArguments #-Type $Type -Encoding $Encoding
  #$Return += $Data
<#
  if($PSCmdlet.ParameterSetName.Contains('all')){
    
     do {
        $Data = Invoke-RestMethod -Method Get -uri $Data.next
        $Return += $Data.results
     }while ($Data.next)
  }
#>

      if ($name){
        #bug? page1 doesn't seem to return the first 3 records.
        $Return = $Data | Where-Object {$_.name -like "*$Name"}

      }elseif($id){
        $Return = $Data
      }
      else{
        $Return = $Data
      }
   
   
  return $Return

}

Function Get-SWVehicule{
<#
.SYNOPSIS

Use "Get-Help Get-SWVehicule -Online" to get the latest help.

.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 

 .LINK
http://powershelldistrict.com/posh-starwars/
 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>
    [cmdletBinding(
       DefaultParameterSetName = 'all'
    )]
    Param(
    
        [Parameter(ParameterSetName='id',Mandatory=$false)]
        [int]
        $id,

        [Parameter(ParameterSetName='name',Mandatory=$false)]
        [string]
        $Name,

        [Parameter(ParameterSetName='schema',Mandatory=$false)]
        [switch]
        $Schema,

        [Parameter(ParameterSetName='filter',Mandatory=$false)]
        [switch]
        $filter,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter(Mandatory=$false)]
        [ValidateSet('JSON','Wookiee')]
        [String]
        $Encoding = 'JSON',

        [Parameter(Mandatory=$false)]
        [switch]
        $All

        
    )


  
  $BaseArguments = @{Type = 'vehicles';Encoding=$Encoding}
  $AdditionalArguments = @{}
  if($PSCmdlet.ParameterSetName.Contains('id')){
    $AdditionalArguments = @{filter = $id; }
    
  }if($PSCmdlet.ParameterSetName.Contains('schema')){
    $AdditionalArguments = @{schema = $true}
    
  }if($PSCmdlet.ParameterSetName.Contains('all')){
    #$AdditionalArguments = @{ Type = "people";}
    
  }
  if($PSCmdlet.ParameterSetName.Contains('filter')){
    $AdditionalArguments = @{filter = $filter; }
    
  }
  
  $HashArguments = $BaseArguments + $AdditionalArguments
  $Return = @()
  $Data = Get-SWObject @HashArguments #-Type $Type -Encoding $Encoding
  #$Return += $Data
<#
  if($PSCmdlet.ParameterSetName.Contains('all')){
    
     do {
        $Data = Invoke-RestMethod -Method Get -uri $Data.next
        $Return += $Data.results
     }while ($Data.next)
  }
#>

      if ($name){
        #bug? page1 doesn't seem to return the first 3 records.
        $Return = $Data | Where-Object {$_.name -like "*$Name"}

      }elseif($id){
        $Return = $Data
      }
      else{
        $Return = $Data
      }
   
   
  return $Return

}

Function Get-SWFilm{
<#
.SYNOPSIS

Use "Get-Help Get-SWFilm -Online" to get the latest help.

.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 

 .LINK
http://powershelldistrict.com/posh-starwars/
 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>
    [cmdletBinding(
       DefaultParameterSetName = 'all'
    )]
    Param(
    
        [Parameter(ParameterSetName='id',Mandatory=$false)]
        [int]
        $id,

        [Parameter(ParameterSetName='name',Mandatory=$false)]
        [string]
        $Name,

        [Parameter(ParameterSetName='schema',Mandatory=$false)]
        [switch]
        $Schema,

        [Parameter(ParameterSetName='filter',Mandatory=$false)]
        [switch]
        $filter,

        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]
        $Credentials,

        [Parameter(Mandatory=$false)]
        [ValidateSet('JSON','Wookiee')]
        [String]
        $Encoding = 'JSON',

        [Parameter(Mandatory=$false)]
        [switch]
        $All

        
    )


  
  $BaseArguments = @{Type = 'films';Encoding=$Encoding}
  $AdditionalArguments = @{}
  if($PSCmdlet.ParameterSetName.Contains('id')){
    $AdditionalArguments = @{filter = $id; }
    
  }if($PSCmdlet.ParameterSetName.Contains('schema')){
    $AdditionalArguments = @{schema = $true}
    
  }if($PSCmdlet.ParameterSetName.Contains('all')){
    #$AdditionalArguments = @{ Type = "people";}
    
  }
  if($PSCmdlet.ParameterSetName.Contains('filter')){
    $AdditionalArguments = @{filter = $filter; }
    
  }
  
  $HashArguments = $BaseArguments + $AdditionalArguments
  $Return = @()
  $Data = Get-SWObject @HashArguments #-Type $Type -Encoding $Encoding
  #$Return += $Data
<#
  if($PSCmdlet.ParameterSetName.Contains('all')){
    
     do {
        $Data = Invoke-RestMethod -Method Get -uri $Data.next
        $Return += $Data.results
     }while ($Data.next)
  }
#>

      if ($name){
        #bug? page1 doesn't seem to return the first 3 records.
        $Return = $Data | Where-Object {$_.name -like "*$Name"}

      }elseif($id){
        $Return = $Data
      }
      else{
        $Return = $Data
      }
   
   
  return $Return

}