# Get Hostname
$hostname = $env:COMPUTERNAME

# Get time and date
$currentDateTime = Get-Date -Format "yyyyMMdd_HHmmss"

# Check system language
$language = (Get-Culture).Name

# Set output file path and name
$outputFile = "$hostname $currentDateTime.txt"

# Check Administrators group name based on language - Supports Brazilian Portuguese and English.
if ($language -eq "en-US") {
    $administratorsGroup = "Administrators"
}
elseif ($language -eq "pt-BR") {
    $administratorsGroup = "Administradores"
}
else {
    Write-Host "Language not supported yet."
    exit
}

# Get the members of the Administrators group
$administrators = Get-LocalGroupMember -Group $administratorsGroup

# Convert members to a formatted list
$membersList = $administrators | Select-Object -ExpandProperty Name

# Save the member list to a TXT file
$membersList | Out-File -FilePath $outputFile

# Copy file to remote server
$remotePath = "\\REMOTESERVER\Folder\$outputFile"
Copy-Item -Path $outputFile -Destination $remotePath

# Remove local file
Remove-Item -Path $outputFile
