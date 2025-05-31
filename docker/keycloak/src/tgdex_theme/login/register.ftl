<#import "template.ftl" as layout>
<#import "register-commons.ftl" as registerCommons>

<@layout.registrationLayout displayMessage=messagesPerField.exists('global') displayRequiredFields=true; section>
    <#if section = "header">
        <div class="logo-container">
            <img src="${url.resourcesPath}/img/Vertical_Green.png" alt="Logo" class="login-logo">
        </div>
        <#if messageHeader??>
            ${kcSanitize(msg("${messageHeader}"))?no_esc}
        <#else>
            ${msg("registerTitle")}
            <div class="custom-pf-form-subTitle">${msg("registerAccountSubtitle")}</div>
        </#if>

    <#elseif section = "form">
        <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">

          <!-- First Name Field -->
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="firstName" class="${properties.kcLabelClass!}">First Name</label> <span  style="color: red;"> *</span>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="firstName" name="firstName" class="${properties.kcInputClass!}"
                           value="${(register.formData.firstName!'')}" placeholder="Enter first name" required />
                    <#if messagesPerField.existsError('firstName')>
                        <span id="input-error-firstName" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <!-- Last Name Field -->
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="lastName" class="${properties.kcLabelClass!}">${msg("lastName")}</label> <span  style="color: red;"> *</span>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="lastName" name="lastName" class="${properties.kcInputClass!}"
                           value="${(register.formData.lastName!'')}" placeholder="Enter last name" required />
                    <#if messagesPerField.existsError('lastName')>
                        <span id="input-error-lastName" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <!-- Email Field -->
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label> <span  style="color: red;"> *</span>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="email" id="email" name="email" class="${properties.kcInputClass!}"
                           value="${(register.formData.email!'')}" placeholder="Enter email" required />
                    <#if messagesPerField.existsError('email')>
                        <span id="input-error-email" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('email'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

          

            <!-- Password Field -->
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label><span  style="color: red;"> *</span>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="password" id="password" name="password" class="${properties.kcInputClass!}"
                           autocomplete="new-password" placeholder="Enter Password"
                           aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>" required />
                    <#if messagesPerField.existsError('password')>
                        <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <!-- Password Strength -->
            <div id="password-strength-container" style="display: none; padding: 20px;">
                <div id="password-strength-bar"></div>
                <div id="password-strength-text"><strong>Password Level:</strong> <span id="strength-label">-</span></div>
                <ul id="password-rules">
                    <li id="rule-length">Minimum number of characters is 8 and maximum is 20.</li>
                    <li id="rule-lowercase">Should contain lowercase.</li>
                    <li id="rule-uppercase">Should contain uppercase.</li>
                    <li id="rule-number">Should contain numbers.</li>
                    <li id="rule-special">Should contain special characters.</li>
                </ul>
            </div>

            <!-- Confirm Password Field -->
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label> <span  style="color: red;"> *</span>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="password" id="password-confirm" name="password-confirm" class="${properties.kcInputClass!}"
                           autocomplete="new-password" placeholder="Enter confirm password"
                           aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" required />
                    <#if messagesPerField.existsError('password-confirm')>
                        <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                        </span>
                        
                    </#if>
                </div>
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
                of TGDeX.
            </span>
        </label>
        <#if messagesPerField.existsError('acceptTerms')>
            <span id="input-error-acceptTerms" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                ${kcSanitize(messagesPerField.get('acceptTerms'))?no_esc}
            </span>
        </#if>
    </div>
</div>

            <@registerCommons.termsAcceptance/>

            <#if recaptchaRequired?? && (recaptchaVisible!false)>
                <div class="form-group">
                    <div class="${properties.kcInputWrapperClass!}">
                        <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
                    </div>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <#if recaptchaRequired?? && !(recaptchaVisible!false)>
                    <script>
                        function onSubmitRecaptcha(token) {
                            document.getElementById("kc-register-form").requestSubmit();
                        }
                    </script>
                    <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                        <button class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!} g-recaptcha" 
                                data-sitekey="${recaptchaSiteKey}" data-callback='onSubmitRecaptcha' data-action='${recaptchaAction}' type="submit">
                            ${msg("doRegister")}
                        </button>
                    </div>
                <#else>
                    <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                        <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" 
                               type="submit" value="${msg("doRegister")}"/>
                    </div>
                </#if>
            </div>
        </form>

        <script>
        document.addEventListener("DOMContentLoaded", function () {
            const emailField = document.querySelector('input[name="email"]');
            if (emailField) {
                emailField.value = "";
            }
        });
        </script>

        <script>
        document.addEventListener("DOMContentLoaded", function () {
            const passwordInput = document.getElementById("password");
            const strengthContainer = document.getElementById("password-strength-container");
            const strengthBar = document.getElementById("password-strength-bar");
            const strengthLabel = document.getElementById("strength-label");
            const form = document.getElementById("kc-register-form");

            const rules = {
                length: document.getElementById("rule-length"),
                lowercase: document.getElementById("rule-lowercase"),
                uppercase: document.getElementById("rule-uppercase"),
                number: document.getElementById("rule-number"),
                special: document.getElementById("rule-special")
            };

            function validatePassword(password) {
                if (!password) {
                    strengthContainer.style.display = "none";
                    return false;
                } else {
                    strengthContainer.style.display = "block";
                }

                const validations = {
                    length: password.length >= 8 && password.length <= 20,
                    lowercase: /[a-z]/.test(password),
                    uppercase: /[A-Z]/.test(password),
                    number: /[0-9]/.test(password),
                    special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
                };

                let score = 0;
                Object.entries(validations).forEach(([ruleId, isValid]) => {
                    const ruleElement = rules[ruleId];
                    if (ruleElement) {
                        ruleElement.className = isValid ? "valid" : "invalid";
                        const textWithoutIcon = ruleElement.textContent.replace(/^✓ |^✗ /, "");
                        ruleElement.textContent = (isValid ? "✓ " : "✗ ") + textWithoutIcon;
                        if (isValid) score++;
                    }
                });

                strengthBar.className = "";
                if (score <= 2) {
                    strengthBar.classList.add("weak");
                    strengthLabel.textContent = "Weak";
                } else if (score <= 4) {
                    strengthBar.classList.add("medium");
                    strengthLabel.textContent = "Medium";
                } else {
                    strengthBar.classList.add("strong");
                    strengthLabel.textContent = "Strong";
                }

                return Object.values(validations).every(v => v === true);
            }

            passwordInput.addEventListener("input", function () {
                validatePassword(this.value);
            });

            form.addEventListener("submit", function (e) {
                const isValid = validatePassword(passwordInput.value);
                if (!isValid) {
                    e.preventDefault();
                }
            });
        });
        </script>

        <div style="padding-left: 30px;margin-bottom: 20px;font-size:14px">
            <span>Already have an account? </span>
            <a href="${url.loginUrl}" style="color: green; font-weight: bold;">Login</a>
        </div>
    </#if>
</@layout.registrationLayout>
