<!doctype html>
<html lang="fr">
<head>
    <meta charset="{$charset}" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>{if $kbarticle.title}{$kbarticle.title} - {/if}{$pagetitle} - {$companyname}</title>
    {include file="$template/includes/head.tpl"}
    {$headoutput}
</head>
{* Section of the client area the current page belongs to (highlights the sidebar). *}
{assign var=lwxSection value=''}
{if $templatefile == 'clientareahome'}{assign var=lwxSection value='home'}
{elseif in_array($templatefile, ['clientareaproducts', 'clientareaproductdetails', 'upgrade', 'upgradesummary', 'clientareacancelrequest'])}{assign var=lwxSection value='services'}
{elseif $templatefile|truncate:16:'':true == 'clientareadomain' || $templatefile == 'bulkdomainmanagement'}{assign var=lwxSection value='domains'}
{elseif in_array($templatefile, ['clientareainvoices', 'clientareaquotes', 'masspay', 'clientareaaddfunds', 'clientareacreditcard', 'account-paymentmethods', 'account-paymentmethods-manage', 'viewquote'])}{assign var=lwxSection value='billing'}
{elseif in_array($templatefile, ['supportticketslist', 'viewticket', 'supportticketsubmit-stepone', 'supportticketsubmit-steptwo', 'supportticketsubmit-confirm', 'supportticketsubmit-customfields', 'supportticketsubmit-kbsuggestions'])}{assign var=lwxSection value='support'}
{elseif $templatefile == 'clientareadetails'}{assign var=lwxSection value='details'}
{elseif $templatefile|truncate:16:'':true == 'account-contacts'}{assign var=lwxSection value='contacts'}
{elseif in_array($templatefile, ['clientareaemails', 'viewemail'])}{assign var=lwxSection value='emails'}
{elseif in_array($templatefile, ['user-security', 'user-password', 'user-profile', 'account-security', 'account-user-management', 'account-user-permissions'])}{assign var=lwxSection value='security'}
{elseif $inShoppingCart}{assign var=lwxSection value='store'}
{/if}
{* Pages redesigned without sidebars. *}
{assign var=lwxFull value=in_array($templatefile, ['clientareahome', 'clientareaproducts', 'clientareainvoices', 'clientareadomains', 'supportticketslist', 'clientareadetails', 'clientareaemails', 'user-security', 'user-password', 'user-profile', 'account-contacts-manage', 'account-contacts-new', 'account-paymentmethods', 'account-user-management', 'account-user-permissions'])}
{if $displayTitle}{assign var=lwxTitle value=$displayTitle}{else}{assign var=lwxTitle value=$pagetitle}{/if}
<body class="primary-bg-color lwx{if $loggedin} lwx-in{/if}{if $lwxFull} lwx-full{/if}" data-phone-cc-input="{$phoneNumberInputStyle}">
    {if $captcha}{$captcha->getMarkup()}{/if}
    {$headeroutput}

<div class="lwx-shell">

    {* ================= Sidebar ================= *}
    <aside class="lwx-side" aria-label="Navigation principale">
        <a class="lwx-brand" href="{$WEB_ROOT}/{if $loggedin}clientarea.php{else}index.php{/if}">
            {if $assetLogoPath}<img src="{$assetLogoPath}" alt="{$companyname}">{else}<span>{$companyname}</span>{/if}
        </a>

        <nav class="lwx-nav">
        {if $loggedin}
            <a class="lwx-link{if $lwxSection == 'home'} active{/if}" href="{$WEB_ROOT}/clientarea.php"><i class="far fa-th-large"></i><span>Tableau de bord</span></a>
            <a class="lwx-link{if $lwxSection == 'services'} active{/if}" href="{$WEB_ROOT}/clientarea.php?action=services"><i class="far fa-cube"></i><span>Mes services</span></a>
            <a class="lwx-link{if $lwxSection == 'domains'} active{/if}" href="{$WEB_ROOT}/clientarea.php?action=domains"><i class="far fa-globe"></i><span>Domaines</span></a>
            <a class="lwx-link{if $lwxSection == 'billing'} active{/if}" href="{$WEB_ROOT}/clientarea.php?action=invoices"><i class="far fa-credit-card"></i><span>Facturation</span>{if $lwx.unpaid_count}<em class="lwx-count">{$lwx.unpaid_count}</em>{/if}</a>
            <a class="lwx-link{if $lwxSection == 'support'} active{/if}" href="{$WEB_ROOT}/supporttickets.php"><i class="far fa-life-ring"></i><span>Assistance</span>{if $lwx.tickets_answered}<em class="lwx-count">{$lwx.tickets_answered}</em>{/if}</a>

            <div class="lwx-label">Commander</div>
            <a class="lwx-link{if $lwxSection == 'store'} active{/if}" href="{$WEB_ROOT}/cart.php"><i class="far fa-shopping-bag"></i><span>Boutique</span></a>
            <a class="lwx-link" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register"><i class="far fa-search"></i><span>Nouveau domaine</span></a>

            <div class="lwx-label">Compte</div>
            <a class="lwx-link{if $lwxSection == 'details'} active{/if}" href="{$WEB_ROOT}/clientarea.php?action=details"><i class="far fa-id-card"></i><span>Mes coordonnées</span></a>
            <a class="lwx-link{if $lwxSection == 'emails'} active{/if}" href="{$WEB_ROOT}/clientarea.php?action=emails"><i class="far fa-envelope"></i><span>E-mails reçus</span></a>
            <a class="lwx-link{if $lwxSection == 'security'} active{/if}" href="{routePath('user-security')}"><i class="far fa-shield-check"></i><span>Sécurité</span></a>
        {else}
            <a class="lwx-link{if $templatefile == 'homepage'} active{/if}" href="{$WEB_ROOT}/index.php"><i class="far fa-home"></i><span>Accueil</span></a>
            <a class="lwx-link{if $inShoppingCart} active{/if}" href="{$WEB_ROOT}/cart.php"><i class="far fa-shopping-bag"></i><span>Boutique</span></a>
            <a class="lwx-link" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register"><i class="far fa-globe"></i><span>Noms de domaine</span></a>
            <a class="lwx-link{if $templatefile|truncate:13:'':true == 'knowledgebase'} active{/if}" href="{routePath('knowledgebase-index')}"><i class="far fa-book"></i><span>Aide en ligne</span></a>
            <a class="lwx-link{if in_array($templatefile, ['announcements', 'viewannouncement'])} active{/if}" href="{routePath('announcement-index')}"><i class="far fa-bullhorn"></i><span>Actualités</span></a>
            <a class="lwx-link{if $templatefile == 'contact'} active{/if}" href="{$WEB_ROOT}/contact.php"><i class="far fa-envelope"></i><span>Contact</span></a>
        {/if}
        </nav>

        <div class="lwx-side-foot">
            {if $lwbStatus}
                <a class="lwx-status" href="{$WEB_ROOT}/{$lwbStatus.url}">
                    <span class="lwb-dot lwb-tone-{$lwbStatus.tone}"></span>
                    <span><b>{$lwbStatus.label}</b><small>{$lwbStatus.page_title|escape}</small></span>
                </a>
            {/if}
            {if $lwbContact.whatsapp_link}
                <a class="lwx-help" href="{$lwbContact.whatsapp_link}" target="_blank" rel="noopener">
                    <i class="fab fa-whatsapp"></i><span><b>Besoin d'aide ?</b>Écrivez-nous sur WhatsApp</span>
                </a>
            {else}
                <a class="lwx-help" href="{$WEB_ROOT}/{if $loggedin}submitticket.php{else}contact.php{/if}">
                    <i class="far fa-life-ring"></i><span><b>Besoin d'aide ?</b>Contactez notre équipe</span>
                </a>
            {/if}
            {if $loggedin}
                <a class="lwx-link lwx-logout" href="{$WEB_ROOT}/logout.php"><i class="far fa-sign-out"></i><span>Se déconnecter</span></a>
            {else}
                <a class="lwx-link" href="{$WEB_ROOT}/login.php"><i class="far fa-sign-in"></i><span>Se connecter</span></a>
            {/if}
        </div>
    </aside>

    {* ================= Main column ================= *}
    <div class="lwx-main">

        {* Mobile bar *}
        <div class="lwx-mbar">
            <div class="lwx-mbar-top">
                <a class="lwx-brand" href="{$WEB_ROOT}/{if $loggedin}clientarea.php{else}index.php{/if}">
                    {if $assetLogoPath}<img src="{$assetLogoPath}" alt="{$companyname}">{else}<span>{$companyname}</span>{/if}
                </a>
                <a class="lwx-mbar-icon" href="{$WEB_ROOT}/cart.php?a=view" aria-label="{lang key="carttitle"}"><i class="far fa-shopping-cart"></i>{if $cartitemcount}<em>{$cartitemcount}</em>{/if}</a>
                {if $loggedin}
                    <a class="lwx-mbar-icon" href="{$WEB_ROOT}/logout.php" aria-label="Se déconnecter"><i class="far fa-sign-out"></i></a>
                {else}
                    <a class="lwx-mbar-icon" href="{$WEB_ROOT}/login.php" aria-label="Se connecter"><i class="far fa-sign-in"></i></a>
                {/if}
            </div>
            <nav class="lwx-mtabs" aria-label="Navigation">
            {if $loggedin}
                <a class="{if $lwxSection == 'home'}active{/if}" href="{$WEB_ROOT}/clientarea.php"><i class="far fa-th-large"></i>Tableau de bord</a>
                <a class="{if $lwxSection == 'services'}active{/if}" href="{$WEB_ROOT}/clientarea.php?action=services"><i class="far fa-cube"></i>Services</a>
                <a class="{if $lwxSection == 'domains'}active{/if}" href="{$WEB_ROOT}/clientarea.php?action=domains"><i class="far fa-globe"></i>Domaines</a>
                <a class="{if $lwxSection == 'billing'}active{/if}" href="{$WEB_ROOT}/clientarea.php?action=invoices"><i class="far fa-credit-card"></i>Facturation</a>
                <a class="{if $lwxSection == 'support'}active{/if}" href="{$WEB_ROOT}/supporttickets.php"><i class="far fa-life-ring"></i>Assistance</a>
                <a class="{if $lwxSection == 'store'}active{/if}" href="{$WEB_ROOT}/cart.php"><i class="far fa-shopping-bag"></i>Boutique</a>
                <a class="{if in_array($lwxSection, ['details', 'emails', 'security', 'contacts'])}active{/if}" href="{$WEB_ROOT}/clientarea.php?action=details"><i class="far fa-user"></i>Compte</a>
            {else}
                <a class="{if $templatefile == 'homepage'}active{/if}" href="{$WEB_ROOT}/index.php"><i class="far fa-home"></i>Accueil</a>
                <a class="{if $inShoppingCart}active{/if}" href="{$WEB_ROOT}/cart.php"><i class="far fa-shopping-bag"></i>Boutique</a>
                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register"><i class="far fa-globe"></i>Domaines</a>
                <a class="{if $templatefile|truncate:13:'':true == 'knowledgebase'}active{/if}" href="{routePath('knowledgebase-index')}"><i class="far fa-book"></i>Aide</a>
                <a class="{if $templatefile == 'contact'}active{/if}" href="{$WEB_ROOT}/contact.php"><i class="far fa-envelope"></i>Contact</a>
            {/if}
            </nav>
        </div>

        {* Top bar *}
        <header class="lwx-top">
            <div class="lwx-top-title">
                <span class="lwx-eyebrow">{$companyname}</span>
                {if $lwxSection == 'home'}<h1>Tableau de bord</h1>{elseif $templatefile == 'clientareainvoices'}<h1>Facturation</h1>{elseif $templatefile == 'supportticketslist'}<h1>Assistance</h1>{elseif $templatefile == 'clientareaproductdetails'}<h1>Mes services</h1>{elseif $templatefile|truncate:16:'':true == 'clientareadomain'}<h1>Domaines</h1>{elseif !in_array($templatefile, ['clientareaproducts', 'clientareadomains'])}<h1>{$lwxTitle}</h1>{/if}
            </div>
            <div class="lwx-top-actions">
                <a class="lwx-icon" href="{$WEB_ROOT}/cart.php?a=view" title="{lang key="carttitle"}">
                    <i class="far fa-shopping-cart"></i>
                    <em id="cartItemCount" class="lwx-dot{if !$cartitemcount} d-none{/if}">{$cartitemcount}</em>
                </a>
                {if $loggedin}
                    <button type="button" class="lwx-icon" data-toggle="popover" id="accountNotifications" data-placement="bottom" title="{lang key='notifications'}">
                        <i class="far fa-bell"></i>
                        {if count($clientAlerts) > 0}<em class="lwx-dot">{count($clientAlerts)}</em>{/if}
                    </button>
                    <div id="accountNotificationsContent" class="w-hidden">
                        <ul class="client-alerts">
                        {foreach $clientAlerts as $alert}
                            <li>
                                <a href="{$alert->getLink()}">
                                    <i class="fas fa-fw fa-{if $alert->getSeverity() == 'danger'}exclamation-circle{elseif $alert->getSeverity() == 'warning'}exclamation-triangle{elseif $alert->getSeverity() == 'info'}info-circle{else}check-circle{/if}"></i>
                                    <div class="message">{$alert->getMessage()}</div>
                                </a>
                            </li>
                        {foreachelse}
                            <li class="none">{lang key='notificationsnone'}</li>
                        {/foreach}
                        </ul>
                    </div>

                    <div class="dropdown">
                        <button type="button" class="lwx-account" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="lwx-avatar">{$client.firstname|truncate:1:"":true|upper}</span>
                            <span class="lwx-account-text">
                                <b>{if $client.companyname}{$client.companyname}{else}{$client.fullName}{/if}</b>
                                <small>Titulaire du compte</small>
                            </span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-menu dropdown-menu-right lwx-menu">
                            <a class="dropdown-item" href="{$WEB_ROOT}/clientarea.php?action=details"><i class="far fa-id-card fa-fw"></i> Mes coordonnées</a>
                            <a class="dropdown-item" href="{routePath('account-contacts')}"><i class="far fa-address-book fa-fw"></i> Contacts</a>
                            <a class="dropdown-item" href="{routePath('account-paymentmethods')}"><i class="far fa-wallet fa-fw"></i> Moyens de paiement</a>
                            <a class="dropdown-item" href="{$WEB_ROOT}/clientarea.php?action=emails"><i class="far fa-envelope fa-fw"></i> E-mails reçus</a>
                            <a class="dropdown-item" href="{routePath('user-password')}"><i class="far fa-key fa-fw"></i> Mot de passe</a>
                            <a class="dropdown-item" href="{routePath('user-security')}"><i class="far fa-shield-check fa-fw"></i> Sécurité</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="{routePath('user-accounts')}"><i class="far fa-random fa-fw"></i> Changer de compte</a>
                            {if $adminMasqueradingAsClient || $adminLoggedIn}
                                <a class="dropdown-item" href="{$WEB_ROOT}/logout.php?returntoadmin=1"><i class="fas fa-redo-alt fa-fw"></i> {lang key="admin.returnToAdmin"}</a>
                            {/if}
                            <a class="dropdown-item" href="{$WEB_ROOT}/logout.php"><i class="far fa-sign-out fa-fw"></i> Se déconnecter</a>
                        </div>
                    </div>
                {else}
                    <a class="lwx-btn lwx-btn-ghost" href="{$WEB_ROOT}/login.php">Se connecter</a>
                    <a class="lwx-btn lwx-btn-primary" href="{$WEB_ROOT}/register.php">Créer un compte</a>
                {/if}
            </div>
        </header>

        {include file="$template/includes/network-issues-notifications.tpl"}

        {if !$lwxFull && !$inShoppingCart && $templatefile != 'homepage' && $templatefile != 'clientareaproductdetails' && $templatefile|truncate:16:'':true != 'clientareadomain'}
            <nav class="master-breadcrumb lwx-crumb" aria-label="breadcrumb">
                {include file="$template/includes/breadcrumb.tpl"}
            </nav>
        {/if}

        {include file="$template/includes/validateuser.tpl"}
        {include file="$template/includes/verifyemail.tpl"}

        {if $templatefile == 'homepage'}
            {if $registerdomainenabled || $transferdomainenabled}
                {include file="$template/includes/domain-search.tpl"}
            {/if}
        {/if}

        <section id="main-body">
            <div class="{if !$skipMainBodyContainer}lwx-container{/if}">

                {* Hero card of the detail pages (service, domain) *}
                {if $templatefile == 'clientareaproductdetails' && $product}
                    <section class="lwx-card lwx-hero">
                        <a class="lwx-iconbtn lwx-back" href="{$WEB_ROOT}/clientarea.php?action=services" aria-label="Retour à mes services"><i class="far fa-arrow-left"></i></a>
                        <span class="lwx-ico lwx-ico-lg"><i class="far {if $type == 'server'}fa-hdd{elseif $domain}fa-server{else}fa-cube{/if}"></i></span>
                        <div class="lwx-hero-main">
                            <span class="lwx-eyebrow">Service n° {$id}{if $groupname} · {$groupname}{/if}</span>
                            <h2>{$product}</h2>
                            {if $domain}<a href="http://{$domain}" target="_blank" rel="noopener">{$domain} <i class="far fa-external-link"></i></a>{/if}
                        </div>
                        <em class="lwx-badge lwx-badge-{$rawstatus|strtolower}">{$status}</em>
                        <dl class="lwx-hero-meta">
                            {if $recurringamount}<div><dt>Montant</dt><dd>{$recurringamount}{if $billingcycle} <small>{$billingcycle}</small>{/if}</dd></div>{elseif $firstpaymentamount}<div><dt>Montant</dt><dd>{$firstpaymentamount}</dd></div>{/if}
                            {if $nextduedate && $nextduedate != '-'}<div><dt>Prochaine échéance</dt><dd>{$nextduedate}</dd></div>{/if}
                            {if $regdate}<div><dt>Date de souscription</dt><dd>{$regdate}</dd></div>{/if}
                            {if $paymentmethod}<div><dt>Mode de paiement</dt><dd>{$paymentmethod}</dd></div>{/if}
                        </dl>
                    </section>
                {elseif $templatefile|truncate:16:'':true == 'clientareadomain' && $domain}
                    <section class="lwx-card lwx-hero">
                        <a class="lwx-iconbtn lwx-back" href="{$WEB_ROOT}/clientarea.php?action=domains" aria-label="Retour à mes domaines"><i class="far fa-arrow-left"></i></a>
                        <span class="lwx-ico lwx-ico-lg"><i class="far fa-globe"></i></span>
                        <div class="lwx-hero-main">
                            <span class="lwx-eyebrow">Nom de domaine</span>
                            <h2>{$domain}</h2>
                            <a href="http://{$domain}" target="_blank" rel="noopener">Visiter le site <i class="far fa-external-link"></i></a>
                        </div>
                        {if $status}<em class="lwx-badge lwx-badge-{if $systemStatus}{$systemStatus|strtolower}{else}active{/if}">{$status}</em>{/if}
                    </section>
                {/if}

                {assign var=lwxAside value=!$lwxFull && !$inShoppingCart && ($primarySidebar->hasChildren() || $secondarySidebar->hasChildren())}
                <div class="row">

                {if $lwxAside}
                    <div class="col-lg-4 col-xl-3 order-lg-2 lwx-aside">
                        <div class="sidebar">
                            {include file="$template/includes/sidebar.tpl" sidebar=$primarySidebar}
                            {if $secondarySidebar->hasChildren()}
                                {include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
                            {/if}
                        </div>
                    </div>
                {/if}
                <div class="{if $lwxAside}col-lg-8 col-xl-9 order-lg-1{else}col-12{/if} primary-content">
