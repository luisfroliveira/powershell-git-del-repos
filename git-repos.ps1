$linhas = Get-Content -Path .\repos.txt

$AzureDevOpsPAT = "SEU TOKEN PAT"
$OrganizationName = "SUA ORGANIZAÇÃO"
$project = "SEU PROJETO"

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }

$Uri = "https://dev.azure.com/$($OrganizationName)/$($project)/_apis/git/repositories?api-version=7.2-preview.1" 
$response = Invoke-RestMethod -Uri $Uri -Method GET -Headers $AzureDevOpsAuthenicationHeader 

foreach ($linha in $linhas) {
    $Repo = $response.value | where { $_.Name -eq $linha }
    $id = $Repo.id

    $UriDelete = "https://dev.azure.com/$($OrganizationName)/$($project)/_apis/git/repositories/$($id)?api-version=7.2-preview.1"
    Invoke-RestMethod -Uri $UriDelete -Method DELETE -Headers $AzureDevOpsAuthenicationHeader 
    Write-Output "Deletando repositorio: $($linha) - $($id)" 
}
