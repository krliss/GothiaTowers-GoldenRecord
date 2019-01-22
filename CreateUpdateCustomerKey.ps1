Function Set-CustomerKey
{
    Param (
        [Parameter(mandatory=$true)]
        [string]$file)

    $csv = Import-Csv C:\temp\goldenrecord\$file.csv -Header T2_CustomerKey,T2_Email,T1_Email,T2_Mobile,T1_Mobile,T2_FirstName,T1_FirstName,T2_LastName,T1_LastName,T2_CustomerSourceId,T1_CustomerSourceId 
    $out = @()

    foreach($a in $csv) {
		$out += "UPDATE edw.ODS_GOLDENRECORD t1 SET CUSTOMERKEY = '"+ $a.T2_CustomerKey + "' where t1.customerkey = '<empty>' and t1.customersourceid = '" + $a.T1_CustomerSourceId + "';"
    }
    #set remaining empty customerkeys with uuid_string() 
    $out += "UPDATE edw.ODS_GOLDENRECORD t1 SET CUSTOMERKEY = uuid_string() where t1.customerkey = '<empty>';" 
 
    $out | out-file -filepath c:\temp\goldenrecord\update$file.sql -Encoding UTF8
}
#copy into @smprod_db.stage.goldenrecord_stage/data.csv from (select * from stage.VIEW_GOLDENRECORD) file_format = (compression='NONE') overwrite=true single=true;
#get @smprod_db.stage.goldenrecord_stage file://c:/temp/goldenrecord/ PATTERN = '.*data.*[.]csv';

Set-CustomerKey data

#snowsql -f c/temp/goldenrecord/updatedata.sql -o output_file=/output.csv -o quiet=true -o friendly=false -o header=false -o output_format=csv
