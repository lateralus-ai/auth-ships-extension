<#-- Master realm login page. It renders no form: master holds only the
     break-glass admin, who signs in through the admin REST API (direct grant),
     not this page. Staff use the askchief realm console. -->
<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        <div class="kc-custom-header">
            <div class="kc-header-logo">
                <img class="kc-wordmark" src="${url.resourcesPath}/img/askchief-wordmark.svg" alt="Ask Chief" />
            </div>
        </div>
    <#elseif section = "form">
    <div class="kc-welcome-back">
        <h2>Restricted area</h2>
        <p class="kc-step-subtitle">This page is not available.</p>
    </div>
    <div id="kc-form-buttons">
        <a class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
           id="kc-login" href="https://app.askchief.ai">Go to Ask Chief</a>
    </div>
    </#if>
</@layout.registrationLayout>
