<?php
/**
 * LWB Theme — client dashboard data for the "lwb-theme" child theme.
 *
 * Only runs when a theme whose name starts with "lwb" is in use: other themes
 * are unaffected.
 *
 * @category  Theme
 * @author    LEWEBMAX Admin
 * @license   MIT
 */

use WHMCS\Database\Capsule;

if (!defined('WHMCS')) {
    die('This file cannot be accessed directly');
}

/**
 * Theme settings. Defaults below; override them in
 * includes/lwb_theme_config.php (see lwb_theme_config.example.php).
 * Empty contact values hide the matching buttons.
 */
function lwb_config()
{
    static $cfg = null;
    if ($cfg !== null) {
        return $cfg;
    }
    $cfg = [
        'support_phone' => '',
        'whatsapp' => '',
        'promo' => [
            'enabled' => false,
            'title' => '',
            'text' => '',
            'cta' => '',
            'url' => 'cart.php',
        ],
    ];
    $file = ROOTDIR . '/includes/lwb_theme_config.php';
    if (is_file($file)) {
        $custom = include $file;
        if (is_array($custom)) {
            $cfg = array_replace_recursive($cfg, $custom);
        }
    }
    return $cfg;
}

/**
 * Contact links shared by every page (empty when not configured).
 */
function lwb_contact()
{
    $cfg = lwb_config();
    $wa = preg_replace('/[^0-9]/', '', (string) $cfg['whatsapp']);
    $phone = trim((string) $cfg['support_phone']);
    return [
        'whatsapp_link' => $wa !== '' ? 'https://wa.me/' . $wa : '',
        'phone' => $phone,
        'phone_link' => $phone !== '' ? 'tel:' . preg_replace('/[^0-9+]/', '', $phone) : '',
    ];
}

function lwb_theme_active($vars = [])
{
    if (!empty($vars['template'])) {
        return strpos((string) $vars['template'], 'lwb') === 0;
    }
    $tpl = '';
    try {
        $tpl = (string) \WHMCS\Session::get('Template');
    } catch (\Throwable $e) {
    }
    if ($tpl === '' && !empty($GLOBALS['CONFIG']['Template'])) {
        $tpl = (string) $GLOBALS['CONFIG']['Template'];
    }
    if ($tpl === '') {
        $tpl = (string) \WHMCS\Config\Setting::getValue('Template');
    }
    return strpos($tpl, 'lwb') === 0;
}

function lwb_is_dashboard()
{
    return basename((string) ($_SERVER['SCRIPT_NAME'] ?? '')) === 'clientarea.php'
        && empty($_REQUEST['action']);
}

function lwb_date($date)
{
    if (!$date || strpos((string) $date, '0000-00-00') === 0) {
        return null;
    }
    return date('d/m/Y', strtotime($date));
}

function lwb_days_until($date)
{
    if (!$date || strpos((string) $date, '0000-00-00') === 0) {
        return null;
    }
    return (int) floor((strtotime(substr($date, 0, 10)) - strtotime(date('Y-m-d'))) / 86400);
}

/**
 * Full-width dashboard: no sidebars on the home page of the theme.
 */
foreach (['ClientAreaPrimarySidebar', 'ClientAreaSecondarySidebar'] as $lwbHook) {
    add_hook($lwbHook, 100, function ($sidebar) {
        if (!lwb_theme_active() || !lwb_is_dashboard() || !$sidebar) {
            return;
        }
        foreach ($sidebar->getChildren() as $child) {
            $sidebar->removeChild($child->getName());
        }
    });
}

/**
 * Cache-busting version for the theme stylesheet (changes on every CSS update).
 */
add_hook('ClientAreaPage', 1, function ($vars) {
    if (!lwb_theme_active($vars)) {
        return [];
    }
    $theme = preg_replace('/[^a-z0-9_-]/i', '', (string) ($vars['template'] ?? 'lwb-theme'));
    $css = ROOTDIR . '/templates/' . $theme . '/css/custom.css';
    return [
        'lwmAssetVersion' => is_file($css) ? (string) filemtime($css) : '',
        'lwbContact' => lwb_contact(),
        'lwbGatewayLogos' => lwb_gateway_logos($vars),
    ];
});

/**
 * Logos of the payment gateways offered at checkout, as a JSON object
 * {sysname: url}. Uses modules/gateways/<sysname>/logo.(svg|png|jpg|webp),
 * which most gateway modules ship. Empty string when there is no gateway list.
 */
function lwb_gateway_logos($vars)
{
    if (empty($vars['gateways']) || !is_array($vars['gateways'])) {
        return '';
    }
    $logos = [];
    foreach ($vars['gateways'] as $key => $gateway) {
        $sysname = is_array($gateway) && !empty($gateway['sysname']) ? $gateway['sysname'] : $key;
        $sysname = preg_replace('/[^a-z0-9_]/i', '', (string) $sysname);
        if ($sysname === '') {
            continue;
        }
        foreach (['svg', 'png', 'jpg', 'webp'] as $ext) {
            $rel = 'modules/gateways/' . $sysname . '/logo.' . $ext;
            if (is_file(ROOTDIR . '/' . $rel)) {
                $logos[$sysname] = $rel;
                break;
            }
        }
    }
    return json_encode((object) $logos, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_SLASHES);
}

function lwb_client_id($vars)
{
    if (!empty($vars['client']) && is_object($vars['client'])) {
        return (int) $vars['client']->id;
    }
    if (!empty($vars['clientsdetails']['userid'])) {
        return (int) $vars['clientsdetails']['userid'];
    }
    return 0;
}

/**
 * Account counters used by the sidebar badges and the list pages (every page).
 */
add_hook('ClientAreaPage', 2, function ($vars) {
    if (!lwb_theme_active($vars) || empty($vars['loggedin'])) {
        return [];
    }
    try {
        $clientId = lwb_client_id($vars);
        if (!$clientId) {
            return [];
        }
        $client = Capsule::table('tblclients')->where('id', $clientId)->first(['credit', 'currency']);
        $currencyId = (int) ($client->currency ?? 1);

        $due = Capsule::table('tblinvoices as i')
            ->where('i.userid', $clientId)->where('i.status', 'Unpaid')
            ->selectRaw('COUNT(*) AS n, COALESCE(SUM(i.total - COALESCE((SELECT SUM(a.amountin - a.amountout) FROM tblaccounts a WHERE a.invoiceid = i.id), 0)), 0) AS balance')
            ->first();

        $tickets = Capsule::table('tbltickets')->where('userid', $clientId);
        if (Capsule::schema()->hasColumn('tbltickets', 'merged_ticket_id')) {
            $tickets->where('merged_ticket_id', 0);
        }
        $byStatus = $tickets->groupBy('status')->selectRaw('status, COUNT(*) AS n')->pluck('n', 'status')->all();
        $answered = (int) ($byStatus['Answered'] ?? 0);
        $closed = (int) ($byStatus['Closed'] ?? 0);
        $open = array_sum($byStatus) - $answered - $closed;

        $services = Capsule::table('tblhosting')->where('userid', $clientId)
            ->groupBy('domainstatus')->selectRaw('domainstatus, COUNT(*) AS n')->pluck('n', 'domainstatus')->all();

        return ['lwx' => [
            'unpaid_count' => (int) $due->n,
            'due' => (string) formatCurrency(max(0, (float) $due->balance), $currencyId),
            'has_due' => (float) $due->balance > 0,
            'credit' => (string) formatCurrency((float) ($client->credit ?? 0), $currencyId),
            'tickets_open' => $open,
            'tickets_answered' => $answered,
            'tickets_closed' => $closed,
            'services_active' => (int) ($services['Active'] ?? 0),
            'services_total' => array_sum($services),
        ]];
    } catch (\Throwable $e) {
        logActivity('LWB Theme (counters): ' . $e->getMessage());
        return [];
    }
});

add_hook('ClientAreaPageHome', 1, function ($vars) {
    if (!lwb_theme_active($vars)) {
        return [];
    }

    try {
        $clientId = 0;
        if (!empty($vars['client']) && is_object($vars['client'])) {
            $clientId = (int) $vars['client']->id;
        } elseif (!empty($vars['clientsdetails']['userid'])) {
            $clientId = (int) $vars['clientsdetails']['userid'];
        }
        if (!$clientId) {
            return [];
        }

        $cfg = lwb_config();
        $client = Capsule::table('tblclients')->where('id', $clientId)->first(['firstname', 'lastname', 'companyname', 'currency']);
        $currencyId = (int) ($client->currency ?? 1);
        $money = function ($amount) use ($currencyId) {
            return (string) formatCurrency($amount, $currencyId);
        };

        // Invoices to pay ------------------------------------------------
        $flexpayActive = false;
        $flexLib = ROOTDIR . '/modules/gateways/flexpay/lib/Gateway.php';
        if (is_file($flexLib)) {
            require_once $flexLib;
            $flexpayActive = \FlexPayWhmcs\Gateway::isActive();
        }

        $rows = Capsule::table('tblinvoices as i')
            ->where('i.userid', $clientId)
            ->where('i.status', 'Unpaid')
            ->select('i.id', 'i.invoicenum', 'i.duedate', 'i.total')
            ->selectRaw('i.total - COALESCE((SELECT SUM(a.amountin - a.amountout) FROM tblaccounts a WHERE a.invoiceid = i.id), 0) AS balance')
            ->orderBy('i.duedate')
            ->get();

        $invoices = [];
        $due = 0.0;
        foreach ($rows as $inv) {
            $balance = max(0, round((float) $inv->balance, 2));
            if ($balance <= 0) {
                continue;
            }
            $due += $balance;
            $days = lwb_days_until($inv->duedate);
            $invoices[] = [
                'id' => (int) $inv->id,
                'num' => $inv->invoicenum ?: $inv->id,
                'due' => lwb_date($inv->duedate),
                'overdue' => $days !== null && $days < 0,
                'days' => $days,
                'amount' => $money($balance),
                'pay_url' => $flexpayActive
                    ? \FlexPayWhmcs\Gateway::guestPayUrl((int) $inv->id, 2)
                    : 'viewinvoice.php?id=' . (int) $inv->id,
                'pay_external' => $flexpayActive,
                'view_url' => 'viewinvoice.php?id=' . (int) $inv->id,
            ];
        }

        // Latest invoices, any status (dashboard list) --------------------
        $statusInvoice = ['Paid' => ['Payée', 'paid'], 'Unpaid' => ['Impayée', 'unpaid'], 'Cancelled' => ['Annulée', 'cancelled'],
            'Refunded' => ['Remboursée', 'refunded'], 'Collections' => ['Recouvrement', 'unpaid'], 'Payment Pending' => ['En cours', 'pending']];
        $unpaidById = [];
        foreach ($invoices as $inv) {
            $unpaidById[$inv['id']] = $inv;
        }
        $recentInvoices = [];
        foreach (Capsule::table('tblinvoices')->where('userid', $clientId)->where('status', '!=', 'Draft')
            ->orderBy('date', 'desc')->orderBy('id', 'desc')->limit(5)->get(['id', 'invoicenum', 'date', 'duedate', 'total', 'status']) as $inv) {
            $st = $statusInvoice[$inv->status] ?? [$inv->status, 'neutral'];
            $unpaid = $unpaidById[(int) $inv->id] ?? null;
            $recentInvoices[] = [
                'id' => (int) $inv->id,
                'num' => $inv->invoicenum ?: $inv->id,
                'date' => lwb_date($inv->date),
                'amount' => $unpaid ? $unpaid['amount'] : $money($inv->total),
                'status' => $st[0],
                'tone' => $st[1],
                'overdue' => $unpaid ? $unpaid['overdue'] : false,
                'pay_url' => $unpaid ? $unpaid['pay_url'] : null,
                'pay_external' => $unpaid ? $unpaid['pay_external'] : false,
                'view_url' => 'viewinvoice.php?id=' . (int) $inv->id,
            ];
        }

        // Services ------------------------------------------------------
        $statusFr = ['Active' => 'Actif', 'Suspended' => 'Suspendu', 'Pending' => 'En attente'];
        $svcRows = Capsule::table('tblhosting as h')
            ->join('tblproducts as p', 'p.id', '=', 'h.packageid')
            ->where('h.userid', $clientId)
            ->whereIn('h.domainstatus', ['Active', 'Suspended', 'Pending'])
            ->orderByRaw("FIELD(h.domainstatus, 'Suspended', 'Pending', 'Active')")
            ->orderBy('h.nextduedate')
            ->get(['h.id', 'h.packageid', 'h.domain', 'h.domainstatus', 'h.nextduedate', 'h.billingcycle', 'p.name', 'p.servertype']);

        // Products for which paid add-ons (extra mailboxes, storage...) can be bought.
        $addonProducts = [];
        foreach (Capsule::table('tbladdons')->where('hidden', 0)->where('retired', 0)->where('showorder', 1)->pluck('packages') as $csv) {
            foreach (array_filter(array_map('intval', explode(',', (string) $csv))) as $pid) {
                $addonProducts[$pid] = true;
            }
        }

        $services = [];
        foreach ($svcRows as $s) {
            $recurring = !in_array($s->billingcycle, ['Free Account', 'One Time'], true);
            $services[] = [
                'id' => (int) $s->id,
                'name' => $s->name,
                'domain' => $s->domain,
                'status' => $s->domainstatus,
                'status_fr' => $statusFr[$s->domainstatus] ?? $s->domainstatus,
                'next_due' => $recurring ? lwb_date($s->nextduedate) : null,
                'manage_url' => 'clientarea.php?action=productdetails&id=' . (int) $s->id,
                'sso_url' => ($s->servertype === 'cpanel' && $s->domainstatus === 'Active')
                    ? 'clientarea.php?action=productdetails&id=' . (int) $s->id . '&dosinglesignon=1'
                    : null,
                'addons_url' => ($s->domainstatus === 'Active' && isset($addonProducts[(int) $s->packageid]))
                    ? 'cart.php?gid=addons&pid=' . (int) $s->id
                    : null,
            ];
        }
        $activeServices = count(array_filter($services, function ($s) {
            return $s['status'] === 'Active';
        }));

        // Domains -------------------------------------------------------
        $domRows = Capsule::table('tbldomains')
            ->where('userid', $clientId)
            ->whereIn('status', ['Active', 'Grace', 'Redemption', 'Pending', 'Pending Transfer'])
            ->get(['id', 'domain', 'status', 'expirydate', 'nextduedate']);

        $domains = [];
        foreach ($domRows as $d) {
            $exp = (strpos((string) $d->expirydate, '0000-00-00') === 0) ? $d->nextduedate : $d->expirydate;
            $days = lwb_days_until($exp);
            $domains[] = [
                'id' => (int) $d->id,
                'domain' => $d->domain,
                'status' => $d->status,
                'expires' => lwb_date($exp),
                'days' => $days,
                'soon' => $days !== null && $days <= 30,
                'manage_url' => 'clientarea.php?action=domaindetails&id=' . (int) $d->id,
            ];
        }
        usort($domains, function ($a, $b) {
            return ($a['days'] ?? PHP_INT_MAX) <=> ($b['days'] ?? PHP_INT_MAX);
        });
        $activeDomains = count(array_filter($domains, function ($d) {
            return $d['status'] === 'Active';
        }));

        // Support -------------------------------------------------------
        $ticketQuery = Capsule::table('tbltickets')
            ->where('userid', $clientId)
            ->where('status', '!=', 'Closed');
        if (Capsule::schema()->hasColumn('tbltickets', 'merged_ticket_id')) {
            $ticketQuery->where('merged_ticket_id', 0);
        }
        $openTickets = (clone $ticketQuery)->count();
        $ticketRows = $ticketQuery->orderBy('lastreply', 'desc')->limit(3)->get(['tid', 'c', 'title', 'status', 'lastreply']);
        $tickets = [];
        foreach ($ticketRows as $t) {
            $tickets[] = [
                'tid' => $t->tid,
                'title' => $t->title,
                'status' => ['Open' => 'Ouvert', 'Customer-Reply' => 'En attente', 'In Progress' => 'En cours', 'On Hold' => 'En pause', 'Answered' => 'Répondu'][$t->status] ?? $t->status,
                'answered' => $t->status === 'Answered',
                'last' => lwb_date($t->lastreply),
                'url' => 'viewticket.php?tid=' . rawurlencode($t->tid) . '&c=' . rawurlencode($t->c),
            ];
        }

        // News ----------------------------------------------------------
        $news = Capsule::table('tblannouncements')
            ->where('published', 1)
            ->where('parentid', 0)
            ->orderBy('date', 'desc')
            ->first(['id', 'title', 'date']);

        // Headline ------------------------------------------------------
        $overdue = count(array_filter($invoices, function ($i) {
            return $i['overdue'];
        }));
        $soonDomains = count(array_filter($domains, function ($d) {
            return $d['soon'];
        }));
        if ($overdue) {
            $headline = $overdue . ' facture' . ($overdue > 1 ? 's' : '') . ' en retard de paiement.';
            $tone = 'danger';
        } elseif ($invoices) {
            $headline = count($invoices) . ' facture' . (count($invoices) > 1 ? 's' : '') . ' en attente de paiement.';
            $tone = 'warning';
        } elseif ($soonDomains) {
            $headline = $soonDomains . ' domaine' . ($soonDomains > 1 ? 's expirent' : ' expire') . ' dans moins de 30 jours.';
            $tone = 'warning';
        } else {
            $headline = 'Tout est en ordre. Vos services fonctionnent normalement.';
            $tone = 'ok';
        }

        return [
            'lwm' => [
                'firstname' => $client->firstname ?: $client->companyname,
                'headline' => $headline,
                'tone' => $tone,
                'due' => $money($due),
                'has_due' => $due > 0,
                'invoices' => $invoices,
                'recent_invoices' => $recentInvoices,
                'overdue_count' => $overdue,
                'lastname' => $client->lastname ?? '',
                'services' => array_slice($services, 0, 5),
                'services_total' => count($services),
                'services_active' => $activeServices,
                'domains' => array_slice($domains, 0, 5),
                'domains_total' => count($domains),
                'domains_active' => $activeDomains,
                'tickets' => $tickets,
                'tickets_open' => $openTickets,
                'news' => $news ? [
                    'title' => $news->title,
                    'date' => lwb_date($news->date),
                    'url' => 'index.php?rp=/announcements/' . (int) $news->id,
                ] : null,
                'promo' => !empty($cfg['promo']['enabled']) ? $cfg['promo'] : null,
            ] + lwb_contact(),
        ];
    } catch (\Throwable $e) {
        logActivity('LWB Theme (dashboard): ' . $e->getMessage());
        return [];
    }
});
