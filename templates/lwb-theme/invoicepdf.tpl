<?php
/**
 * Facture PDF du thème LWB Theme.
 *
 * Si le module LWM Factures est actif (option « PDF au même style »), le PDF
 * reprend le modèle choisi dans Addons > LWM Factures. Sinon, on utilise le
 * PDF standard du thème parent Twenty-One.
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
                \LwmInvoices\Settings::renderOptions() + ['logo' => \LwmInvoices\Settings::logoPath()]
            );
            $renderer->render();
            $lwmInvoicesUsed = true;
        }
    } catch (\Throwable $e) {
        logActivity('LWM Factures (PDF) : ' . $e->getMessage());
    }
}

if (!$lwmInvoicesUsed) {
    include ROOTDIR . '/templates/twenty-one/invoicepdf.tpl';
}
