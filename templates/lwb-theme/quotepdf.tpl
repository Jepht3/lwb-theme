<?php
/**
 * Facture proforma (devis WHMCS) en PDF, thème LWB Theme.
 *
 * Si le module LWM Factures est actif (option « PDF au même style »), la
 * proforma reprend le modèle choisi dans Addons > LWM Factures. Sinon, on
 * utilise le PDF de devis standard du thème parent Twenty-One.
 */

$lwmInvoicesLib = ROOTDIR . '/modules/addons/lwm_invoices/lib/bootstrap.php';
$lwmInvoicesUsed = false;

if (file_exists($lwmInvoicesLib)) {
    try {
        require_once $lwmInvoicesLib;
        if (\LwmInvoices\Settings::isActive() && \LwmInvoices\Settings::get('pdf') === 'on') {
            $renderer = new \LwmInvoices\PdfRenderer(
                $pdf,
                get_defined_vars(),
                \LwmInvoices\Variants::get(\LwmInvoices\Settings::get('variant')),
                \LwmInvoices\Settings::renderOptions() + [
                    'logo' => \LwmInvoices\Settings::logoPath(),
                    'mode' => 'quote',
                ]
            );
            $renderer->render();
            $lwmInvoicesUsed = true;
        }
    } catch (\Throwable $e) {
        logActivity('LWM Factures (PDF proforma) : ' . $e->getMessage());
    }
}

if (!$lwmInvoicesUsed) {
    include ROOTDIR . '/templates/twenty-one/quotepdf.tpl';
}
