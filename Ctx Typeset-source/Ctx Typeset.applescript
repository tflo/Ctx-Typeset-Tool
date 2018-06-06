#
# Script name: Ctx Typeset Tool
# What it does: Launches ConTeXt typesetting and provides a GUI for various ConTeXt-related tasks.
# Web page: <http://dflect.net/context-typeset-tool/>
# Author: Thomas Floeren <ecdltf@mac.com>
# Created: 2013
# Last modified: 2018-06-06
# Version: 2.0.0b1 (68)
#
# Copyright © 2013-2018 Thomas Floeren
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies. 
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use scripting additions


set theDefaults to current application's NSUserDefaults's alloc()'s initWithSuiteName:"net.dflect.CtxTypesetTool"

theDefaults's registerDefaults:{ctxBeta:"", ctxCurrent:"", mainList:"", myCtx:"", useJit:false, prMode:false, pdfViewer:"com.apple.Preview", pdfViewerList:"Preview", pdfViewerLaunch:true, syncTex:false, terminalMode:false, logViewerNormal:"Console", logViewerFinder:"Console", autoSyntaxCheck:true, terminalWinRecycle:true, terminalWinForeground:true, enableNotifications:true, enableSound:true, enableTMexclude:true, backupDir:"", backUpToSameLocation:false, prFile:"", prFileNameTail:"", prevPrFile:"", prevPrFileNameTail:"", prFileFolder:"", runCount:0} ¬
	
# The old globals
global fileName, fileNameHead, fileNameTail, fileNameRoot, parentFolder, isFromFinder, isFromBBEdit, targetApp, currentEditorFile, showList, dirNameCtx, bakName, ctxVersiondate, makeNewBak, cSourceCtx, tsModeSwap, previousApp, keyDown

# New globals from User Defaults
global ctxBeta, ctxCurrent, useJit, prMode, pdfViewer, pdfViewerLaunch, syncTex, terminalMode, logViewerNormal, logViewerFinder, autoSyntaxCheck, checkCmd, terminalWinRecycle, terminalWinForeground, enableNotifications, finishSound, enableSound, enableTMexclude, backupDir, backUpToSameLocation, bakComprLevel, p7z, descrFile

# Meta
global theDefaults, mainList, pdfViewerList, toolsList


set ctxBeta to ctxBeta of theDefaults as text
set ctxCurrent to ctxCurrent of theDefaults as text

set mainList to mainList of theDefaults as list
set pdfViewerList to pdfViewerList of theDefaults as list

set myCtx to myCtx of theDefaults as text
set useJit to useJit of theDefaults as boolean
set prMode to prMode of theDefaults as boolean
set pdfViewer to pdfViewer of theDefaults as text
set pdfViewerLaunch to pdfViewerLaunch of theDefaults as boolean
set syncTex to syncTex of theDefaults as boolean
set terminalMode to terminalMode of theDefaults as boolean
set logViewerNormal to logViewerNormal of theDefaults as text
set logViewerFinder to logViewerFinder of theDefaults as text
set autoSyntaxCheck to autoSyntaxCheck of theDefaults as boolean
set terminalWinRecycle to terminalWinRecycle of theDefaults as boolean
set terminalWinForeground to terminalWinForeground of theDefaults as boolean
set enableNotifications to enableNotifications of theDefaults as boolean
set enableSound to enableSound of theDefaults as boolean
set enableTMexclude to enableTMexclude of theDefaults as boolean
set backupDir to backupDir of theDefaults as text
set backUpToSameLocation to backUpToSameLocation of theDefaults as boolean

set prFile to prFile of theDefaults as text
set prFileNameTail to prFileNameTail of theDefaults as text
set prevPrFile to prevPrFile of theDefaults as text
set prevPrFileNameTail to prevPrFileNameTail of theDefaults as text
set prFileFolder to prFileFolder of theDefaults as text # TODO: make sure if we need this in the defaults
set runCount to runCount of theDefaults as integer


################################################################################
# EXPLANATION OF THE VARIABLES (DEFAULT SETTINGS) 
################################################################################
#
# Usually there is no need to change anything here!
# You can set most options in The Options Window (main window) by holding down the Control key when launching the script.
#
# The only variables that may be of interest for the user and are not available through the GUI are the following five;
# you can set them here.
#
# Run delay
set runDelay to 0.5
#
# Command for the syntax-check script
set checkCmd to "mtxrun --script check"
#
# The sound file for the completion sound
set finishSound to "/System/Library/Sounds/Submarine.aiff"
#
# The sound file for the alert sound
set alertSound to "/System/Library/Sounds/Basso.aiff"
# Note: the 'beep' command somehow doesn't work
#
# Compression level for ConTeXt installation backups
set bakComprLevel to 2
#
# You find the explanations for these and the other settings in the comments below:
# [The value in brackets show the default value used by the program.]
#
(*
################################################################################
#
# ctxBeta, ctxCurrent [""]
#
# "setuptex" paths for Ctx Beta and Ctx Current.
#
# If you have only one ConTeXt directory both variables should have the same
# value The script will use the first one by default (This can also be changed
# in the options screen.)
#
################################################################################
#
# runDelay [0.5]
#
# The launch (run) delay
#
# If you are launching the script in a way that doesn’t allow the use of certain 
# modifier keys – e.g. launching it from the Script menu in the menu bar doesn’t
# work with the option or shift key – you can set a longer delay that allows you
# to press a modifier key comfortably after script launch, e.g. 1 or 1.5 sec.
#
# This cannot be set in the GUI! If you want to change it, you have to set it at
# the beginning of this section.
#
# Currently I've set a short delay even for the synchronous use of hotkey and
# modifier keys, because sometimes I noticed problems wit the proper recognition
# of modifier keys. (Experimental.)
#
################################################################################
#
# useJit [false]
#
# If the luajittex engine should be used. Otherwise: luatex
#
################################################################################
#
# prMode [false] 
#
# Product mode or Normal mode.
#
# Can be toggled by holding down the option key at script launch.
#
################################################################################
#
# pdfViewer ["com.apple.Preview"]
#
# Preferred pdf viewer to auto-launch
#
# Acceptable values:
# "net.sourceforge.skim-app.skim"
# "com.apple.Preview"
# "com.adobe.Acrobat.Pro"
# "com.Adobe.Reader"
# "com.smileonmymac.PDFpenPro"
#
################################################################################
#
# pdfViewerLaunch [true]
#
# If the PDF viewer should be launched automatically.
#
################################################################################
#
# syncTex [false]
#
# If SyncTeX should be used.
#
################################################################################
#
# terminalMode [false]
#
# This is the run mode.
#
# Choose if you want to run the typesetting command in the "hidden" standard
# shell or in the terminal. Running it in the shell won’t show you any progress
# indication but you will be notified upon completion and the log file will be
# opened if an error occurs. 
# Set terminalMode to false if your terminal shell is not compatible with this
# script.
#
# To quickly swap modes hold down the Shift key at script launch. 
#
################################################################################
#
# logViewerNormal ["Console"]
#
# Log viewer if typesetting a document from the editor (the log will only be
# shown in case of errors)
# Only applies if terminalMode is false.
#
# Acceptable values:
#
# "Console":
# The standard system log viewer.
# "Current Editor":
# Log opens in your active text editor (the one with the .tex document)
#
# You can alo set another specific viewer, e.g. "TextWrangler"
#
################################################################################
#
# logViewerFinder ["Console"]
#
# Like above, but log viewer if typesetting the Finder selection
#
################################################################################
#
# autoSyntaxCheck [true]
#
# Automatic syntax check; only applies if terminalMode is false.
#
# The script calls automatically ConTeXt’s syntax check 
# if a typesetting error occurs. The output will be appended to the log file.
# (This is handy for example to detect a missing "}".)
#
################################################################################
#
# checkCmd ["mtxrun --script check"]
#
# Your preferred syntax check command.
#
# This cannot be set in the GUI! If you want to change it, you have to set it at
# the beginning of this section.
#
# Examples:
# "mtxrun --script check": newer lua script (mtx-check)
# "mtxrun --script concheck": the older ruby script
#
# The checkCmd variable also applies to manual syntax check.
#
################################################################################
#
# terminalWinRecycle [true]
#
# The desired Terminal behavior.
# Only applies if terminalMode is true.
#
# false: if you want to launch a new terminal window for each typesetting
# process. (If true, the frontmost open terminal window will be reused for
# typesetting; terminal windows that are busy with other processes won’t be
# touched in either case.)
#
################################################################################
#
# terminalWinForeground [true]
#
# Terminal window behavior.
# Only applies if terminalMode is true.
#
# true: if you want the typesetting Terminal window to come to the foreground.
# Not strictly necessary because you will be notified when typesetting has
# finished; but probably better if typesetting a nasty document, so you can see
# immediatly the failure.
#
################################################################################
#
# enableNotifications [true]
#
# Notifications on/off.
# Should be disbled if OS < 10.9.
#
################################################################################
#
# enableSound [true]
#
# If a completion sound should be played after successful typesetting, and an alert sound in case of failure.
#
################################################################################
#
# finishSound ["/System/Library/Sounds/Submarine.aiff"]
#
# The sound file to be played as completion sound.
#
# This cannot be set in the GUI! If you want to change it, you have to set it at
# the beginning of this section.
#
# Other examples: "/System/Library/Sounds/Glass.aiff",
# "/System/Library/Sounds/Blow.aiff"
#
################################################################################
#
# alertSound ["/System/Library/Sounds/Basso.aiff"]
#
# The sound file to be played as alert (failure) sound.
#
# This cannot be set in the GUI! If you want to change it, you have to set it at
# the beginning of this section.
#
################################################################################
#
# enableTMexclude [true]
#
# Excludes the generated PDF from Time Machine backup
#
# If true: It writes the extebded attribute
# "com.apple.metadata:com_apple_backup_excludeItem com.apple.backupd" to the
# generated PDF file. 
#
# Since the generated PDF is reproducible, often very large and frequently
# changing when you are still working on your source files, this is set to true
# by default.
#
# Can be toggled in the main options window.
#
################################################################################
#
# backupDir [""]
#
# The directory where the script should save the ConTeXt backup when updating
# the installation. (Before updating the installed ConTeXt the script will
# backup your previous, supposedly working, ConTeXt.)
#
################################################################################
#
# backUpToSameLocation [false]
#
# If the backup should be written to the same directory where the ConTeXt
# installtion lives.
#
################################################################################
#
# bakComprLevel [2]
#
# The ompression level for your ConTeXt backup archive.
#
# This cannot be set in the GUI! If you want to change it, you have to set it at
# the beginning of this section.
#
# Acceptable values:
#
# 0: No compression (tar archive)
# 1: gzipped archive (tar.gz), approx. 50%
# 2: lzma compressed archive (tar.xz), approx. 30%
#
# All methods are entirely Mac metadata safe (tags, comments, xattr)
#
# 0 will be very fast: chosse this if you are going to delete the backup anyway
# or if you want to compress several archives together afterwards
#
# 1 is quite fast: should be OK as compromise for most purposes 
#
# 2 is a bit slower but compresses well: if you guard more than a couple of old
# versions or if you don’t have disk space to waste. (I added this because I
# prefer this format personally for longer-time archiving.) Compression runs
# multithreaded and takes about 20s on a Mac Mini.
#
################################################################################
# END of explanation of the variables (default settings) 
################################################################################
*)

################################################################################
# Other variables
################################################################################

# Bundled files

if ((path to me) as text) ends with ".applescript" then
	# For the source file
	set p7z to (quoted form of POSIX path of ("/Users/tom/Documents/Scripts/AppleScript/Ctx Typeset/Ctx Typeset Tool/Ctx Typeset.scptd/Contents/Resources/bin/7zr")) as text
	set descrFile to POSIX file "/Users/tom/Documents/Scripts/AppleScript/Ctx Typeset/Ctx Typeset Tool/Manual.html" as text
else
	set p7z to (quoted form of POSIX path of (path to resource "bin/7zr")) as text
	set descrFile to (path to resource "Manual/Manual.html") as text
end if


# Misc

set currentEditorFile to ""
set fileName to ""
set isFromFinder to false
set isFromBBEdit to false
set runModeSwap to false
set tsModeSwap to false
set pdfViewerLaunchSwap to false

global currentFinderFile, prFile, prFileFolder, prFileNameTail, prevPrFile, prevPrFileNameTail, finderSel, runCount, notSuitable

set currentFinderFile to ""
set finderSel to ""
set notSuitable to "[→ No suitable path here. Let me search myself… →]"

# Get frontmost app at script launch time
tell application "System Events" to set previousApp to name of first process where frontmost is true

# Settings list 

set showList to false
--set toolsList to ""

global lCtx, lJit, lprMode, lRegPrFile, lUnregPrFile, lReregPrFile, lTerminal, lTerminalNew, lPdfViewerAuto, lPdfViewerChange, lTerminalBack, lLogViewer, lAutoSynCheck, lNotifications, lSound, lTM, lSynctex, lTools, lHelp, pdfViewerInventory

set lCtx to "▷	Use ConTeXt Current (Instead of  Beta)"
set lJit to "▷	Use LuaJitTeX (Instead of LuaTeX)"
set lprMode to "▷	Product Mode  ⌥"
set lRegPrFile to "	▶▶	Register as New Product File  ⌃⌥"
set lUnregPrFile to ""
set lReregPrFile to ""
set lTerminal to "▷	Run Typesetting in Terminal  ⌥⇧"
set lTerminalNew to " 	▷	New Terminal Window for Each Run"
set lPdfViewerAuto to "▷	Do not Auto-launch PDF Viewer  ⇧"
set lPdfViewerChange to "	▷	Set PDF Viewer →"
set lTerminalBack to "▷	Keep Terminal Windows in Background"
set lLogViewer to "▷	View Error Logs in Current Text Editor"
set lAutoSynCheck to "▷	Automatic Syntax Check on Error Off"
set lNotifications to "▷	Notifications Off"
set lSound to "▷	Completion Sound Off"
set lTM to "▷	Don’t Exclude Generated PDF from Backup"
set lSynctex to "▷	Enforce SyncTeX"
set lTools to "Tools →"
set lHelp to "Help"

set pdfViewerInventory to {{"Skim", "net.sourceforge.skim-app.skim"}, {"Preview", "com.apple.Preview"}, {"Adobe Acrobat Pro", "com.adobe.Acrobat.Pro"}, {"Adobe Reader", "com.Adobe.Reader"}, {"PDFpenPro", "com.smileonmymac.PDFpenPro"}}


# Tools list

global lVersionInfo, lUpdBeta, lUpdCurrent, lSelectNewCtx, lMakeFormatsBeta, lMakeFormatsCurrent, lListFontsAll, lManualSynCheck, lPurge, lPurgeall, lTrashPdf

set lVersionInfo to "◼	ConTeXt Version Info"
set lUpdBeta to "▶	Update ConTeXt Beta (Mk IV)"
set lUpdCurrent to "▶	Update ConTeXt Current (Mk IV)"
set lSelectNewCtx to "▶	Reassign ConTeXt Installations (Beta/Current Slots)"
set lMakeFormatsBeta to "◼	Make Formats for ConTeXt Beta (Mk IV)"
set lMakeFormatsCurrent to "◼	Make Formats for ConTeXt Current (Mk IV)"
set lListFontsAll to "◼	List All Available Fonts"
set lManualSynCheck to "◼◼	Syntax Check"
set lPurge to "◼◼	Purge (Ctx Script)"
set lPurgeall to "◼◼	Purge All (Ctx Script)"
set lTrashPdf to "◼◼	Trash Generated PDF Files"


# Bash related

global cPurgeNormal, cPurgeAll, cVersionCtx, cVersionLua, cVersionCtxDate, xattrTMExclusion, cCtxFormat, cListFontsAll, cFirstsetupUpdate

# texutil needs the UTF-8 setting if the path to ConTeXt contains non-ASCII chars; the other commands are fine w/o it.
set cPurgeNormal to "export LC_ALL='en_US.UTF-8' && mtxrun texutil --purgefiles"
set cPurgeAll to "export LC_ALL='en_US.UTF-8' && mtxrun texutil --purgeallfiles"
set cVersionCtx to "context --version  | awk 'match($0, /current version:/) { print \"ConTeXt: \" substr($0, RSTART+17) }'"
set cVersionLua to "luatex --version | awk 'match($0, /, Version/) {print \"LuaTeX:   \" substr($0, RSTART+10) }'"
set cVersionCtxDate to "context --version  | awk 'match($0, /current version:/) { i = substr($0, RSTART+17) ; gsub(/\\.|:/, \"\", i) ; sub(/ /, \"T\", i) ; print i}'"
set xattrTMExclusion to "com.apple.metadata:com_apple_backup_excludeItem com.apple.backupd"

set cSourceCtx to "source " & quoted form of myCtx
set cCtxFormat to "mtxrun --selfupdate ; mtxrun --generate ; context --make cont-en"
set cListFontsAll to "mtxrun --script fonts --list --all"
set cFirstsetupUpdate to "rsync -ptv rsync://contextgarden.net/minimals/setup/first-setup.sh ."


################################################################################
################################################################################
# Script
################################################################################
################################################################################

testPaths()

################################################################################
# Modifier keys
################################################################################


# Execute the preset run delay to give time to any modifier key
delay runDelay

modifierKeyTest()

# Lock on product file
if keyDown's optionDown and keyDown's controlDown then
	regPrFile() of me
	return
	# Swap run mode (Terminal vs shell)
else if keyDown's shiftDown and keyDown's optionDown then
	set runModeSwap to true -- … or non-permanent swapping(?)
	# Swap auto-launching of pdf viewer
else if keyDown's shiftDown then
	set pdfViewerLaunchSwap to true
	# Swap Product mode (force Finder selection to be typeset)
else if keyDown's optionDown then
	set tsModeSwap to true -- … or non-permanent swapping(?)
else if keyDown's controlDown then
	set showList to true
end if


################################################################################
# Settings list
################################################################################

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
			if pdfViewerList is false then error number -128
			set pdfViewerList of theDefaults to pdfViewerList
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
	# Clean list from selections that shouldn’t be remembered
	set tmpList to mainList
	set mainList to {}
	repeat with i from 1 to the count of tmpList
		if item i of tmpList does not contain "Set PDF Viewer" and item i of tmpList does not contain "Tools" and item i of tmpList does not contain "egister" and item i of tmpList does not contain "Help" then
			set end of mainList to item i of tmpList
		end if
	end repeat
	set mainList of theDefaults to mainList
	set myCtx of theDefaults to myCtx
	set useJit of theDefaults to useJit
	set prMode of theDefaults to prMode
	set terminalMode of theDefaults to terminalMode
	set terminalWinForeground of theDefaults to terminalWinForeground
	set terminalWinRecycle of theDefaults to terminalWinRecycle
	set pdfViewerLaunch of theDefaults to pdfViewerLaunch
	set syncTex of theDefaults to syncTex
	set logViewerNormal of theDefaults to logViewerNormal
	set autoSyntaxCheck of theDefaults to autoSyntaxCheck
	set enableNotifications of theDefaults to enableNotifications
	set enableSound of theDefaults to enableSound
	set enableTMexclude of theDefaults to enableTMexclude
	return
end if


################################################################################
# Getting filename and paths
################################################################################

# Getting document
if (prMode and not tsModeSwap) or (not prMode and tsModeSwap) then
	if prFile is not "" then
		set fileName to prFile
	else
		getFromFinderOnly()
		fileNameStandardization()
	end if
	set defactoPrMode to true
else
	# Getting document from text editor app and then from Finder selection
	getFromEditorFirst()
	fileNameStandardization()
	set defactoPrMode to false
end if
filetypeCheck()

# Getting file name components
getFileNameComponents()
tell application previousApp to activate


################################################################################
# Other variables for the command string
################################################################################

# PDF viewer 
if (pdfViewerLaunch and not pdfViewerLaunchSwap) or (not pdfViewerLaunch and pdfViewerLaunchSwap) then
	set pdfOpen to " && open -b " & pdfViewer & space & quoted form of fileNameRoot & ".pdf"
else
	set pdfOpen to ""
end if

# Exclude aux files and – optionally – output PDF from Time Machine backup 
if enableTMexclude then
	set TMExclude to " && xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".pdf" & space & quoted form of fileNameRoot & ".tuc" & space & quoted form of fileNameRoot & ".log && [ ! -f" & space & quoted form of fileNameRoot & ".synctex.gz ] || xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".synctex.gz"
else
	set TMExclude to " && xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".tuc" & space & quoted form of fileNameRoot & ".log && [ ! -f" & space & quoted form of fileNameRoot & ".synctex.gz ] || xattr -w" & space & xattrTMExclusion & space & quoted form of fileNameRoot & ".synctex.gz"
end if

# Sounds
if enableSound then
	set makeFinishNoise to " && afplay " & quoted form of finishSound
	set makeAlertNoise to "afplay " & quoted form of alertSound
else
	set makeFinishNoise to ""
	set makeAlertNoise to ""
end if

# Case-specific log viewer
if not isFromFinder then
	set logViewer to logViewerNormal
else
	set logViewer to logViewerFinder
end if
if logViewer is "Current Editor" then set logViewer to targetApp

# Displayed info on ConTeXt installation
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

# Parent item (product folder / component folder in product mode | product file in normal mode)
if defactoPrMode and prFile is not "" then
	set {parentItem, showTsMode} to {"ƒ " & prFileFolder, "Product Mode"}
else if defactoPrMode then
	set {parentItem, showTsMode} to {"ƒ " & parentFolder, "Product Mode"}
else if not defactoPrMode and prFile is not "" then
	set {parentItem, showTsMode} to {prFileNameTail, "Normal Mode"}
else
	set {parentItem, showTsMode} to {"ƒ " & parentFolder, "Normal Mode"}
end if

# Notifications
set {notificationStart, notificationEnd} to {"", ""}

# ConTeXt and options
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

# Skim refresh
-- Can’t make this work ATM, so Skim refresh is currently limited to *non-terminal* typesetting mode
--
--if pdfViewer is "net.sourceforge.skim-app.skim" then
--	set pdfName to (fileNameHead & "/" & fileNameRoot & ".pdf")
--	set skimRefresh to " && osascript -e 'tell application \"Skim\"' -e 'set skimPDF to get documents whose path is " & quoted form of pdfName & "' -e 'if (count of skimPDF) greater than 0 then revert skimPDF' -e 'end tell'"
--else
--	set skimRefresh to ""
--end if


################################################################################
# Actual shell command strings
################################################################################

set typesetCmd to notificationStart ¬
	& "ulimit -n 1024 ; " & cSourceCtx ¬
	& " && cd " & quoted form of fileNameHead ¬
	& ctxRun ¬
	& optJit ¬
	& optSync ¬
	& optConsole ¬
	& quoted form of fileNameTail ¬
	& makeFinishNoise ¬
	& notificationEnd ¬
	& pdfOpen ¬
	& TMExclude

set autoCheckCmd to "cd " & quoted form of fileNameHead & " && " & cSourceCtx & " && { printf \"

---

Syntax checker says:

\" ; " & checkCmd & space & quoted form of fileNameTail & " ; } >> " & quoted form of fileNameRoot & ".log"

set logViewCmd to "cd " & quoted form of fileNameHead & " && open -a  " & logViewer & space & quoted form of fileNameRoot & ".log"


################################################################################
# Run
################################################################################

display notification parentItem & " | " & showTsMode with title showCtx & " | Started ☕️" subtitle quoted form of fileNameTail

if (not terminalMode and not runModeSwap) or (terminalMode and runModeSwap) then
	try
		do shell script typesetCmd
		display notification parentItem & " | " & showTsMode with title showCtx & " | Completed 🍺" subtitle quoted form of fileNameTail
		# Experimental: Proper Skim reload
		# Disable "Check for file changes" in Skim's prefs
		refreshSkim()
	on error
		do shell script makeAlertNoise
		try
			do shell script logViewCmd
		end try
		if autoSyntaxCheck then do shell script autoCheckCmd
		--error number -128
		return
	end try
else
	doTerminal(typesetCmd)
end if
set runCount to (runCount + 1)
if (runCount = 3) or (runCount = 9) or (runCount = 17) then firstTimeMessage()
set runCount of theDefaults to runCount


################################################################################
# Handlers
################################################################################

on getFileNameComponents()
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {"/"}
	set fileNameHead to text items 1 through -2 of fileName as text
	set fileNameTail to text item -1 of fileName
	set parentFolder to text item -2 of fileName
	set AppleScript's text item delimiters to {".tex"}
	set fileNameRoot to text item 1 of fileNameTail
	set AppleScript's text item delimiters to saveTID
	return
end getFileNameComponents

# 1st attempt: Get document from frontmost process
on getFromEditor()
	tell application "System Events"
		set targetApp to name of (first application process whose frontmost is true)
		# As of February 2015 BBEdit 11’s (10’s?)frontmost window is named 'window 2' instead of 'window 1'
		# So instead of switching to 'window 2' for BBEdit it is more robust
		# to use BBEdit's own AppleScript dictionary
		if targetApp is "BBEdit" then
			tell application "BBEdit"
				# Conditional is needed to preserve the variable in case of failure; Hmm, really?
				if name of text document 1 ends with ".tex" then
					set currentEditorFile to POSIX path of (file of text document 1 as alias)
					set isFromFinder to false
					set isFromBBEdit to true
				end if
			end tell
		else
			try
				tell application process targetApp
					# Conditional is needed to preserve the variable in case of failure; Hmm, really?
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

# Fallback in case our editor was pushed away from frontmost position 
# (e.g. if user compiled the script as application bundle, or by a launcher, …)
on restoreFrontmostApp()
	tell application "System Events"
		# if we are in Finder chances are high that we went there deliberately …
		if name of (first application process whose frontmost is true) is not "Finder" then
			set visible of the first application process whose frontmost is true to false
			delay 0.7
		end if
	end tell
end restoreFrontmostApp

# 2nd attempt: Get Finder selection
on getFromFinder()
	tell application "Finder"
		--activate
		try
			set finderSel to the selection
			if (count of finderSel) is greater than 1 then
				say "oohps"
				display alert "Please select 1 file." as warning
				error number -128
				# only update  if a tex file is selected; otherwise reuse the last valid selection
			else if (the finderSel as text) ends with ".tex" then
				set currentFinderFile to the finderSel as text
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
		tell frontmost application to set fileName to POSIX path of currentFinderFile
	else if isFromBBEdit then
		set fileName to currentEditorFile as text
	else
		# URL to POSIX; for document names obtained through GUI scripting
		try
			set fileName to urlToPOSIXPath(currentEditorFile)
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
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {"/"}
	set prFileNameTail to text item -1 of prFile
	set prFileFolder to text item -2 of prFile
	set prevPrFileNameTail to text item -1 of prevPrFile
	set AppleScript's text item delimiters to saveTID
	display notification "ƒ " & prFileFolder with title "Product file registered" subtitle prFileNameTail
	setPrFileDefaults()
	tell application previousApp to activate
	return prFile
end regPrFile

on unregPrFile()
	if prFile is "" then return
	set prevPrFile to prFile
	set prFile to ""
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {"/"}
	set prevPrFileNameTail to text item -1 of prevPrFile
	set AppleScript's text item delimiters to saveTID
	display notification "Previous product file: " & prevPrFileNameTail with title "Product file unregistered" subtitle prFileNameTail
	setPrFileDefaults()
	return
end unregPrFile

on reregPrFile()
	if prevPrFile is "" or prFile is equal to prevPrFile then return
	set tmpPrFile to prFile
	set prFile to prevPrFile
	set prevPrFile to tmpPrFile
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {"/"}
	set prFileNameTail to text item -1 of prFile
	set prFileFolder to text item -2 of prFile
	set prevPrFileNameTail to text item -1 of prevPrFile
	set AppleScript's text item delimiters to saveTID
	setPrFileDefaults()
	display notification "ƒ " & prFileFolder with title "Product file re-registered" subtitle prFileNameTail
	return
end reregPrFile

on setPrFileDefaults()
	set prFile of theDefaults to prFile
	set prFileNameTail of theDefaults to prFileNameTail
	set prevPrFile of theDefaults to prevPrFile
	set prevPrFileNameTail of theDefaults to prevPrFileNameTail
	set prFileFolder of theDefaults to prFileFolder
end setPrFileDefaults

on urlToPOSIXPath(theURL)
	set the urlString to current application's NSString's stringWithString:theURL
	set the textString to the (urlString's stringByReplacingPercentEscapesUsingEncoding:(current application's NSUTF8StringEncoding)) as string
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {"file://"}
	return text item -1 of the textString
	set AppleScript's text item delimiters to saveTID
end urlToPOSIXPath

on setPdfViewer()
	repeat with i in pdfViewerInventory
		if (item 1 of i is item 1 of pdfViewerList) then
			set pdfViewer to item 2 of i
			exit repeat
		end if
	end repeat
	set pdfViewer of theDefaults to pdfViewer
	return pdfViewer
end setPdfViewer

# Test for ConTeXt paths
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
				# In case user has disabled Spotlight or file is out of search scope of Spotlight
				display alert "Deep Search Needed" message "The first search run with Spotlight didn’t yield any results. Now searching with ‘find’ in Home, /Users/Shared, /Applications, /opt, /usr/local and /usr/share. 
					This may take a few seconds.
					
					Press OK to start deep search." buttons {"Cancel", "OK"} default button "OK" cancel button "Cancel"
				set foundSetuptex to do shell script "find $HOME /Users/Shared /Applications /opt /usr/local /usr/share -name 'setuptex' -maxdepth 6 | grep  '/tex/setuptex$' ; exit 0"
				-- Is the depth sufficient for nested install locations in ~/Library/ ?
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
	set ctxBeta of theDefaults to ctxBeta
	set ctxCurrent of theDefaults to ctxCurrent
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
					if window 1 is busy or window 1's processes contains "less" then -- Necessary?
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
		# Simple terminal launch with new instance for every typesetting
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
			# A more compact form for the clipboard
			set versionString to ctxBetaVersion & return & ctxCurrentVersion
			set theFind to {"(ConTeXt):\\s*", "\\r(LuaTeX):\\s*"}
			set theReplace to {"$1 ", "; $1 "}
			repeat with i from 1 to number of items in theFind
				set theText to (current application's NSString's stringWithString:versionString)
				set versionString to (theText's stringByReplacingOccurrencesOfString:(item i of theFind) withString:(item i of theReplace) options:(current application's NSRegularExpressionSearch) range:{0, theText's |length|()}) as text
			end repeat
			set the clipboard to versionString
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
	set pdfNameHead to POSIX file fileNameHead as text
	tell application "System Events"
		activate
		set pdfList to name of every file of the folder pdfNameHead whose name extension is "pdf"
		set pdfSelection to choose from list pdfList with title "Select PDFs to trash" with prompt "Hold down ⌘ to select multiple files." OK button name "OK" cancel button name "Cancel" multiple selections allowed yes empty selection allowed no
		if pdfSelection is false then error number -128
		set pdfTrashed to ""
		tell application "Finder"
			repeat with i in pdfSelection
				move file ((pdfNameHead & ":" & i) as text) to trash
				set pdfTrashed to pdfTrashed & ", " & i as text
			end repeat
		end tell
		-- TODO: At time of writing the above tell block was painfully slow. If this doesn’t improve, stay with System Events and use ‘delete’ (which deletes the files).
		-- Using ‘delete’ in the Finder doesn’t help, since it seems to be just an alias for ‘move to trash’.
		set pdfTrashed to (text items 3 through -1 of pdfTrashed) as text
		display notification pdfTrashed with title ((count of pdfSelection) as text) & space & "PDFs trashed"
	end tell
end _trashPdf

on makeFormatsBeta()
	doTerminal("source " & quoted form of ctxBeta & " && " & cCtxFormat)
end makeFormatsBeta

on makeFormatsCurrent()
	doTerminal("source " & quoted form of ctxCurrent & " && " & cCtxFormat)
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
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {"/"}
	set dirCtx to text items 1 through -3 of ctxToUpdate as text
	set dirNameCtx to text item -1 of dirCtx
	if backUpToSameLocation is true then set backupDir to text items 1 through -2 of dirCtx as text
	set AppleScript's text item delimiters to saveTID
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
			
			doTerminal("cd " & quoted form of dirCtx & " && tar -cf - . | " & p7z & " a -txz -si -bd -mx=5 " & quoted form of backupDir & "/" & quoted form of dirNameCtx & ".ctx-" & bakName & quoted form of ctxVersiondate & ".tar.xz && source " & quoted form of ctxToUpdate & " && " & cFirstsetupUpdate & " && sh ./first-setup.sh --context=" & updOption & " --engine=luatex --modules=all")
			
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
		tell application "Finder" to move POSIX file (backupDir & "/" & dirNameCtx & ".ctx-" & bakName & ctxVersiondate & "." & bakExt) as text to trash
	end try
end trashOldBak

on openDescription()
	tell application "Finder" to open descrFile
end openDescription

on doRound(theNumber, thePrecision)
	return (round (theNumber / thePrecision) ¬
		rounding as taught in school) * thePrecision
end doRound

# For debugging
--on checkFront()
--	tell application "System Events"
--		set currentApp to name of (first application process whose frontmost is true)
--		say currentApp
--	end tell
--end checkFront

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

on modifierKeyTest()
	set keyDown to {commandDown:false, optionDown:false, controlDown:false, shiftDown:false}
	
	set currentModifiers to current application's class "NSEvent"'s modifierFlags()
	
	tell keyDown
		set its optionDown to (currentModifiers div (get current application's NSAlternateKeyMask) mod 2 is 1)
		set its commandDown to (currentModifiers div (get current application's NSCommandKeyMask) mod 2 is 1)
		set its shiftDown to (currentModifiers div (get current application's NSShiftKeyMask) mod 2 is 1)
		set its controlDown to (currentModifiers div (get current application's NSControlKeyMask) mod 2 is 1)
	end tell
	
	return keyDown
end modifierKeyTest


# üè (encoding test chars)
