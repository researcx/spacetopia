Import-Module BitsTransfer
while(1){
Get-BitsTransfer | Remove-BitsTransfer
$cs = Invoke-WebRequest -URI https://spacetopia.pw/modules/ss13.php?clothing_list
ConvertFrom-Csv $cs | Start-BitsTransfer -Asynchronous
Get-BitsTransfer | Complete-BitsTransfer
sleep 5
}