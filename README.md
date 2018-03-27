# dbachecks-wrapper
An example of how you might wrap [dbachecks](https://github.com/sqlcollaborative/dbachecks) and get tests you've written elsewhere (in this example [SQLChecks](https://github.com/taddison/SQLChecks)) reported on the DBAChecks dashboard.

The code to execute the checks and read config values is all contained in [RunAllChecks.ps1](https://github.com/taddison/dbachecks-wrapper/blob/master/Checks/RunChecks.ps1).

## Structure
- A root folder to contain all global settings and invocation scripts
  - Right now the global settings are the export path (for the json files used by the Power BI dashboard), and the path to SQLChecks
- A subfolder called Environments, with one folder per environment
- Each environment folder contains a pair of config files, with details about the environment as well as the dbachecks config settings
- An optional folder SQLChecks (per-environment), which contains any SQLChecks config files - one per-instance in the environment

## The Script
- The script will execute all DBAChecks specified in the tests.config.json file for the environment
- The script will also execute any SQLChecks tests found, only attempting to execute tests which are present in the configuration file

## TODO
- The SQLChecks tests are currently exported as ENVIRONMENT-SERVER, and need to be merged into a single results file
- SQLChecks doesn't currently have any tags and so no tests ever run (without hacking the repo)
- SQLChecks doesn't use Describe blocks in the way DBAChecks expects, and they need to be refactored to have the last word be the ServerInstance

![Dashboard](/img/DashboardExample.png)