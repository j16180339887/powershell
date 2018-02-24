![PS](https://i.imgur.com/onDinT2.png)

Install
====
```sh
# Open cmd.exe (as administrator) to install choco command
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install this config, Open powershell (as administrator)
Set-ExecutionPolicy RemoteSigned
Invoke-WebRequest https://raw.githubusercontent.com/j16180339887/powershell/master/profile.ps1 -o ~/Documents/WindowsPowerShell/profile.ps1

# Optional packages
choco install 7zip vim-tux.portable git poshgit aria2 miniconda miniconda3 ffmpeg youtube-dl -y
```

Features
=====
* No plugins, just one file
* Fast
* Default startup directory is Desktop
* Zsh-like Tab-Completion
* Powershell ISE supported
* Runs on Powershell > 1.0
* UTF-8

The code is under Public-domain licence.

| Keys      | Action                                                | Description |
| --------- | ----------------------------------------------------- | ----------- |
| Ctrl A    | Move cursor to the beginning of the line              | Just like macOS and terminals |
| Ctrl E    | Move cursor to the end of the line                    | Just like macOS and terminals |
| Ctrl C    | Copy/Cancel command                                   | |
| Ctrl X    | Cut                                                   | |
| Ctrl V    | Paste                                                 | Escape &(ampersand) character |
| Ctrl D    | Exit                                                  | |
| Ctrl K    | Kill whole line                                       | Just like nano |
| Ctrl F    | Run current command forever                           | |
| Ctrl R    | Search the history backward                           | |
| Ctrl G    | Select all                                            | |
| Ctrl T    | New Window                                            | Open new tab in Powershell ISE |
| Ctrl Z    | Undo                                                  | |
| Ctrl Y    | Redo                                                  | |
| Ctrl S    | Search the history forward                            | |
| Ctrl W    | Close tab                                             | Powershell ISE only |
| Ctrl L    | Clear                                                 | |
| Ctrl O    | Open file explorer here                               | |
| Ctrl →    | Next word                                             | |
| Ctrl ←    | Previous word                                         | |
| Shift →   | Select one character right                            | |
| Shift ←   | Select one character left                             | |
| ↑         | Previous command in history                           | |
| ↓         | Next command in history                               | |
| Ctrl Backspace    |  Delete a word backward                       | |
| Shift+Insert      |  Paste                                        | |

## Extra commands (Most of them were added to the GUI Edit menu already)

| Command   | Action                                                    | Description |
| --------- | --------------------------------------------------------- | ----------- |
| upgradeProfile    | Upgrade [this file](https://github.com/j16180339887/powershell)   | |
| upgradeChoco      | Upgrade all installed choco packages                              | |
| upgradeModule     | Upgrade all installed Modules from Powershell Gallery             | |
| upgradeConda      | Upgrade all Anaconda/Miniconda packages                           | |
| upgradeConda2     | Upgrade all Miniconda2 packages                                   | choco install miniconda2 |
| upgradeConda3     | Upgrade all Miniconda3 packages                                   | choco install miniconda3 |
| upgradePip        | Upgrade all pip packages                                          | |
| upgradePip2       | Upgrade all pip2 packages                                         | choco install miniconda2 |
| upgradePip3       | Upgrade all pip3 packages                                         | choco install miniconda3 |
| upgradeVimrc      | Upgrade [vimrc](https://github.com/j16180339887/vimrc) file       | |
| MtuForWifiGaming  | Network MTU value for better gaming experience                    | |
| MtuForWifiNormal  | Network MTU value reset                                           | |
| Reset-Networking  | Reset all network cache                                           | Useful when internet is broken |
| python2           | C:\ProgramData\Miniconda2\python.exe                              | choco install miniconda2 |
| python3           | C:\ProgramData\Miniconda3\python.exe                              | choco install miniconda3 |
| conda2            | C:\ProgramData\Miniconda2\Scripts\conda.exe                       | choco install miniconda2 |
| conda3            | C:\ProgramData\Miniconda3\Scripts\conda.exe                       | choco install miniconda3 |
| pip2              | C:\ProgramData\Miniconda2\Scripts\pip.exe                         | choco install miniconda2 |
| pip3              | C:\ProgramData\Miniconda3\Scripts\pip.exe                         | choco install miniconda3 |


### Extra notes

* The python2 `PYTHONIOENCODING` and java `JAVA_TOOL_OPTIONS` variables were set to UTF-8
* The best font for Powershell is [Sarasa-Gothic](https://github.com/be5invis/Sarasa-Gothic/releases) (previously [Iosevka](https://github.com/be5invis/Iosevka/releases)), the developers of this font works at Microsoft

### TODO
* Compatible with upcoming Powershell 6
