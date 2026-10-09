{assign var=lwxFull value=in_array($templatefile, ['clientareahome', 'clientareaproducts', 'clientareainvoices', 'clientareadomains', 'supportticketslist', 'clientareadetails', 'clientareaemails', 'user-security', 'user-password', 'user-profile', 'account-contacts-manage', 'account-contacts-new', 'account-paymentmethods', 'account-user-management', 'account-user-permissions'])}
                    </div>

                    </div>
                <div class="clearfix"></div>
            </div>
        </section>

        <footer id="footer" class="lwx-footer">
            <div class="lwx-container lwx-footer-inner">
                <p>{lang key="copyrightFooterNotice" year=$date_year company=$companyname}</p>
                <ul>
                    <li><a href="{$WEB_ROOT}/contact.php">{lang key='contactus'}</a></li>
                    {if $acceptTOS}
                        <li><a href="{$tosURL}" target="_blank">{lang key='ordertos'}</a></li>
                    {/if}
                    {if $languagechangeenabled && count($locales) > 1 || $currencies}
                        <li>
                            <button type="button" class="lwx-locale" data-toggle="modal" data-target="#modalChooseLanguage">
                                <span class="iti-flag {if $activeLocale.countryCode === '001'}us{else}{$activeLocale.countryCode|lower}{/if}"></span>
                                {$activeLocale.localisedName} / {$activeCurrency.prefix} {$activeCurrency.code}
                            </button>
                        </li>
                    {/if}
                </ul>
            </div>
        </footer>

    </div>{* /.lwx-main *}
</div>{* /.lwx-shell *}

    <div id="fullpage-overlay" class="w-hidden">
        <div class="outer-wrapper">
            <div class="inner-wrapper">
                <img src="{$WEB_ROOT}/assets/img/overlay-spinner.svg" alt="">
                <br>
                <span class="msg"></span>
            </div>
        </div>
    </div>

    <div class="modal system-modal fade" id="modalAjax" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">{lang key='close'}</span>
                    </button>
                </div>
                <div class="modal-body">
                    {lang key='loading'}
                </div>
                <div class="modal-footer">
                    <div class="float-left loader">
                        <i class="fas fa-circle-notch fa-spin"></i>
                        {lang key='loading'}
                    </div>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        {lang key='close'}
                    </button>
                    <button type="button" class="btn btn-primary modal-submit">
                        {lang key='submit'}
                    </button>
                </div>
            </div>
        </div>
    </div>

    <form method="get" action="{$currentpagelinkback}">
        <div class="modal modal-localisation" id="modalChooseLanguage" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <button type="button" class="close text-light" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>

                        {if $languagechangeenabled && count($locales) > 1}
                            <h5 class="h5 pt-5 pb-3">{lang key='chooselanguage'}</h5>
                            <div class="row item-selector">
                                <input type="hidden" name="language" data-current="{$language}" value="{$language}" />
                                {foreach $locales as $locale}
                                    <div class="col-4">
                                        <a href="#" class="item{if $language == $locale.language} active{/if}" data-value="{$locale.language}">
                                            {$locale.localisedName}
                                        </a>
                                    </div>
                                {/foreach}
                            </div>
                        {/if}
                        {if !$loggedin && $currencies}
                            <p class="h5 pt-5 pb-3">{lang key='choosecurrency'}</p>
                            <div class="row item-selector">
                                <input type="hidden" name="currency" data-current="{$activeCurrency.id}" value="">
                                {foreach $currencies as $selectCurrency}
                                    <div class="col-4">
                                        <a href="#" class="item{if $activeCurrency.id == $selectCurrency.id} active{/if}" data-value="{$selectCurrency.id}">
                                            {$selectCurrency.prefix} {$selectCurrency.code}
                                        </a>
                                    </div>
                                {/foreach}
                            </div>
                        {/if}
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-default">{lang key='apply'}</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    {if !$loggedin && $adminLoggedIn}
        <a href="{$WEB_ROOT}/logout.php?returntoadmin=1" class="btn btn-return-to-admin" data-toggle="tooltip" data-placement="bottom" title="{if $adminMasqueradingAsClient}{lang key='adminmasqueradingasclient'} {lang key='logoutandreturntoadminarea'}{else}{lang key='adminloggedin'} {lang key='returntoadminarea'}{/if}">
            <i class="fas fa-redo-alt"></i>
            <span class="d-none d-md-inline-block">{lang key="admin.returnToAdmin"}</span>
        </a>
    {/if}

    {include file="$template/includes/generate-password.tpl"}

    <script>
    (function () {
        // Keep the active tab visible in the mobile navigation.
        var a = document.querySelector('.lwx-mtabs a.active');
        if (a) { a.parentNode.scrollLeft = Math.max(0, a.offsetLeft - 16); }

        // Search and filter tabs of the list pages (services, invoices, domains, tickets).
        document.querySelectorAll('[data-lwx-list]').forEach(function (list) {
            var root = list.closest('.lwx-page') || document;
            var input = root.querySelector('[data-lwx-search]');
            var tabs = root.querySelectorAll('[data-lwx-tab]');
            var counter = root.querySelector('[data-lwx-count]');
            var empty = root.querySelector('[data-lwx-empty]');
            var current = 'all';
            if (list.hasAttribute('data-lwx-sort')) {
                var rows = Array.prototype.slice.call(list.querySelectorAll('[data-lwx-key]'));
                rows.sort(function (a, b) { return a.getAttribute('data-lwx-key') < b.getAttribute('data-lwx-key') ? 1 : -1; });
                var emptyBox = list.querySelector('[data-lwx-empty]');
                rows.forEach(function (r) { list.insertBefore(r, emptyBox); });
            }
            function apply() {
                var q = input ? input.value.trim().toLowerCase() : '';
                var shown = 0;
                list.querySelectorAll('[data-lwx-row]').forEach(function (row) {
                    var okTab = current === 'all' || (' ' + row.getAttribute('data-lwx-row') + ' ').indexOf(' ' + current + ' ') !== -1;
                    var okText = !q || row.textContent.toLowerCase().indexOf(q) !== -1;
                    var on = okTab && okText;
                    row.style.display = on ? '' : 'none';
                    if (on) { shown++; }
                });
                if (counter) { counter.textContent = shown; }
                if (empty) { empty.style.display = shown ? 'none' : ''; }
            }
            tabs.forEach(function (t) {
                t.addEventListener('click', function () {
                    current = t.getAttribute('data-lwx-tab');
                    tabs.forEach(function (x) { x.classList.toggle('active', x === t); });
                    apply();
                });
            });
            if (input) {
                input.addEventListener('input', apply);
                var form = input.closest('form');
                if (form) { form.addEventListener('submit', function (e) { e.preventDefault(); apply(); }); }
            }
            apply();
        });
    })();
    </script>

    {if $lwbGatewayLogos}
    <script>
    // Checkout: payment methods as a grid of cards with the gateway logo.
    jQuery(function ($) {
        var logos = {$lwbGatewayLogos};
        var box = $('#paymentGatewaysContainer');
        if (!box.length || box.hasClass('lwb-pay')) { return; }
        box.addClass('lwb-pay');
        var grid = box.find('label.radio-inline').first().parent().addClass('lwb-pay-grid');
        grid.find('label.radio-inline').each(function () {
            var label = $(this).addClass('lwb-pay-card');
            var input = label.find('input[name="paymentmethod"]');
            var name = $.trim(label.text());
            label.contents().filter(function () { return this.nodeType === 3; }).remove();
            var logo = $('<span class="lwb-pay-logo"></span>');
            var sys = input.val();
            if (logos[sys]) {
                logo.append($('<img alt="" loading="lazy">').attr('src', '{$WEB_ROOT}/' + logos[sys]));
            } else {
                var icon = /paypal/i.test(sys) ? 'fab fa-paypal' : (input.hasClass('is-credit-card') ? 'far fa-credit-card' : 'far fa-wallet');
                logo.append($('<i aria-hidden="true"></i>').addClass(icon));
            }
            label.append(logo, $('<span class="lwb-pay-name"></span>').text(name));
        });
        function sync() {
            grid.find('.lwb-pay-card').each(function () {
                $(this).toggleClass('is-checked', $(this).find('input[name="paymentmethod"]').prop('checked'));
            });
        }
        grid.on('change ifChanged ifChecked', 'input[name="paymentmethod"]', function () { setTimeout(sync, 0); });
        sync();
    });
    </script>
    {/if}

    {$footeroutput}

</body>
</html>
