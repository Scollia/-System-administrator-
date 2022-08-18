# VPN-���������� ��������� ����������
$strVPNName              = "My_VPN"
$strHost                 = "190.90.80.10"
$strIPSec                = "123456"
$strTunnelType           = "L2TP"
$strAuthenticationMethod = "MSChapv2"
$strEncryptionLevel      = "Maximum"
$strUserName             = $args[0]
$strUserPwd              = $args[1]

# ����� VPN-���������� ��� �������� ���������� ���������
$vpnConnections = Get-VpnConnection #-AllUserConnection
if ($vpnConnections.Name -eq $strVPNName) {
  Write-Host $strVPNName " ���������� ��� ��������� � ����� �������." -ForegroundColor Yellow -BackgroundColor DarkGreen
} else {
  try {
    # �������� VPN-���������� $strVPNName
    Write-Host "�������� VPN-����������� " $strVPNName -ForegroundColor Yellow -BackgroundColor DarkGreen
    Add-VpnConnection -Name $strVPNName -ServerAddress $strHost -TunnelType $strTunnelType -L2tpPsk $strIPSec -AuthenticationMethod $strAuthenticationMethod -EncryptionLevel $strEncryptionLevel -SplitTunneling $False -Force #-PassThru

    # ��������� ������� ��� VPN ���������� �� ������� ������� �������
    Write-Host "��������� ������� ��� VPN ���������� �� ������� ������� ������� (10.117.0.0/24)." -ForegroundColor Yellow -BackgroundColor DarkGreen
    Add-VpnConnectionRoute -ConnectionName $strVPNName -DestinationPrefix "10.117.0.0/24"

    # ��������� ������� ��� VPN ���������� �� ������� ����� ��������
    Write-Host "��������� ������� ��� VPN ���������� �� ������� ������� ������� (10.118.0.0/24)." -ForegroundColor Yellow -BackgroundColor DarkGreen
    Add-VpnConnectionRoute -ConnectionName $strVPNName -DestinationPrefix "10.118.0.0/24"

    Write-Host ""
    Write-Host "VPN-���������� " $strVPNName " ������ � �������������." -ForegroundColor Black -BackgroundColor White
  } catch {
    Write-Host "������ ��� ��������� �����������!" -ForegroundColor White -BackgroundColor Red
    Write-Host $_.Exception.Message
    throw
    Write-Host
    Write-Host "��� ���������� ������� Enter"
    $x = read-host
    exit
  }
}

$vpn = Get-VpnConnection -Name $strVPNName;
if ($vpn.ConnectionStatus -eq "Disconnected") {
  rasdial $strVPNName $strUserName $strUserPwd;
  Write-Host $strVPNName " ���������� �����������." -ForegroundColor Yellow -BackgroundColor DarkGreen
} else {
  Write-Host $strVPNName " ���������� ��� �����������." -ForegroundColor Yellow -BackgroundColor DarkGreen
}

Write-Host
Write-Host "��� ���������� ������� Enter"
$x = read-host
