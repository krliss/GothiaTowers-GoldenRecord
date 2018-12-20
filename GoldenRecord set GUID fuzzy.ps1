Import-module $PSScriptRoot\Get-JaroWinklerDistance.ps1 
Import-module $PSScriptRoot\CopyInto-SnowflakeStage.ps1
Import-module $PSScriptRoot\Get-SnowflakeStageFile.ps1
Import-module $PSScriptRoot\Remove-SnowflakeStageFile.ps1
Import-module $PSScriptRoot\Put-SnowflakeStageFile.ps1
Import-module $PSScriptRoot\CreateReplace-SnowflakeTable.ps1
Import-module $PSScriptRoot\CopyInto-SnowflakeGoldenRecord.ps1
#------------------------------------------------------------------------------------------------
#copy into @smprod_db.stage.goldenrecord_stage from (select distinct '<empty>', trim(g.customersourceid, '"'), g.email, g.mobile, g.FirstName, g.LastName, g.Date
#from smprod_db.stage.STAGE_CUSTOMERS g where trim(email, ' ') <> '' order by email, firstname, lastname) file_format=(skip_header=1 null_if=('') field_optionally_enclosed_by='"') overwrite=true;
#------------------------------------------------------------------------------------------------
#get @smprod_db.stage.goldenrecord_stage file://c:/temp/goldenrecord/ PATTERN = '.*data.*[.]csv.gz';
#------------------------------------------------------------------------------------------------
#remove @smprod_db.stage.goldenrecord_stage PATTERN = '.*newdata.*[.]csv.gz';
#put file://C:\temp\goldenrecord\newdata*.csv @smprod_db.stage.#goldenrecord_stage;
#------------------------------------------------------------------------------------------------
#create or replace table stage.GoldenRecord_10 ( customerKey varchar(36), CustomerSourceId varchar(36), Email varchar(100), Mobile varchar(36), FirstName varchar(36), LastName varchar(36), Date timestamp );
#------------------------------------------------------------------------------------------------
#COPY INTO "SMPROD_DB"."STAGE"."GOLDENRECORD_10" FROM '@"SMPROD_DB"."STAGE"."GOLDENRECORD_STAGE"/' 
#PATTERN = '.*newdata.*[.]csv.gz' FILE_FORMAT = '"SMPROD_DB"."STAGE"."GOLDENRECORD"' ON_ERROR = 'ABORT_STATEMENT' PURGE = FALSE;

Function Set-CustomerKey
{
    Param (
        [Parameter(mandatory=$true)]
        [string]$file)

    $csv = Import-Csv C:\temp\goldenrecord\$file.csv -Header CustomerKey,CustomerSourceId,Email,Mobile,FirstName,LastName,Date 
    $out = @()

    foreach($a in $csv) {
        $guid = [guid]::NewGuid()
        $jwValue1 = Get-JaroWinklerDistance $a.FirstName $out[-1].FirstName -Jaro
        $jwValue2 = Get-JaroWinklerDistance $a.LastName $out[-1].LastName -Jaro
        if($a.Email -eq $out[-1].Email -And $jwValue1 -gt 0.92 -And $jwValue2 -gt 0.92 -And $a.Email -ne "") {

            if($out[-2].CustomerKey -eq $out[-1].CustomerKey -And $out[-1].CustomerKey -ne "<empty>") {
                $guid = $out[-1].CustomerKey
            }
            $out[-1].CustomerKey = $guid
            $a.CustomerKey = $out[-1].CustomerKey 
        }
        if($a.Mobile -eq $out[-1].Mobile -And $a.Mobile -ne "" -And $a.Mobile.ToUpper() -ne "N/A") { 
            ##previous key empty with same mobile number
            if($a.CustomerKey -ne $out[-1].CustomerKey -AND $out[-1].CustomerKey -replace '"', '' -eq "<empty>") {
                $out[-1].CustomerKey = $a.CustomerKey
            }
            ##the current key empty with same mobile number
            if($a.CustomerKey -ne $out[-1].CustomerKey -AND $a.CustomerKey -replace '"', ''  -eq "<empty>") {
                $a.CustomerKey = $out[-1].CustomerKey
            }
            ##both keys empty with same mobile number
            if($a.CustomerKey -eq $out[-1].CustomerKey -AND $a.CustomerKey -replace '"', ''-eq "<empty>") {
                $a.CustomerKey = $guid
                $out[-1].CustomerKey = $guid
            }
        } else {
            ##empty key with previous line not with the same mobile number
            if($a.CustomerKey -replace '"','' -eq "<empty>") {
                $a.CustomerKey = $guid
            }
        }
		$out += $a
    }

    $out | export-csv -Path c:\temp\goldenrecord\new$file.csv -NoTypeInformation -Encoding UTF8
}
#define as a function, with the file name as input parameter
CopyInto-SnowflakeStage
Get-SnowflakeStageFile 
Set-CustomerKey data_0_0_0
Set-CustomerKey data_0_1_0
Set-CustomerKey data_0_2_0
Set-CustomerKey data_0_3_0
Set-CustomerKey data_0_4_0
Set-CustomerKey data_0_5_0
Set-CustomerKey data_0_6_0
Set-CustomerKey data_0_7_0
Remove-SnowflakeStageFile
Put-SnowflakeStageFile
CreateReplace-SnowflakeTable
CopyInto-SnowflakeGoldenRecord
