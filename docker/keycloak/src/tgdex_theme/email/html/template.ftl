<#macro emailLayout>
<#-- otp-email.ftl -->
<#-- Subject -->
<#assign subject = "TGDeX Platform Login OTP" />

<#-- Email Body -->
<p>If you are trying to login to the TGDeX Platform, please use the temporary login code below:</p>

<h2 style="text-align: center; font-size: 24px; letter-spacing: 4px;">
    ${otp!''}
</h2>

<p>This code is valid for 5 minutes.</p>

<br/>

<p>Regards,</p>
<p><strong>TGDEX Team</strong></p>
</#macro>