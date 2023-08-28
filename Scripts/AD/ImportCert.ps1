<#
PowerShell ����� �������� ������ � ���������� ���������� Windows � ������� PSDrive-������� "Cert:\"

My			������
Root			���������� �������� ������ ������������
Trust			���������� ��������� � �����������
CA			������������� ������ ������������
UserDS			������ ������������ Active Directory
TrustedPublisher	���������� ��������
AuthRoot                Third-Party Root Certification Authorities
TrustedPeople           ���������� ����
ClientAuthIssuer	���������� ������������ �������� ����������� ��������
addressbook		������ ������������
REQUEST                 ������� ������ �� ����������
SmartCardRoot
Disallowed
ACRS

Local NonRemovable Certificates
Remote Desktop 		Remote Desktop
#>

Get-ChildItem -Path \\corp.dskvrn.ru\sharedpo\Certificates | Foreach-Object {
  $logicalstorage = $_.Name
  Get-ChildItem -Path \\corp.dskvrn.ru\sharedpo\Certificates\$logicalstorage\*.cer | Foreach-Object {
    Import-Certificate -FilePath $_.FullName -CertStoreLocation Cert:\CurrentUser\$logicalstorage
  }
}

# $pfxPassword = "ComplexPassword!" | ConvertTo-SecureString -AsPlainText -Force
# Import-PfxCertificate -Exportable -Password $pfxPassword -CertStoreLocation 'Cert:\CurrentUser\My' -FilePath $env:USERPROFILE\Desktop\certificate.pfx