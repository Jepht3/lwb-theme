{* LWB Theme — résumé du statut des services (module LWB Statut) · LEWEBMAX Admin *}
{if $lwbStatus}
<section class="lwx-card lwx-statuscard{if $lwbStatus.state != 'operational'} is-alert{/if}{if $lwbStatusClass} {$lwbStatusClass}{/if}">
    <div class="lwx-statuscard-main">
        <span class="lwb-dot lwb-tone-{$lwbStatus.tone}"></span>
        <div>
            <b>{$lwbStatus.label}</b>
            <small>
                {if $lwbStatus.incident}{$lwbStatus.incident.title|escape} · {$lwbStatus.incident.status}
                {elseif $lwbStatus.maintenance}Maintenance prévue : {$lwbStatus.maintenance.title|escape}{if $lwbStatus.maintenance.date} · {$lwbStatus.maintenance.date}{/if}
                {else}{$lwbStatus.components_total} service{if $lwbStatus.components_total > 1}s{/if} surveillé{if $lwbStatus.components_total > 1}s{/if} en continu{/if}
            </small>
        </div>
    </div>
    {if !$lwbStatusCompact}
        <div class="lwx-statuscard-chips">
            {foreach $lwbStatus.components as $sc}
                <span class="lwx-chip lwb-tone-{$sc.tone}" title="{$sc.label}"><i></i>{$sc.name|escape}</span>
            {/foreach}
        </div>
    {/if}
    <a class="lwx-btn lwx-btn-ghost lwx-btn-sm" href="{$WEB_ROOT}/{$lwbStatus.url}">Voir le statut</a>
</section>
{/if}
