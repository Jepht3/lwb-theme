{* LWB Theme — liste des services · LEWEBMAX Admin *}
{include file="$template/includes/flashmessage.tpl"}

<div class="lwx-page">
    <div class="lwx-pagehead">
        <div>
            <span class="lwx-eyebrow">Services</span>
            <h2>Vos services</h2>
            <p>Hébergements, e-mails professionnels et serveurs liés à votre compte.</p>
        </div>
        <a href="{$WEB_ROOT}/cart.php" class="lwx-btn lwx-btn-ghost"><i class="far fa-plus"></i> Commander un service</a>
    </div>

    <form class="lwx-search" role="search">
        <i class="far fa-search"></i>
        <input type="search" data-lwx-search placeholder="Rechercher un service, un domaine, un statut…" aria-label="Rechercher">
        <button type="submit" class="lwx-btn lwx-btn-dark lwx-btn-sm">Rechercher</button>
    </form>

    <div class="lwx-tabs" role="tablist">
        <button type="button" class="active" data-lwx-tab="all">Tous</button>
        <button type="button" data-lwx-tab="active">Actifs</button>
        <button type="button" data-lwx-tab="pending">En attente</button>
        <button type="button" data-lwx-tab="suspended">Suspendus</button>
        <button type="button" data-lwx-tab="closed">Terminés</button>
    </div>
    <p class="lwx-meta"><span data-lwx-count>{count($services)}</span> service(s)</p>

    <div class="lwx-list" data-lwx-list>
        {foreach $services as $service}
            {assign var=st value=$service.status|strtolower}
            <div class="lwx-item" data-lwx-row="{if in_array($st, ['cancelled', 'terminated', 'fraud'])}closed{else}{$st}{/if}">
                <span class="lwx-ico"><i class="far {if $service.domain}fa-server{else}fa-cube{/if}"></i></span>
                <div class="lwx-item-main">
                    <a href="{$WEB_ROOT}/clientarea.php?action=productdetails&amp;id={$service.id}"><b>{$service.product}</b></a>
                    <small>Service n° {$service.id}{if $service.domain} · {$service.domain}{/if}</small>
                </div>
                <div class="lwx-item-col">
                    <span>Facturation</span>
                    <b>{$service.amount}</b>
                    <small>{$service.billingcycle}</small>
                </div>
                <div class="lwx-item-col">
                    <span>Échéance</span>
                    <b>{if $service.nextduedate && $service.nextduedate != '-'}{$service.nextduedate}{else}—{/if}</b>
                </div>
                <div class="lwx-item-col lwx-keep">
                    <span>Statut</span>
                    <em class="lwx-badge lwx-badge-{$st}">{$service.statustext}</em>
                </div>
                <div class="lwx-item-actions">
                    <a href="{$WEB_ROOT}/clientarea.php?action=productdetails&amp;id={$service.id}" class="lwx-btn lwx-btn-dark lwx-btn-sm">Gérer <i class="far fa-arrow-right"></i></a>
                    {if $st == 'suspended'}
                        <a href="{$WEB_ROOT}/submitticket.php" class="lwx-btn lwx-btn-danger-ghost lwx-btn-sm"><i class="far fa-life-ring"></i> Aide</a>
                    {/if}
                </div>
            </div>
        {/foreach}
        <div class="lwx-card lwx-empty" data-lwx-empty{if count($services)} style="display:none"{/if}>
            <p>Aucun service ne correspond.</p>
            <a href="{$WEB_ROOT}/cart.php" class="lwx-btn lwx-btn-ghost lwx-btn-sm">Découvrir nos offres</a>
        </div>
    </div>
</div>
