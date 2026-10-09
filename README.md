# LWB Theme

Tableau de bord client moderne et open source pour **WHMCS**, conçu par **LEWEBMAX Admin**.
C'est un thème enfant de **Twenty-One** : il fonctionne sur n'importe quelle installation WHMCS.

- Barre latérale de navigation, barre supérieure et menu mobile
- Tableau de bord : services, factures à payer, domaines, tickets, crédit disponible
- Pages redessinées : services, domaines (et détail d'un domaine), factures, tickets
- Facture en ligne modernisée, compteurs (factures impayées, réponses reçues) dans le menu
- Commande : modes de paiement présentés en cartes avec le logo de chaque passerelle
  (3 par ligne, 2 sur mobile), logo lu dans `modules/gateways/<module>/logo.png`
- Boutons WhatsApp / téléphone optionnels
- Compatible avec les modules **LWB Statut** (voyant de statut dans le menu, carte sur le tableau de bord et la page de connexion) et **LWB Champs** (formulaires allégés)
- Intégrations optionnelles détectées automatiquement :
  passerelle FlexPay (bouton « Payer » direct) et module de factures `lwm_invoices` ;
  sans eux, le thème utilise le comportement standard de WHMCS / Twenty-One.

**Compatibilité :** WHMCS 8.x et 9.x, PHP 7.4 à 8.3. Textes de l'interface en français.

## Installation

1. Copiez le contenu du dépôt à la racine de WHMCS :

   ```
   includes/hooks/lwb_theme.php                 ← données du tableau de bord
   includes/lwb_theme_config.example.php        ← exemple de réglages
   templates/lwb-theme/                         ← le thème
   ```

2. Dans **Configuration → Paramètres système → Paramètres généraux → Général**,
   choisissez le thème système **LWB Theme**.

3. (Optionnel) Copiez `includes/lwb_theme_config.example.php` en
   `includes/lwb_theme_config.php` et renseignez votre numéro WhatsApp, votre
   téléphone et la carte promotionnelle. Les boutons restent masqués tant que
   les valeurs sont vides.

Le hook ne s'active que si le thème utilisé commence par `lwb` : les autres
thèmes ne sont pas affectés.

## Personnalisation

- Couleurs et mise en page : `templates/lwb-theme/css/custom.css`
- Logo : celui défini dans WHMCS (**Paramètres généraux → Logo**)
- Ne modifiez pas les fichiers du thème parent `twenty-one`.

## Historique

- **1.4.0** — Nouveau design : bas de la page de paiement (lettre d'information, CGU, bouton), base de connaissances, annonces ; intégration du statut des services.
- **1.3.1** — Page de commande : modes de paiement en grille de cartes avec logos.
- **1.3.0** — Première version publique sous le nom LWB Theme : refonte de
  l'espace client (en-tête, pied de page, barre latérale, accueil, domaines,
  services, factures, tickets), réglages externalisés.

## Licence

MIT — voir [LICENSE](LICENSE).