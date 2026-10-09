<?php
/**
 * LWB Theme — optional settings.
 *
 * Copy this file to includes/lwb_theme_config.php and adjust the values.
 * Leave a value empty to hide the matching button.
 */
return [
    'support_phone' => '',          // e.g. '+243 000 000 000'
    'whatsapp'      => '',          // international number, digits only, e.g. '243000000000'
    'promo' => [
        'enabled' => false,         // promo card on the dashboard
        'title'   => 'Faites grandir votre présence en ligne',
        'text'    => 'Hébergement, noms de domaine et e-mails professionnels : découvrez nos offres.',
        'cta'     => 'Voir les offres',
        'url'     => 'cart.php',
    ],
];