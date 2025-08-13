<#import "template.ftl" as layout>
<@layout.emailLayout>
  <h2 style="color: #179c63;">Your One-Time Password</h2>
  <p>Hello ${user.firstName},</p>
  <p>Your OTP is: <strong>${otp}</strong></p>
  <p>This code will expire in 10 minutes.</p>
</@layout.emailLayout>