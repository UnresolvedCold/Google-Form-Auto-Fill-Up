;Global Variables
;Address of the form
$adrs="https://docs.google.com/forms/d/e/1FAIpQLScI_lKrLE3jon2qXFj_03CZ8rQZ2dn4V7Px7SVunRZahlXyhg/viewform"
;Title of the form
$form="Know it before you do it - UC Browser"
;Trace if there is a refill button
$CanSbmtAnthrRes=1
;Wait Time
$time=5000
;Number of Response
$nResponse=1
;No. of questions
$nQuestions=31
;Browser
$browser="C:\Program Files (x86)\UCBrowser\Application\UCBrowser.exe"

;init Q
;Take values from User
$adrs=InputBox("Form Adress","Enter the address of form","","")
 If $adrs=='' Then Exit
$form=InputBox("Enter the title of the form","form title is one shown in uc browser title","","")&" - UC Browser"
 If $form=='' Then Exit
$CanSbmtAnthrRes=InputBox("Is submitting another response allowed in Form","Can I submit multi response? 0=no 1=yes","","")
 If $CanSbmtAnthrRes=='' Then $CanSbmtAnthrRes=0
$time=InputBox("Enter the waiting time for form load","Generally between the range 5000 to 10000","","")
 If $time=='' Then $time=5000
$nResponse=InputBox("Enter the number of response to simulate","Number of responses","","")
 If $nResponse=='' Then Exit
$nQuestions=InputBox("Enter the total number of questions in the form","Number of questions","","")
 If $nQuestions=='' Then Exit

;Variables arb
$i=1
$j=1
Dim $Array[$nQuestions+1] ;answer for a question
Dim $RandomM[$nQuestions+1] ;track if random or not
Dim $RandValue1[$nQuestions+1];
Dim $RandValue2[$nQuestions+1];
;Logic
;Init the value of response in each case
For $k=1 To $nQuestions
   $resp = InputBox("Question"&$k, "Enter Response Number"&@CRLF&"r-1-3 = random b/w 1 and 3"&@CRLF&"ar-1-3 = random from this question to last"&@CRLF&"s-Say My Name = string =Say My Name", "", "")
   $Random= StringSplit($resp,"-");2-3 nos 1- delim
   If $resp=='' Then
	  Exit
   ElseIf $Random[1]=="r" Then
	  $RandomM[$k]=$Random[1]
	  $RandValue1[$k]=$Random[2]
	  $RandValue2[$k]=$Random[3]
   ElseIf $Random[1]=="s" Then
	  $Array[$k]=$Random[2]
   ElseIf $Random[1]=="ar" Then
	  For $l=$k To $nQuestions
		 $RandomM[$l]="r"
		 $RandValue1[$l]=$Random[2]
		 $RandValue2[$l]=$Random[3]
	  Next
	  ExitLoop
   Else
	  $Array[$k]=$resp
   EndIf
Next

;Open the form in UC Browser

BlockInput(1)

Run($browser)
WinWaitActive("New Tab - UC Browser")
Send($adrs)
Send("{ENTER}")
While $j<=$nResponse
   ;Generate Random nos if activated
   For $k=1 To $nQuestions
		  If $RandomM[$k]=="r" Then
			   $Array[$k]=Random($RandValue1[$k],$RandValue2[$k],1)
		 EndIf
   Next
   ;Wait till form activates
   ;used sleep for temp uses
   Sleep($time)
   $i=1
   While $i<=$nQuestions
	  ;Repeat for all questions
	  Send("{TAB}")
	  ;Choose the option
	  If $RandomM[$i]=="s" Then

		 ;ControlSend($form,$Array[$k])
		 Sleep(1000)
	  Else
		 If $Array[$i]==1 Then
			Send("{DOWN}")
			Send("{UP}")
			Send("{SPACE}")
			Sleep(1000)
		 ElseIf $Array[$i]>1 Then
			$count=$Array[$i]-1
			For $l=1 To $count;select the option
			Send("{DOWN}")
			Next
			Send("{SPACE}")
			Sleep(1000)
		 EndIf
	  EndIf
	  $i=$i+1
   WEnd
   ;Submit
   Send("{TAB}")
   Send("{ENTER}")
   ;Next Form
   Sleep(5000)
   Send("{TAB}")
   Send("{ENTER}")
   Sleep(5000)
   $j=$j+1
WEnd
Send("!{F4}")
Sleep(2000)
Send("{ENTER}")
BlockInput(0)
MsgBox(0,"Done","Number of response submitted = "&$nResponse)

