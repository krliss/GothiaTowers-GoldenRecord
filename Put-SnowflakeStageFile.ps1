Function Put-SnowflakeStageFile {

        $snowsqlcommand = 'C:\Program Files\Snowflake SnowSQL\snowsql.exe' 
        $arguments = '-q "put file://C:\temp\goldenrecord\newdata*.csv @smprod_db.stage.goldenrecord_stage;" --option friendly=false '
        start-process $snowsqlcommand $arguments

}