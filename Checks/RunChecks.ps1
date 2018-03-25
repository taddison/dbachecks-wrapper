#Requires -Module dbachecks

Get-Content -Path './config.json' -Raw | ConvertFrom-Json -OutVariable globalConfig

$resultExportPath = $globalConfig.ResultExportPath

foreach($instance in Get-ChildItem -Path './Environments' -Directory)
{
    $dbcConfigPath = $instance.FullName + "\DbcConfig.json"
    Import-DbcConfig -Path $dbcConfigPath

    $testConfigPath = $instance.FullName + "\TestConfig.json"
    Get-Content -Path $testConfigPath -Raw | ConvertFrom-Json -OutVariable testConfig

    $environment = $testConfig.Environment
    
    foreach($check in $testConfig.Checks)
    {
        Invoke-DbcCheck -Check $check -PassThru | Update-DbcPowerBiDataSource -Environment $environment -Path $resultExportPath
    }   
}

Start-DbcPowerBi -Path ../Dashboard/