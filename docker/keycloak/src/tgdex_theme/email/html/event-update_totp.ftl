    <#import "template.ftl" as layout>
    <@layout.emailLayout>
      <h2 style="color: #179c63;">TGDeX Platform Login OTP</h2>
      <p>If you are trying to login to the TGDeX Platform, please use the temporary login code below:</p>
      <pre style="font-size: 1.5em; text-align: center; background: #f5f5f5; padding: 10px; border-radius: 5px;">
        ${otp}
      </pre>
      <p>This code is valid for 5 minutes.</p>
      <p>Regards,<br/>TGDEX Team</p>
    </@layout.main>
  <p>This code is valid for 5 minutes.</p>
  <p>Regards,<br/>TGDEX Team</p>
</@layout.emailLayout>