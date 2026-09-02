<#import "template.ftl" as layout>
<#import "password-commons.ftl" as passwordCommons>

<#-- Change password: the UPDATE_PASSWORD required action, reached from the
     app's "Change password" menu entry (an application-initiated action) or
     when an admin marks the password as temporary. Upstream base template
     structure, form ids and field names preserved; only the presentation is
     ours. -->
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        <#-- Usually never rendered: template.ftl skips the header section once the
             user is identified (auth.showUsername()), which is always the case by
             the time a password is being changed. The brand block therefore lives
             in "form" below, and the stock #kc-username is hidden and re-rendered
             there so it sits under the wordmark instead of above it. -->
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
    <div class="kc-custom-header">
        <div class="kc-header-logo">
            <img class="kc-wordmark" src="${url.resourcesPath}/img/askchief-wordmark.svg" alt="Ask Chief" />
        </div>
    </div>

    <div class="kc-welcome-back kc-welcome-compact">
        <h2>Choose a new password</h2>
        <p class="kc-step-subtitle">Your new password must have:</p>
        <ul class="kc-password-rules">
            <li>at least 14 characters</li>
            <li>an uppercase letter, a lowercase letter, a number and a symbol</li>
            <li>nothing from your username or email address</li>
            <li>no repeat of your last 4 passwords</li>
        </ul>
    </div>

    <#if auth?? && auth.attemptedUsername??>
        <p class="kc-signing-in-as">
            Changing the password for <strong>${auth.attemptedUsername}</strong>
        </p>
    </#if>

    <div id="kc-form">
      <div id="kc-form-wrapper">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" onsubmit="login.disabled = true; return true;"
              action="${url.loginAction}" method="post">

            <div class="${properties.kcFormGroupClass!}">
                <label for="password-new" class="kc-field-label">${msg("passwordNew")}</label>
                <input type="password" id="password-new" name="password-new"
                       class="${properties.kcInputClass!}"
                       autofocus autocomplete="new-password" dir="ltr"
                       aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                />

                <#if messagesPerField.existsError('password')>
                    <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('password'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <label for="password-confirm" class="kc-field-label">${msg("passwordConfirm")}</label>
                <input type="password" id="password-confirm" name="password-confirm"
                       class="${properties.kcInputClass!}"
                       autocomplete="new-password" dir="ltr"
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                />

                <#if messagesPerField.existsError('password-confirm')>
                    <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <@passwordCommons.logoutOtherSessions/>

                <div id="kc-form-buttons">
                    <input name="login" type="submit"
                           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                           value="Save new password" />
                    <#if isAppInitiatedAction??>
                        <button type="submit" class="kc-button-secondary"
                                name="cancel-aia" value="true">${msg("doCancel")}</button>
                    </#if>
                </div>
            </div>
        </form>
      </div>
    </div>
    </#if>
</@layout.registrationLayout>
