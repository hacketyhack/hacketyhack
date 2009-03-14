;--------------------------------
;Definitions
!define AppName    "Hackety Hack"
!define AppVersion "0.Y"
!define AppMainEXE "hacketyhack.exe"
!define ShortName  "HacketyHack"
!define InstallKey "Software\Hackety.org\${AppName}"

;--------------------------------
;Include Modern UI

  !include "MUI.nsh"
  !include LogicLib.nsh

;--------------------------------
;General

  ;Name and file
  Name "${AppName}"
  OutFile "${ShortName}-${AppVersion}.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${AppName}"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "${InstallKey}" ""

  ;Vista redirects $SMPROGRAMS to all users without this
  RequestExecutionLevel admin

;--------------------------------
;Variables

  Var MUI_TEMP
  Var STARTMENU_FOLDER

;--------------------------------
;Interface Configuration

  !define MUI_ABORTWARNING
  !define MUI_ICON setup.ico
  !define MUI_UNICON setup.ico
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_WELCOMEFINISHPAGE_BITMAP installer-1.bmp
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_RIGHT
  !define MUI_HEADERIMAGE_BITMAP installer-2.bmp
  !define MUI_COMPONENTSPAGE_NODESC

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  Page custom HackFolderPage HackFolderHook

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "${InstallKey}" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  
  !insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER
  !insertmacro MUI_PAGE_INSTFILES

  ; Finish Page
  !define MUI_FINISHPAGE_NOREBOOTSUPPORT
  !define MUI_FINISHPAGE_TITLE_3LINES
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_FUNCTION LaunchApp
  !define MUI_FINISHPAGE_RUN_TEXT $(LAUNCH_TEXT)
  !define MUI_PAGE_CUSTOMFUNCTION_PRE preFinish
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"
  LangString LAUNCH_TEXT ${LANG_ENGLISH} "Run Hackety Hack"
  LangString TEXT_IO_TITLE ${LANG_ENGLISH} "Your Hackety Hack Settings"
  LangString TEXT_IO_SUBTITLE ${LANG_ENGLISH} "Customize the way you use Hackety Hack"

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  ReserveFile "HackFolder.ini"
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

;--------------------------------
;Installer Section
!macro MakeFileAssoc LangName LangExt
  WriteRegStr HKCR ".hack-${LangExt}" "" "${ShortName}.${LangName}Program"
  WriteRegStr HKCR "${ShortName}.${LangName}Program" "" "${AppName} ${LangName} Program"
  WriteRegStr HKCR "${ShortName}.${LangName}Program\shell\open\command" "" '"$INSTDIR\${AppMainEXE}" "%1"'
!macroend

!macro UnmakeFileAssoc LangName LangExt
  DeleteRegKey /ifempty HKCU ".hack-${LangExt}"
  DeleteRegKey /ifempty HKCU "${ShortName}.${LangName}Program"
!macroend

Section "App Section" SecApp

  SetOutPath "$INSTDIR"
  
  File /r /x components\compreg.dat /x components\xpti.dat /x installer ..\*.*
  
  ;Store installation folder
  WriteRegStr HKCU "${InstallKey}" "" $INSTDIR
  
  ;Store hacks folder
  !insertmacro MUI_INSTALLOPTIONS_READ $0 "HackFolder.ini" "Field 3" "State"
  ${If} $0 == "1"
    WriteRegStr HKCU "${InstallKey}" "HackFolder" "%DESKTOP%/Hackety Hack"
  ${Else}
    !insertmacro MUI_INSTALLOPTIONS_READ $0 "HackFolder.ini" "Field 4" "State"
    ${If} $0 == "1"
      !insertmacro MUI_INSTALLOPTIONS_READ $0 "HackFolder.ini" "Field 5" "State"
      WriteRegStr HKCU "${InstallKey}" "HackFolder" $0
    ${Else}
      WriteRegStr HKCU "${InstallKey}" "HackFolder" "%MYDOCUMENTS%/My Hacks"
    ${EndIf}
  ${EndIf}
  
  ;Make associations
  !insertmacro MakeFileAssoc "Ruby" "rb"

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    
    ;Create shortcuts
    CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Hackety Hack.lnk" "$INSTDIR\${AppMainEXE}"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Get Help.lnk" "$INSTDIR\${AppMainEXE}" "--manual"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd


Function .onInit

  ;Extract InstallOptions INI files
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "HackFolder.ini"
  
FunctionEnd

Function HackFolderPage

  !insertmacro MUI_HEADER_TEXT "$(TEXT_IO_TITLE)" "$(TEXT_IO_SUBTITLE)"
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "HackFolder.ini"

FunctionEnd

Function HackFolderHook

  !insertmacro MUI_INSTALLOPTIONS_READ $0 "HackFolder.ini" "Settings" "State"
  StrCmp $0 0 validate
  StrCmp $0 2 nofolder
  StrCmp $0 3 nofolder
  StrCmp $0 4 otherfolder ; Select your own folder
  Abort

nofolder: 
  !insertmacro MUI_INSTALLOPTIONS_READ $1 "HackFolder.ini" "Field 5" "HWND"
  EnableWindow $1 0
  !insertmacro MUI_INSTALLOPTIONS_READ $1 "HackFolder.ini" "Field 5" "HWND2"
  EnableWindow $1 0
  !insertmacro MUI_INSTALLOPTIONS_WRITE "HackFolder.ini" "Field 5" "Flags" "DISABLED"
  Abort

otherfolder:
  !insertmacro MUI_INSTALLOPTIONS_READ $1 "HackFolder.ini" "Field 5" "HWND"
  EnableWindow $1 1
  !insertmacro MUI_INSTALLOPTIONS_READ $1 "HackFolder.ini" "Field 5" "HWND2"
  EnableWindow $1 1
  !insertmacro MUI_INSTALLOPTIONS_WRITE "HackFolder.ini" "Field 5" "Flags" ""
  Abort

validate:
  !insertmacro MUI_INSTALLOPTIONS_READ $0 "HackFolder.ini" "Field 4" "State"
  ${If} $0 == "1"
    !insertmacro MUI_INSTALLOPTIONS_READ $0 "HackFolder.ini" "Field 5" "State"
    ${If} $0 == ""
      MessageBox MB_ICONEXCLAMATION|MB_OK "You must select a folder for your programs."
      Abort
    ${EndIf}
  ${EndIf}
FunctionEnd

; When we add an optional action to the finish page the cancel button is
; enabled. This disables it and leaves the finish button as the only choice.
Function preFinish
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "settings" "cancelenabled" "0"
FunctionEnd

Function LaunchApp
  ; ${CloseApp} "true" $(WARN_APP_RUNNING_INSTALL)
  Exec "$INSTDIR\${AppMainEXE}"
FunctionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecApp ${LANG_ENGLISH} "A test section."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecApp} $(DESC_SecApp)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;--------------------------------
;Uninstaller Section

Section "Uninstall"

  RMDir /r "$INSTDIR"

  !insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP
    
  Delete "$SMPROGRAMS\$MUI_TEMP\Hackety Hack.lnk"
  Delete "$SMPROGRAMS\$MUI_TEMP\Uninstall.lnk"
  
  ;Delete empty start menu parent diretories
  StrCpy $MUI_TEMP "$SMPROGRAMS\$MUI_TEMP"
 
  startMenuDeleteLoop:
  ClearErrors
    RMDir $MUI_TEMP
    GetFullPathName $MUI_TEMP "$MUI_TEMP\.."
    
    IfErrors startMenuDeleteLoopDone
  
    StrCmp $MUI_TEMP $SMPROGRAMS startMenuDeleteLoopDone startMenuDeleteLoop
  startMenuDeleteLoopDone:

  ;Unmake associations
  !insertmacro UnmakeFileAssoc "Ruby" "rb"

  DeleteRegKey /ifempty HKCU "${InstallKey}"

SectionEnd
