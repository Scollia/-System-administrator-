# VPN-���������� ��������� ����������
$strVPNName = "My_VPN"

$vpn = Get-VpnConnection -Name $strVPNName;
Write-Host $vpn.ConnectionStatus
if ($vpn.ConnectionStatus -eq "Connected") {
  rasdial $strVPNName /disconnect;
  Write-Host $strVPNName " ���������� ���������." -ForegroundColor Yellow -BackgroundColor DarkGreen
} else {
  Write-Host $strVPNName " ���������� ��� ���������." -ForegroundColor Yellow -BackgroundColor DarkGreen
}

Write-Host
Write-Host "��� ���������� ������� Enter"
$x = read-host
