{* LWB Theme — dernières connexions au compte (module LWB IP) · LEWEBMAX Admin *}
{if $lwbIp}
<section class="lwx-card lwx-ipcard{if $lwbIp.alert} is-alert{/if}">
    <header class="lwx-card-head">
        <h3><i class="fas fa-shield-alt"></i> Sécurité du compte</h3>
        <a href="{$WEB_ROOT}/{$lwbIp.url}">Toutes les connexions</a>
    </header>
    {if $lwbIp.alert}
        <p class="lwx-notice lwx-notice-warning"><i class="fas fa-exclamation-triangle"></i> Dernière connexion depuis un pays inhabituel. Si ce n'était pas vous, bloquez l'adresse et changez votre mot de passe.</p>
    {/if}
    <ul class="lwx-iplist">
        {foreach $lwbIp.logins as $l}
            <li>
                <span class="lwx-ico"><i class="fas {if $l.mobile}fa-mobile-alt{else}fa-desktop{/if}"></i></span>
                <div>
                    <b>{$l.device|escape}</b>
                    <small>{if $l.place}{$l.place|escape} · {/if}{$l.ago}</small>
                </div>
                {if $l.current}<span class="lwx-badge lwx-badge-active">C'est vous</span>{elseif $l.blocked}<span class="lwx-badge lwx-badge-suspended">Bloquée</span>{/if}
            </li>
        {/foreach}
    </ul>
    <a class="lwx-btn lwx-btn-ghost lwx-btn-sm" href="{$WEB_ROOT}/{$lwbIp.url}">Gérer mes connexions</a>
</section>
{/if}
