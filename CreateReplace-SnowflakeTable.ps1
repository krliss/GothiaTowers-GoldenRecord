Function CreateReplace-SnowflakeTable {

        $sfOdbc = New-Object System.Data.Odbc.OdbcConnection
        $AZDWConStr = "DSN=Snowflake; UID=Knowit_Admin; PWD=Knowit2018%;"
        $sfOdbc.ConnectionString = $AZDWConStr
        $sfOdbc.Open()

        $remSQL = "create or replace table stage.GoldenRecord181221 ( customerKey varchar(36), CustomerSourceId varchar(36), Email varchar(255), Mobile varchar(255), FirstName varchar(255), LastName varchar(255), Date_column varchar(36) );"
        $null = (New-Object System.Data.Odbc.OdbcCommand($remSQL,$sfOdbc)).ExecuteNonQuery()

        $sfOdbc.Close()
}