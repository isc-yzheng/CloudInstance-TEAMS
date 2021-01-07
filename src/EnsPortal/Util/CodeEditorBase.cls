/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// Base class to implement common code editor code to allow for code indentation and
/// similar functionality.
Class EnsPortal.Util.CodeEditorBase [ Abstract, System = 4 ]
{

/// Keypress handler for Zen textarea controls which automatically inserts the indentation
/// used on the previous line of the control when the user hits the Enter key.
/// Note that the actual whitespace determination is performed in <method>getPrevWhitespace</method>().
ClientMethod codeKeyPress(zenControl, evt) [ Language = javascript ]
{
	if (zenControl && evt) {
		var control = zenControl.findElement('control');
		var keyCode = (evt.keyCode ? evt.keyCode : evt.which);
		if (control && (keyCode == zenENTER)) {
			var value = control.value;
			var valBefore, valAfter;
			if ((typeof control.selectionStart == 'number') && (typeof control.selectionEnd == 'number')) {
				valBefore = value.substring(0,control.selectionStart);
				valAfter = value.substring(control.selectionStart);
				var whitespace = zenPage.getPrevWhitespace(valBefore);
				control.value = valBefore + '\n' + whitespace + valAfter;
				
				control.selectionStart = control.value.length - valAfter.length;
				control.selectionEnd = control.selectionStart;
				return false;
			}
			else {
				var range = document.selection.createRange();
				if (range && (range.parentElement() == control)) {
					var textRange = control.createTextRange();
					var startRange = control.createTextRange();
					textRange.moveToBookmark(range.getBookmark());
					startRange.setEndPoint('EndToStart',textRange);
					
					valBefore = value.substring(0,startRange.text.length);
					valAfter = value.substring(startRange.text.length);
					var whitespace = zenPage.getPrevWhitespace(valBefore);
					
					control.value = valBefore + '\r\n' + whitespace + valAfter;;
					textRange = control.createTextRange();
					var newPos = valBefore.length - (valBefore.split('\r\n').length - 1) + 1 + whitespace.length;
					textRange.move('character',newPos);
					textRange.select();
					return false;
				}
			}
			
		}
	}
	return true;
}

/// Helper method to indicate what the indentation for the last line in <var>previousData</var> was.
/// If the line didn't have any indentation, two space characters are returned.
ClientMethod getPrevWhitespace(previousData) [ Language = javascript ]
{
	var whitespace = '  ';
	if (typeof previousData == 'string') {
		// note that \r\n on IE is ignored - we only care about the data after the \n
		var prevLine = previousData.split('\n').pop();
		var whitespaceMatch = prevLine.match(/^(\s+)/);
		if (whitespaceMatch) {
			whitespace = whitespaceMatch[0];
		}
	}
	return whitespace;
}

}
