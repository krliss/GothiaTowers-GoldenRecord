Function CopyInto-SnowflakeGoldenRecord {

        $sfOdbc = New-Object System.Data.Odbc.OdbcConnection
        $AZDWConStr = "DSN=Snowflake; UID=Knowit_Admin; PWD=Knowit2018%;"
        $sfOdbc.ConnectionString = $AZDWConStr
        $sfOdbc.Open()

        $copyStmt = @"
COPY INTO SMPROD_DB.STAGE.GOLDENRECORD_10 FROM '@SMPROD_DB.STAGE.GOLDENRECORD_STAGE/' 
PATTERN = '.*newdata.*[.]csv.gz' FILE_FORMAT = 'SMPROD_DB.STAGE.GOLDENRECORD' ON_ERROR = 'ABORT_STATEMENT' PURGE = FALSE;
"@
        $copyCmd = New-Object System.Data.Odbc.OdbcCommand($copyStmt,$sfOdbc)
        $loadRes = New-Object Data.DataTable
        $null = (New-Object Data.odbc.odbcDataAdapter($copyCmd)).fill($loadRes)

        $sfOdbc.Close()
}

