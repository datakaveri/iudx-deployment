<#macro emailLayout>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>TGDeX Platform Login OTP</title>
  </head>
  <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
  
     <h2 style="color: #179c63;">TGDeX Platform Login OTP</h2>
    
      <p>If you are trying to login to the TGDeX Platform, please use the temporary login code below:</p>
     
      <pre style="font-size: 1.5em; text-align: center; background: #f5f5f5; padding: 10px; border-radius: 5px;">
        ${otp}
      </pre>
      
     <p>This code is valid for 5 minutes.</p>

    <p>Regards,<br>
    <strong>TGDeX Team</strong></p>
  </body>
</html>

<#-- Subject -->
<#assign subject = "TGDeX Platform Login OTP" />

<#-- Email Body -->
<p>If you are trying to login to the TGDeX Platform, please use the temporary login code below:</p>

<pre style="font-size: 1.5em; text-align: center; background: #f5f5f5; padding: 10px; border-radius: 5px;">
        ${otp}
</pre>

<p>This code is valid for 5 minutes.</p>

<br/>

<p>Regards,</p>
<p><strong>TGDEX Team</strong></p>

</#macro>