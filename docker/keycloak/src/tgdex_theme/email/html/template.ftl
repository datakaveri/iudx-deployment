<#macro emailLayout>
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