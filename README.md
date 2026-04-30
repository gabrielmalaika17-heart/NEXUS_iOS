# NEXUS OS — Application iOS

## Structure du projet
```
NEXUS/
├── App/
│   ├── NEXUSApp.swift          ✅ Point d'entrée
│   └── ContentView.swift       ✅ Navigation TabBar
├── Models/
│   └── Models.swift            ✅ TaskItem, SleepEntry, FocusSession
├── Managers/
│   └── AppStateManager.swift   ✅ État global, Focus timer, Exercices
├── Views/
│   ├── Components/
│   │   └── DesignSystem.swift  ✅ Couleurs, polices, composants
│   ├── Accueil/
│   │   └── AccueilView.swift   ✅ Dashboard principal
│   ├── Planif/
│   │   └── PlanifView.swift    ✅ Tâches + ajout
│   └── AllScreens.swift        ✅ Fitness, Sommeil, Bloquer, NexusAI
```

## Configuration API
1. Créer `Config.xcconfig` dans Xcode
2. Ajouter: `ANTHROPIC_API_KEY = sk-ant-VOTRE_CLE`
3. Référencer dans Info.plist: `ANTHROPIC_API_KEY = $(ANTHROPIC_API_KEY)`

## Déploiement via Codemagic (sans Mac)
Voir SETUP_CODEMAGIC.md
