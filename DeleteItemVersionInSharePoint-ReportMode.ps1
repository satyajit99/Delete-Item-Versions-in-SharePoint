###########################################################################
#### Delete-Item-Versions-in-SharePoint using PowerShell - Report Mode ####
###########################################################################
if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) 
{
	Add-PSSnapin Microsoft.SharePoint.PowerShell;
}

$myWeb = "http://mysharepoint.com/sites/myweb1"
$myList = "Fantastic Library"
$myDate = "2014-01-01"
$myPath = "E:\Satyajit\VersionHistoryDeleteCheckWithDateFilter.csv"

$results = @()
$storageSaved = 0

$SPWeb = Get-SPWeb $myWeb
foreach ($list in $SPWeb.Lists)
{
    if ($list.Title -eq $myList)
    {
        Write-Host "Name: " $list.Title
        Write-Host "Type: " $list.BaseType
        $itemColl = $list.Items
        foreach ($item in $itemColl)
        {           
            foreach ($ver in $item.Versions)
            {
                #this block for non-current versions
                if (!$ver.IsCurrentVersion)        
                { 
                  if ((Get-Date $ver.Created) -lt (Get-Date $myDate))
                  {                                      
                        $RowDetails = @{
                            "Document Name" = $item.Name
                            "Version Number" = $ver.VersionLabel
                            "Created Date" = $ver.Created
                            "Created By" = $ver.CreatedBy
                            "Delete Flag" = "Can be deleted" 
                            "Date Flag" = "Match"    
			                "Version Size (Kb)" =  "{0:n2}"-f ($item.File.Versions.GetVersionFromLabel($ver.VersionLabel).Size/1KB)                                     
                        }
                        $tempSize = "{0:n2}"-f ($item.File.Versions.GetVersionFromLabel($ver.VersionLabel).Size/1MB)
                        $storageSaved = $storageSaved + $tempSize  
                        $results += New-Object PSObject -Property $RowDetails 
                   }
                   else
                   {
                        $RowDetails = @{
                                "Document Name" = $item.Name
                                "Version Number" = $ver.VersionLabel
                                "Created Date" = $ver.Created
                                "Created By" = $ver.CreatedBy
                                "Delete Flag" = "Do not Delete" 
                                "Date Flag" = "Does not Match" 
				                "Version Size (Kb)" = "{0:n2}"-f ($item.File.Versions.GetVersionFromLabel($ver.VersionLabel).Size/1KB)                                        
                            }
                         $results += New-Object PSObject -Property $RowDetails                         
                   }
                }
                
                #this block for current versions
                else
                {
                    if ((Get-Date $ver.Created) -lt (Get-Date $myDate))
                    {  
                        $RowDetails = @{
                                "Document Name" = $item.Name
                                "Version Number" = $ver.VersionLabel
                                "Created Date" = $ver.Created
                                "Created By" = $ver.CreatedBy     
                                "Delete Flag" = "Do not Delete " 
                                "Date Flag" = "Match"    
				                "Version Size (Kb)" = "{0:n2}"-f ($item.File.Versions.GetVersionFromLabel($ver.VersionLabel).Size/1KB)            
                            }
                            $results += New-Object PSObject -Property $RowDetails 
                    }
                    else
                    {
                        $RowDetails = @{
                                "Document Name" = $item.Name
                                "Version Number" = $ver.VersionLabel
                                "Created Date" = $ver.Created
                                "Created By" = $ver.CreatedBy   
                                "Delete Flag" = "Do not Delete" 
                                "Date Flag" = "Does not Match"	
				                "Version Size (Kb)" = "{0:n2}"-f ($item.File.Versions.GetVersionFromLabel($ver.VersionLabel).Size/1KB)                                    
                            }
                         $results += New-Object PSObject -Property $RowDetails                        
                    }
                }
                
            }
            
        }
    }    
}
$TotalSizeSaved = @{
	"Document Name" = ""
    "Version Number" = ""
    "Created Date" = ""
    "Created By" = ""  
    "Delete Flag" = ""
    "Date Flag" = ""
	"Version Size (Kb)" =  "Total Size = " + $storageSaved 
}
$results += New-Object PSObject -Property $TotalSizeSaved
$results | export-csv -Path $myPath -NoTypeInformation
Write-Host "---------------------------------------------------------------"
Write-Host $storageSaved " MB can be saved from this library"
Write-Host "---------------------------------------------------------------"
