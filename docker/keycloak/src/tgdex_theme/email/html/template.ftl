<#macro emailLayout>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>${msg("emailTitle")!}</title>
  </head>
  <body style="font-family: Arial, sans-serif; background-color: #f6f6f6; padding: 20px; color: #333;">
    <#assign subject = "TGDeX Platform Login OTP" />

<p>If you are trying to login to the TGDeX Platform, please use the temporary login code below:</p>

<h2 style="text-align: center; font-size: 24px; letter-spacing: 4px;">
    ${otp}
</h2>

<p>This code is valid for 5 minutes.</p>

<br/>

<p>Regards,</p>
<p><strong>TGDEX Team</strong></p>
  </body>
</html>


<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>${msg("emailTitle")!}</title>
  </head>
  <body style="font-family: Arial, sans-serif; background-color: #f6f6f6; padding: 20px; color: #333;">
    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; margin: auto; background-color: #ffffff; padding: 20px; border-radius: 6px;">
      <tr>
        <td>
          <#nested>
        </td>
      </tr>
    </table>
    <p style="text-align: center; font-size: 12px; color: #999;">
      &copy; ${.now?string("yyyy")} Your Company. All rights reserved.
    </p>
  </body>
</html>
</#macro>