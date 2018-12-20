Function Remove-SnowflakeStageFile {

        $snowsqlcommand = 'C:\Program Files\Snowflake SnowSQL\snowsql.exe' 
        $arguments = '-q "remove @smprod_db.stage.goldenrecord_stage PATTERN = ''.*newdata.*[.]csv.gz'';" --option friendly=false '
        start-process $snowsqlcommand $arguments


}

#Remove-SnowflakeStageFile