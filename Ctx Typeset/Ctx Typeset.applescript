# Script name: Ctx Typeset Tool
# What it does: Launches ConTeXt typesetting and provides a GUI for various ConTeXt tools.
# Web page: <http://dflect.net/context-typeset-tool/>
# Author: Thomas Floeren <ecdltf@mac.com>
# Version / date: 1.2.5 (64) / 2016-03-22
# 
# Copyright © 2013-2016 Thomas Floeren
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.





#############################################
### SETTINGS 
#############################################

# Please note: If you want to change a setting here that is also present in the Options Window, don’t forget to comment/delete the corresponding line in the Options List section ("mainList") below. Otherwise it will get overridden by the Options Window setting. (E.g. run mode, terminal behavior.)


## "SETUPTEX" PATHS FOR CTX BETA AND CURRENT 

# If you change/recompile the script often (but why should you do this? ;)
# you can set here the paths to the "setuptex" files of your 
# ConTeXt Beta and ConTeXt Current directories, so the search
# dialog won't pop up after each recompilation:

# Note: Normally it’s not necessary to set the paths here!

property ctxBeta : "/Users/XXX/ConTeXt/beta/tex/setuptex" -- ConTeXt Beta
property ctxCurrent : "/Users/XXX/ConTeXt/current/tex/setuptex" -- ConTeXt Current

# If you have only one ConTeXt directory set both to the same value

property myCtx : ctxBeta

# The script will use the first one by default
# (This can also be changed in the options screen.)

----------------------------------------------------------------------------------

## LUAJITTEX / LUATEX

# The engine to use (default: LuaTeX)

property useJit : false

----------------------------------------------------------------------------------

## LAUNCH DELAY

# If you are launching the script in a way that doesn’t allow the use of certain 
# modifier keys – e.g. launching it from the Script menu in the menu bar 
# doesn’t work with the option or shift key – you can set a longer delay 
# that allows you to press a modifier key comfortably after script launch, e.g. 1 or 1.5 sec.

delay 0.6

# Currently I've set a short delay even for the synchronous use of hotkey and modifier keys, 
# because sometimes I noticed problems wit the proper recognition of modifier keys. (Experimental.)

----------------------------------------------------------------------------------

## PRODUCT MODE

# Set this to "true" if you want to typeset always the file you have locked on 
# **Can be toggled by holding down the *opt key* at script launch. **
# Not necessary to set this here

property prMode : false

----------------------------------------------------------------------------------

## PREFERRED PDF VIEWER TO AUTO-LAUNCH

--property pdfViewer : "net.sourceforge.skim-app.skim"
property pdfViewer : "com.apple.Preview"
--property pdfViewer : "com.adobe.Acrobat.Pro"
--property pdfViewer : "com.Adobe.Reader"
--property pdfViewer : "com.smileonmymac.PDFpenPro"

# To disable auto-launching of PDF viewer set this to "false":
property pdfViewerLaunch : true

----------------------------------------------------------------------------------

## RUN MODE

# Choose if you want to run the typesetting command in the standard shell (sh)
# or in the terminal. Running it in the shell won’t show you any progress indication
# but you will be notified upon completion and the log file will be opened
# if an error occurs. Set terminalMode to false if your terminal shell is not
# compatible with this script.

property terminalMode : false

# You need to change this only if you don’t use the modifier keys
# **To swap the modes hold down the *Shift key* at script launch. **

----------------------------------------------------------------------------------

## ERROR LOG VIEWER

# Only applies if Run Mode is *not* set to Terminal

# Choose log viewer (the log will only be shown in case of errors)

# Log viewer if typesetting a document from the editor
--property logViewerNormal : "Current Editor" -- Adaptive: Log opens in your active text editor (the one with the .tex document)
property logViewerNormal : "Console" -- The standard system log viewer
--property logViewerNormal : "TextWrangler" -- Example

# Log viewer if typesetting the Finder selection
property logViewerFinder : "Console" -- The standard system log viewer
--property logViewerFinder : "Terminal" -- Example

----------------------------------------------------------------------------------

## AUTOMATIC SYNTAX CHECK

# Only applies if Run Mode is *not* set to Terminal

# The script calls automatically ConTeXt’s syntax check 
# if a typesetting error occurs. The output will be appended to the log file.
# (this is good for example for detecting missing "}".)

# Set this to "false" if you don’t want it.
property autoSyntaxCheck : true

# Set your preferred syntax check command
property checkCmd : "mtxrun --script check" -- newer lua script (mtx-check)
--property checkCmd : "mtxrun --script concheck" -- the older ruby script

# The checkCmd also applies to manual syntax check

----------------------------------------------------------------------------------

## TERMINAL BEHAVIOR

# Only applies if Run Mode is set to Terminal

# Set this to "false" if you want to launch a new terminal window for each typesetting process
# (Otherwise the frontmost open terminal window will be reused for typesetting;
# terminal windows that are busy with other processes won’t be touched in either case.)

property terminalWinRecycle : true

----------------------------------------------------------------------------------

## TERMINAL WINDOW BEHAVIOR

# Only applies if Run Mode is set to Terminal

# Set this to "true" if you want the typesetting terminal window to come to foreground.
# Not strictly necessary because you will be notified when typesetting has finished;
# but probably better if typesetting a nasty document to see immediatly the failure.

property terminalWinForeground : true

----------------------------------------------------------------------------------

## NOTIFICATIONS ON/OFF

# Set this to "false" if … 
# – OS < 10.8
# – The helper app (terminal-notifier) doesn’t work on your system for any reason

property enableNotifications : true

----------------------------------------------------------------------------------

## COMPLETION SOUND

# The sound to play after successful typesetting

--property finishSound : "/System/Library/Sounds/Glass.aiff"
property finishSound : "/System/Library/Sounds/Submarine.aiff"
--property finishSound : "/System/Library/Sounds/Blow.aiff"

# To disable completion sound set this to "false":
property enableSound : true

----------------------------------------------------------------------------------

## EXCLUDE GENERATED PDF FROM TIME MACHINE BACKUP

property enableTMexclude : true

# Writes the extebded attribute "com.apple.metadata:com_apple_backup_excludeItem com.apple.backupd"
# to the generated PDF file. Since the generated PDF is reproducible, often very large and changes
# frequently when you are still working on your source files this is set to true by default.

# It can be toggled in the main options window.

----------------------------------------------------------------------------------

## TOOLS: UPDATE CONTEXT

# Before updating the installed ConTeXt the script will backup your previous, supposedly working, ConTeXt.

# You can set here a default directory where it should save the backup to:

--property backupDir : POSIX path of (path to home folder) & "Desktop" -- Current user’s Desktop
--property backupDir : POSIX path of (path to home folder) & "my backup folder/context backups" -- Example: arbitrary folder in current user’s home directory
--property backupDir : "/Users/Shared" -- Example
property backupDir : ""

# Set this to "true" if you want to backup to the same directory where your ConTeXt lives:
property backUpToSameLocation : false

# Set here the compression level for the archive of your previous ConTeXt

# Level 0: No compression (tar archive), approx. 240MB
# Level 1: gzipped archive (tar.gz), approx. 104MB
# Level 2: lzma compressed archive (tar.xz), approx. 68MB

# All methods are entirely Mac metadata safe (tags, comments, other xattr)

# 0 will be very fast: chosse this if you are going to delete the backup anyway
# or if you want to compress several archives together afterwards

# 1 is quite fast: should be OK as compromise for most purposes 

# 2 is a bit slower but compresses well: if you guard more than a couple of old versions
# or if you don’t have disk space to waste (I added this because I prefer this format 
# personally for longer-time archiving). Compression is multithreaded and takes 
# about 20s on my Mac Mini.

property bakComprLevel : 2

----------------------------------------------------------------------------------

# End of Settings 
#############################################


------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Other variables & properties
------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Bundled files

property asocRunner : ""
--set asocRunner to (path to resource "bin/ASObjC Runner-N.app") as text
set asocRunner to ("/Users/tom/Documents/Scripts/AppleScript/Ctx Typeset/Ctx Typeset/Ctx Typeset - Sierra.scptd/Contents/Resources/bin/ASObjC Runner-N.app") as text
property terminalNotifier : ""
--set terminalNotifier to (quoted form of POSIX path of (path to resource "bin/terminal-notifier.app/Contents/MacOS/terminal-notifier")) as text
set terminalNotifier to (quoted form of POSIX path of ("/Users/tom/Documents/Scripts/AppleScript/Ctx Typeset/Ctx Typeset/Ctx Typeset - Sierra.scptd/Contents/Resources/bin/terminal-notifier.app")) as text
property p7z : ""
--set p7z to (quoted form of POSIX path of (path to resource "bin/7zr")) as text
set p7z to (quoted form of POSIX path of ("/Users/tom/Documents/Scripts/AppleScript/Ctx Typeset/Ctx Typeset/Ctx Typeset - Sierra.scptd/Contents/Resources/bin/7zr")) as text
property descrFile : ""
--set descrFile to (path to resource "Manual/Manual.html") as text
set descrFile to ("/Users/tom/Documents/Scripts/AppleScript/Ctx Typeset/Ctx Typeset/Ctx Typeset - Sierra.scptd/Contents/Resources/Manual/Manual.html") as text

-- Misc

global fileName, fileNameHead, fileNameTail, fileNameRoot, parentFolder, isFromFinder, isFromBBEdit, targetApp, currentEditorFile, showList, dirNameCtx, bakName, ctxVersiondate, makeNewBak, MVnotifications, MLnotifications, cSourceCtx, tsModeSwap, previousApp
set currentEditorFile to ""
set fileName to "" -- if not reset previous fileName will be processed even in case of error
set isFromFinder to false
set isFromBBEdit to false
set runModeSwap to false
set tsModeSwap to false
set pdfViewerLaunchSwap to false
set soundNumber to random number from 1 to 12

property currentFinderFile : ""
property prFile : ""
property prFileFolder : ""
property prFileNameTail : ""
property prevPrFile : ""
property prevPrFileNameTail : ""
property finderSel : ""
property runCount : 0
property notSuitable : "[→ No suitable path here. Let me search myself… →]"

-- Get frontmost app at script launch time
tell application "System Events" to set previousApp to name of first process where frontmost is true

-- Settings list 

set showList to false
property mainList : ""
property pdfViewerList : ""
property toolsList : ""
set toolsList to ""

property lCtx : "▷	Use ConTeXt Current (Instead of  Beta)"
property lJit : "▷	Use LuaJitTeX (Instead of LuaTeX)"
property lprMode : "▷	Product Mode  ⌥"
property lRegPrFile : "	▶▶	Register as New Product File  ⌃⌥"
property lUnregPrFile : ""
property lReregPrFile : ""
property lTerminal : "▷	Run Typesetting in Terminal  ⌥⇧"
property lTerminalNew : " 	▷	New Terminal Window for Each Run"
property lPdfViewerAuto : "▷	Do not Auto-launch PDF Viewer  ⇧"
property lPdfViewerChange : "	▶	Set PDF Viewer →"
property lTerminalBack : "▷	Keep Terminal Windows in Background"
property lLogViewer : "▷	View Error Logs in Current Text Editor"
property lAutoSynCheck : "▷	Automatic Syntax Check on Error Off"
property lNotifications : "▷	Notifications Off"
property lSound : "▷	Completion Sound Off"
property lTM : "▷	Don’t Exclude Generated PDF from Backup"
property lSynctex : "▷	Enforce SyncTeX"
property lTools : "Tools →"
property lHelp : "Help"

property pdfViewerInventory : {{"Skim", "net.sourceforge.skim-app.skim"}, {"Preview", "com.apple.Preview"}, {"Adobe Acrobat Pro", "com.adobe.Acrobat.Pro"}, {"Adobe Reader", "com.Adobe.Reader"}, {"PDFpenPro", "com.smileonmymac.PDFpenPro"}}


-- Tools list

property lVersionInfo : "◼	ConTeXt Version Info"
property lUpdBeta : "▶	Update ConTeXt Beta (Mk IV)"
property lUpdCurrent : "▶	Update ConTeXt Current (Mk IV)"
property lSelectNewCtx : "▶	Reassign ConTeXt Installations (Beta/Current Slots)"
property lMakeFormatsBeta : "◼	Make Formats for ConTeXt Beta (Mk IV)"
property lMakeFormatsCurrent : "◼	Make Formats for ConTeXt Current (Mk IV)"
property lListFontsAll : "◼	List All Available Fonts"
property lManualSynCheck : "◼◼	Syntax Check"
property lPurge : "◼◼	Purge (Ctx Script)"
property lPurgeall : "◼◼	Purge All (Ctx Script)"
property lTrashPdf : "◼◼	Trash Generated PDF Files"


-- Bash related

property cPurgeNormal : "mtxrun texutil --purgefiles"
property cPurgeAll : "mtxrun texutil --purgeallfiles"
property cVersionCtx : "context --version  | awk 'match($0, /current version:/) { print \"ConTeXt: \" substr($0, RSTART+17) }'"
property cVersionLua : "luatex --version | awk 'match($0, /, Version/) {print \"LuaTeX:   \" substr($0, RSTART+10) }'"
property cVersionCtxDate : "context --version  | awk 'match($0, /current version:/) { i = substr($0, RSTART+17) ; gsub(/\\.|:/, \"\", i) ; sub(/ /, \"T\", i) ; print i}'"
property xattrTMExclusion : "com.apple.metadata:com_apple_backup_excludeItem com.apple.backupd"

--property cSourceCtx : "source " & quoted form of myCtx
set cSourceCtx to "source " & quoted form of myCtx
property cCtxFormat : "mtxrun --selfupdate ; mtxrun --generate ; context --make cont-en"
property cListFontsAll : "mtxrun --script fonts --list --all"
property cFirstsetupUpdate : "rsync -ptv rsync://contextgarden.net/minimals/setup/first-setup.sh ."

-- Notifications type

if enableNotifications then
	tell application "Finder" to set sysVs to version
	if sysVs begins with "10.11" or sysVs begins with "10.10" or sysVs begins with "10.9" then
		set {MVnotifications, MLnotifications} to {true, false}
	else if sysVs begins with "10.8" then --10.8
		set {MVnotifications, MLnotifications} to {false, true}
	else
		set {MVnotifications, MLnotifications} to {false, false}
	end if
else
	set {MVnotifications, MLnotifications} to {false, false}
end if


using terms from application "ASObjC Runner-N"
	
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
	-- Script
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
	
	testPaths()
	
	------------------------------------------------------------------------------
	-- Modifier keys
	------------------------------------------------------------------------------
	
	tell application asocRunner
		if (option key down of modifier keys) and (control key down of modifier keys) then -- Lock on product file
			regPrFile() of me
			return
		else if (shift key down of modifier keys) and (option key down of modifier keys) then -- Swap run mode (Terminal vs shell)
			
			--if not terminalMode then -- Permanent swapping …
			--	set terminalMode to true
			--else
			--	set terminalMode to false
			
			set runModeSwap to true -- … or non-permanent swapping(?)
		else if (shift key down of modifier keys) then -- Swap auto-launching of pdf viewer
			set pdfViewerLaunchSwap to true
		else if (option key down of modifier keys) then -- Swap Product mode (force Finder selection to be typeset)
			
			--if not finderOnly then -- Permanent swapping …
			--	set finderOnly to true
			--else
			--	set finderOnly to false
			
			set tsModeSwap to true -- … or non-permanent swapping(?)
		else if (control key down of modifier keys) then
			set showList to true
		end if
	end tell
	
	
	------------------------------------------------------------------------------
	-- Settings list
	------------------------------------------------------------------------------
	
	if showList then
		
		set showPrFile to ""
		set showPrevPrFile to ""
		
		if prFile is "" then
			set showPrFile to " (n/a)"
		else
			set showPrFile to " (" & quoted form of prFileNameTail & ")"
		end if
		
		if prevPrFile is "" or prevPrFile is prFile then
			set showPrevPrFile to " (n/a)"
		else
			set showPrevPrFile to " (" & quoted form of prevPrFileNameTail & ")"
			
		end if
		set lUnregPrFile to " 	▶	Unregister Product File" & showPrFile
		set lReregPrFile to " 	▶	Re-Register Previous Product File" & showPrevPrFile
		
		tell application "System Events"
			activate
			set mainList to choose from list {¬
				lCtx, ¬
				lJit, ¬
				lprMode, ¬
				lRegPrFile, ¬
				lUnregPrFile, ¬
				lReregPrFile, ¬
				lTerminal, ¬
				lTerminalNew, ¬
				lPdfViewerAuto, ¬
				lPdfViewerChange, ¬
				lSynctex, ¬
				lTerminalBack, ¬
				lTM, ¬
				lLogViewer, ¬
				lAutoSynCheck, ¬
				lNotifications, ¬
				lSound, ¬
				lTools, ¬
				lHelp} ¬
				with title "Options" with prompt "Hold cmd key ⌘ down to select/deselect multiple entries." OK button name "OK" cancel button name "Cancel" default items mainList multiple selections allowed yes empty selection allowed yes
			
			--if the button returned of mainList is "Cancel" then error number -128
			
			if mainList contains lCtx then
				set myCtx to ctxCurrent
			else
				set myCtx to ctxBeta
			end if
			if mainList contains lJit then
				set useJit to true
			else
				set useJit to false
			end if
			if mainList contains lprMode then
				set prMode to true
			else
				set prMode to false
			end if
			if mainList contains lRegPrFile then
				regPrFile() of me
			else if mainList contains lUnregPrFile then
				unregPrFile() of me
			else if mainList contains lReregPrFile then
				reregPrFile() of me
			end if
			if mainList contains lTerminal then
				set terminalMode to true
			else
				set terminalMode to false
			end if
			if mainList contains lTerminalBack then
				set terminalWinForeground to false
			else
				set terminalWinForeground to true
			end if
			if mainList contains lTerminalNew then
				set terminalWinRecycle to false
			else
				set terminalWinRecycle to true
			end if
			if mainList contains lPdfViewerAuto then
				set pdfViewerLaunch to false
			else
				set pdfViewerLaunch to true
			end if
			if mainList contains lSynctex then
				set syncTex to true
			else
				set syncTex to false
			end if
			if mainList contains lLogViewer then
				set logViewerNormal to targetApp
			else
				set logViewerNormal to "Console"
			end if
			if mainList contains lAutoSynCheck then
				set autoSyntaxCheck to false
			else
				set autoSyntaxCheck to true
			end if
			if mainList contains lNotifications then
				set enableNotifications to false
			else
				set enableNotifications to true
			end if
			if mainList contains lSound then
				set enableSound to false
			else
				set enableSound to true
			end if
			if mainList contains lTM then
				set enableTMexclude to false
			else
				set enableTMexclude to true
			end if
			if mainList contains lHelp then openDescription() of me
			
			if mainList contains lPdfViewerChange then
				set pdfViewerList to choose from list {¬
					"Preview", ¬
					"Skim", ¬
					"Adobe Acrobat Pro", ¬
					"Adobe Reader", ¬
					"PDFpenPro"} ¬
					with title "Choose PDF Viewer" OK button name "OK" cancel button name "Cancel" default items pdfViewerList multiple selections allowed no empty selection allowed no
				my setPdfViewer()
			end if
			
			if mainList contains lTools then
				set toolsList to choose from list {¬
					lPurge, ¬
					lPurgeall, ¬
					lTrashPdf, ¬
					lManualSynCheck, ¬
					lVersionInfo, ¬
					lUpdBeta, ¬
					lUpdCurrent, ¬
					lSelectNewCtx, ¬
					lListFontsAll, ¬
					lMakeFormatsBeta, ¬
					lMakeFormatsCurrent, ¬
					lHelp} ¬
					with title "Tools" OK button name "OK" cancel button name "Cancel" default items "" multiple selections allowed yes empty selection allowed no
				if toolsList contains lVersionInfo then
					my getVersionInfo()
				else if toolsList contains lManualSynCheck then
					my synCheck()
				else if toolsList contains lUpdBeta then
					my updCtx(ctxBeta)
				else if toolsList contains lUpdCurrent then
					my updCtx(ctxCurrent)
				else if toolsList contains lSelectNewCtx then
					my reselectCtx()
				else if toolsList contains lMakeFormatsBeta then
					my makeFormatsBeta()
				else if toolsList contains lMakeFormatsCurrent then
					my makeFormatsCurrent()
				else if toolsList contains lListFontsAll then
					my listFontsAll()
				else if toolsList contains lPurge and toolsList contains lTrashPdf then
					my trashPdfpurgeNormal()
				else if toolsList contains lPurgeall and toolsList contains lTrashPdf then
					my trashPdfpurgeAll()
				else if toolsList contains lPurge then
					my purgeNormal()
				else if toolsList contains lPurgeall then
					my purgeAll()
				else if toolsList contains lTrashPdf then
					my trashPdf()
				else if toolsList contains lHelp then
					my openDescription()
				end if
			end if
		end tell
		if (mainList does not contain lTools) or ((mainList contains lTools) and (terminalWinForeground is false)) then tell application previousApp to activate
		if mainList is false then error number -128
		tell application asocRunner to set mainList to (refine list mainList using predicates {"not self contains 'Set PDF Viewer'", "not self contains 'Tools'", "not self contains 'egister'", "not self contains 'Help'"})
		return
	end if
	
	
	
	------------------------------------------------------------------------------
	-- Getting filename and paths
	------------------------------------------------------------------------------
	
	-- Getting document
	
	if (prMode and not tsModeSwap) or (not prMode and tsModeSwap) then
		if prFile is not "" then
			set fileName to prFile -- Already POSIX
		else
			getFromFinderOnly()
			fileNameStandardization()
		end if
		set defactoPrMode to true
	else
		getFromEditorFirst() -- Getting document from text editor app and then from Finder selection
		fileNameStandardization()
		set defactoPrMode to false
	end if
	
	filetypeCheck()
	
	-- Getting file name components
	
	getFileNameComponents()
	
	tell application previousApp to activate
	
	------------------------------------------------------------------------------
	-- Other variables for the command string
	------------------------------------------------------------------------------
	
	-- PDF viewer 
	if (pdfViewerLaunch and not pdfViewerLaunchSwap) or (not pdfViewerLaunch and pdfViewerLaunchSwap) then
		set pdfOpen to " && open -b " & pdfViewer & space & quoted form of fileNameRoot & ".pdf"
	else
		set pdfOpen to ""
	end if
	
	-- Exclude aux files and – optionally – output PDF from Time Machine backup 
	if enableTMexclude then
		set TMExclude to " && xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".pdf" & space & quoted form of fileNameRoot & ".tuc" & space & quoted form of fileNameRoot & ".log && [ ! -f" & space & quoted form of fileNameRoot & ".synctex.gz ] || xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".synctex.gz"
	else
		set TMExclude to " && xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".tuc" & space & quoted form of fileNameRoot & ".log && [ ! -f" & space & quoted form of fileNameRoot & ".synctex.gz ] || xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".synctex.gz"
	end if
	
	
	-- Completion sound 
	
	if enableSound then
		set makeNoise to " && afplay " & quoted form of finishSound
	else
		set makeNoise to ""
	end if
	
	
	-- Case-specific log viewer
	
	if not isFromFinder then
		set logViewer to logViewerNormal
	else
		set logViewer to logViewerFinder
	end if
	if logViewer is "Current Editor" then set logViewer to targetApp
	
	
	-- Displayed info on ConTeXt installation
	if ctxBeta is ctxCurrent then
		set showCtx to "ConTeXt"
	else if myCtx is ctxBeta then
		set showCtx to "ConTeXt (Beta)"
	else if myCtx is ctxCurrent then
		set showCtx to "ConTeXt (Current)"
	else
		tell application "System Events"
			activate
			beep 10
			display alert "This cannot happen."
		end tell
	end if
	
	
	-- URL of log file for terminal-notifier
	
	set logFile to fileNameHead & "/" & fileNameRoot & ".log"
	
	tell application asocRunner
		modify string logFile so it is escaped URI
		set logFileURL to result
	end tell
	set logFileURL to "file://" & logFileURL
	
	
	-- Parent item (product folder / component folder in product mode | product file in normal mode)
	
	if defactoPrMode and prFile is not "" then
		set {parentItem, showTsMode} to {"ƒ " & prFileFolder, "Product Mode"}
	else if defactoPrMode then
		set {parentItem, showTsMode} to {"ƒ " & parentFolder, "Product Mode"}
	else if not defactoPrMode and prFile is not "" then
		set {parentItem, showTsMode} to {prFileNameTail, "Normal Mode"}
	else
		set {parentItem, showTsMode} to {"ƒ " & parentFolder, "Normal Mode"}
	end if
	
	
	-- Notifications
	
	
	if MLnotifications then
		set notificationStart to terminalNotifier & " -title '" & showCtx & " | Started ☕️' -subtitle " & quoted form of fileNameTail & " -message '" & parentItem & " | " & showTsMode & "' ; "
		set notificationEnd to " && " & terminalNotifier & " -title '" & showCtx & " | Completed 🍺' -subtitle " & quoted form of fileNameTail & " -message '" & parentItem & " | " & showTsMode & "' -open '" & logFileURL & "'"
	else
		set {notificationStart, notificationEnd} to {"", ""}
	end if
	
	
	-- ConTeXt and options
	
	set ctxRun to " && mtxrun --script context --autogenerate "
	
	if (not terminalMode and not runModeSwap) or (terminalMode and runModeSwap) then
		set optConsole to "--noConsole "
	else
		set optConsole to ""
	end if
	
	if useJit then
		set optJit to "--jit "
	else
		set optJit to ""
	end if
	
	if syncTex then
		set optSync to "--synctex=zipped "
	else
		set optSync to ""
	end if
	
	
	-- Skim refresh
	-- Can’t make this work ATM, so Skim refresh is currently limited to non-terminal typesetting mode
	(*
	if pdfViewer is "net.sourceforge.skim-app.skim" then
		set pdfName to (fileNameHead & "/" & fileNameRoot & ".pdf")
		set skimRefresh to " && osascript -e 'tell application \"Skim\"' -e 'set skimPDF to get documents whose path is " & quoted form of pdfName & "' -e 'if (count of skimPDF) greater than 0 then revert skimPDF' -e 'end tell'"
	else
		set skimRefresh to ""
	end if
*)
	
	------------------------------------------------------------------------------
	-- Actual Bash command strings
	------------------------------------------------------------------------------
	
	set typesetCmd to notificationStart ¬
		& "ulimit -n 1024 ; " & cSourceCtx ¬
		& " && cd " & quoted form of fileNameHead ¬
		& ctxRun ¬
		& optJit ¬
		& optSync ¬
		& optConsole ¬
		& quoted form of fileNameTail ¬
		& makeNoise ¬
		& notificationEnd ¬
		& pdfOpen ¬
		& TMExclude
	
	set autoCheckCmd to "cd " & quoted form of fileNameHead & " && " & cSourceCtx & " && { printf \"

---

Syntax checker says:

\" ; " & checkCmd & space & quoted form of fileNameTail & " ; } >> " & quoted form of fileNameRoot & ".log"
	
	set logViewCmd to "cd " & quoted form of fileNameHead & " && open -a  " & logViewer & space & quoted form of fileNameRoot & ".log"
	
	
	------------------------------------------------------------------------------
	-- Run
	------------------------------------------------------------------------------
	
	if MVnotifications then display notification parentItem & " | " & showTsMode with title showCtx & " | Started ☕️" subtitle quoted form of fileNameTail
	
	if (not terminalMode and not runModeSwap) or (terminalMode and runModeSwap) then
		try
			do shell script typesetCmd
			if MVnotifications then display notification parentItem & " | " & showTsMode with title showCtx & " | Completed 🍺" subtitle quoted form of fileNameTail
			
			# Experimental: Proper Skim reload
			# Disable "Check for file changes" in Skim's prefs
			refreshSkim()
			
		on error
			try
				do shell script logViewCmd
			end try
			if autoSyntaxCheck then do shell script autoCheckCmd
			errorSound(soundNumber)
			--error number -128
			return
		end try
		
	else
		doTerminal(typesetCmd)
	end if
	
	set runCount to (runCount + 1)
	if (runCount = 3) or (runCount = 9) or (runCount = 17) then firstTimeMessage()
	
	
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
	-- Handlers
	------------------------------------------------------------------------------
	------------------------------------------------------------------------------
	
	on getFileNameComponents()
		tell application asocRunner
			set fileNameHead to containing item of (parsed path fileName) as text
			set fileNameTail to name of (parsed path fileName) as text
			set fileNameRoot to name stub of (parsed path fileName) as text
			set parentFolder to name of (about file (containing item of (parsed path fileName) as text))
		end tell
		return
	end getFileNameComponents
	
	-- 1st attempt: Get document from frontmost process
	on getFromEditor()
		tell application "System Events"
			set targetApp to name of (first application process whose frontmost is true)
			-- As of February 2015 BBEdit 11’s (10’s?)frontmost window is named 'window 2' instead of 'window 1'
			-- So instead of switching to 'window 2' for BBEdit it is more robust
			-- to use BBEdit's own AppleScript dictionary
			if targetApp is "BBEdit" then
				tell application "BBEdit"
					-- Conditional is needed to preserve the variable in case of failure; Hmm, really?
					if name of text document 1 ends with ".tex" then
						set currentEditorFile to POSIX path of (file of text document 1 as alias)
						set isFromFinder to false
						set isFromBBEdit to true
					end if
				end tell
			else
				try
					tell application process targetApp
						-- Conditional is needed to preserve the variable in case of failure; Hmm, really?
						if value of attribute "AXDocument" of window 1 ends with ".tex" then
							set currentEditorFile to value of attribute "AXDocument" of window 1
							set isFromFinder to false
						end if
					end tell
				end try
			end if
		end tell
		return
	end getFromEditor
	
	-- Fallback in case our editor was pushed away from frontmost position 
	-- (e.g. if user compiled the script as application bundle, or by a launcher, …)
	on restoreFrontmostApp()
		tell application "System Events"
			-- if we are in Finder chances are high that we went there deliberately …
			if name of (first application process whose frontmost is true) is not "Finder" then
				set visible of the first application process whose frontmost is true to false
				delay 0.7
			end if
		end tell
	end restoreFrontmostApp
	
	-- 2nd attempt: Get Finder selection
	on getFromFinder()
		tell application "Finder"
			--activate
			try
				set finderSel to the selection
				if (count of finderSel) is greater than 1 then
					say "oohps"
					display alert "Please select 1 file." as warning
					error number -128
					-- only update  if a tex file is selected; otherwise reuse the last valid selection
				else if (finderSel as text) ends with ".tex" then
					set currentFinderFile to finderSel as text
					set isFromFinder to true
				end if
			end try
		end tell
		return
	end getFromFinder
	
	on getFromEditorFirst()
		getFromEditor()
		if currentEditorFile does not end with ".tex" then
			restoreFrontmostApp()
			getFromEditor()
		end if
		if currentEditorFile does not end with ".tex" then getFromFinder()
		return
	end getFromEditorFirst
	
	on getFromFinderOnly()
		getFromFinder()
		return
	end getFromFinderOnly
	
	on fileNameStandardization()
		if isFromFinder then
			-- Why doesn’t this work?: --set fileName to POSIX path of currentFinderFile as text
			tell application asocRunner to set fileName to POSIX path of (about file currentFinderFile) as text
		else if isFromBBEdit then
			set fileName to currentEditorFile as text
		else -- URL to POSIX; for document names obtained through GUI scripting
			try
				set fileName to urlToPOSIXPath(currentEditorFile) as text
			end try
		end if
		return
	end fileNameStandardization
	
	on filetypeCheck()
		if fileName does not end with ".tex" then noValidFileAlert()
		return
	end filetypeCheck
	
	on noValidFileAlert()
		say "oohps"
		tell application "System Events"
			display alert "No TeX file found!" & return & return & ¬
				"Make sure that …" & return & return & ¬
				"… a '*.tex' file is opened in the first window of your text editor." & return & ¬
				"… your text editor is the frontmost application." & return & ¬
				"… your text editor is not hidden." & return & ¬
				"… your text editor is compatible with this script." & return & return & ¬
				"or …" & return & return & ¬
				"… a '*.tex' file is selected in the Finder." & return & return & ¬
				"Make sure that the system requirements are met (see description)." as warning
		end tell
		error number -128
	end noValidFileAlert
	
	on regPrFile()
		getFromEditorFirst()
		fileNameStandardization()
		filetypeCheck()
		set prevPrFile to prFile
		set prFile to fileName
		tell application asocRunner
			set prFileNameTail to name of (parsed path prFile) as text
			set prFileFolder to name of (about file (containing item of (parsed path prFile) as text))
			set prevPrFileNameTail to name of (parsed path prevPrFile) as text
		end tell
		if MVnotifications then
			display notification "ƒ " & prFileFolder with title "Product file registered" subtitle prFileNameTail
		else
			do shell script terminalNotifier & " -title 'Product file registered' -subtitle '" & prFileNameTail & "' -message 'ƒ " & prFileFolder & "'"
		end if
		tell application previousApp to activate
		return prFile
	end regPrFile
	
	on unregPrFile()
		if prFile is "" then return
		set prevPrFile to prFile
		set prFile to ""
		tell application asocRunner
			set prevPrFileNameTail to name of (parsed path prevPrFile) as text
		end tell
		if MVnotifications then
			display notification "Previous product file: " & prevPrFileNameTail with title "Product file unregistered" subtitle prFileNameTail
		else
			do shell script terminalNotifier & " -title 'Product file unregistered' -message 'Previous product file: " & prevPrFileNameTail & "'"
		end if
		return
	end unregPrFile
	
	on reregPrFile()
		if prevPrFile is "" or prFile is equal to prevPrFile then return
		set tmpPrFile to prFile
		set prFile to prevPrFile
		set prevPrFile to tmpPrFile
		tell application asocRunner
			set prFileNameTail to name of (parsed path prFile) as text
			set prFileFolder to name of (about file (containing item of (parsed path prFile) as text))
			set prevPrFileNameTail to name of (parsed path prevPrFile) as text
		end tell
		if MVnotifications then
			display notification "ƒ " & prFileFolder with title "Product file re-registered" subtitle prFileNameTail
		else
			do shell script terminalNotifier & " -title 'Product file re-registered' -subtitle '" & prFileNameTail & "' -message 'ƒ " & prFileFolder & "'"
		end if
		return
	end reregPrFile
	
	
	-- From http://macscripter.net/viewtopic.php?id=14861
	-- Modified as in http://stackoverflow.com/questions/9617029/how-to-get-the-a-file-url-in-osx-with-applescript-or-a-shell-script
	-- TODO: Find a better way without Python
	on urlToPOSIXPath(theURL)
		return do shell script "python -c \"import urllib, urlparse, sys; print (urllib.unquote(urlparse.urlparse(sys.argv[1])[2]))\" " & quoted form of theURL
	end urlToPOSIXPath
	
	(*
	on urlToPOSIXFile(theURL)
		return POSIX file urlToPOSIXPath(theURL)
	end urlToPOSIXFile
*)
	
	on setPdfViewer()
		repeat with i in pdfViewerInventory
			if (item 1 of i is item 1 of pdfViewerList) then
				set pdfViewer to item 2 of i
				exit repeat
			end if
		end repeat
		return pdfViewer
	end setPdfViewer
	
	-- Test for ConTeXt paths
	on testPaths()
		tell application "System Events"
			activate
			try
				(ctxBeta as POSIX file) as alias
				(ctxCurrent as POSIX file) as alias
			on error
				beep
				display dialog ¬
					"Your ConTeXt paths are not set correctly or have changed. The script needs the paths to the ‘setuptex’ files of your ConTeXt installations." & return & return & ¬
					"I will try to find the ‘setuptex’ files for you." & return & return & "Please choose the ‘setuptex’ path of your ConTeXt *Beta* from the *first* window, and the ‘setuptex’ of your ConTeXt *Current* from the *second*." & return & return & "If you only use one ConTeXt installation set both to the same ‘setuptex’ path." with title "Missing ConTeXt Paths!" buttons {"Later", "Search…"} default button 2 cancel button 1
				set foundSetuptex to do shell script "mdfind -name 'setuptex' | grep  '/tex/setuptex$' ; exit 0"
				if foundSetuptex is "" then
					showSearchProgress() of me
					-- In case user has disabled Spotlight or file is out of search scope of Spotlight
					set foundSetuptex to do shell script "find $HOME /Users/Shared /Applications /opt /usr/local /usr/share -name 'setuptex' -maxdepth 6 | grep  '/tex/setuptex$' ; exit 0"
					-- Is the depth sufficient for nested install locations in ~/Library/ ?
					stopProgress() of me
				end if
				if foundSetuptex is not "" then
					set foundSetuptex to every paragraph of foundSetuptex
					set foundSetuptex to foundSetuptex & notSuitable
					set ctxBeta to choose from list foundSetuptex with title "‘setuptex’ from ConTeXt Beta" with prompt "Choose ‘setuptex’ path of your primary ConTeXt installation (usually ConTeXt *Beta*):" empty selection allowed no multiple selections allowed no
					if ctxBeta is false then error number -128
					if ctxBeta does not contain notSuitable then
						set ctxCurrent to choose from list foundSetuptex with title "‘setuptex’ from ConTeXt Current" with prompt "Choose ‘setuptex’ path of your secondary ConTeXt installation (usually ConTeXt *Current*). If you use only one installation select the same as for the primary installation:" empty selection allowed no multiple selections allowed no
						if ctxCurrent is false then error number -128
						if ctxCurrent contains notSuitable then manualPathSelection() of me
					else
						manualPathSelection() of me
					end if
				else
					display dialog "Sorry, I couldn’t find any ‘setuptex’ file." & return & return & "If you are sure that ConTeXt is installed on this computer please select the files in the following file selection dialogs." & return & return & "(The ‘setuptex’ file is located in the ‘tex’ folder inside your ConTeXt directory.)" buttons {"Continue…"} default button 1
					manualPathSelection() of me
				end if
				display dialog ¬
					"The following paths have been set:" & return & return & "ConTeXt Beta:" & return & return & ctxBeta & return & return & "ConTeXt Current:" & return & return & ctxCurrent buttons {"Cancel", "Paths are correct"} default button 2
				if the button returned of the result is "Cancel" then error number -128
				set ctxBeta to (ctxBeta as text)
				set ctxCurrent to (ctxCurrent as text)
				set myCtx to ctxBeta
				set cSourceCtx to "source " & quoted form of myCtx
				set showList to true
			end try
		end tell
	end testPaths
	
	on manualPathSelection()
		tell application "System Events"
			activate
			set ctxBeta to choose file with prompt "Please select the ‘setuptex’ file of your ConTeXt Beta directory:" of type {""} default location (path to home folder)
			try
				set tmpDefaultPath to POSIX path of container of container of container of ctxBeta
			on error
				set tmpDefaultPath to (path to home folder)
			end try
			set ctxCurrent to choose file with prompt "Please select the ‘setuptex’ file of your ConTeXt Current directory:" of type {""} default location tmpDefaultPath
			set ctxBeta to POSIX path of ctxBeta as text
			set ctxCurrent to POSIX path of ctxCurrent as text
		end tell
	end manualPathSelection
	
	on showSearchProgress()
		tell application asocRunner
			reset progress
			set properties of progress window to {button visible:false, indeterminate:true, message:"Deep Search…", detail:"The first search run with Spotlight didn’t yield any results. Now searching with 'find' in Home, /Users/Shared, /Applications, /opt, /usr/local and /usr/share."}
			activate
			show progress
		end tell
	end showSearchProgress
	
	on stopProgress()
		tell application asocRunner to hide progress
	end stopProgress
	
	on reselectCtx()
		set ctxBeta to ""
		set ctxCurrent to ""
		testPaths()
	end reselectCtx
	
	on doTerminal(bashScript)
		if terminalWinRecycle is true then
			tell application "Terminal"
				launch
				if terminalWinForeground is true then activate
				set windowCount to (count of the windows)
				if windowCount is greater than 0 then
					repeat with w from 1 to windowCount
						if window 1 is busy or window 1's processes contains "less" then -- Respect also open man pages
							set frontmost of window 1 to false
						else
							do script bashScript in window 1
							set frontmost of window 1 to true
							return
						end if
					end repeat
				end if
				tell window 1
					do script bashScript
					set frontmost to true
				end tell
			end tell
		else
			-- Simple terminal launch with new instance for every typesetting
			tell application "Terminal"
				launch
				do script bashScript
				if terminalWinForeground is true then activate
			end tell
		end if
	end doTerminal
	
	
	on firstTimeMessage()
		tell application "System Events"
			delay 1
			activate
			display dialog "Remember, you have these modifier keys at your disposal:" & return & return & "ctrl:" & return & "Main Settings" & return & return & "opt:" & return & "Swap temporarly Normal typesetting mode and Product typesetting mode" & return & return & "shift:" & return & "Swap temporarly PDF viewer auto-launch on/off" & return & return & "opt-shift:" & return & "Swap temporarly terminal mode and standard shell mode" & return & return & "ctrl-opt:" & return & "Register new product file" & return & return & "Hold down the modifier key in addition to your normal hotkey. The ctrl-key will work also when you launch the script with the mouse from the AppleScript menu." & return & return & "You find more information in the ReadMe file." & return & return & "Have fun." buttons {"Yes"} default button 1
		end tell
		return
	end firstTimeMessage
	
	on getVersionInfo()
		try
			set ctxBetaVersion to do shell script "source " & quoted form of ctxBeta & " && " & cVersionCtx & " ; " & cVersionLua
			set ctxCurrentVersion to do shell script "source " & quoted form of ctxCurrent & " && " & cVersionCtx & " ; " & cVersionLua
			tell application "System Events"
				activate
				display dialog "Version Info" & return & return & "ConTeXt Beta:" & return & return & ctxBetaVersion & return & return & "ConTeXt Current:" & return & return & ctxCurrentVersion buttons {"Copy to clipboard", "OK"} default button 2
			end tell
			if button returned of the result is "Copy to clipboard" then
				tell application asocRunner
					look for "(ConTeXt):\\s*" in (ctxBetaVersion & return & ctxCurrentVersion) replacing with "$1 "
					look for "\\r(LuaTeX):\\s*" in result replacing with "; $1 "
					set the clipboard to the result
				end tell
			end if
		end try
	end getVersionInfo
	
	on synCheck()
		getFromEditorFirst()
		fileNameStandardization()
		filetypeCheck()
		doTerminal(cSourceCtx & " && " & checkCmd & space & quoted form of fileName)
	end synCheck
	
	on getFilenameForPurging()
		if (prMode and not tsModeSwap) or (not prMode and tsModeSwap) then
			if prFile is not "" then
				set fileName to prFile
			else
				getFromFinderOnly()
				fileNameStandardization()
			end if
		else
			getFromEditorFirst()
			fileNameStandardization()
		end if
	end getFilenameForPurging
	
	on purgeNormal()
		getFilenameForPurging()
		filetypeCheck()
		getFileNameComponents()
		_purgeNormal()
	end purgeNormal
	
	on purgeAll()
		getFilenameForPurging()
		filetypeCheck()
		getFileNameComponents()
		_purgeAll()
	end purgeAll
	
	on trashPdf()
		getFilenameForPurging()
		filetypeCheck()
		getFileNameComponents()
		_trashPdf()
	end trashPdf
	
	on trashPdfpurgeNormal()
		getFilenameForPurging()
		filetypeCheck()
		getFileNameComponents()
		_trashPdf()
		_purgeNormal()
	end trashPdfpurgeNormal
	
	on trashPdfpurgeAll()
		getFilenameForPurging()
		filetypeCheck()
		getFileNameComponents()
		_trashPdf()
		_purgeAll()
	end trashPdfpurgeAll
	
	on _purgeNormal()
		doTerminal(cSourceCtx & " && cd " & quoted form of fileNameHead & " && " & cPurgeNormal)
	end _purgeNormal
	
	on _purgeAll()
		doTerminal(cSourceCtx & " && cd " & quoted form of fileNameHead & " && " & cPurgeAll)
	end _purgeAll
	
	on _trashPdf()
		set otherPdfs to ""
		set todeletePdfs to ""
		set countOtherPdfs to 0
		set countDeletedPdfs to 0
		set remSize to 0
		set reclSize to 0
		--try
		tell application asocRunner
			set fileNameHeadURI to (modify string fileNameHead so it is escaped URI)
			try
				set otherPdfs to file path from (modify list (file path from (enumerate folder fileNameHead match extensions "pdf") deleting extension yes) subtracting list (file path from (enumerate folder fileNameHead match extensions "tex") deleting extension yes)) adding extension "pdf"
			end try
			try
				if (count of otherPdfs) > 0 then
					set countOtherPdfs to (count of otherPdfs)
					repeat with i from 1 to count of otherPdfs
						set remSize to (remSize + (physical size of (about file item i in otherPdfs)))
					end repeat
					set remSize to my doRound((remSize / (1000 * 1000)), 0.1)
				end if
			end try
			try
				set todeletePdfs to file path from (modify list (file path from (enumerate folder fileNameHead match extensions "pdf") deleting extension yes) intersecting with list (file path from (enumerate folder fileNameHead match extensions "tex") deleting extension yes)) adding extension "pdf"
			end try
			try
				if (count of todeletePdfs) > 0 then
					set countDeletedPdfs to (count of todeletePdfs)
					repeat with i from 1 to count of todeletePdfs
						set reclSize to (reclSize + (physical size of (about file item i in todeletePdfs)))
					end repeat
					set reclSize to my doRound((reclSize / (1000 * 1000)), 0.1)
					manage file todeletePdfs with deleting without finality
				end if
			end try
		end tell
		if MVnotifications is true and countDeletedPdfs > 0 then
			display notification "Kept PDF files: " & countOtherPdfs & " (" & remSize & " MB)" with title "PDF files purged" subtitle "Trashed PDF files: " & countDeletedPdfs & " (" & reclSize & " MB)"
		else if MLnotifications is true and countDeletedPdfs > 0 then
			do shell script terminalNotifier & " -title 'PDF files purged' -subtitle 'Trashed PDF files: " & countDeletedPdfs & " (" & reclSize & " MB)' -message 'Kept PDF files: " & countOtherPdfs & " (" & remSize & " MB)' -open file://" & fileNameHeadURI
		else if MVnotifications is true then
			display notification "Kept PDF files: " & countOtherPdfs & " (" & remSize & " MB)" with title "No eligible PDF files found"
		else if MLnotifications is true then
			do shell script terminalNotifier & " -title 'No eligible PDF files found' -message 'Kept PDF files: " & countOtherPdfs & " (" & remSize & " MB)' -open file://" & fileNameHeadURI
		end if
	end _trashPdf
	
	on makeFormatsBeta()
		doTerminal("source " & ctxBeta & " && " & cCtxFormat)
	end makeFormatsBeta
	
	on makeFormatsCurrent()
		doTerminal("source " & ctxCurrent & " && " & cCtxFormat)
	end makeFormatsCurrent
	
	on listFontsAll()
		doTerminal(cSourceCtx & " && " & cListFontsAll)
	end listFontsAll
	
	on updCtx(ctxToUpdate)
		set ctxVersiondate to do shell script "source " & quoted form of ctxToUpdate & " && " & cVersionCtxDate
		if ctxVersiondate does not start with "201" or ctxVersiondate does not contain "T" then
			tell application "System Events" to display alert "Could not get date of installed ConTeXt."
			error number -128
		end if
		if ctxToUpdate is ctxBeta then
			set updOption to "beta"
		else
			set updOption to "current"
		end if
		if ctxBeta is not equal to ctxCurrent then
			set bakName to updOption & "-"
		else
			set bakName to ""
		end if
		
		--if backupDir is "" then
		tell application "System Events"
			if not (exists folder backupDir) then
				activate
				choose folder with prompt "Please select the directory where you want to backup your previous ConTeXt installation to:" default location (path to home folder)
				set backupDir to (POSIX path of result) as text
			end if
		end tell
		--end if
		tell application asocRunner
			set dirCtx to containing item of (parsed path containing item of (parsed path ctxToUpdate)) as text
			set dirNameCtx to name of (about file dirCtx)
			if backUpToSameLocation is true then set backupDir to (containing item of (parsed path dirCtx) as text)
		end tell
		if bakComprLevel is 1 then
			testForBak("tar.gz")
			if makeNewBak is false then
				doTerminal("source " & quoted form of ctxToUpdate & " && cd " & quoted form of dirCtx & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
			else
				trashOldBak("tar.gz")
				(*
				doTerminal("tar -czf " & quoted form of backupDir & "/" & quoted form of dirNameCtx & ".ctx-" & bakName & quoted form of ctxVersiondate & ".tar.gz --options='compression-level=2' -C " & quoted form of dirCtx & " . && source " & quoted form of ctxToUpdate & " && cd " & quoted form of dirCtx & " && " & cFirstsetupUpdate & " && sh ./first-setXup.sh --context=" & updOption & " --engine=luatex --modules=all")
*)
				doTerminal("cd " & quoted form of dirCtx & " && tar -czf " & quoted form of backupDir & "/" & quoted form of dirNameCtx & ".ctx-" & bakName & quoted form of ctxVersiondate & ".tar.gz --options='compression-level=2' . && source " & quoted form of ctxToUpdate & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
			end if
		else if bakComprLevel is 0 then
			testForBak("tar")
			if makeNewBak is false then
				doTerminal("source " & quoted form of ctxToUpdate & " && cd " & quoted form of dirCtx & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
			else
				trashOldBak("tar")
				doTerminal("cd " & quoted form of dirCtx & " && tar -cf " & quoted form of backupDir & "/" & quoted form of dirNameCtx & ".ctx-" & bakName & quoted form of ctxVersiondate & ".tar . && source " & quoted form of ctxToUpdate & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
			end if
		else if bakComprLevel is 2 then
			testForBak("tar.xz")
			if makeNewBak is false then
				doTerminal("source " & quoted form of ctxToUpdate & " && cd " & quoted form of dirCtx & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
			else
				trashOldBak("tar.xz")
				
				doTerminal("cd " & quoted form of dirCtx & " && tar -cf - . | " & p7z & " a -txz -si -bd -m0=lzma2 -mx=5 -ms=on -mtm=on -mtc=off -mta=off -mmt=on " & quoted form of backupDir & "/" & quoted form of dirNameCtx & ".ctx-" & bakName & quoted form of ctxVersiondate & ".tar.xz && source " & quoted form of ctxToUpdate & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
				
				-- "Keep parent folder" version:
				(*
				doTerminal("cd " & quoted form of dirCtx & " && tar -cf - -C $(dirname " & quoted form of dirCtx & ") $(basename " & quoted form of dirCtx & ") | " & p7z & " a -txz -si -bd -m0=lzma2 -mx=5 -ms=on -mtm=on -mtc=off -mta=off -mmt=on " & quoted form of backupDir & "/" & quoted form of dirNameCtx & ".ctx-" & bakName & quoted form of ctxVersiondate & ".tar.xz && source " & quoted form of ctxToUpdate & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
*)
			end if
		end if
	end updCtx
	
	on testForBak(bakExt)
		set makeNewBak to true
		tell application "System Events"
			if exists file (backupDir & "/" & dirNameCtx & ".ctx-" & bakName & ctxVersiondate & "." & bakExt) then
				activate
				display dialog "There is already a backup of this ConTeXt version. Do you want to replace it with a new one?" buttons {"Keep existing backup", "Move old backup to trash"} default button 1
				if button returned of result is "Keep existing backup" then set makeNewBak to false
			end if
		end tell
	end testForBak
	
	on trashOldBak(bakExt)
		try
			tell application asocRunner to manage file (backupDir & "/" & dirNameCtx & ".ctx-" & bakName & ctxVersiondate & "." & bakExt) with deleting without finality
		end try
	end trashOldBak
	
	on openDescription()
		tell application "Finder" to open descrFile
	end openDescription
	
	on doRound(theNumber, thePrecision)
		return (round (theNumber / thePrecision) ¬
			rounding as taught in school) * thePrecision
	end doRound
	
	-- For debugging
	on checkFront()
		tell application "System Events"
			set currentApp to name of (first application process whose frontmost is true)
			say currentApp
		end tell
	end checkFront
	
	on errorSound(soundNumber)
		if soundNumber is less than 3 then
			say "oh my god!"
		else if soundNumber is greater than 2 and soundNumber is less than 6 then
			say "shit!"
		else if soundNumber is greater than 5 and soundNumber is less than 10 then
			say "holy shit!"
		else if soundNumber is greater than 9 and soundNumber is less than 12 then
			say "what the fuck?"
		else if soundNumber is 12 then
			say "shit! come on!"
		end if
	end errorSound
	
	on refreshSkim()
		if pdfViewer is "net.sourceforge.skim-app.skim" then
			tell application "Skim"
				--activate
				set skimPDF to get documents whose path is (fileNameHead & "/" & fileNameRoot & ".pdf")
				--try
				if (count of skimPDF) > 0 then revert skimPDF
				--end try
				--open skimPDF
			end tell
		end if
	end refreshSkim
	
end using terms from

-- Old 7z string:
-- p7z & " a -txz -si -bd -m0=lzma2 -mx=9 -ms=on -md=28 -mfb=128 -mtm=on -mtc=off -mta=off -mmt=on "