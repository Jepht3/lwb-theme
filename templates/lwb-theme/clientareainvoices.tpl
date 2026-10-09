{* LWB Theme — factures · LEWEBMAX Admin *}
{include file="$template/includes/flashmessage.tpl"}

<div class="lwx-page">
    <section class="lwx-stats lwx-stats-billing">
        <div class="lwx-stat">
            <span class="lwx-ico"><i class="far fa-wallet"></i></span>
            <div><b>{$lwx.credit}</b><span>Crédit disponible</span></div>
        </div>
        <div class="lwx-stat{if $lwx.has_due} is-alert{/if}">
            <span class="lwx-ico"><i class="far fa-file-invoice"></i></span>
            <div><b>{$lwx.unpaid_count}</b><span>Factures impayées</span></div>
        </div>
        <div class="lwx-stat">
            <span class="lwx-ico"><i class="far fa-coins"></i></span>
            <div><b>{$lwx.due}</b><span>Montant à régler</span></div>
        </div>
        <div class="lwx-stat lwx-stat-actions">
            {if $lwx.unpaid_count > 1}
                <a href="{$WEB_ROOT}/clientarea.php?action=masspay&amp;all=true" class="lwx-btn lwx-btn-primary lwx-btn-block">Tout payer</a>
            {elseif $lwx.unpaid_count == 1}
                {foreach $invoices as $invoice}{if $invoice.statusClass == 'unpaid'}<a href="{$WEB_ROOT}/viewinvoice.php?id={$invoice.id}" class="lwx-btn lwx-btn-primary lwx-btn-block">Payer la facture</a>{break}{/if}{/foreach}
            {/if}
            <a href="{$WEB_ROOT}/clientarea.php?action=addfunds" class="lwx-btn lwx-btn-ghost lwx-btn-block">Ajouter du crédit</a>
        </div>
    </section>

    <div class="lwx-pagehead">
        <div>
            <span class="lwx-eyebrow">Facturation</span>
            <h2>Factures</h2>
            <p>Suivez vos paiements, vos soldes et vos dates d'échéance. Paiement par Mobile Money, Visa ou Mastercard.</p>
        </div>
        <a href="{routePath('account-paymentmethods')}" class="lwx-link-strong">Moyens de paiement</a>
    </div>

    <form class="lwx-search" role="search">
        <i class="far fa-search"></i>
        <input type="search" data-lwx-search placeholder="Rechercher un numéro, une date, un montant ou un statut…" aria-label="Rechercher">
        <button type="submit" class="lwx-btn lwx-btn-dark lwx-btn-sm">Rechercher</button>
    </form>

    <div class="lwx-tabs" role="tablist">
        <button type="button" class="active" data-lwx-tab="all">Toutes</button>
        <button type="button" data-lwx-tab="unpaid">Impayées</button>
        <button type="button" data-lwx-tab="paid">Payées</button>
        <button type="button" data-lwx-tab="cancelled">Annulées</button>
    </div>
    <p class="lwx-meta"><span data-lwx-count>{count($invoices)}</span> facture(s)</p>

    <div class="lwx-list" data-lwx-list data-lwx-sort>
        {foreach $invoices as $invoice}
            <div class="lwx-item lwx-item-invoice" data-lwx-row="{$invoice.statusClass}" data-lwx-key="{if $invoice.statusClass == 'unpaid'}1{else}0{/if}-{$invoice.normalisedDateCreated}-{$invoice.id|string_format:"%010d"}">
                <span class="lwx-ico"><i class="far fa-file-alt"></i></span>
                <div class="lwx-item-main">
                    <a href="{$WEB_ROOT}/viewinvoice.php?id={$invoice.id}"><b>Facture n° {$invoice.invoicenum}</b></a>
                    <small>Émise le {$invoice.datecreated} · échéance le {$invoice.datedue}</small>
                </div>
                <div class="lwx-item-amount">
                    <b>{$invoice.total}</b>
                    <em class="lwx-badge lwx-badge-{$invoice.statusClass}">{$invoice.status}</em>
                </div>
                <div class="lwx-item-actions">
                    {if $invoice.statusClass == 'unpaid'}
                        <a href="{$WEB_ROOT}/viewinvoice.php?id={$invoice.id}" class="lwx-btn lwx-btn-primary lwx-btn-sm">Payer</a>
                    {else}
                        <a href="{$WEB_ROOT}/viewinvoice.php?id={$invoice.id}" class="lwx-btn lwx-btn-ghost lwx-btn-sm">Voir</a>
                    {/if}
                    <a href="{$WEB_ROOT}/dl.php?type=i&amp;id={$invoice.id}" class="lwx-iconbtn" title="Télécharger le PDF" aria-label="Télécharger le PDF"><i class="far fa-download"></i></a>
                </div>
            </div>
        {/foreach}
        <div class="lwx-card lwx-empty" data-lwx-empty{if count($invoices)} style="display:none"{/if}>
            <p>Aucune facture ne correspond.</p>
        </div>
    </div>
</div>
