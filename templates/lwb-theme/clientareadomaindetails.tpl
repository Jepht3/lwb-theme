{* LWB Theme — gestion d'un nom de domaine · LEWEBMAX Admin (dérivé de Twenty-One) *}
{if $registrarcustombuttonresult=="success"}
    {include file="$template/includes/alert.tpl" type="success" msg="{lang key='moduleactionsuccess'}" textcenter=true}
{elseif $registrarcustombuttonresult}
    {include file="$template/includes/alert.tpl" type="error" msg="{lang key='moduleactionfailed'}" textcenter=true}
{/if}

{if $unpaidInvoice}
    <div class="alert alert-{if $unpaidInvoiceOverdue}danger{else}warning{/if} lwx-alert-row" id="alert{if $unpaidInvoiceOverdue}Overdue{else}Unpaid{/if}Invoice">
        <span>{$unpaidInvoiceMessage}</span>
        <a href="viewinvoice.php?id={$unpaidInvoice}" class="btn btn-sm btn-primary">{lang key='payInvoice'}</a>
    </div>
{/if}

<div class="tab-content margin-bottom">

    {* ================= Overview ================= *}
    <div class="tab-pane fade show active" id="tabOverview">
        <div class="card">
            <div class="card-body">
                <div class="lwx-sec-head">
                    <span class="lwx-eyebrow">Vue d'ensemble</span>
                    <h3>Informations du domaine</h3>
                </div>

                {if $alerts}
                    {foreach $alerts as $alert}
                        {include file="$template/includes/alert.tpl" type=$alert.type msg="<strong>{$alert.title}</strong><br>{$alert.description}" textcenter=true}
                    {/foreach}
                {/if}
                {if $systemStatus != 'Active'}
                    <div class="alert alert-warning" role="alert">{lang key='domainCannotBeManagedUnlessActive'}</div>
                {/if}
                {if $lockstatus eq "unlocked"}
                    {capture name="domainUnlockedMsg"}<strong>{lang key='domaincurrentlyunlocked'}</strong><br />{lang key='domaincurrentlyunlockedexp'}{/capture}
                    {include file="$template/includes/alert.tpl" type="error" msg=$smarty.capture.domainUnlockedMsg}
                {/if}

                <dl class="lwx-facts">
                    <div><dt>Statut</dt><dd><em class="lwx-badge lwx-badge-{$systemStatus|strtolower}">{$status}</em></dd></div>
                    <div><dt>Enregistré le</dt><dd>{if $registrationdate}{$registrationdate}{else}—{/if}</dd></div>
                    <div><dt>Prochaine échéance</dt><dd>{if $nextduedate}{$nextduedate}{else}—{/if}</dd></div>
                    <div><dt>Renouvellement</dt><dd>{$recurringamount} <small>/ {$registrationperiod} an(s)</small></dd></div>
                    <div><dt>Premier paiement</dt><dd>{$firstpaymentamount}</dd></div>
                    <div><dt>Mode de paiement</dt><dd>{$paymentmethod}</dd></div>
                    {if $sslStatus}
                        <div class="{if $sslStatus->isInactive()}ssl-inactive{/if}">
                            <dt>Certificat SSL</dt>
                            <dd>
                                <img src="{$sslStatus->getImagePath()}" width="16" data-type="domain" data-domain="{$domain}" data-showlabel="1" class="{$sslStatus->getClass()}"/>
                                <span id="statusDisplayLabel">{if !$sslStatus->needsResync()}{$sslStatus->getStatusDisplayLabel()}{else}{lang key='loading'}{/if}</span>
                            </dd>
                        </div>
                        {if $sslStatus->isActive() || $sslStatus->needsResync()}
                            <div><dt>SSL valide jusqu'au</dt><dd><span id="ssl-expirydate">{if !$sslStatus->needsResync() || $sslStatus->expiryDate}{$sslStatus->expiryDate->toClientDateFormat()}{else}{lang key='loading'}{/if}</span></dd></div>
                            <div><dt>Émetteur SSL</dt><dd><span id="ssl-issuer">{if !$sslStatus->needsResync() || $sslStatus->issuerName}{$sslStatus->issuerName}{else}{lang key='loading'}{/if}</span></dd></div>
                            <div class="d-none"><dt>SSL depuis</dt><dd><span id="ssl-startdate">{if !$sslStatus->needsResync() || $sslStatus->startDate}{$sslStatus->startDate->toClientDateFormat()}{/if}</span></dd></div>
                        {/if}
                    {/if}
                </dl>

                {if $registrarclientarea}
                    <div class="moduleoutput">{$registrarclientarea|replace:'modulebutton':'btn'}</div>
                {/if}
                {foreach $hookOutput as $output}
                    <div>{$output}</div>
                {/foreach}
            </div>
        </div>

        {if $canDomainBeManaged and ($managementoptions.nameservers or $managementoptions.contacts or $managementoptions.locking or $renew)}
            <div class="card">
                <div class="card-body">
                    <div class="lwx-sec-head">
                        <span class="lwx-eyebrow">Actions rapides</span>
                        <h3>{lang key='doToday'}</h3>
                    </div>
                    <div class="lwx-actions-grid">
                        {if $systemStatus == 'Active' && $managementoptions.nameservers}
                            <a class="lwx-action tabControlLink" data-toggle="tab" href="#tabNameservers">
                                <span class="lwx-ico"><i class="far fa-server"></i></span>
                                <span><b>Serveurs de noms</b><small>{lang key='changeDomainNS'}</small></span>
                            </a>
                        {/if}
                        {if $systemStatus == 'Active' && $managementoptions.contacts}
                            <a class="lwx-action" href="clientarea.php?action=domaincontacts&domainid={$domainid}">
                                <span class="lwx-ico"><i class="far fa-address-card"></i></span>
                                <span><b>Contacts WHOIS</b><small>{lang key='updateWhoisContact'}</small></span>
                            </a>
                        {/if}
                        {if $systemStatus == 'Active' && $managementoptions.locking}
                            <a class="lwx-action tabControlLink" data-toggle="tab" href="#tabReglock">
                                <span class="lwx-ico"><i class="far fa-lock"></i></span>
                                <span><b>Verrouillage</b><small>{lang key='changeRegLock'}</small></span>
                            </a>
                        {/if}
                        {if $renew}
                            <a class="lwx-action" href="{routePath('domain-renewal', $domain)}">
                                <span class="lwx-ico"><i class="far fa-sync"></i></span>
                                <span><b>Renouveler</b><small>{lang key='domainrenew'}</small></span>
                            </a>
                        {/if}
                    </div>
                </div>
            </div>
        {/if}
    </div>

    {* ================= Auto-renewal ================= *}
    <div class="tab-pane fade" id="tabAutorenew">
        <div class="card">
            <div class="card-body">
                <div class="lwx-sec-head">
                    <span class="lwx-eyebrow">Renouvellement</span>
                    <h3>{lang key='domainsautorenew'}</h3>
                </div>
                {if $changeAutoRenewStatusSuccessful}
                    {include file="$template/includes/alert.tpl" type="success" msg="{lang key='changessavedsuccessfully'}" textcenter=true}
                {/if}
                <p class="text-muted">{lang key='domainrenewexp'}</p>
                <div class="lwx-toggle-row">
                    <div>
                        <span class="lwx-toggle-label">{lang key='domainautorenewstatus'}</span>
                        <em class="lwx-badge {if $autorenew}lwx-badge-active{else}lwx-badge-suspended{/if}">{if $autorenew}{lang key='domainsautorenewenabled'}{else}{lang key='domainsautorenewdisabled'}{/if}</em>
                    </div>
                    <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails#tabAutorenew">
                        <input type="hidden" name="id" value="{$domainid}">
                        <input type="hidden" name="sub" value="autorenew" />
                        {if $autorenew}
                            <input type="hidden" name="autorenew" value="disable">
                            <button type="submit" class="btn btn-danger">{lang key='domainsautorenewdisable'}</button>
                        {else}
                            <input type="hidden" name="autorenew" value="enable">
                            <button type="submit" class="btn btn-primary">{lang key='domainsautorenewenable'}</button>
                        {/if}
                    </form>
                </div>
            </div>
        </div>
    </div>

    {* ================= Name servers ================= *}
    <div class="tab-pane fade" id="tabNameservers">
        <div class="card">
            <div class="card-body">
                <div class="lwx-sec-head">
                    <span class="lwx-eyebrow">DNS</span>
                    <h3>{lang key='domainnameservers'}</h3>
                </div>
                {if $nameservererror}
                    {include file="$template/includes/alert.tpl" type="error" msg=$nameservererror textcenter=true}
                {/if}
                {if $subaction eq "savens"}
                    {if $updatesuccess}
                        {include file="$template/includes/alert.tpl" type="success" msg="{lang key='changessavedsuccessfully'}" textcenter=true}
                    {elseif $error}
                        {include file="$template/includes/alert.tpl" type="error" msg=$error textcenter=true}
                    {/if}
                {/if}
                <p class="text-muted">{lang key='domainnsexp'}</p>

                <form role="form" method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails#tabNameservers">
                    <input type="hidden" name="id" value="{$domainid}" />
                    <input type="hidden" name="sub" value="savens" />
                    <div class="lwx-choice">
                        <label class="lwx-choice-item">
                            <input type="radio" name="nschoice" value="default" onclick="disableFields('domnsinputs',true)"{if $defaultns} checked{/if} />
                            <span>{lang key='nschoicedefault'}</span>
                        </label>
                        <label class="lwx-choice-item">
                            <input type="radio" name="nschoice" value="custom" onclick="disableFields('domnsinputs',false)"{if !$defaultns} checked{/if} />
                            <span>{lang key='nschoicecustom'}</span>
                        </label>
                    </div>
                    <div class="lwx-ns-grid">
                        {for $num=1 to 5}
                            <div class="form-group">
                                <label for="inputNs{$num}">{lang key='clientareanameserver'} {$num}</label>
                                <input type="text" name="ns{$num}" class="form-control domnsinputs" id="inputNs{$num}" value="{$nameservers[$num].value}" placeholder="ns{$num}.exemple.com" />
                            </div>
                        {/for}
                    </div>
                    <button type="submit" class="btn btn-primary">{lang key='changenameservers'}</button>
                </form>
            </div>
        </div>
    </div>

    {* ================= Registrar lock ================= *}
    <div class="tab-pane fade" id="tabReglock">
        <div class="card">
            <div class="card-body">
                <div class="lwx-sec-head">
                    <span class="lwx-eyebrow">Sécurité</span>
                    <h3>{lang key='domainregistrarlock'}</h3>
                </div>
                {if $subaction eq "savereglock"}
                    {if $updatesuccess}
                        {include file="$template/includes/alert.tpl" type="success" msg="{lang key='changessavedsuccessfully'}" textcenter=true}
                    {elseif $error}
                        {include file="$template/includes/alert.tpl" type="error" msg=$error textcenter=true}
                    {/if}
                {/if}
                <p class="text-muted">{lang key='domainlockingexp'}</p>
                <div class="lwx-toggle-row">
                    <div>
                        <span class="lwx-toggle-label">{lang key='domainreglockstatus'}</span>
                        <em class="lwx-badge {if $lockstatus == "locked"}lwx-badge-active{else}lwx-badge-suspended{/if}">{if $lockstatus == "locked"}{lang key='domainsautorenewenabled'}{else}{lang key='domainsautorenewdisabled'}{/if}</em>
                    </div>
                    <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails#tabReglock">
                        <input type="hidden" name="id" value="{$domainid}">
                        <input type="hidden" name="sub" value="savereglock" />
                        {if $lockstatus=="locked"}
                            <button type="submit" class="btn btn-danger">{lang key='domainreglockdisable'}</button>
                        {else}
                            <button type="submit" class="btn btn-primary" name="reglock" value="1">{lang key='domainreglockenable'}</button>
                        {/if}
                    </form>
                </div>
            </div>
        </div>
    </div>

    {* ================= Release ================= *}
    <div class="tab-pane fade" id="tabRelease">
        <div class="card">
            <div class="card-body">
                <div class="lwx-sec-head">
                    <span class="lwx-eyebrow">Transfert</span>
                    <h3>{lang key='domainrelease'}</h3>
                </div>
                {if $releaseDomainSuccessful}
                    {include file="$template/includes/alert.tpl" type="success" msg="{lang key='changessavedsuccessfully'}" textcenter="true"}
                {elseif !empty($error)}
                    {include file="$template/includes/alert.tpl" type="error" msg="$error" textcenter="true"}
                {/if}
                <p class="text-muted">{lang key='domainreleasedescription'}</p>
                <form role="form" method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails#tabRelease">
                    <input type="hidden" name="sub" value="releasedomain">
                    <input type="hidden" name="id" value="{$domainid}">
                    <div class="form-group">
                        <label for="inputReleaseTag">{lang key='domainreleasetag'}</label>
                        <input type="text" class="form-control" id="inputReleaseTag" name="transtag" />
                    </div>
                    <button type="submit" class="btn btn-primary">{lang key='domainrelease'}</button>
                </form>
            </div>
        </div>
    </div>

    {* ================= Add-ons ================= *}
    <div class="tab-pane fade" id="tabAddons">
        <div class="card">
            <div class="card-body">
                <div class="lwx-sec-head">
                    <span class="lwx-eyebrow">Options</span>
                    <h3>{lang key='domainaddons'}</h3>
                </div>
                <p class="text-muted">{lang key='domainaddonsinfo'}</p>
                <div class="lwx-addon-list">
                    {if $addons.idprotection}
                        <div class="lwx-addon">
                            <span class="lwx-ico"><i class="far fa-user-shield"></i></span>
                            <div class="lwx-addon-main"><b>{lang key='domainidprotection'}</b><small>{lang key='domainaddonsidprotectioninfo'}</small></div>
                            <form action="clientarea.php?action=domainaddons" method="post">
                                <input type="hidden" name="id" value="{$domainid}"/>
                                {if $addonstatus.idprotection}
                                    <input type="hidden" name="disable" value="idprotect"/>
                                    <button type="submit" class="btn btn-sm btn-danger">{lang key='disable'}</button>
                                {else}
                                    <input type="hidden" name="buy" value="idprotect"/>
                                    <button type="submit" class="btn btn-sm btn-primary">{lang key='domainaddonsbuynow'} {$addonspricing.idprotection}</button>
                                {/if}
                            </form>
                        </div>
                    {/if}
                    {if $addons.dnsmanagement}
                        <div class="lwx-addon">
                            <span class="lwx-ico"><i class="far fa-cloud"></i></span>
                            <div class="lwx-addon-main"><b>{lang key='domainaddonsdnsmanagement'}</b><small>{lang key='domainaddonsdnsmanagementinfo'}</small></div>
                            <form action="clientarea.php?action=domainaddons" method="post">
                                <input type="hidden" name="id" value="{$domainid}"/>
                                {if $addonstatus.dnsmanagement}
                                    <input type="hidden" name="disable" value="dnsmanagement"/>
                                    <a class="btn btn-sm btn-primary" href="clientarea.php?action=domaindns&domainid={$domainid}">{lang key='manage'}</a>
                                    <button type="submit" class="btn btn-sm btn-danger">{lang key='disable'}</button>
                                {else}
                                    <input type="hidden" name="buy" value="dnsmanagement"/>
                                    <button type="submit" class="btn btn-sm btn-primary">{lang key='domainaddonsbuynow'} {$addonspricing.dnsmanagement}</button>
                                {/if}
                            </form>
                        </div>
                    {/if}
                    {if $addons.emailforwarding}
                        <div class="lwx-addon">
                            <span class="lwx-ico"><i class="far fa-share-square"></i></span>
                            <div class="lwx-addon-main"><b>{lang key='domainemailforwarding'}</b><small>{lang key='domainaddonsemailforwardinginfo'}</small></div>
                            <form action="clientarea.php?action=domainaddons" method="post">
                                <input type="hidden" name="id" value="{$domainid}"/>
                                {if $addonstatus.emailforwarding}
                                    <input type="hidden" name="disable" value="emailfwd"/>
                                    <a class="btn btn-sm btn-primary" href="clientarea.php?action=domainemailforwarding&domainid={$domainid}">{lang key='manage'}</a>
                                    <button type="submit" class="btn btn-sm btn-danger">{lang key='disable'}</button>
                                {else}
                                    <input type="hidden" name="buy" value="emailfwd"/>
                                    <button type="submit" class="btn btn-sm btn-primary">{lang key='domainaddonsbuynow'} {$addonspricing.emailforwarding}</button>
                                {/if}
                            </form>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>
