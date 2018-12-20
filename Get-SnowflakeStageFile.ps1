Function Get-SnowflakeStageFile {

        #PATTERN='.*data.*[.]csv.gz'
        
        $snowsqlcommand = 'C:\Program Files\Snowflake SnowSQL\snowsql.exe' 
        $arguments = '-q "get @smprod_db.stage.goldenrecord_stage file://c:/temp/goldenrecord/ PATTERN=''.*data.*[.]csv.gz'';" --option friendly=false '
        start-process $snowsqlcommand $arguments -Wait
        ExtractFiles

}

Function ExtractFiles {
        ## Extract files
        $argumentlist="e c:\temp\goldenrecord\data*.gz -oc:\temp\goldenrecord -y"
        ## Execute command
        start-process 'C:\Program Files\7-Zip\7z.exe' -argumentlist $argumentlist 

}

#Get-SnowflakeStageFile 
