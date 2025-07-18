<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        <span>Register</span>
    <#elseif section = "form">
        <form id="kc-register-form" class="${properties.kcFormClass!} custom-form" action="${url.registrationAction}" method="post">
        <div class='form-col'>
            <div class="${properties.kcFormGroupClassCustom!}">
                <div class="${properties.kcLabelWrapperClassCustom!}">
                    <label for="firstName" class="${properties.kcLabelClass!}">${msg("firstName")}</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="firstName" class="${properties.kcInputClass!}" name="firstName"
                        value="${(register.formData.firstName!'')}"
                        aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                        placeholder="Enter first name" />

                    <#if messagesPerField.existsError('firstName')>
                        <span id="input-error-firstname" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <div class="${properties.kcFormGroupClassCustom!}">
                <div class="${properties.kcLabelWrapperClassCustom!}">
                    <label for="lastName" class="${properties.kcLabelClass!}">${msg("lastName")}</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="lastName" class="${properties.kcInputClass!}" name="lastName"
                        value="${(register.formData.lastName!'')}"
                        aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                        placeholder="Enter last name" />

                    <#if messagesPerField.existsError('lastName')>
                        <span id="input-error-lastname" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>
        </div>

        <div id='form-col-full' class="${properties.kcFormGroupClassCustom!}">
            <div class="${properties.kcLabelWrapperClassCustom!}">
                <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
            </div>
            <div class="${properties.kcInputWrapperClass!}">
                <input type="text" id="email" class="${properties.kcInputClass!}" name="email"
                    value="${(register.formData.email!'')}" autocomplete="email"
                    aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                    placeholder="you@example.com" />

                <#if messagesPerField.existsError('email')>
                    <span id="input-error-email" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('email'))?no_esc}
                    </span>
                </#if>
            </div>
        </div>

        <#if !realm.registrationEmailAsUsername>
            <div class="${properties.kcFormGroupClassCustom!}">
                <div class="${properties.kcLabelWrapperClassCustom!}">
                    <label for="username" class="${properties.kcLabelClass!}">${msg("username")}</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="username" class="${properties.kcInputClass!}" name="username"
                        value="${(register.formData.username!'')}" autocomplete="username"
                        aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                        placeholder="Enter username" />

                    <#if messagesPerField.existsError('username')>
                        <span id="input-error-username" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>
        </#if>

        <div class='form-col'>
            <#if passwordRequired??>
            <div class="${properties.kcFormGroupClassCustom!}" style="position: relative;">
                <div class="${properties.kcLabelWrapperClassCustom!}">
                    <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                </div>
                <div style="position: relative;">
                    <input type="password" id="password" class="${properties.kcInputClass!}" name="password"
                        autocomplete="new-password"
                        aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                        placeholder="Enter password" />

                    <img id="togglePassword" src="${url.resourcesPath}/img/eye.svg" alt="Toggle Password Visibility"
                        style="position: absolute; top: 50%; right: 16px; transform: translateY(-50%); cursor: pointer; width: 20px; height: 20px;" />

                    
                </div>
                <#if messagesPerField.existsError('password')>
                        <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
            </div>

            <div class="${properties.kcFormGroupClassCustom!}" style="position: relative;">
                <div class="${properties.kcLabelWrapperClassCustom!}">
                    <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>
                </div>
                <div style="position: relative;">
                    <input type="password" id="password-confirm" class="${properties.kcInputClass!}" name="password-confirm"
                        autocomplete="new-password" placeholder="Confirm password" />

                    <img id="togglePasswordConfirm" src="${url.resourcesPath}/img/eye.svg" alt="Toggle Password Visibility"
                        style="position: absolute; top: 50%; right: 16px; transform: translateY(-50%); cursor: pointer; width: 20px; height: 20px;" />

                    
                </div>
                <#if messagesPerField.existsError('password-confirm')>
                        <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                        </span>
                    </#if>
            </div>
            </#if>
        </div>
        <div class="${properties.kcFormGroupClass!}">
            <div class="${properties.kcInputWrapperClass!}">
                <label for="acceptTerms" class="checkbox-container" style="display: flex; align-items: flex-start; gap: 10px;padding-top:20px">
                    <input type="checkbox" id="acceptTerms" name="acceptTerms" required style="margin-top: 3px;">
                    <span class="terms-text" style="font-size: 14px;">
                        I have read and agree with 
                        <a href="https://tgdex.telangana.gov.in/terms-of-service" target="_blank">Terms of Service</a> 
                        and 
                        <a href="https://tgdex.telangana.gov.in/privacy-policy" target="_blank">Privacy Policy</a>
                        of Forest Stack.
                    </span>
                </label>
                <#if messagesPerField.existsError('acceptTerms')>
                    <span id="input-error-acceptTerms" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('acceptTerms'))?no_esc}
                    </span>
                </#if>
            </div>
        </div>

        <#if recaptchaRequired??>
            <div class="form-group">
                <div class="${properties.kcInputWrapperClass!}">
                    <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                </div>
            </div>
        </#if>

        <div class="${properties.kcFormGroupClass!} bottom-align">
            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doRegister")}" />
            </div>
            <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                <div class="${properties.kcFormOptionsWrapperClass!}">
                    <span class="${properties.kcLoginHelperText}">${msg("kcLoginHelperText")}<a class="${properties.kcLoginText}" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></span>
                </div>
            </div>
        </div>
        </form>

        <script>
        document.addEventListener("DOMContentLoaded", function () {
            function setupToggle(inputId, toggleId) {
                const input = document.getElementById(inputId);
                const toggle = document.getElementById(toggleId);

                toggle.addEventListener("click", function () {
                    const isPassword = input.type === "password";
                    input.type = isPassword ? "text" : "password";
                    toggle.src = "${url.resourcesPath}/img/eye.svg";
                });
            }

            setupToggle("password", "togglePassword");
            setupToggle("password-confirm", "togglePasswordConfirm");
        });
        </script>
    </#if>
</@layout.registrationLayout>
