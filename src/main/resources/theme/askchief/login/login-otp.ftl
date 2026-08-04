<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section = "header">
        <div class="kc-rebrand-banner">
            Ask Chief has a new look — same product, nothing has moved.
        </div>
        <div class="kc-custom-header">
            <div class="kc-header-logo">
                <img class="kc-wordmark" src="${url.resourcesPath}/img/askchief-wordmark.svg" alt="Ask Chief" />
            </div>
        </div>
    <#elseif section = "form">
    <div class="kc-welcome-back kc-welcome-compact">
        <h2>Two-factor authentication</h2>
        <p class="kc-step-subtitle">Enter the 6-digit code from your authenticator app.</p>
    </div>

    <div id="kc-form">
      <div id="kc-form-wrapper">
        <form id="kc-otp-login-form" class="${properties.kcFormClass!}" onsubmit="login.disabled = true; return true;"
              action="${url.loginAction}" method="post">

            <#if otpLogin.userOtpCredentials?size gt 1>
                <div class="${properties.kcFormGroupClass!}">
                    <label class="kc-field-label">Choose a device</label>
                    <div class="kc-otp-credential-list">
                        <#list otpLogin.userOtpCredentials as otpCredential>
                            <input id="kc-otp-credential-${otpCredential?index}" class="${properties.kcLoginOTPListInputClass!}"
                                   type="radio" name="selectedCredentialId" value="${otpCredential.id}"
                                   <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if>>
                            <label for="kc-otp-credential-${otpCredential?index}" class="kc-otp-credential-item" tabindex="${otpCredential?index}">
                                <span class="kc-otp-credential-title">${otpCredential.userLabel}</span>
                            </label>
                        </#list>
                    </div>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <label for="otp" class="kc-field-label">${msg("loginOtpOneTime")}</label>
                <input id="otp" name="otp" autocomplete="one-time-code" type="text"
                       class="${properties.kcInputClass!} kc-otp-code-input"
                       autofocus inputmode="numeric" placeholder="000000"
                       aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" dir="ltr" />

                <#if messagesPerField.existsError('totp')>
                    <span id="input-error-otp-code" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                    </span>
                </#if>
            </div>

            <div id="kc-form-buttons" class="${properties.kcFormGroupClass!}">
                <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                       name="login" id="kc-login" type="submit" value="${msg("doLogIn")}" />
            </div>
        </form>
      </div>
    </div>
    </#if>
</@layout.registrationLayout>
