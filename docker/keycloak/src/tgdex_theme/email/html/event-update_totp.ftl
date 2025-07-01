    <#import "template.ftl" as layout>
    <@layout.emailLayout>
   <html>
  <body style="font-family: Arial, sans-serif; line-height: 1.6;">
    <p>${msg("emailVerification.greeting")}</p>

    <p>${msg("emailVerification.intro")}</p>

    <p>${msg("emailVerification.instructions")}</p>

    <p>
      <a href="${link}">${msg("emailVerification.link")}</a>
    </p>

    <p>${msg("emailVerification.note")}</p>

    <p>${msg("emailVerification.ignore")}</p>


    <p>
      ${msg("emailVerification.thanks")}<br/>
      ${msg("emailVerification.team")}
    </p>
  </body>
</html>

  <p>Regards,<br/>TGDEX Team</p>
</@layout.emailLayout>