#Requires -Modules dbachecks, SQLChecks

Get-Content -Path '.\global.config.json' -Raw | ConvertFrom-Json -OutVariable globalConfig | Out-Null

$resultExportPath = $globalConfig.ResultExportPath
$sqlChecksTestPath = $globalConfig.SQLChecksTestPath

foreach($instance in Get-ChildItem -Path './Environments' -Directory)
{
    # Global config settings
    $testConfigPath = $instance.FullName + "\tests.config.json"
    Get-Content -Path $testConfigPath -Raw | ConvertFrom-Json -OutVariable testConfig | Out-Null

    $environment = $testConfig.Environment

    # DBAChecks
    if(Test-Path ($instance.FullName + "\dbachecks.config.json"))
    {
        Write-Host "Found DBAChecks configuration for $environment"

        $dbcConfigPath = $instance.FullName + "\dbachecks.config.json"
        Import-DbcConfig -Path $dbcConfigPath | Out-Null
        
        foreach($check in $testConfig.DBAChecks.Checks)
        {
            Write-Host "[DBACHECKS] Running $check on $environment"
            Invoke-DbcCheck -Check $check -PassThru | Update-DbcPowerBiDataSource -Environment $environment -Path $resultExportPath
        }   
    }

    $sqlChecksFolder = $instance.FullName + "\\SQLChecks"
    if(Test-Path ($sqlChecksFolder))
    {
        Write-Host "Found SQLChecks folder for $environment"

        foreach($sqlChecksConfig in Get-ChildItem -Path $sqlChecksFolder -Filter "*.config.json")
        {
            $sqlChecksConfigPath = $sqlChecksConfig.FullName
            [string]$data = Get-Content -Path $sqlChecksConfigPath -Raw
            $data | ConvertFrom-Json -OutVariable sqlCheckConfig | Out-Null

            $instance = $sqlCheckConfig.ServerInstance
            $sqlCheckEnvironment = $environment + "-" + $instance
            $exportPath = $resultExportPath + "\\SQLChecks\\$environment"
            
            foreach($check in $sqlCheckConfig | Get-Member -Type NoteProperty | Where-Object { $_.Name -ne "ServerInstance"} | Select-Object -ExpandProperty Name)
            {
                Write-Host "[SQLCHECKS] Running $check on $environment - $instance"
                Invoke-Pester -Script @{Path=$sqlChecksTestPath;Parameters= @{configs=$sqlChecksConfig}} -Tag $check -PassThru | Update-DbcPowerBiDataSource -Environment $sqlCheckEnvironment -Path $exportPath
            } 
        }        
    }
}

#Start-DbcPowerBi -Path ../Dashboard/