'�������� ��������� ������
On Error Resume Next

' ���������� ��� ������ � SID-���, ������������ �������
DataSubDir    = "UserSID"
' ������������� ����/�����
IsInteractive = "true"

'====================================================================
Function get_SID(strUsername, strInUserDomain)
  On Error Resume Next
  ' ��������� ������ �������� �������� ������������
  Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

  Err.Clear
  Set objAccount = objWMIService.Get("Win32_UserAccount.Name='" & strUsername & "',Domain='" & strInUserDomain & "'")

  If Err.Number <> 0 Then
    if IsInteractive = "true" then 
      MsgBox("������������ �� ������")
    end if
    WScript.Quit 2
  end if

  ' ���������� SID �������� ������������
  get_SID = objAccount.SID
End Function
'====================================================================
Sub Create_Dir(strDataDir)
  Set objFSO          = CreateObject("Scripting.FileSystemObject")
  Set vScriptFullName = objFSO.GetFile(Wscript.ScriptFullName)

  if not objFSO.FolderExists(strDataDir) then
    ind_razd = InStrRev(strDataDir, "\", len(strDataDir), vbTextCompare)
    if not ind_razd = 0 then
      call Create_Dir(Left(strDataDir, ind_razd - 1))
    end if
    objFSO.CreateFolder(strDataDir)
  end if
end Sub
'====================================================================
Sub Save_SID(getSID, strUsername, strDataDir)
  Set objFSO          = CreateObject("Scripting.FileSystemObject")
  Set vScriptFullName = objFSO.GetFile(Wscript.ScriptFullName)

  call Create_Dir(strDataDir)

  if IsInteractive = "true" then 
    MsgBox("SID ������������ "  + strUsername + " �������� � ����:" + vbCrLf + strDataDir + "\" + strUsername + "_SID.txt")
  end if

  Set objFile = objFSO.OpenTextFile(strDataDir + "\" + strUsername + "_SID.txt", 2, true, -1)
  objFile.WriteLine(getSID)
  objFile.Close
End Sub
'====================================================================

Set objNetwork = CreateObject("Wscript.Network")

' ��� ������������ � �������� ������������ ���
' ������������� � ��� �������� ������������
strInUsername   = objNetwork.UserName
' ��� ������ ������������
' ������������ � ��� ������ �������� ������������
strInUserDomain = objNetwork.UserDomain

' ���������� ������ ��� ������������, ������� �����, ���� ��������� � ������
if strInUserDomain = "" then
  strInFullUserName = strInUsername
else
  strInFullUserName = strInUserDomain + "\" + strInUsername
end if

' ������� ������ �� ���� ����� ������������
if IsInteractive = "true" then 
  strInFullUserName   = InputBox("������� ��� ������������, ��� SID �������� ����������", "���� ����� ������������", strInFullUserName)
end if 

' ��������� ������������ � ����� ������������ ��� ������
ind_razd = InStr(1, strInFullUserName, "\", vbTextCompare)
' � ����������� �� ���������� ������������� ������� ��� ������������ � �����
if not ind_razd = 0 then
  strUsername     = Right(strInFullUserName, len(strInFullUserName) - ind_razd)
  strInUserDomain = Left(strInFullUserName, ind_razd - 1)
else
  strUsername     = strInFullUserName
  strInUserDomain = objNetwork.ComputerName
end if

if strUsername = "" then
  if IsInteractive = "true" then 
    MsgBox("����������� ��� ������������")
  end if
  WScript.Quit 1
end if


getSID = get_SID(strUsername, strInUserDomain)
if IsInteractive = "true" then 
  MsgBox(getSID)
end if
call Save_SID(getSID, strUsername, DataSubDir + "\" + strInUserDomain)

WScript.Quit 0