Function CreateReplace-SnowflakeTable {

        $sfOdbc = New-Object System.Data.Odbc.OdbcConnection
        $AZDWConStr = "DSN=Snowflake; UID=Knowit_Admin; PWD=Knowit2018%;"
        $sfOdbc.ConnectionString = $AZDWConStr
        $sfOdbc.Open()

        $remSQL = "create or replace table stage.GoldenRecord_10 ( customerKey varchar(36), CustomerSourceId varchar(36), Email varchar(100), Mobile varchar(36), FirstName varchar(36), LastName varchar(36) );"
        $null = (New-Object System.Data.Odbc.OdbcCommand($remSQL,$sfOdbc)).ExecuteNonQuery()

        $sfOdbc.Close()
}