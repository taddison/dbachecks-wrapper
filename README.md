# dbachecks-wrapper
An example of how you might wrap [dbachecks](https://github.com/sqlcollaborative/dbachecks).

The code to execute the checks and read config values is all contained in [RunAllChecks.ps1](https://github.com/taddison/dbachecks-wrapper/blob/master/Checks/RunChecks.ps1).

## Structure
- A root folder to contain all global settings and invocation scripts
  - Right now the only global setting is the export path
- A subfolder containing one folder per environment to check
- A pair of config files per-environment, with details about the environment as well as the specific DbcConfig settings to import
  - Multiple servers can be configured per-environment
- The intention is the checks folder is source controlled - the Results/Power BI folder would not be

## Example
- In the example we run three sets of checks against the localhost instance
  - Prod has two servers (locahost and 127.0.0.1), and dev has one server (::1)
- One environment (PROD) is set to check DAC is on, and the other (DEV) that DAC is off (one will always fail)
- Both environments run the suspect page check
- One file per-check per-environment will be produced in the specified output folder
- The PowerBI dashboard is launched - click refresh to update the results

![Dashboard](/img/DashboardExample.png)