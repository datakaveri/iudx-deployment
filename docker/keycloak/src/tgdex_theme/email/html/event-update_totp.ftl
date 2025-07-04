<#import "template.ftl" as layout>
<@layout.emailLayout>
  <p>If you are trying to login to the <strong>TGDeX Platform</strong>, please use the temporary login code below:</p>
  <p style="font-size: 24px; font-weight: bold; letter-spacing: 4px; text-align: center; margin: 20px 0;">
    ${otp}
  </p>
  <p>This code is valid for 5 minutes.</p>
  <p>Regards,<br>
  <strong>TGDeX Team</strong></p>
</@layout.emailLayout>