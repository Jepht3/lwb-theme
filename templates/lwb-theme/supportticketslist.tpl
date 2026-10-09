{* LWB Theme — tickets d'assistance · LEWEBMAX Admin *}
{include file="$template/includes/flashmessage.tpl"}

<div class="lwx-page">
    <section class="lwx-card lwx-welcome">
        <div>
            <span class="lwx-eyebrow">Centre d'aide</span>
            <h2>Comment pouvons-nous vous aider ?</h2>
            <p>Ouvrez une nouvelle demande ou poursuivez une conversation avec notre équipe.</p>
        </div>
        <div class="lwx-actions">
            <a href="{$WEB_ROOT}/submitticket.php" class="lwx-btn lwx-btn-primary"><i class="far fa-plus"></i> Nouveau ticket</a>
            {if $lwbContact.whatsapp_link}<a href="{$lwbContact.whatsapp_link}" target="_blank" rel="noopener" class="lwx-btn lwx-btn-ghost"><i class="fab fa-whatsapp"></i> WhatsApp</a>{/if}
        </div>
    </section>

    <section class="lwx-stats lwx-stats-3">
        <div class="lwx-stat">
            <span class="lwx-ico"><i class="far fa-comment-dots"></i></span>
            <div><b>{$lwx.tickets_open}</b><span>En cours</span></div>
        </div>
        <div class="lwx-stat">
            <span class="lwx-ico"><i class="far fa-reply"></i></span>
            <div><b>{$lwx.tickets_answered}</b><span>Réponses reçues</span></div>
        </div>
        <div class="lwx-stat">
            <span class="lwx-ico"><i class="far fa-check-circle"></i></span>
            <div><b>{$lwx.tickets_closed}</b><span>Fermés</span></div>
        </div>
    </section>

    <form class="lwx-search" role="search">
        <i class="far fa-search"></i>
        <input type="search" data-lwx-search placeholder="Rechercher un sujet, un service, un statut ou un numéro…" aria-label="Rechercher">
        <button type="submit" class="lwx-btn lwx-btn-dark lwx-btn-sm">Rechercher</button>
    </form>

    <div class="lwx-tabs" role="tablist">
        <button type="button" class="active" data-lwx-tab="all">Tous</button>
        <button type="button" data-lwx-tab="open">En cours</button>
        <button type="button" data-lwx-tab="answered">Réponse reçue</button>
        <button type="button" data-lwx-tab="closed">Fermés</button>
    </div>
    <p class="lwx-meta"><span data-lwx-count>{count($tickets)}</span> ticket(s)</p>

    <div class="lwx-list lwx-list-tight" data-lwx-list>
        {foreach $tickets as $ticket}
            {assign var=tst value=$ticket.statusClass}
            <a class="lwx-item lwx-item-ticket{if $ticket.unread} is-unread{/if}" href="{$WEB_ROOT}/viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" data-lwx-row="{if $tst == 'closed'}closed{elseif $tst == 'answered'}answered{else}open{/if}">
                <span class="lwx-ico"><i class="far fa-ticket-alt"></i></span>
                <div class="lwx-item-main">
                    <b>{$ticket.subject}</b>
                    <small>#{$ticket.tid} · {$ticket.department} · dernière réponse {$ticket.lastreply}</small>
                </div>
                <em class="lwx-badge {if is_null($ticket.statusColor)}lwx-badge-{$tst}{else}lwx-badge-custom{/if}"{if !is_null($ticket.statusColor)} style="--c:{$ticket.statusColor}"{/if}>{$ticket.status|strip_tags}</em>
                <i class="far fa-chevron-right lwx-chev"></i>
            </a>
        {/foreach}
        <div class="lwx-card lwx-empty" data-lwx-empty{if count($tickets)} style="display:none"{/if}>
            <p>Aucun ticket ne correspond.</p>
            <a href="{$WEB_ROOT}/submitticket.php" class="lwx-btn lwx-btn-ghost lwx-btn-sm">Ouvrir un ticket</a>
        </div>
    </div>
</div>
