<#import "template.ftl" as layout>
<#import "password-commons.ftl" as passwordCommons>

<@layout.registrationLayout displayRequiredFields=false displayMessage=!messagesPerField.existsError('totp','userLabel'); section>
    <#if section = "header">
        <#-- No rebrand banner here: it is position:fixed, and this page is tall
             enough to scroll, so it would sit over the form's content. -->
        <div class="kc-custom-header">
            <div class="kc-header-logo">
                <img class="kc-wordmark" src="${url.resourcesPath}/img/askchief-wordmark.svg" alt="Ask Chief" />
            </div>
        </div>
    <#elseif section = "form">
    <div class="kc-welcome-back kc-welcome-compact">
        <h2>Set up two-factor authentication</h2>
        <p class="kc-step-subtitle">Add a second step to your sign-in to keep your account secure.</p>
    </div>

    <div id="kc-form">
      <div id="kc-form-wrapper">

        <div class="kc-totp-steps">
            <div class="kc-totp-step">
                <span class="kc-totp-step-number">1</span>
                <div class="kc-totp-step-body">
                    <p class="kc-totp-step-title">Install an authenticator app</p>
                    <ul id="kc-totp-supported-apps" class="kc-totp-apps">
                        <#list totp.supportedApplications as app>
                            <li>${msg(app)}</li>
                        </#list>
                    </ul>
                </div>
            </div>

            <#if mode?? && mode = "manual">
                <div class="kc-totp-step">
                    <span class="kc-totp-step-number">2</span>
                    <div class="kc-totp-step-body">
                        <p class="kc-totp-step-title">Enter this key in your app</p>
                        <p class="kc-totp-secret-wrap"><span id="kc-totp-secret-key">${totp.totpSecretEncoded}</span></p>
                        <p class="kc-totp-switch-mode"><a href="${totp.qrUrl}" id="mode-barcode">${msg("loginTotpScanBarcode")}</a></p>
                    </div>
                </div>
                <div class="kc-totp-step">
                    <span class="kc-totp-step-number">3</span>
                    <div class="kc-totp-step-body">
                        <p class="kc-totp-step-title">${msg("loginTotpManualStep3")}</p>
                        <ul class="kc-totp-manual-details">
                            <li id="kc-totp-type">${msg("loginTotpType")}: ${msg("loginTotp." + totp.policy.type)}</li>
                            <li id="kc-totp-algorithm">${msg("loginTotpAlgorithm")}: ${totp.policy.getAlgorithmKey()}</li>
                            <li id="kc-totp-digits">${msg("loginTotpDigits")}: ${totp.policy.digits}</li>
                            <#if totp.policy.type = "totp">
                                <li id="kc-totp-period">${msg("loginTotpInterval")}: ${totp.policy.period}</li>
                            <#elseif totp.policy.type = "hotp">
                                <li id="kc-totp-counter">${msg("loginTotpCounter")}: ${totp.policy.initialCounter}</li>
                            </#if>
                        </ul>
                    </div>
                </div>
            <#else>
                <div class="kc-totp-step">
                    <span class="kc-totp-step-number">2</span>
                    <div class="kc-totp-step-body">
                        <p class="kc-totp-step-title">Scan this code with the app</p>
                        <div class="kc-qr-card">
                            <img id="kc-totp-secret-qr-code" src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="QR code for authenticator setup">
                        </div>
                        <p class="kc-totp-switch-mode"><a href="${totp.manualUrl}" id="mode-manual">${msg("loginTotpUnableToScan")}</a></p>
                    </div>
                </div>
            </#if>

        </div>

        <hr class="kc-form-divider" />

        <form action="${url.loginAction}" class="${properties.kcFormClass!}" id="kc-totp-settings-form" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <label for="totp" class="kc-field-label">${msg("authenticatorCode")}</label>
                <p class="kc-field-help">Enter the 6-digit code your app is showing now.</p>
                <input type="text" id="totp" name="totp" autocomplete="one-time-code"
                       class="${properties.kcInputClass!} kc-otp-code-input"
                       aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"
                       inputmode="numeric" autofocus placeholder="000000" dir="ltr"
                />

                <#if messagesPerField.existsError('totp')>
                    <span id="input-error-otp-code" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                    </span>
                </#if>

                <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
                <#if mode??><input type="hidden" id="mode" name="mode" value="${mode}"/></#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <label for="userLabel" class="kc-field-label">
                    ${msg("loginTotpDeviceName")}<#if totp.otpCredentials?size gte 1> <span class="required">*</span></#if>
                </label>
                <input type="text" class="${properties.kcInputClass!}" id="userLabel" name="userLabel" autocomplete="off"
                       placeholder="e.g. iPhone"
                       aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>" dir="ltr"
                />

                <#if messagesPerField.existsError('userLabel')>
                    <span id="input-error-otp-label" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('userLabel'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <@passwordCommons.logoutOtherSessions/>

                <div id="kc-form-buttons">
                    <#if isAppInitiatedAction??>
                        <input type="submit"
                               class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                               id="saveTOTPBtn" value="${msg("doSubmit")}"
                        />
                        <button type="submit"
                                class="kc-button-secondary"
                                id="cancelTOTPBtn" name="cancel-aia" value="true">${msg("doCancel")}</button>
                    <#else>
                        <input type="submit"
                               class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                               id="saveTOTPBtn" value="${msg("doSubmit")}"
                        />
                    </#if>
                </div>
            </div>
        </form>
      </div>
    </div>
    </#if>
</@layout.registrationLayout>
