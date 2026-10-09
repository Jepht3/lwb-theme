<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="{$charset}" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    <link href="{assetPath file='all.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{assetPath file='theme.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/assets/css/fontawesome-all.min.css" rel="stylesheet">
    <link href="{assetPath file='invoice.min.css'}?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v={if $lwmAssetVersion}{$lwmAssetVersion}{else}{$versionHash}{/if}" rel="stylesheet">
    {if $lwmInvoiceCss}<link href="{$lwmInvoiceCss}" rel="stylesheet">{/if}
    <script>var whmcsBaseUrl = "{$WEB_ROOT}";</script>
    <script src="{assetPath file='scripts.min.js'}?v={$versionHash}"></script>
</head>
<body class="{if $lwmInvoiceHtml}lwx-body{else}lwi-body{/if}">

{if $lwmInvoiceHtml}
{* Facture générée par le module LWM Factures (modèle choisi dans Addons > LWM Factures). *}
{$lwmInvoiceHtml}
{else}
<div class="lwi">

    <div class="lwi-top d-print-none">
        <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="lwi-back"><i class="fas fa-arrow-left" aria-hidden="true"></i> {lang key='invoicesbacktoclientarea'}</a>
        {if !$invalidInvoiceIdRequested}
        <div class="lwi-tools">
            <a href="javascript:window.print()" class="lwi-tool" title="{lang key='print'}"><i class="fas fa-print" aria-hidden="true"></i><span>{lang key='print'}</span></a>
            <a href="dl.php?type=i&amp;id={$invoiceid}" class="lwi-tool" title="{lang key='invoicesdownload'}"><i class="fas fa-download" aria-hidden="true"></i><span>PDF</span></a>
        </div>
        {/if}
    </div>

    <div class="lwi-sheet">

    {if $invalidInvoiceIdRequested}

        {include file="$template/includes/panel.tpl" type="danger" headerTitle="{lang key='error'}" bodyContent="{lang key='invoiceserror'}" bodyTextCenter=true}

    {else}

        {* ---------- Header ---------- *}
        <header class="lwi-head">
            <div class="lwi-brand">
                {if $logo}
                    <img src="{$logo}" alt="{$companyname}" />
                {else}
                    <strong>{$companyname}</strong>
                {/if}
            </div>
            <div class="lwi-title">
                <h1>{$pagetitle}</h1>
                {if $status eq "Draft"}
                    <span class="lwi-status lwi-s-neutral">{lang key='invoicesdraft'}</span>
                {elseif $status eq "Unpaid"}
                    <span class="lwi-status lwi-s-danger">{lang key='invoicesunpaid'}</span>
                {elseif $status eq "Paid"}
                    <span class="lwi-status lwi-s-ok">{lang key='invoicespaid'}</span>
                {elseif $status eq "Refunded"}
                    <span class="lwi-status lwi-s-warn">{lang key='invoicesrefunded'}</span>
                {elseif $status eq "Cancelled"}
                    <span class="lwi-status lwi-s-neutral">{lang key='invoicescancelled'}</span>
                {elseif $status eq "Collections"}
                    <span class="lwi-status lwi-s-danger">{lang key='invoicescollections'}</span>
                {elseif $status eq "Payment Pending"}
                    <span class="lwi-status lwi-s-info">{lang key='invoicesPaymentPending'}</span>
                {/if}
            </div>
            <dl class="lwi-dates">
                <div><dt>{lang key='invoicesdatecreated'}</dt><dd>{$date}</dd></div>
                {if $status eq "Unpaid" || $status eq "Draft"}
                    <div><dt>{lang key='invoicesdatedue'}</dt><dd>{$datedue}</dd></div>
                {/if}
            </dl>
        </header>

        {* ---------- Payment feedback ---------- *}
        {if $paymentSuccessAwaitingNotification}
            {include file="$template/includes/panel.tpl" type="success" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicePaymentSuccessAwaitingNotify'}" bodyTextCenter=true}
        {elseif $paymentSuccess}
            {include file="$template/includes/panel.tpl" type="success" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicepaymentsuccessconfirmation'}" bodyTextCenter=true}
        {elseif $paymentInititated}
            {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicePaymentInitiated'}" bodyTextCenter=true}
        {elseif $pendingReview}
            {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='success'}" bodyContent="{lang key='invoicepaymentpendingreview'}" bodyTextCenter=true}
        {elseif $paymentFailed}
            {include file="$template/includes/panel.tpl" type="danger" headerTitle="{lang key='error'}" bodyContent="{lang key='invoicepaymentfailedconfirmation'}" bodyTextCenter=true}
        {elseif $offlineReview}
            {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='success'}" bodyContent="{lang key='invoiceofflinepaid'}" bodyTextCenter=true}
        {/if}

        {* ---------- Pay now ---------- *}
        {if $status eq "Unpaid" || $status eq "Draft"}
        <section class="lwi-pay d-print-none">
            <div class="lwi-pay-summary">
                <span class="lwi-label">{lang key='invoicesbalance'}</span>
                <span class="lwi-balance">{$balance}</span>
                <span class="lwi-muted">{lang key='invoicesdatedue'} : {$datedue}</span>
                <div class="lwi-method">
                    <span class="lwi-label">{lang key='paymentmethod'}</span>
                    {if $status eq "Unpaid" && $allowchangegateway}
                        <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}">
                            {$tokenInput}
                            <select name="gateway" class="custom-select" onchange="submit()">
                                {foreach $availableGateways as $gatewayModule => $gatewayName}
                                    <option value="{$gatewayModule}"{if $gatewayModule == $selectedGateway} selected="selected"{/if}>{$gatewayName}</option>
                                {/foreach}
                            </select>
                        </form>
                    {else}
                        <span>{$paymentmethod}{if $paymethoddisplayname} ({$paymethoddisplayname}){/if}</span>
                    {/if}
                </div>
            </div>
            <div class="lwi-pay-action payment-btn-container">
                {$paymentbutton}
            </div>
        </section>
        {/if}

        {* ---------- Apply credit ---------- *}
        {if $manualapplycredit}
        <section class="lwi-box lwi-credit d-print-none">
            <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}">
                <input type="hidden" name="applycredit" value="true" />
                <p><strong>{lang key='invoiceaddcreditapply'}</strong><br>
                {lang key='invoiceaddcreditdesc1'} <strong>{$totalcredit}</strong>. {lang key='invoiceaddcreditdesc2'}. {lang key='invoiceaddcreditamount'} :</p>
                <div class="input-group lwi-credit-input">
                    <input type="text" name="creditamount" value="{$creditamount}" class="form-control" />
                    <div class="input-group-append">
                        <button type="submit" class="btn btn-primary" id="btnInvoiceAddCreditApply">{lang key='invoiceaddcreditapply'}</button>
                    </div>
                </div>
            </form>
        </section>
        {/if}

        {* ---------- Parties ---------- *}
        <section class="lwi-parties">
            <div>
                <span class="lwi-label">{lang key='invoicesinvoicedto'}</span>
                <address>
                    {if $clientsdetails.companyname}<strong>{$clientsdetails.companyname}</strong><br />{/if}
                    {$clientsdetails.firstname} {$clientsdetails.lastname}<br />
                    {$clientsdetails.address1}{if $clientsdetails.address2}, {$clientsdetails.address2}{/if}<br />
                    {$clientsdetails.city}{if $clientsdetails.state}, {$clientsdetails.state}{/if}{if $clientsdetails.postcode}, {$clientsdetails.postcode}{/if}<br />
                    {$clientsdetails.country}
                    {if $clientsdetails.tax_id}<br />{$taxIdLabel} : {$clientsdetails.tax_id}{/if}
                    {if $customfields}
                        <br />
                        {foreach $customfields as $customfield}
                            <br />{$customfield.fieldname} : {$customfield.value}
                        {/foreach}
                    {/if}
                </address>
            </div>
            <div>
                <span class="lwi-label">{lang key='invoicespayto'}</span>
                <address>
                    {$payto}
                    {if $taxCode}<br />{$taxIdLabel} : {$taxCode}{/if}
                </address>
            </div>
            {if !($status eq "Unpaid" || $status eq "Draft")}
            <div>
                <span class="lwi-label">{lang key='paymentmethod'}</span>
                <address>{$paymentmethod}{if $paymethoddisplayname} ({$paymethoddisplayname}){/if}</address>
            </div>
            {/if}
        </section>

        {if $notes}
            {include file="$template/includes/panel.tpl" type="info" headerTitle="{lang key='invoicesnotes'}" bodyContent=$notes}
        {/if}

        {* ---------- Items ---------- *}
        <section class="lwi-box lwi-items">
            <table class="lwi-table">
                <thead>
                    <tr>
                        <th>{lang key='invoicesdescription'}</th>
                        <th class="lwi-num">{lang key='invoicesamount'}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $invoiceitems as $item}
                        <tr>
                            <td>{$item.description}{if $item.taxed eq "true"} *{/if}</td>
                            <td class="lwi-num">{$item.amount}</td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
            <dl class="lwi-totals">
                <div><dt>{lang key='invoicessubtotal'}</dt><dd>{$subtotal}</dd></div>
                {if $taxname}<div><dt>{$taxrate}% {$taxname}</dt><dd>{$tax}</dd></div>{/if}
                {if $taxname2}<div><dt>{$taxrate2}% {$taxname2}</dt><dd>{$tax2}</dd></div>{/if}
                <div><dt>{lang key='invoicescredit'}</dt><dd>{$credit}</dd></div>
                <div class="lwi-grand"><dt>{lang key='invoicestotal'}</dt><dd>{$total}</dd></div>
            </dl>
            {if $taxrate}<p class="lwi-muted lwi-note">* {lang key='invoicestaxindicator'}</p>{/if}
        </section>

        {* ---------- Transactions ---------- *}
        <section class="lwi-box lwi-transactions">
            <h2>Transactions</h2>
            <div class="table-responsive">
                <table class="lwi-table lwi-table-sm">
                    <thead>
                        <tr>
                            <th>{lang key='invoicestransdate'}</th>
                            <th>{lang key='invoicestransgateway'}</th>
                            <th>{lang key='invoicestransid'}</th>
                            <th class="lwi-num">{lang key='invoicestransamount'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $transactions as $transaction}
                            <tr>
                                <td>{$transaction.date}</td>
                                <td>{$transaction.gateway}</td>
                                <td class="lwi-mono">{$transaction.transid}</td>
                                <td class="lwi-num">{$transaction.amount}</td>
                            </tr>
                        {foreachelse}
                            <tr><td colspan="4" class="lwi-muted lwi-center">{lang key='invoicestransnonefound'}</td></tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <div class="lwi-balance-row"><span>{lang key='invoicesbalance'}</span><strong>{$balance}</strong></div>
        </section>

    {/if}

    </div>
</div>
{/if}

<div id="fullpage-overlay" class="w-hidden">
    <div class="outer-wrapper">
        <div class="inner-wrapper">
            <img src="{$WEB_ROOT}/assets/img/overlay-spinner.svg" alt="">
            <br>
            <span class="msg"></span>
        </div>
    </div>
</div>

</body>
</html>
