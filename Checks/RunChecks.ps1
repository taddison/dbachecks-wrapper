#Requires -Module dbachecks

Get-Content -Path '.\global.config.json' -Raw | ConvertFrom-Json -OutVariable globalConfig

$resultExportPath = $globalConfig.ResultExportPath

foreach($instance in Get-ChildItem -Path './Environments' -Directory)
{
    $dbcConfigPath = $instance.FullName + "\dbachecks.config.json"
    Import-DbcConfig -Path $dbcConfigPath

    $testConfigPath = $instance.FullName + "\tests.config.json"
    Get-Content -Path $testConfigPath -Raw | ConvertFrom-Json -OutVariable testConfig

    $environment = $testConfig.Environment
    
    foreach($check in $testConfig.DBAChecks.Checks)
    {
        Invoke-DbcCheck -Check $check -PassThru | Update-DbcPowerBiDataSource -Environment $environment -Path $resultExportPath
    }   
}

Start-DbcPowerBi -Path ../Dashboard/