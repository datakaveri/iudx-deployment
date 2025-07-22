<#macro emailLayout>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
  </head>
  <p>If you are tying to login, please use the temporary login code below:
  <body style="font-family: Arial, sans-serif; background-color: #f6f6f6; padding: 20px; color: #333;">
    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; margin: auto; background-color: #ffffff; padding: 20px; border-radius: 6px;">
      <tr>
        <td>
          <#nested>
        </td>
      </tr>
    </table>
  </body>
  <p>Regards,<br/></p>
</html>
</#macro>