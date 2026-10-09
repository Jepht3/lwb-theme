{* LWB Theme — noms de domaine · LEWEBMAX Admin *}
{include file="$template/includes/flashmessage.tpl"}
{if $warnings}
    {include file="$template/includes/alert.tpl" type="warning" msg=$warnings textcenter=true}
{/if}

<div class="lwx-page">
    <div class="lwx-pagehead">
        <div>
            <span class="lwx-eyebrow">Domaines</span>
            <h2>Vos noms de domaine</h2>
            <p>Gérez les serveurs DNS, le renouvellement et les contacts de vos domaines.</p>
        </div>
        <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register" class="lwx-btn lwx-btn-ghost"><i class="far fa-plus"></i> Enregistrer ou transférer</a>
    </div>

    <form class="lwx-search" role="search">
        <i class="far fa-search"></i>
        <input type="search" data-lwx-search placeholder="Rechercher un domaine, un statut ou une date…" aria-label="Rechercher">
        <button type="submit" class="lwx-btn lwx-btn-dark lwx-btn-sm">Rechercher</button>
    </form>

    <div class="lwx-tabs" role="tablist">
        <button type="button" class="active" data-lwx-tab="all">Tous</button>
        <button type="button" data-lwx-tab="active">Actifs</button>
        <button type="button" data-lwx-tab="soon">Expirent bientôt</button>
        <button type="button" data-lwx-tab="pending">En attente</button>
        <button type="button" data-lwx-tab="closed">Expirés / annulés</button>
    </div>

    <form id="domainForm" method="post" action="clientarea.php?action=bulkdomain">
        <input id="bulkaction" name="update" type="hidden" />

        <div class="lwx-bulk">
            <p class="lwx-meta"><span data-lwx-count>{count($domains)}</span> domaine(s) · cochez des domaines pour agir sur plusieurs à la fois</p>
            <div class="btn-group btn-group-sm" role="group">
                <button type="button" class="btn btn-default setBulkAction" id="nameservers"><i class="far fa-server"></i> {lang key='domainmanagens'}</button>
                <button type="button" class="btn btn-default setBulkAction" id="contactinfo"><i class="far fa-user"></i> {lang key='domaincontactinfoedit'}</button>
                {if $allowrenew}
                    <button type="button" class="btn btn-default setBulkAction" id="renewDomains"><i class="far fa-sync"></i> {lang key='domainmassrenew'}</button>
                {/if}
                <div class="btn-group btn-group-sm" role="group">
                    <button id="btnGroupDrop1" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">{lang key="more"}…</button>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="btnGroupDrop1">
                        <a class="dropdown-item setBulkAction" href="#" id="autorenew"><i class="far fa-sync"></i> {lang key='domainautorenewstatus'}</a>
                        <a class="dropdown-item setBulkAction" href="#" id="reglock"><i class="far fa-lock"></i> {lang key='domainreglockstatus'}</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="lwx-list" data-lwx-list>
            {foreach $domains as $domain}
                {assign var=dst value=$domain.statusClass}
                <div class="lwx-item" data-lwx-row="{if in_array($dst, ['expired', 'cancelled', 'transferred-away', 'fraud', 'redemption', 'grace'])}closed{elseif $dst|truncate:7:'':true == 'pending'}pending{else}{$dst}{/if}{if $domain.expiringSoon} soon{/if}">
                    <input type="checkbox" name="domids[]" class="domids stopEventBubble lwx-check" value="{$domain.id}" aria-label="Sélectionner {$domain.domain}" />
                    <span class="lwx-ico"><i class="far fa-globe"></i></span>
                    <div class="lwx-item-main">
                        <a href="{$WEB_ROOT}/clientarea.php?action=domaindetails&amp;id={$domain.id}"><b>{$domain.domain}</b></a>
                        <small>{if $domain.autorenew}<i class="fas fa-check text-success"></i>{else}<i class="fas fa-times text-danger"></i>{/if} {lang key='domainsautorenew'}</small>
                    </div>
                    <div class="lwx-item-col">
                        <span>Enregistré le</span>
                        <b>{if $domain.registrationdate}{$domain.registrationdate}{else}—{/if}</b>
                    </div>
                    <div class="lwx-item-col">
                        <span>Échéance</span>
                        <b>{if $domain.nextduedate}{$domain.nextduedate}{else}—{/if}</b>
                    </div>
                    <div class="lwx-item-col lwx-keep">
                        <span>Statut</span>
                        <em class="lwx-badge lwx-badge-{$dst}">{$domain.statustext}</em>
                        {if $domain.expiringSoon}<small class="lwx-soon">{lang key="domainsExpiringSoon"}</small>{/if}
                    </div>
                    <div class="lwx-item-actions">
                        <a href="{$WEB_ROOT}/clientarea.php?action=domaindetails&amp;id={$domain.id}" class="lwx-btn lwx-btn-dark lwx-btn-sm">Gérer <i class="far fa-arrow-right"></i></a>
                    </div>
                </div>
            {/foreach}
            <div class="lwx-card lwx-empty" data-lwx-empty{if count($domains)} style="display:none"{/if}>
                <p>Aucun domaine ne correspond.</p>
                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register" class="lwx-btn lwx-btn-ghost lwx-btn-sm">Rechercher un domaine</a>
            </div>
        </div>
    </form>
</div>
