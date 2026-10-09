{* LWB Theme — tableau de bord client · LEWEBMAX Admin *}
{include file="$template/includes/flashmessage.tpl"}

{if !$lwm}
    {include file="twenty-one/clientareahome.tpl"}
{else}
<div class="lwx-page">

    {* ---------- Welcome ---------- *}
    <section class="lwx-card lwx-welcome">
        <div>
            <span class="lwx-eyebrow">Bon retour</span>
            <h2>{$lwm.firstname|escape} {$lwm.lastname|escape}</h2>
            <p>Tout ce dont vous avez besoin pour votre compte {$companyname}, au même endroit.</p>
            {if $lwm.tone != 'ok'}
                <p class="lwx-notice lwx-notice-{$lwm.tone}"><i class="fas fa-circle"></i> {$lwm.headline|escape}</p>
            {/if}
        </div>
        <div class="lwx-actions">
            <a href="{$WEB_ROOT}/cart.php" class="lwx-btn lwx-btn-primary">Commander</a>
            <a href="{$WEB_ROOT}/clientarea.php?action=services" class="lwx-btn lwx-btn-ghost">Mes services</a>
        </div>
    </section>

    {* ---------- Stats ---------- *}
    <section class="lwx-stats">
        <a class="lwx-stat" href="{$WEB_ROOT}/clientarea.php?action=services">
            <span class="lwx-ico"><i class="far fa-cube"></i></span>
            <div><b>{$lwm.services_active}</b><span>Services actifs</span></div>
        </a>
        <a class="lwx-stat{if $lwm.has_due} is-alert{/if}" href="{$WEB_ROOT}/clientarea.php?action=invoices">
            <span class="lwx-ico"><i class="far fa-file-invoice"></i></span>
            <div><b>{count($lwm.invoices)}</b><span>{if $lwm.has_due}Factures à payer · {$lwm.due}{else}Factures à payer{/if}</span></div>
        </a>
        <a class="lwx-stat" href="{$WEB_ROOT}/supporttickets.php">
            <span class="lwx-ico"><i class="far fa-comments"></i></span>
            <div><b>{$lwm.tickets_open}</b><span>Tickets ouverts</span></div>
        </a>
        <a class="lwx-stat" href="{$WEB_ROOT}/clientarea.php?action=addfunds">
            <span class="lwx-ico"><i class="far fa-wallet"></i></span>
            <div><b>{$lwx.credit}</b><span>Crédit disponible</span></div>
        </a>
    </section>

    <div class="lwx-grid2">

        {* ---------- Recent services ---------- *}
        <section class="lwx-card">
            <header class="lwx-card-head">
                <h3>Services récents</h3>
                {if $lwm.services_total > 0}<a href="{$WEB_ROOT}/clientarea.php?action=services">Tout voir</a>{/if}
            </header>
            {if $lwm.services}
                {foreach $lwm.services as $svc}
                    <a class="lwx-rowlink" href="{$WEB_ROOT}/{$svc.manage_url}">
                        <div>
                            <b>{$svc.name|escape}</b>
                            <small>{if $svc.domain}{$svc.domain|escape}{else}Service n° {$svc.id}{/if}{if $svc.next_due} · échéance {$svc.next_due}{/if}</small>
                        </div>
                        <span class="lwx-badge lwx-badge-{$svc.status|lower}">{$svc.status_fr}</span>
                    </a>
                {/foreach}
            {else}
                <div class="lwx-empty">
                    <p>Vous n'avez pas encore de service.</p>
                    <a href="{$WEB_ROOT}/cart.php" class="lwx-btn lwx-btn-ghost lwx-btn-sm">Découvrir nos offres</a>
                </div>
            {/if}
        </section>

        {* ---------- Recent invoices ---------- *}
        <section class="lwx-card">
            <header class="lwx-card-head">
                <h3>Factures récentes</h3>
                {if $lwm.recent_invoices}<a href="{$WEB_ROOT}/clientarea.php?action=invoices">Tout voir</a>{/if}
            </header>
            {if $lwm.recent_invoices}
                {foreach $lwm.recent_invoices as $inv}
                    <div class="lwx-rowlink">
                        <a class="lwx-rowmain" href="{$WEB_ROOT}/{$inv.view_url}">
                            <b>Facture n° {$inv.num|escape}</b>
                            <small>{$inv.date}</small>
                        </a>
                        <div class="lwx-rowside">
                            <strong>{$inv.amount}</strong>
                            {if $inv.pay_url}
                                <a href="{if $inv.pay_external}{$inv.pay_url}{else}{$WEB_ROOT}/{$inv.pay_url}{/if}" class="lwx-btn lwx-btn-primary lwx-btn-xs">Payer</a>
                            {else}
                                <span class="lwx-badge lwx-badge-{$inv.tone}">{$inv.status}</span>
                            {/if}
                        </div>
                    </div>
                {/foreach}
            {else}
                <div class="lwx-empty"><p>Aucune facture pour le moment.</p></div>
            {/if}
        </section>

        {* ---------- Domains ---------- *}
        <section class="lwx-card">
            <header class="lwx-card-head">
                <h3>Domaines</h3>
                {if $lwm.domains_total > 0}<a href="{$WEB_ROOT}/clientarea.php?action=domains">Tout voir</a>{/if}
            </header>
            {if $lwm.domains}
                {foreach $lwm.domains as $dom}
                    <a class="lwx-rowlink" href="{$WEB_ROOT}/{$dom.manage_url}">
                        <div>
                            <b>{$dom.domain|escape}</b>
                            <small>{if $dom.days !== null && $dom.days < 0}Expiré le {$dom.expires}{elseif $dom.expires}Expire le {$dom.expires}{/if}</small>
                        </div>
                        {if $dom.soon}
                            <span class="lwx-badge lwx-badge-pending">{if $dom.days < 0}Expiré{elseif $dom.days == 0}Aujourd'hui{else}{$dom.days} jours{/if}</span>
                        {else}
                            <span class="lwx-badge lwx-badge-active">Actif</span>
                        {/if}
                    </a>
                {/foreach}
            {else}
                <div class="lwx-empty">
                    <p>Aucun nom de domaine pour le moment.</p>
                    <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register" class="lwx-btn lwx-btn-ghost lwx-btn-sm">Rechercher un domaine</a>
                </div>
            {/if}
        </section>

        {* ---------- Support ---------- *}
        <section class="lwx-card">
            <header class="lwx-card-head">
                <h3>Assistance</h3>
                <a href="{$WEB_ROOT}/submitticket.php">Nouveau ticket</a>
            </header>
            {if $lwm.tickets}
                {foreach $lwm.tickets as $t}
                    <a class="lwx-rowlink" href="{$WEB_ROOT}/{$t.url}">
                        <div>
                            <b>{$t.title|escape}</b>
                            <small>#{$t.tid|escape}{if $t.last} · {$t.last}{/if}</small>
                        </div>
                        <span class="lwx-badge {if $t.answered}lwx-badge-info{else}lwx-badge-neutral{/if}">{if $t.answered}Réponse reçue{else}{$t.status|escape}{/if}</span>
                    </a>
                {/foreach}
            {else}
                <div class="lwx-empty"><p>Aucune demande en cours. Notre équipe est là pour vous aider.</p></div>
            {/if}
            {if $lwm.whatsapp_link || $lwm.phone}
            <div class="lwx-contact">
                {if $lwm.whatsapp_link}<a href="{$lwm.whatsapp_link}" target="_blank" rel="noopener"><i class="fab fa-whatsapp"></i> WhatsApp</a>{/if}
                {if $lwm.phone}<a href="{$lwm.phone_link}"><i class="fas fa-phone"></i> {$lwm.phone}</a>{/if}
            </div>
            {/if}
        </section>

    </div>
</div>
{/if}
