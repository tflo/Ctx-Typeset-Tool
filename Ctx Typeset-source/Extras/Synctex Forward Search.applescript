# Script name: Synctex Forward Search for BBEdit
# Author: Thomas Floeren <thomas.floeren@wop-networks.com>
# Copyright (C) 2014 Thomas Floeren
# Do not distribute or publish this script without permission of the author
# Version: 1.0 (5) [2014-06-02]

--------------------------------------------------------------------------------
-- DESCRIPTION
--------------------------------------------------------------------------------

-- Put the script into BBEdit's Scripts Folder

-- Make sure there is a product line in the component's first lines, for example "\product  prd_p3_de_E5". The name must not contain spaces.

-- Works from within subcomponents (\readjobfile… etc.) that are in a different folder, only if subcomponent and product file are in an open BBEdit project.

--------------------------------------------------------------------------------
-- VARIABLES
--------------------------------------------------------------------------------

set isSubComponent to false

--------------------------------------------------------------------------------
-- SCRIPT
--------------------------------------------------------------------------------

tell application "BBEdit"
	-- tell window 1
	
	# The "src" variables refer to the actually open tex file (usually a standalone source file or a component file)
	# The "prd" variables refer to the product file as defined in the source file's first lines
	
	set srcName to POSIX path of ((file of document 1) as alias)
	
	set storedDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to "/"
	
	set srcHead to (text items 1 thru -2 of srcName) as text
	
	# Looking for "\product <productname>" in the file header
	find "^\\\\product\\s*(\\S*)\\s*$" searching in lines 1 thru 12 of document 1 options {search mode:grep}
	
	# A. If we have a product file
	if found of the result then
		set prdRoot to grep substitution of "\\1"
		set prdTail to prdRoot & ".tex"
		
		set pdfName to srcHead & "/" & prdRoot & ".pdf"
		
		# If file pdfName doesn't exist on that path => source file must be a subcomponent
		tell application "Finder" to if not (exists (pdfName as POSIX file)) then set isSubComponent to true
		if isSubComponent then
			set prdName to POSIX path of (file (project item prdTail of project document 1))
			set prdHead to (text items 1 thru -2 of prdName) as text
			set pdfName to prdHead & "/" & prdRoot & ".pdf"
		end if
		
		# B. If there is no product file
	else
		set AppleScript's text item delimiters to storedDelimiters
		set pdfName to ((items 1 thru -4 of srcName) as text) & "pdf"
	end if
	
	set AppleScript's text item delimiters to storedDelimiters
	
	# There seems to be a general offset of a couple of lines
	set lineNumber to ((startLine of selection) + 5)
	
end tell


try
	do shell script "/Applications/Skim.app/Contents/SharedSupport/displayline -b" & space & lineNumber & space & quoted form of pdfName & space & quoted form of srcName
on error errmsg
	display alert errmsg
	error number -128
end try

