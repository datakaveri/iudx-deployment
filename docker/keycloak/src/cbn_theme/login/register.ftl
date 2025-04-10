<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('fullname','email','username','password','password-confirm'); section>
    <#if section = "header">
     <div class="logo-container">
            <img src="${url.resourcesPath}/img/cbn-favicon.png" alt="Logo" class="login-logo">
    </div>
        ${msg("registerTitle")}
          <div class="custom-pf-form-subTitle">${msg("registerSubtitle")}</div>
    <#elseif section = "form">
        <form id="kc-register-form" class="${properties.kcFormClass!} custom-form" action="${url.registrationAction}" method="post">
        <div class='form-col'>
             <div class="${properties.kcFormGroupClassCustom!}">
                <div class="${properties.kcLabelWrapperClassCustom!}">
                    <label for="fullname" class="${properties.kcLabelClass!}">${msg("Fullname")}</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="fullname" class="${properties.kcInputClass!}" name="user.attributes.fullname"
                          placeholder="Enter Full name"
                           value="${(register.formData.fullname!'')}"
                           aria-invalid="<#if messagesPerField.existsError('fullname')>true</#if>"
                    />

                    <#if messagesPerField.existsError('fullname')>
                        <span id="input-error-fullname" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.get('fullname'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>
        </div>
            
            <div class="row-elements">
            <div id='form-col-full' class="${properties.kcFormGroupClassCustom!}">
                <div class="${properties.kcLabelWrapperClassCustom!}">
                    <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="email" class="${properties.kcInputClass!}" name="email"
                           value="${(register.formData.email!'')}" autocomplete="email"
                           placeholder="Enter Email id"
                           aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                    />

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
                               value="${(register.formData.username!'')}" autocomplete="username" placeholder="Enter username"
                               aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                        />

                        <#if messagesPerField.existsError('username')>
                            <span id="input-error-username" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('username'))?no_esc}
                            </span>
                        </#if>
                    </div>
                </div>
            </#if>

            </div>
            <div class='form-col'>
                <#if passwordRequired??>
                <div class="${properties.kcFormGroupClassCustom!}">
                    <div class="${properties.kcLabelWrapperClassCustom!}">
                        <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                    </div>
                    <div class="${properties.kcInputWrapperClass!}">
                        <input type="password" id="password" class="${properties.kcInputClass!}" name="password" 
                               autocomplete="new-password" placeholder="Enter password"
                               aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                        />

               
                        <#if messagesPerField.existsError('password')>
                            <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('password'))?no_esc}
                            </span>
                        </#if>
                    </div>
                </div>
            </#if>

              <div class="${properties.kcFormGroupClassCustom!}">
                    <div class="${properties.kcLabelWrapperClassCustom!}">
                        <label for="password-confirm"
                               class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>
                    </div>
                    <div class="${properties.kcInputWrapperClass!}">
                        <input type="password" id="password-confirm" class="${properties.kcInputClass!}"
                               name="password-confirm" placeholder="Confirm password"
                               aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                        />

                        <#if messagesPerField.existsError('password-confirm')>
                            <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                            </span>
                        </#if>
                    </div>
                </div>
            </div>
            

            <#if recaptchaRequired??>
                <div class="form-group">
                    <div class="${properties.kcInputWrapperClass!}">
                        <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                    </div>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doRegister")}"/>
                </div>
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                        <span class="${properties.kcLoginHelperText}">${msg("kcLoginHelperText")}<a class="${properties.kcLoginText}" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></span>
                    </div>
                </div>
            </div>

             <script>
            window.addEventListener('load', function() {
        document.getElementById('username').value = '';
           });
        </script>
        </form>
    </#if>


    <script>


document.getElementById("kc-register-form").addEventListener("submit", function(event) {
    let isValid = true;

    function showError(inputId, message) {
        let inputElement = document.getElementById(inputId);
        let errorSpan = document.getElementById("input-error-" + inputId);

        if (!errorSpan) {
            errorSpan = document.createElement("span");
            errorSpan.id = "input-error-" + inputId;
            errorSpan.className = "kcInputErrorMessageClass";
            inputElement.parentNode.appendChild(errorSpan);
        }
        errorSpan.innerText = message;
        errorSpan.style.color = "red";
    }

    function clearError(inputId) {
        let errorSpan = document.getElementById("input-error-" + inputId);
        if (errorSpan) {
            errorSpan.remove();
        }
    }

    function addInputListener(inputId, validationFn) {
        let inputElement = document.getElementById(inputId);
        if (inputElement) {
            inputElement.addEventListener("input", function () {
                validationFn();
            });
        }
    }

    // Full Name Validation
    let fullName = document.getElementById("fullname");
    function validateFullName() {
        if (fullName.value.trim() === "") {
            showError("fullname", "Full name is required.");
            isValid = false;
        } else {
            clearError("fullname");
        }
    }
    validateFullName();
    addInputListener("fullname", validateFullName);

    // Email Validation
    let email = document.getElementById("email");
    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    function validateEmail() {
        if (email.value.trim() === "") {
            showError("email", "Email is required.");
            isValid = false;
        } else if (!emailRegex.test(email.value)) {
            showError("email", "Invalid email format.");
            isValid = false;
        } else {
            clearError("email");
        }
    }
    validateEmail();
    addInputListener("email", validateEmail);

    // Username Validation (only if username field exists)
    let username = document.getElementById("username");
    if (username) {
        function validateUsername() {
            if (username.value.trim() === "") {
                showError("username", "Username is required.");
                isValid = false;
            } else {
                clearError("username");
            }
        }
        validateUsername();
        addInputListener("username", validateUsername);
    }


    // Confirm Password Validation
    function validateConfirmPassword() {
        if (confirmPassword.value.trim() === "") {
            showError("password-confirm", "Confirm Password is required.");
            isValid = false;
        } else if (password.value !== confirmPassword.value) {
            showError("password-confirm", "Passwords do not match.");
            isValid = false;
        } else {
            clearError("password-confirm");
        }
    }
    validateConfirmPassword();
    addInputListener("password-confirm", validateConfirmPassword);

    // Prevent form submission if validation fails
    if (!isValid) {
        event.preventDefault();
    }
});


    </script>
</@layout.registrationLayout>