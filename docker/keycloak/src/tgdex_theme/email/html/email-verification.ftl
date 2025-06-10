<html>
<body>
${msg("emailVerificationBodyHtml",link, linkExpiration, realmName)}
<div> ${msg("emailVerificationBody1")} </div>
<br />

<p>
	${msg("emailVerificationBody2")}
</p>
<br />

<p>
	${msg("emailVerificationBody3")}
</p>
<br />
<p>
	<Verification Link>${msg("emailVerificationBody4"),link}

	</Verification>
</p>
</body>
</html>
