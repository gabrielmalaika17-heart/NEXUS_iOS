import SwiftUI
import Combine

// MARK: - App State Manager
@MainActor
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()

    // Fitness data
    @Published var calories: Double = 1840
    @Published var steps: Int = 7230
    @Published var waterMl: Double = 1000
    @Published var heartRate: Int = 72
    @Published var heartRateStatus: String = "Bonne"

    // Hydration helpers
    var waterProgress: Double { min(waterMl / 2500.0, 1.0) }
    var waterStatus: String {
        let pct = waterProgress
        if pct >= 0.8 { return "✓ Optimal" }
        if pct >= 0.5 { return "~ Correct" }
        return "⚠ Faible"
    }
    var waterStatusColor: Color {
        let pct = waterProgress
        if pct >= 0.8 { return NexusColors.green }
        if pct >= 0.5 { return NexusColors.yellow }
        return NexusColors.red
    }
    var waterMessage: String {
        let pct = waterProgress
        if pct >= 0.8 { return "Excellent ! Tu es bien hydraté." }
        if pct >= 0.5 { return "Continue à boire régulièrement." }
        return "Tu es déshydraté. Bois plus d'eau."
    }

    func addWater(_ ml: Double) {
        waterMl = min(waterMl + ml, 2500)
    }

    // Focus state
    @Published var focusIsRunning: Bool = false
    @Published var focusSecondsRemaining: Int = 0
    @Published var focusDurationMinutes: Int = 25
    @Published var focusIsPaused: Bool = false
    @Published var focusBlockedApps: [String] = []

    private var focusTimer: Timer?

    func startFocus(minutes: Int, apps: [String]) {
        focusDurationMinutes = minutes
        focusSecondsRemaining = minutes * 60
        focusBlockedApps = apps
        focusIsRunning = true
        focusIsPaused = false
        startTimer()
    }

    func pauseResumeFocus() {
        focusIsPaused.toggle()
        if focusIsPaused {
            focusTimer?.invalidate()
        } else {
            startTimer()
        }
    }

    func stopFocus(completed: Bool = false) {
        focusTimer?.invalidate()
        focusTimer = nil
        focusIsRunning = false
        focusIsPaused = false
    }

    private func startTimer() {
        focusTimer?.invalidate()
        focusTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                if self.focusSecondsRemaining > 0 {
                    self.focusSecondsRemaining -= 1
                } else {
                    self.stopFocus(completed: true)
                }
            }
        }
    }

    var timerDisplayString: String {
        let m = focusSecondsRemaining / 60
        let s = focusSecondsRemaining % 60
        return String(format: "%02d:%02d", m, s)
    }

    // App blockers list
    @Published var blockedApps: [BlockedApp] = [
        BlockedApp(name: "Instagram", icon: "📸", subtitle: "Réseau social",    isBlocked: true),
        BlockedApp(name: "TikTok",    icon: "🎵", subtitle: "Vidéos courtes",  isBlocked: true),
        BlockedApp(name: "X",         icon: "✖",  subtitle: "Réseau social",   isBlocked: false),
        BlockedApp(name: "Facebook",  icon: "👤", subtitle: "Réseau social",   isBlocked: false),
        BlockedApp(name: "Snapchat",  icon: "👻", subtitle: "Messagerie",      isBlocked: true),
        BlockedApp(name: "YouTube",   icon: "▶",  subtitle: "Streaming vidéo", isBlocked: true),
    ]

    var activeBlockedApps: [String] { blockedApps.filter(\.isBlocked).map(\.name) }
}

// MARK: - Exercise Data
class ExerciseLibrary {
    static let all: [Exercise] = [
        // FORCE
        Exercise(name: "Développé couché", muscle: "Pectoraux · Triceps · Épaules ant.", icon: "🏋️",
                 level: "Intermédiaire", equipment: "Barre + banc", repsScheme: "4 × 8-10",
                 steps: ["Allonger sur le banc, pieds à plat au sol",
                         "Saisir la barre légèrement plus large que les épaules",
                         "Descendre vers la partie basse des pectoraux",
                         "Pousser vers le haut en expirant",
                         "Verrouiller sans bloquer les coudes"],
                 errors: ["Cambrer excessivement le bas du dos", "Rebondir la barre sur la poitrine"],
                 category: .force),

        Exercise(name: "Squat barre", muscle: "Quadriceps · Fessiers · Ischio", icon: "🦵",
                 level: "Intermédiaire", equipment: "Barre + rack", repsScheme: "4 × 6-8",
                 steps: ["Barre sur les trapèzes, pieds largeur hanches",
                         "Pointes légèrement ouvertes vers l'extérieur",
                         "Descendre dos neutre, talons au sol",
                         "Cuisses parallèles ou en dessous du sol",
                         "Pousser dans les talons pour remonter"],
                 errors: ["Genoux qui rentrent vers l'intérieur", "Talon qui se lève du sol"],
                 category: .force),

        Exercise(name: "Soulevé de terre", muscle: "Ischio · Dos complet · Fessiers", icon: "⬆️",
                 level: "Avancé", equipment: "Barre", repsScheme: "4 × 5",
                 steps: ["Pieds sous la barre, écartés largeur hanches",
                         "Saisir prise mixte, dos plat, bras tendus",
                         "Pousser dans le sol tout en tirant la barre",
                         "Hanches et épaules montent ensemble",
                         "Terminer debout, épaules en arrière"],
                 errors: ["Dos arrondi = risque grave de blessure", "Barre qui s'éloigne du corps"],
                 category: .force),

        Exercise(name: "Rowing barre", muscle: "Grand dorsal · Biceps · Rhomboïdes", icon: "🔄",
                 level: "Intermédiaire", equipment: "Barre", repsScheme: "4 × 10",
                 steps: ["Penché à 45°, dos neutre et droit",
                         "Saisir barre en pronation, largeur épaules",
                         "Tirer vers le nombril, coudes en arrière",
                         "Rétracter les omoplates en fin de mouvement",
                         "Descendre lentement en 3 secondes"],
                 errors: ["Balancer le tronc pour aider", "Hausser les épaules en fin de mouvement"],
                 category: .force),

        // CARDIO
        Exercise(name: "Course à pied", muscle: "Cardiovasculaire · Jambes · Mental", icon: "🏃",
                 level: "Débutant", equipment: "Chaussures running", repsScheme: "30-45 min",
                 steps: ["Échauffement 5 min marche rapide",
                         "Courir à allure modérée (pouvoir parler)",
                         "FC cible 65-75% FC max",
                         "Retour au calme 5 min marche",
                         "Étirements 5 min post-séance"],
                 errors: ["Partir trop vite dès le départ", "Surfaces dures sans chaussures adaptées"],
                 category: .cardio),

        Exercise(name: "Vélo elliptique", muscle: "Full body cardio basse intensité", icon: "🚴",
                 level: "Débutant", equipment: "Appareil elliptique", repsScheme: "40 min",
                 steps: ["Régler hauteur de pas à ta taille",
                         "Dos droit, tenir les poignées mobiles",
                         "Pousser/tirer les bras avec les jambes",
                         "Zone cardiaque 65-75% FC max",
                         "Augmenter résistance toutes les 10 min"],
                 errors: ["Se pencher trop en avant", "Mouvements saccadés sans rythme"],
                 category: .cardio),

        // HIIT
        Exercise(name: "Burpees", muscle: "Full body · Explosivité · Cardio", icon: "💥",
                 level: "Avancé", equipment: "Aucun", repsScheme: "4 × 10 / repos 30s",
                 steps: ["Debout, plonger en position pompe",
                         "Pompe complète (optionnel débutant)",
                         "Revenir accroupi, pieds vers les mains",
                         "Sauter explosivement bras levés au max",
                         "Enchaîner sans pause, rythme constant"],
                 errors: ["Hanches qui s'effondrent en pompe", "Sauter si douleur aux genoux"],
                 category: .hiit),

        Exercise(name: "Mountain Climbers", muscle: "Abdos · Cardio · Épaules", icon: "🏔️",
                 level: "Intermédiaire", equipment: "Aucun", repsScheme: "4 × 40 secondes",
                 steps: ["Planche haute, mains sous les épaules",
                         "Corps gaîné, alignement tête-talons",
                         "Amener genou droit vers la poitrine",
                         "Alterner gauche/droite rapidement",
                         "Hanches stables tout au long"],
                 errors: ["Hanches qui forment un triangle", "Dos qui s'affaisse"],
                 category: .hiit),

        Exercise(name: "Jump Squats", muscle: "Quadriceps · Fessiers · Explosivité", icon: "⬆️",
                 level: "Intermédiaire", equipment: "Aucun", repsScheme: "4 × 15 / repos 45s",
                 steps: ["Pieds largeur épaules, debout",
                         "Descendre en squat à 90°",
                         "Sauter explosivement vers le haut",
                         "Atterrir doucement sur les orteils",
                         "Fléchir genoux pour amortir l'impact"],
                 errors: ["Atterrir jambes tendues = impact fort", "Genoux rentrants à la réception"],
                 category: .hiit),

        // MOBILITÉ
        Exercise(name: "Salutation au soleil", muscle: "Full body · Flexibilité · Respiration", icon: "☀️",
                 level: "Débutant", equipment: "Tapis de yoga", repsScheme: "5-10 cycles",
                 steps: ["Debout, mains jointes, respiration profonde",
                         "Lever les bras, extension dorsale douce",
                         "Descendre vers l'avant, mains au sol",
                         "Étendre jambes en arrière alternativement",
                         "Chien tête en bas → cobra → répéter"],
                 errors: ["Retenir son souffle pendant les postures", "Forcer les étirements"],
                 category: .mobility),

        Exercise(name: "Foam Rolling", muscle: "Récupération musculaire globale", icon: "🟤",
                 level: "Débutant", equipment: "Foam roller", repsScheme: "2 min par zone",
                 steps: ["Poser le roller sous le muscle ciblé",
                         "Rouler lentement bout à bout",
                         "Tenir 20-30s sur zones sensibles",
                         "Zones : mollets, ischio, quadriceps, dos",
                         "Respirer profondément pendant la pression"],
                 errors: ["Rouler directement sur les articulations", "Aller trop vite sans tenir les zones"],
                 category: .mobility),

        // FULL BODY
        Exercise(name: "Tractions", muscle: "Grand dorsal · Biceps · Rhomboïdes", icon: "⬆️",
                 level: "Intermédiaire", equipment: "Barre de traction", repsScheme: "4 × max",
                 steps: ["Saisir en supination, largeur épaules",
                         "Partir à bras complètement tendus",
                         "Tirer jusqu'au menton au-dessus barre",
                         "Descendre lentement en 3 secondes",
                         "Corps stable, sans balancement"],
                 errors: ["Balancer le corps pour aider", "Monter avec les reins"],
                 category: .fullBody),

        Exercise(name: "Pompes prise serrée", muscle: "Triceps · Pectoraux internes", icon: "💎",
                 level: "Intermédiaire", equipment: "Aucun", repsScheme: "4 × 12-15",
                 steps: ["Mains proches (15cm), corps gaîné",
                         "Alignement parfait tête-talons",
                         "Descendre lentement, coudes vers l'arrière",
                         "Pousser jusqu'à extension complète",
                         "Expirer à la montée"],
                 errors: ["Coudes qui s'écartent vers les côtés", "Hanches qui tombent ou se lèvent"],
                 category: .fullBody),

        Exercise(name: "Dips barres parallèles", muscle: "Triceps · Pectoraux · Deltoïdes ant.", icon: "🔽",
                 level: "Intermédiaire", equipment: "Barres parallèles", repsScheme: "4 × 10-12",
                 steps: ["Monter sur les barres, bras tendus",
                         "Pencher légèrement le tronc en avant",
                         "Descendre jusqu'à coudes à 90°",
                         "Remonter en poussant fort",
                         "Contrôler chaque répétition"],
                 errors: ["Trop pencher le buste", "Ne pas descendre assez bas"],
                 category: .fullBody),
    ]

    static func exercises(for category: WorkoutCategory) -> [Exercise] {
        all.filter { $0.category == category }
    }
}

// MARK: - Default Tasks
extension TaskItem {
    static var defaults: [TaskItem] {
        [
            { let t = TaskItem(title: "Prière du matin", category: .priere, colorHex: "#9d4edd", hour: "05:00", duration: "30 min", importance: .important); t.isDone = true; return t }(),
            { let t = TaskItem(title: "Marche", category: .marche, colorHex: "#00e5ff", hour: "06:00", duration: "45 min", importance: .normal); t.isDone = true; return t }(),
            { let t = TaskItem(title: "Petit-déjeuner", category: .cuisine, colorHex: "#ff9500", hour: "07:00", duration: "45 min", importance: .important); t.isDone = true; return t }(),
            TaskItem(title: "Travail", category: .travail, colorHex: "#ff3b5c", hour: "08:00", duration: "3h 30m", importance: .critique),
            { let t = TaskItem(title: "Réunion équipe", category: .travail, colorHex: "#ff3b5c", hour: "09:30", duration: "1h", importance: .tresImportant); t.isDone = true; return t }(),
            { let t = TaskItem(title: "Déjeuner", category: .cuisine, colorHex: "#ff9500", hour: "12:00", duration: "1h", importance: .important); t.isDone = true; return t }(),
            TaskItem(title: "Études — Chapitre 4", category: .etudes, colorHex: "#4fc3f7", hour: "14:00", duration: "1h 30m", importance: .tresImportant),
            TaskItem(title: "Vélo", category: .velo, colorHex: "#00ff9d", hour: "17:30", duration: "45 min", importance: .normal),
            { let t = TaskItem(title: "Salle — Pectoraux & Triceps", category: .salle, colorHex: "#00ff9d", hour: "18:30", duration: "1h", importance: .important); t.isDone = true; return t }(),
            TaskItem(title: "Cuisine — Repas sain", category: .cuisine, colorHex: "#ff9500", hour: "20:00", duration: "1h", importance: .tresImportant),
            TaskItem(title: "Lecture", category: .etudes, colorHex: "#4fc3f7", hour: "21:30", duration: "30 min", importance: .normal),
            TaskItem(title: "Sommeil", category: .sommeil, colorHex: "#9d4edd", hour: "22:30", duration: "7h 30m", importance: .critique),
        ]
    }
}
