Function CopyInto-SnowflakeStage {

        $sfOdbc = New-Object System.Data.Odbc.OdbcConnection
        $AZDWConStr = "DSN=Snowflake; UID=Knowit_Admin; PWD=Knowit2018%;"
        $sfOdbc.ConnectionString = $AZDWConStr
        $sfOdbc.Open()

        $copyStmt = @"
copy into @smprod_db.stage.goldenrecord_stage from (select distinct '<empty>', trim(g.customersourceid, '"'), g.email, g.mobile, g.FirstName, g.LastName
from smprod_db.stage.STAGE_CUSTOMERS g where trim(email, ' ') <> '' order by email) file_format=(skip_header=1 null_if=('') field_optionally_enclosed_by='"') overwrite=true;
"@
        $copyCmd = New-Object System.Data.Odbc.OdbcCommand($copyStmt,$sfOdbc)
        $loadRes = New-Object Data.DataTable
        $null = (New-Object Data.odbc.odbcDataAdapter($copyCmd)).fill($loadRes)

        $sfOdbc.Close()
}



#CopyInto-SnowflakeStage