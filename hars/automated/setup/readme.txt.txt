Application Purpose:
This is a super powerful shorcut tool enabling windows users just do anything by keyboard shortcut.
Just put it in your muscle memory and forget about using the mouse forever.

App Dependencies:
AutoHotKey version 1.x

How To Install:
1. type powershell at windows start.
2. Right-click on the PowerShell icon → then choose "Run as Administrator".
3. On the powershell terminal, change directory to this folder.
4. Run the ps1 file by running ".\setup_winvim.ps1".

What These Four Steps Do:
1. Put english.ahk and persian.ahk into a folder on c:\custom. These two files are responsible for every keyboard shortcut. So if you wanna customize the shortcuts, go ahead and modify these two files. The persian file is for persian-speaking users like me who use two kinds of keyboard layout for typing. You can customize the same thing for your own language.
2. Make a task schedule named "ElevatedAHK" which starts the files "english.ahk" and "persian.ahk" whenever any user logs into the system.
3. Create a shortcut on your desktop so that when the app seems buggy or after purposely terminating it (say, for the time when a normal user is using your system), you can simply click on it to restart the application__ no need to navigate to the c:\custom directory and manually run either english.ahk or persian.ahk files.
