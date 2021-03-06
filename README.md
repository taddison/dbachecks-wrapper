# dbachecks-wrapper
An example of how you might wrap [dbachecks](https://github.com/sqlcollaborative/dbachecks) and get tests you've written elsewhere (in this example [SQLChecks](https://github.com/taddison/SQLChecks)) reported on the DBAChecks dashboard.

The code to execute the checks and read config values is all contained in [RunAllChecks.ps1](https://github.com/taddison/dbachecks-wrapper/blob/master/Checks/RunChecks.ps1).

## Structure
- A root folder to contain all global settings and invocation scripts
  - Right now the global settings are the export path (for the json files used by the Power BI dashboard), and the slug to append to filenames for SQLChecks test output
- A subfolder called Environments, with one folder per environment
- Each environment folder contains a pair of config files, with details about the environment as well as the dbachecks config settings
- An optional folder SQLChecks (per-environment), which contains any SQLChecks config files - one per-instance in the environment

## The Script
- The script will execute all DBAChecks specified in the `tests.config.json` file for the environment
- The script will also execute any SQLChecks tests found, only attempting to execute tests which are present in the configuration file
- The script will output the results of each check (DBAChecks or SQLChecks) to the specified folder

## Report update
- The original dashboard can be downloaded from the [dbachecks repo](https://github.com/sqlcollaborative/dbachecks)
- The Power BI dashboard query has been updated to remove .sqlchecks and anything that follows in the filename of all imported files - this works around the limitation that SQLChecks tests don't have a native concept of environment.  This change means the first 3 lines of the report query look like this:

```
let
    Source = Folder.Files(#"Path to Data"),
    #"Filtered For Json Files" = Table.SelectRows(Source, each Text.EndsWith([Name], ".json")),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Filtered For Json Files", "Name", Splitter.SplitTextByEachDelimiter({".sqlchecks"}, QuoteStyle.Csv, true), {"Name", "Name.Extension"}),
```

![Dashboard](/img/DashboardExample.png)