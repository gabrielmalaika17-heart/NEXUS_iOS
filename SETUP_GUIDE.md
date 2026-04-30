# NEXUS OS — Guide de déploiement complet (sans Mac)

## ÉTAPE 1 — Créer ton compte GitHub

1. Va sur https://github.com
2. Crée un compte gratuit
3. Crée un nouveau dépôt : "NEXUS-iOS" (privé recommandé)

## ÉTAPE 2 — Uploader le code

Sur GitHub, dans ton dépôt vide :
- Clique "uploading an existing file"
- Glisse-dépose tous les fichiers .swift du projet
- Respecte la structure de dossiers

Structure à respecter :
```
NEXUS/
  App/
    NEXUSApp.swift
    ContentView.swift
  Models/
    Models.swift
  Managers/
    AppStateManager.swift
  Views/
    Components/
      DesignSystem.swift
    Accueil/
      AccueilView.swift
    Planif/
      PlanifView.swift
    AllScreens.swift
codemagic.yaml
```

## ÉTAPE 3 — Créer le projet Xcode (nécessaire une fois)

Option A — Utiliser un Mac en bibliothèque ou emprunté :
1. Ouvre Xcode → New Project → iOS App
2. Nom: NEXUS, Bundle ID: com.yourname.nexus
3. Language: Swift, Interface: SwiftUI
4. Copie tous les fichiers .swift dans le projet
5. Commit et push vers GitHub

Option B — MacStadium (Mac en cloud, ~20$/mois) :
1. Va sur macstadium.com
2. Loue un Mac pour 1-2 heures (pay-as-you-go)
3. Installe Xcode, crée le projet, push vers GitHub

## ÉTAPE 4 — Créer compte Codemagic

1. Va sur https://codemagic.io
2. Connecte ton compte GitHub
3. Sélectionne le dépôt NEXUS-iOS
4. Codemagic détecte automatiquement codemagic.yaml

## ÉTAPE 5 — Configurer les variables secrètes

Dans Codemagic → Settings → Environment variables :
- Nom: `ANTHROPIC_API_KEY`
- Valeur: ta clé API Claude (commence par sk-ant-)
- Cocher "Secure" (chiffré)

## ÉTAPE 6 — Lancer le premier build

1. Dans Codemagic, clique "Start new build"
2. Attends 15-30 minutes
3. Tu reçois un email avec le résultat

## ÉTAPE 7 — Tester sur ton iPhone

Pour tester SANS App Store (développement) :
1. Installe "TestFlight" sur ton iPhone
2. Dans Codemagic → Publishing → TestFlight
3. Configure ton Apple Developer Account (gratuit pour tests)
4. L'app s'installe directement sur ton iPhone via TestFlight

## ÉTAPE 8 — Publier sur l'App Store (quand prêt)

1. Apple Developer Program : 99$/an
2. Dans Xcode (ou Codemagic) → Archive → Upload to App Store
3. Remplis la fiche App Store Connect
4. Soumets pour review (1-7 jours)

---

## Résumé des coûts

| Service | Coût |
|---------|------|
| GitHub | Gratuit |
| Codemagic | Gratuit (500 min/mois) |
| Apple Developer (tests) | Gratuit |
| Apple Developer (App Store) | 99$/an |
| MacStadium (si besoin) | ~3$ pour 2h |
| API Claude (Anthropic) | ~0.01$/conversation |

---

## Problèmes fréquents et solutions

**"Code signing error"**
→ Dans Xcode : Signing & Capabilities → Automatically manage signing

**"Module not found"**
→ Vérifie que tous les fichiers .swift sont dans le bon target Xcode

**"API key not found"**
→ Vérifie que ANTHROPIC_API_KEY est bien dans les variables Codemagic

**"Build timeout"**
→ Codemagic gratuit = 500 min/mois. Chaque build prend ~10-15 min.

---

## Contact pour aide

Si tu bloques sur une étape, envoie le message d'erreur exact à Claude
et je t'aide à déboguer étape par étape.
