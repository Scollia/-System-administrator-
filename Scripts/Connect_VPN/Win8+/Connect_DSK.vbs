strUserName = InputBox("������� ��� ������������", "���� ����� ������������", strInFullUserName)
strUserPwd  = InputBox("������� ������", "���� ������ ������������", strInFullUserName)

Set objShell = CreateObject("Wscript.Shell")
objShell.Run("powershell.exe .\Connect_DSK.ps1 " & strUserName & " " & strUserPwd)
