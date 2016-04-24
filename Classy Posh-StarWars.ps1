#version: 0.4
#Author: Stéphane van Gulick
#twitter: @stephanevg
#WebSite: http://powershelldistrict.com/posh-starwars/

enum SWobjectType {
    people
    planet
    specie
    starship
    vehicle
    film
}

enum SWEncoding { 
    JSON
    Wookie
}

$PSDefaultParameterValues.Add('*:verbose',$True)
$PSDefaultParameterValues.Add('*:debug',$True)

#Start of classes
Class SWobject {
            
        [string]$Name
        [int]$Id


        #[ValidateSet('JSON','Wookiee')]
        [SWEncoding] $Encoding# = 'JSON' # 

        #[ValidateSet('people','planets','species','starships','vehicles','films')]
        [SWobjectType]$Type

        [string]$Filter

        hidden [System.Management.Automation.PSCredential]$Credentials
        #Method ShowSchema
            #        [switch]$Schema,

        hidden $BaseUrl = 'http://swapi.co/api/'
        hidden $Data
        hidden $Schema
        
        swobject(){
        }

        SWobject([int]$Id,[SWobjectType]$Type){
            $this.id = $Id
            $this.Type = $Type
        }

        SWobject([string]$Name,[SWobjectType]$Type){
        if ($this.Encoding -eq "wookie"){
            throw "Wookies don't understand PowerShell name filtering. Please use the ID instead. Waarrghaaa!"
        }
        $this.Name = $Name
        $this.Type = $Type
    }


        Get(){
            write-debug $this
            if (!($this.Type)){
                
                throw 'Cannot continue without assigning a type. Please assign a type, and retry again.'
            }

            if ($this.name -eq $null -and $this.id -eq $null){
                throw 'Specify at least and ID or a Name parameter'
            }else{
            
                #$BaseUrl = 'http://swapi.co/api/'
                $Return = @()
                $Dataraw = ''
                if ($this.id){

                    
                    $Url = $this.BaseUrl + $this.Type + 's' + '/' + $this.id 
                    
                    write-verbose 'returning information'
                    Write-debug "Invoking rest: $($url)"
                    $Dataraw = Invoke-RestMethod -Method Get -uri $Url
                    $this.Data = $Dataraw
                    #$this.Data = $return


                }elseif ($this.name){
                    
                    #$this.Data = Invoke-RestMethod -Method Get -Uri $Url #-Credential $Credentials
                }else{
                    $Url = $this.BaseUrl + $this.Type + 's' + '/' 
                    $Dataraw = Invoke-RestMethod -Method Get -uri $Url
                    $return += $Dataraw.results
                    Write-Verbose "Found $($DataRaw.Count) entries."
                     while ($Dataraw.Data.next){
                        write-verbose 'Information, there is a lot. Patient, you will be...'
                        $Dataraw = Invoke-RestMethod -Method Get -uri $Dataraw.next
                        $return += $Dataraw.results
                     }

                     $this.Data = $return
                     
                }
            
            }
        }

        GetSchema(){
            
            $Url = $this.BaseUrl + $this.Type + 's' + '/' + 'schema'
            
            write-verbose 'returning information'
            Write-debug "Invoking rest: $($url)"

            $this.Schema = Invoke-RestMethod -Method Get -Uri $Url #-Credential $Credentials

            #return $this.Schema
        }


}

Class SWFilm : SWObject{
    
    [String]$Director
    [String]$Producer
    $Release_Date
    $Crawl

    #Constructors

        SWFilm(){
            $this.Type = [SWobjectType]::film
        }

        SWFilm([int]$Id): Base([int]$Id,[SWobjectType]::film){

        }

        SWfilm([string]$Name) : Base([string]$Name,[SWobjectType]::film){
        
        }

    #Methods
        [Object]SetData(){
        
                if ($this.data.count -gt 1){
                    write-verbose 'Assigning films'
                        $AllFilms = @()
                        foreach ($film in $this.Data){
                            if ($film -ne '' -or $film -eq $null){

                                write-debug "Creating new film object: '$($film.Title)'" 
                                    $NewFilm = [SWFilm]::New();
                                    $NewFilm.Director = $film.director
                                    $NewFilm.Producer = $film.Producer
                                    $NewFilm.id = $film.episode_id
                                    $NewFilm.Release_Date = $film.release_Date
                                    $NewFilm.Name = $film.Title
                                    $NewFilm.Crawl = $Film.opening_crawl
                                    $AllFilms += $NewFilm
                            }
                        }#end foreach
                return $AllFilms | sort id
            }else{

                $this.Director = $this.Data.director
                $this.Producer = $this.Data.Producer
                $this.Release_Date = $this.Data.release_Date
                $this.id = $this.data.episode_id
                $this.Name = $this.Data.Title
                $this.Crawl = $this.data.opening_crawl

                return $this 
            }
        }

        [string]GetCrawl(){
            return $this.Crawl
        }

}


#$PSDefaultParameterValues.remove('*:verbose')
#$PSDefaultParameterValues.remove('*:debug')

