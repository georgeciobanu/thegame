$(function() {
    $("form").submit(function() { return false; });
});

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^(("[\w-+\s]+")|([\w-+]+(?:\.[\w-+]+)*)|("[\w-+\s]+")([\w-+]+(?:\.[\w-+]+)*))(@((?:[\w-+]+\.)*\w[\w-+]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][\d]\.|1[\d]{2}\.|[\d]{1,2}\.))((25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\.){2}(25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
}

function submitEmail() {
	var email = document.getElementById('email').value;
	if(email == '' || !isValidEmailAddress(email))
		document.getElementById('msg').innerHTML = "'" + email + "': is not a valid Email address";		 	
	else
		jQuery.post( '/emails.json', {'email': {'email': email}}, emailAdded );		
}

function emailAdded(data) {
	if(data.email != null)
		document.getElementById('msg').innerHTML = data.email + ' added<br />';
	else
		document.getElementById('msg').innerHTML = 'Email not added. Please try again later';		 	
}