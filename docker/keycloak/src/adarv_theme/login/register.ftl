<#import "template.ftl" as layout>
<#import "register-commons.ftl" as registerCommons>

<@layout.registrationLayout displayMessage=messagesPerField.exists('global') displayRequiredFields=true; section>
    <#if section = "header">
        <#if messageHeader??>
            ${kcSanitize(msg("${messageHeader}"))?no_esc}
        <#else>
            ${msg("registerTitle")}
            <div class="custom-pf-form-subTitle">${msg("registerAccountSubtitle")}</div>
        </#if>
    <#elseif section = "form">
        <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">

            <!-- First Name Field --> 
            <div class="${properties.kcFormGroupClass!} pt-2">
                <div class="${properties.kcLabelWrapperClass!} label-column" style="width:fit-content">
                    <label for="firstName" class="${properties.kcLabelClass!}">First Name</label> 
                </div>
                <div class="${properties.kcInputWrapperClass!} input-column">
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
            <div class="${properties.kcFormGroupClass!} pt-2">
                <div class="${properties.kcLabelWrapperClass!} label-column" style="width:fit-content">
                    <label for="lastName" class="${properties.kcLabelClass!}">Last Name</label> 
                </div>
                <div class="${properties.kcInputWrapperClass!} input-column">
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
            <div class="${properties.kcFormGroupClass!} pt-2">
                <div class="${properties.kcLabelWrapperClass!} label-column" style="width:fit-content">
                    <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label> 
                </div>
                <div class="${properties.kcInputWrapperClass!} input-column">
                    <input type="email" id="email" name="email" class="${properties.kcInputClass!}"
                           value="${(register.formData.email!'')}" placeholder="Enter email" required />
                    <#if messagesPerField.existsError('email')>
                        <span id="input-error-email" class="${properties.kcInputErrorMessageClass!} emailExistsError" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('email'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <!-- Password Field -->
            <div class="${properties.kcFormGroupClass!} pt-2">
                <div class="${properties.kcLabelWrapperClass!} label-column" style="width:fit-content">
                    <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                </div>
                <div class="${properties.kcInputWrapperClass!} input-column">
                    <input type="password" id="password" name="password" class="${properties.kcInputClass!}"
                           autocomplete="new-password" placeholder="Enter Password"
                           aria-invalid="<#if messagesPerField.existsError('password')>true</#if>" required />
                    <#if messagesPerField.existsError('password')>
                        <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>

            <!-- Confirm Password Field -->
            <div class="${properties.kcFormGroupClass!} pt-2">
                <div class="${properties.kcLabelWrapperClass!} label-column" style="width:fit-content">
                    <label for="password-confirm" class="${properties.kcLabelClass!}">Confirm Password</label>
                </div>
                <div class="${properties.kcInputWrapperClass!} input-column">
                    <input type="password" id="password-confirm" name="password-confirm" class="${properties.kcInputClass!}"
                           autocomplete="new-password" placeholder="Re-enter Password" required />
                    <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite" style="display:none;"></span>
                </div>
            </div>

            <!-- Password Strength -->
            <div id="password-strength-container" style="padding: 20px;">
                <ul id="password-rules" style="display: flex; flex-wrap: wrap; gap: 8px; list-style: none; padding: 0;">
                    <li id="rule-length" class="password-rule-pill">8–20 characters</li>
                    <li id="rule-uppercase" class="password-rule-pill">Uppercase (A–Z)</li>
                    <li id="rule-lowercase" class="password-rule-pill">Lowercase (a–z)</li>
                    <li id="rule-number" class="password-rule-pill">Number (0–9)</li>
                    <li id="rule-special" class="password-rule-pill">Special character (e.g. !@#$&amp;*)</li>
                    <li id="rule-simple" class="password-rule-pill">Avoid simple words or sequences like password, admin, 1234 or abcd</li>
                </ul>
            </div>

            <!-- reCAPTCHA -->
            <#if recaptchaRequired?? && (recaptchaVisible!false)>
                <div class="form-group">
                    <div class="${properties.kcInputWrapperClass!}">
                        <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
                    </div>
                </div>
            </#if>

            <!-- Submit Button -->
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

        <!-- Clear email field on load -->
        <script>
        document.addEventListener("DOMContentLoaded", function () {
            const emailField = document.querySelector('input[name="email"]');
            if (emailField) {
                emailField.value = "";
            }
        });
        </script>

        <!-- Password Strength Validation Script -->
        <script>
        document.addEventListener("DOMContentLoaded", function () {
            const passwordInput = document.getElementById("password");
            const passwordConfirmInput = document.getElementById("password-confirm");
            const strengthContainer = document.getElementById("password-strength-container");
            const form = document.getElementById("kc-register-form");

            // Last Name validation
            const lastNameInput = document.getElementById("lastName");

            const rules = {
                length: document.getElementById("rule-length"),
                lowercase: document.getElementById("rule-lowercase"),
                uppercase: document.getElementById("rule-uppercase"),
                number: document.getElementById("rule-number"),
                special: document.getElementById("rule-special"),
                simple: document.getElementById("rule-simple")
            };

            function validatePassword(password) {
                if (!password) {
                    strengthContainer.style.display = "block";
                    Object.entries(rules).forEach(([ruleId, ruleElement]) => {
                        ruleElement.className = "password-rule-pill invalid";
                        ruleElement.innerHTML = "&#10007; " + ruleElement.textContent.replace(/^✓ |^✗ |^✔️ |^❌ /, "");
                    });
                    return false;
                } else {
                    strengthContainer.style.display = "block";
                }

                // Simple words or sequences to avoid
                const simplePatterns = [
                    "password", "admin", "1234", "abcd", "qwerty", "letmein", "welcome"
                ];
                let isSimple = false;
                for (const pattern of simplePatterns) {
                    if (password.toLowerCase().includes(pattern)) {
                        isSimple = true;
                        break;
                    }
                }

                const validations = {
                    length: password.length >= 8 && password.length <= 20,
                    lowercase: /[a-z]/.test(password),
                    uppercase: /[A-Z]/.test(password),
                    number: /[0-9]/.test(password),
                    special: /[!@#$%^&*(),.?":{}|<>]/.test(password),
                    simple: !isSimple
                };

                Object.entries(validations).forEach(([ruleId, isValid]) => {
                    const ruleElement = rules[ruleId];
                    if (ruleElement) {
                        ruleElement.className = "password-rule-pill " + (isValid ? "valid" : "invalid");
                        ruleElement.innerHTML = (isValid ? "&#10003;" : "&#10007;") + " " + ruleElement.textContent.replace(/^✓ |^✗ |^✔️ |^❌ /, "");
                    }
                });

                return Object.values(validations).every(v => v === true);
            }

            function validateConfirmPassword() {
                const errorSpan = document.getElementById("input-error-password-confirm");
                // Only show error if user has started typing in confirm password field and they do not match
                if (passwordConfirmInput.value.length > 0) {
                    if (passwordConfirmInput.value !== passwordInput.value) {
                        errorSpan.textContent = "Passwords do not match.";
                        errorSpan.style.display = "block";
                        return false;
                    } else {
                        errorSpan.textContent = "";
                        errorSpan.style.display = "none";
                        return true;
                    }
                } else {
                    errorSpan.textContent = "";
                    errorSpan.style.display = "none";
                    return true;
                }
            }

            // Immediately run the password validation on load to check for strength.
            validatePassword(passwordInput.value);

            // Event listener for password input
            passwordInput.addEventListener("input", function () {
                validatePassword(this.value);
                validateConfirmPassword();
            });
            passwordConfirmInput.addEventListener("input", validateConfirmPassword);

            form.addEventListener("submit", function (e) {
                let valid = true;
                // Password validation
                const isValidPassword = validatePassword(passwordInput.value);
                if (!isValidPassword) {
                    valid = false;
                }
                // Last Name validation
                if (!lastNameInput.value.trim()) {
                    let lastNameError = document.getElementById("input-error-lastName");
                    if (!lastNameError) {
                        lastNameError = document.createElement("span");
                        lastNameError.id = "input-error-lastName";
                        lastNameError.className = "${properties.kcInputErrorMessageClass!}";
                        lastNameError.setAttribute("aria-live", "polite");
                        lastNameInput.parentNode.appendChild(lastNameError);
                    }
                    lastNameError.textContent = "Last name is required.";
                    valid = false;
                } else {
                    const lastNameError = document.getElementById("input-error-lastName");
                    if (lastNameError) lastNameError.textContent = "";
                }
                // Confirm Password validation
                if (!validateConfirmPassword()) {
                    valid = false;
                }
                if (!valid) {
                    e.preventDefault();
                }
            });
        });
        </script>

        <!-- Login redirect -->
        <div class="d-flex justify-content-center"
    style = "margin-bottom: 60px;font-size: 18px;">
            <span>Already have an account? </span>
            <a href="${url.loginUrl}" style="color:#22376C;font-weight: bold;padding-left:15px">Sign in</a>
        </div>
    </#if>
</@layout.registrationLayout>
