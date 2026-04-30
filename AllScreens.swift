import SwiftUI

// MARK: ============ FITNESS ============
struct FitnessView: View {
    @State private var selectedCategory: WorkoutCategory = .force
    @State private var selectedExercise: Exercise?

    var exercises: [Exercise] { ExerciseLibrary.exercises(for: selectedCategory) }

    var body: some View {
        ZStack {
            NexusColors.bg.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    NexusPageHeader(title: "Fitness", subtitle: "Programme du jour")

                    // Rings row
                    FitnessRingsRow()
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)

                    // Workout selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(WorkoutCategory.allCases, id: \.self) { cat in
                                Button(cat.rawValue) { selectedCategory = cat }
                                    .font(NexusFont.orbitron(11, weight: .medium))
                                    .foregroundStyle(selectedCategory == cat ? NexusColors.cyan : NexusColors.text2)
                                    .tracking(0.5)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(selectedCategory == cat ? NexusColors.cyan.opacity(0.15) : .clear)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(selectedCategory == cat ? NexusColors.cyan : NexusColors.border2, lineWidth: 1))
                                    .shadow(color: selectedCategory == cat ? NexusColors.cyan.opacity(0.2) : .clear, radius: 6)
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .padding(.bottom, 12)

                    // Exercise cards
                    ForEach(exercises) { ex in
                        ExerciseCard(exercise: ex)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 8)
                            .onTapGesture { selectedExercise = ex }
                    }
                    Spacer(minLength: 20)
                }
            }
        }
        .sheet(item: $selectedExercise) { ex in
            ExerciseDetailView(exercise: ex)
        }
    }
}

struct FitnessRingsRow: View {
    @State private var heartScale: CGFloat = 1.0
    var body: some View {
        HStack(spacing: 0) {
            FitnessRing(value: 0.77, color: NexusColors.orange, label: "1840", sublabel: "kcal", footer: "CALORIES", footerSub: "/ 2400")
            FitnessRing(value: 0.72, color: NexusColors.green,  label: "7230",  sublabel: "pas",  footer: "PAS",      footerSub: "/ 10000")
            FitnessRing(value: 0.64, color: NexusColors.cyan,   label: "1.6L",  sublabel: "eau",  footer: "HYDRAT.",  footerSub: "/ 2.5L")
            VStack(spacing: 6) {
                ZStack {
                    Circle().stroke(NexusColors.red.opacity(0.15), lineWidth: 7)
                    Circle().trim(from: 0, to: 0.30).stroke(NexusColors.red, style: StrokeStyle(lineWidth: 7, lineCap: .round)).rotationEffect(.degrees(-90))
                    VStack(spacing: 1) {
                        Text("72").font(NexusFont.orbitron(12, weight: .bold)).foregroundStyle(NexusColors.red).scaleEffect(heartScale).onAppear { withAnimation(.easeInOut(duration: 0.9).repeatForever()) { heartScale = 1.18 } }
                        Text("bpm").font(.system(size: 7)).foregroundStyle(NexusColors.text3)
                    }
                }
                .frame(width: 70, height: 70)
                Text("FC").font(NexusFont.orbitron(9)).foregroundStyle(NexusColors.text2).tracking(1.5)
                NexusBadge(text: "Bonne", color: NexusColors.green)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(NexusColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(NexusColors.border, lineWidth: 1))
    }
}

struct FitnessRing: View {
    let value: Double; let color: Color; let label: String; let sublabel: String; let footer: String; let footerSub: String
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle().stroke(color.opacity(0.15), lineWidth: 7)
                Circle().trim(from: 0, to: value).stroke(color, style: StrokeStyle(lineWidth: 7, lineCap: .round)).rotationEffect(.degrees(-90)).animation(.easeInOut(duration: 1), value: value)
                VStack(spacing: 1) {
                    Text(label).font(NexusFont.orbitron(11, weight: .bold)).foregroundStyle(color)
                    Text(sublabel).font(.system(size: 7)).foregroundStyle(NexusColors.text3)
                }
            }
            .frame(width: 70, height: 70)
            Text(footer).font(NexusFont.orbitron(9)).foregroundStyle(NexusColors.text2).tracking(1.5)
            Text(footerSub).font(.system(size: 9)).foregroundStyle(NexusColors.text3)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    var body: some View {
        HStack(spacing: 12) {
            Text(exercise.icon).font(.system(size: 32))
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name).font(.system(size: 15, weight: .bold)).foregroundStyle(NexusColors.text)
                Text(exercise.muscle).font(.system(size: 11)).foregroundStyle(NexusColors.green)
                HStack(spacing: 6) {
                    NexusBadge(text: exercise.level, color: NexusColors.cyan)
                    NexusBadge(text: exercise.equipment, color: NexusColors.purple)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(exercise.repsScheme).font(NexusFont.orbitron(12, weight: .semibold)).foregroundStyle(NexusColors.cyan)
                Text("Voir démo ▶").font(.system(size: 10)).foregroundStyle(NexusColors.text2)
            }
        }
        .padding(14)
        .background(NexusColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))
        .contentShape(Rectangle())
    }
}

struct ExerciseDetailView: View {
    let exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            NexusColors.bg.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold)).foregroundStyle(NexusColors.cyan).padding(10).background(NexusColors.card).clipShape(RoundedRectangle(cornerRadius: 10)).overlay(RoundedRectangle(cornerRadius: 10).stroke(NexusColors.border2, lineWidth: 1))
                        }
                        Text(exercise.name).font(NexusFont.orbitron(16, weight: .semibold)).foregroundStyle(.white).padding(.leading, 8)
                        Spacer()
                    }
                    .padding(16)
                    .overlay(alignment: .bottom) { Rectangle().fill(NexusColors.border).frame(height: 1) }

                    VStack(spacing: 16) {
                        // Video placeholder
                        ZStack {
                            RoundedRectangle(cornerRadius: 14).fill(Color.black.opacity(0.6)).overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle().fill(NexusColors.green.opacity(0.15)).frame(width: 52, height: 52).overlay(Circle().stroke(NexusColors.green, lineWidth: 2))
                                    Image(systemName: "play.fill").font(.system(size: 18)).foregroundStyle(NexusColors.green)
                                }
                                Text("VIDÉO DÉMO").font(NexusFont.orbitron(12)).foregroundStyle(NexusColors.text2).tracking(1)
                                Text("Demander à NEXUS IA").font(.system(size: 10)).foregroundStyle(NexusColors.text3)
                            }
                        }
                        .frame(height: 150)

                        // Stats
                        VStack(spacing: 0) {
                            NexusStatRow(label: "💪 Muscles", value: exercise.muscle, valueColor: NexusColors.green)
                            NexusStatRow(label: "📊 Niveau", value: exercise.level)
                            NexusStatRow(label: "🏋️ Matériel", value: exercise.equipment)
                            NexusStatRow(label: "🔁 Séries/Reps", value: exercise.repsScheme, valueColor: NexusColors.cyan)
                        }
                        .padding(14)
                        .background(NexusColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))

                        // Steps
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 6) {
                                Rectangle().fill(NexusColors.cyan).frame(width: 3, height: 10).cornerRadius(2)
                                Text("EXÉCUTION").font(NexusFont.orbitron(10, weight: .semibold)).foregroundStyle(NexusColors.cyan).tracking(2)
                            }
                            .padding(.bottom, 10)
                            ForEach(Array(exercise.steps.enumerated()), id: \.offset) { idx, step in
                                HStack(alignment: .top, spacing: 10) {
                                    ZStack {
                                        Circle().fill(NexusColors.cyan.opacity(0.15)).overlay(Circle().stroke(NexusColors.cyan.opacity(0.3), lineWidth: 1))
                                        Text("\(idx + 1)").font(NexusFont.orbitron(10, weight: .bold)).foregroundStyle(NexusColors.cyan)
                                    }
                                    .frame(width: 22, height: 22)
                                    Text(step).font(.system(size: 13)).foregroundStyle(NexusColors.text).lineSpacing(3)
                                }
                                .padding(.vertical, 8)
                                Divider().background(Color.white.opacity(0.04))
                            }
                        }
                        .padding(14)
                        .background(NexusColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))

                        // Errors
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 6) {
                                Rectangle().fill(NexusColors.red).frame(width: 3, height: 10).cornerRadius(2)
                                Text("ERREURS FRÉQUENTES").font(NexusFont.orbitron(10, weight: .semibold)).foregroundStyle(NexusColors.red).tracking(2)
                            }
                            .padding(.bottom, 10)
                            ForEach(exercise.errors, id: \.self) { err in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 12)).foregroundStyle(NexusColors.red)
                                    Text(err).font(.system(size: 13)).foregroundStyle(NexusColors.text).lineSpacing(3)
                                }
                                .padding(.vertical, 6)
                                Divider().background(Color.white.opacity(0.04))
                            }
                        }
                        .padding(14)
                        .background(NexusColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// MARK: ============ SOMMEIL ============
struct SommeilView: View {
    @State private var selectedTab = 0
    let tabs = ["Aperçu", "Détails", "Tendances", "Conseils"]

    var body: some View {
        ZStack {
            NexusColors.bg.ignoresSafeArea()
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("NEXUS OS").font(NexusFont.orbitron(11, weight: .bold)).foregroundStyle(NexusColors.cyan).tracking(3)
                            Text("Sommeil").font(NexusFont.orbitron(22, weight: .bold)).foregroundStyle(.white)
                        }
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left").font(.system(size: 16)).foregroundStyle(NexusColors.text2)
                            Text("29 avr.").font(.system(size: 11)).foregroundStyle(NexusColors.text2)
                            Image(systemName: "chevron.right").font(.system(size: 16)).foregroundStyle(NexusColors.text2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                    // Tab bar
                    HStack(spacing: 0) {
                        ForEach(Array(tabs.enumerated()), id: \.offset) { idx, tab in
                            Button(tab) { withAnimation { selectedTab = idx } }
                                .font(NexusFont.orbitron(11))
                                .foregroundStyle(selectedTab == idx ? NexusColors.cyan : NexusColors.text2)
                                .tracking(0.5)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .overlay(alignment: .bottom) {
                                    Rectangle().fill(selectedTab == idx ? NexusColors.cyan : .clear).frame(height: 2)
                                }
                        }
                    }
                    .overlay(alignment: .bottom) { Rectangle().fill(NexusColors.border).frame(height: 1) }
                }
                .background(LinearGradient(colors: [NexusColors.bg2.opacity(0.95), .clear], startPoint: .top, endPoint: .bottom))

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if selectedTab == 0 { SommeilApercuView() }
                        else if selectedTab == 1 { SommeilDetailsView() }
                        else { SommeilTendancesView() }
                        Spacer(minLength: 20)
                    }
                }
            }
        }
    }
}

struct SommeilApercuView: View {
    @State private var bedtime = Date()
    @State private var wakeTime = Date()

    var body: some View {
        VStack(spacing: 10) {
            // Score
            VStack(spacing: 8) {
                ZStack {
                    Circle().stroke(Color.white.opacity(0.05), lineWidth: 10).frame(width: 140, height: 140)
                    Circle().trim(from: 0, to: 0.87).stroke(LinearGradient(colors: [NexusColors.purple2, NexusColors.cyan], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 10, lineCap: .round)).rotationEffect(.degrees(-90)).frame(width: 140, height: 140)
                    VStack(spacing: 2) {
                        Text("87").font(NexusFont.orbitron(36, weight: .bold)).foregroundStyle(.white)
                        Text("/100").font(.system(size: 14)).foregroundStyle(NexusColors.text2)
                    }
                }
                Text("Excellent").font(NexusFont.orbitron(14, weight: .semibold)).foregroundStyle(NexusColors.cyan)
                HStack(spacing: 16) {
                    SleepStatItem(value: "7h 32m", label: "DURÉE")
                    SleepStatItem(value: "22:28", label: "ENDORMI", valueColor: NexusColors.purple)
                    SleepStatItem(value: "06:00", label: "RÉVEIL", valueColor: NexusColors.cyan)
                }
            }
            .padding(20)
            .background(NexusColors.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(NexusColors.border, lineWidth: 1))
            .padding(.horizontal, 12)

            // Phases
            VStack(alignment: .leading, spacing: 10) {
                NexusCardTitle(title: "QUALITÉ DU SOMMEIL")
                VStack(alignment: .leading, spacing: 2) {
                    Text("Excellente qualité").font(.system(size: 14, weight: .bold)).foregroundStyle(NexusColors.green)
                    Text("Sommeil profond suffisant et continu.").font(.system(size: 11)).foregroundStyle(NexusColors.text2)
                }
                HStack(spacing: 8) {
                    PhaseCard(name: "PROFOND", duration: "2h 15m", pct: "29%", color: NexusColors.purple)
                    PhaseCard(name: "LÉGER",   duration: "4h 17m", pct: "57%", color: NexusColors.blue)
                    PhaseCard(name: "ÉVEIL",   duration: "1h 00m", pct: "14%", color: NexusColors.orange)
                }
                HStack(spacing: 6) {
                    SleepMetricBox(title: "EFFICACITÉ", value: "93%",  color: NexusColors.cyan)
                    SleepMetricBox(title: "RÉGULARITÉ", value: "Bonne", color: NexusColors.green)
                    SleepMetricBox(title: "DETTE",       value: "15m",  color: NexusColors.yellow)
                }
            }
            .nexusCard()
            .padding(.horizontal, 12)

            // Weekly chart
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    NexusCardTitle(title: "TENDANCE 7 JOURS")
                    Spacer()
                    Text("↑ +7% cette semaine").font(.system(size: 11)).foregroundStyle(NexusColors.green)
                }
                SleepWeekChart()
            }
            .nexusCard()
            .padding(.horizontal, 12)

            // Manual entry
            VStack(alignment: .leading, spacing: 10) {
                NexusCardTitle(title: "SAISIE MANUELLE")
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("COUCHER").font(NexusFont.orbitron(10)).foregroundStyle(NexusColors.text2).tracking(1)
                        DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .accentColor(NexusColors.cyan)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("RÉVEIL").font(NexusFont.orbitron(10)).foregroundStyle(NexusColors.text2).tracking(1)
                        DatePicker("", selection: $wakeTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .accentColor(NexusColors.cyan)
                    }
                    Spacer()
                }
                Button("Démarrer suivi du sommeil") {}
                    .buttonStyle(NexusPrimaryButtonStyle(color: NexusColors.purple))
            }
            .nexusCard()
            .padding(.horizontal, 12)
        }
        .padding(.top, 10)
    }
}

struct SleepStatItem: View {
    let value: String; let label: String; var valueColor: Color = NexusColors.text
    var body: some View {
        VStack(spacing: 3) {
            Text(value).font(NexusFont.orbitron(16, weight: .bold)).foregroundStyle(valueColor)
            Text(label).font(.system(size: 10)).foregroundStyle(NexusColors.text2).tracking(0.5)
        }
    }
}

struct PhaseCard: View {
    let name: String; let duration: String; let pct: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(name).font(NexusFont.orbitron(9)).foregroundStyle(NexusColors.text2).tracking(1)
            Text(duration).font(NexusFont.orbitron(13, weight: .bold)).foregroundStyle(color)
            Text(pct).font(.system(size: 10)).foregroundStyle(NexusColors.text2)
            Rectangle().fill(color).frame(height: 4).cornerRadius(2)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(NexusColors.bg3)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }
}

struct SleepMetricBox: View {
    let title: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 3) {
            Text(title).font(NexusFont.orbitron(8)).foregroundStyle(NexusColors.text2).tracking(1)
            Text(value).font(NexusFont.orbitron(14, weight: .bold)).foregroundStyle(color)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(NexusColors.bg3)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SleepWeekChart: View {
    let data: [(day: String, score: Int, color: Color)] = [
        ("Jeu", 76, NexusColors.orange), ("Ven", 82, NexusColors.cyan), ("Sam", 83, NexusColors.cyan),
        ("Dim", 78, NexusColors.yellow), ("Lun", 85, NexusColors.cyan), ("Mar", 81, NexusColors.cyan), ("Mer", 87, NexusColors.green)
    ]
    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            ForEach(data, id: \.day) { d in
                VStack(spacing: 4) {
                    Text("\(d.score)").font(.system(size: 9)).foregroundStyle(d.color)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(d.color.opacity(d.day == "Mer" ? 1.0 : 0.5))
                        .frame(height: CGFloat(d.score) / 87.0 * 50)
                    Text(d.day).font(NexusFont.orbitron(9)).foregroundStyle(NexusColors.text3)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 70)
    }
}

struct SommeilDetailsView: View {
    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                NexusCardTitle(title: "PARAMÈTRES PHYSIOLOGIQUES").padding(.bottom, 6)
                NexusStatRow(label: "❤ Fréquence cardiaque moy.", value: "52 bpm")
                NexusStatRow(label: "📊 HRV",                      value: "68 ms", valueColor: NexusColors.green)
                NexusStatRow(label: "🌬 Fréq. respiratoire",        value: "14 br/min")
                NexusStatRow(label: "🌡 Température",               value: "36.6°C")
                NexusStatRow(label: "💧 SpO2",                      value: "97%", valueColor: NexusColors.cyan)
            }.nexusCard().padding(.horizontal, 12)
            VStack(alignment: .leading, spacing: 8) {
                NexusCardTitle(title: "LATENCE D'ENDORMISSEMENT")
                Text("12 min").font(NexusFont.orbitron(36, weight: .bold)).foregroundStyle(NexusColors.cyan).frame(maxWidth: .infinity, alignment: .center)
                NexusBadge(text: "Bonne", color: NexusColors.green).frame(maxWidth: .infinity, alignment: .center)
                NexusProgressBar(value: 0.20, color: NexusColors.cyan)
            }.nexusCard().padding(.horizontal, 12)
            VStack(alignment: .leading, spacing: 6) {
                NexusCardTitle(title: "RONFLEMENTS")
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Faibles").font(.system(size: 13, weight: .semibold)).foregroundStyle(NexusColors.green)
                        Text("30 min au total").font(.system(size: 10)).foregroundStyle(NexusColors.text2)
                    }
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("8%").font(NexusFont.orbitron(22, weight: .bold)).foregroundStyle(NexusColors.green)
                        Text("du temps").font(.system(size: 10)).foregroundStyle(NexusColors.text2)
                    }
                }
            }.nexusCard().padding(.horizontal, 12)
        }
        .padding(.top, 10)
    }
}

struct SommeilTendancesView: View {
    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                NexusCardTitle(title: "FACTEURS AYANT UN IMPACT")
                ForEach([("Activité physique", "Positive", NexusColors.green), ("Exposition lumière", "Bonne", NexusColors.green), ("Caféine", "Neutre", NexusColors.text2), ("Écran avant coucher", "Négatif", NexusColors.red), ("Stress", "Léger", NexusColors.yellow)], id: \.0) { factor in
                    HStack {
                        Text(factor.0).font(.system(size: 12)).foregroundStyle(NexusColors.text2)
                        Spacer()
                        Text(factor.1).font(.system(size: 12, weight: .semibold)).foregroundStyle(factor.2)
                    }
                    .padding(.vertical, 6)
                    Divider().background(Color.white.opacity(0.04))
                }
            }.nexusCard().padding(.horizontal, 12)
        }
        .padding(.top, 10)
    }
}

// MARK: ============ BLOQUER ============
struct BloquerView: View {
    @StateObject private var state = AppStateManager.shared
    @State private var showConfirmStop = false
    @State private var durationText = "25"

    var body: some View {
        ZStack {
            NexusColors.bg.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    NexusPageHeader(title: "Bloquer", subtitle: "Mode concentration volontaire")

                    // Master switch
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mode Concentration").font(.system(size: 14, weight: .semibold)).foregroundStyle(NexusColors.text)
                            Text(state.focusIsRunning ? "Session active" : "Inactif — Choisissez une durée")
                                .font(.system(size: 11)).foregroundStyle(NexusColors.text2)
                        }
                        Spacer()
                        NexusToggle(isOn: Binding(get: { state.focusIsRunning }, set: { _ in
                            if state.focusIsRunning { showConfirmStop = true } else {
                                if let dur = Int(durationText), dur > 0 {
                                    state.startFocus(minutes: dur, apps: state.activeBlockedApps)
                                }
                            }
                        }))
                    }
                    .padding(14)
                    .background(NexusColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)

                    // Active timer
                    if state.focusIsRunning {
                        VStack(spacing: 8) {
                            Text("SESSION EN COURS").font(NexusFont.orbitron(10)).foregroundStyle(NexusColors.text2).tracking(3)
                            Text(state.timerDisplayString)
                                .font(NexusFont.orbitron(56, weight: .bold))
                                .foregroundStyle(NexusColors.cyan)
                                .tracking(4)
                                .shadow(color: NexusColors.cyan.opacity(0.5), radius: 20)
                            Text("Bloqué : \(state.activeBlockedApps.joined(separator: ", "))")
                                .font(.system(size: 11)).foregroundStyle(NexusColors.text2).multilineTextAlignment(.center)
                            HStack(spacing: 8) {
                                Button(state.focusIsPaused ? "▶ Reprendre" : "⏸ Pause") { state.pauseResumeFocus() }
                                    .buttonStyle(NexusPrimaryButtonStyle())
                                Button("✕ Arrêter") { showConfirmStop = true }
                                    .buttonStyle(NexusPrimaryButtonStyle(color: NexusColors.red))
                            }
                        }
                        .padding(20)
                        .background(NexusColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(NexusColors.border, lineWidth: 1))
                        .padding(.horizontal, 12)
                        .padding(.bottom, 8)
                    } else {
                        // Config
                        VStack(alignment: .leading, spacing: 10) {
                            NexusCardTitle(title: "CONFIGURATION")
                            HStack(spacing: 8) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("DURÉE (MIN)").font(NexusFont.orbitron(10)).foregroundStyle(NexusColors.text2).tracking(1)
                                    TextField("25", text: $durationText)
                                        .font(.system(size: 14)).foregroundStyle(NexusColors.text)
                                        .keyboardType(.numberPad)
                                        .padding(10)
                                        .background(NexusColors.cyan.opacity(0.04))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(NexusColors.border, lineWidth: 1))
                                }
                            }
                            Button("▶ Démarrer la session") {
                                if let dur = Int(durationText), dur > 0 {
                                    state.startFocus(minutes: dur, apps: state.activeBlockedApps)
                                }
                            }
                            .buttonStyle(NexusPrimaryButtonStyle(color: NexusColors.green))
                        }
                        .nexusCard()
                        .padding(.horizontal, 12)
                        .padding(.bottom, 8)
                    }

                    // Apps list
                    NexusSectionTitle(title: "APPS À LIMITER")
                    VStack(spacing: 0) {
                        ForEach($state.blockedApps) { $app in
                            HStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).fill(NexusColors.bg3).frame(width: 36, height: 36).overlay(RoundedRectangle(cornerRadius: 10).stroke(NexusColors.border, lineWidth: 1))
                                    Text(app.icon).font(.system(size: 20))
                                }
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(app.name).font(.system(size: 13, weight: .semibold)).foregroundStyle(NexusColors.text)
                                    Text(app.subtitle).font(.system(size: 10)).foregroundStyle(NexusColors.text2)
                                }
                                Spacer()
                                NexusToggle(isOn: $app.isBlocked)
                            }
                            .padding(.vertical, 12)
                            Divider().background(Color.white.opacity(0.04))
                        }
                    }
                    .padding(14)
                    .background(NexusColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(NexusColors.border, lineWidth: 1))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)

                    // Guide
                    VStack(alignment: .leading, spacing: 10) {
                        NexusCardTitle(title: "GUIDE — TEMPS D'ÉCRAN iPHONE")
                        ForEach(Array(["Ouvrir Réglages iPhone", "Appuyer sur « Temps d'écran »", "Activer Temps d'écran", "Aller dans « Limites d'apps »", "Sélectionner les apps", "Définir la durée quotidienne"].enumerated()), id: \.offset) { idx, step in
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle().fill(NexusColors.cyan.opacity(0.1)).overlay(Circle().stroke(NexusColors.border2, lineWidth: 1))
                                    Text("\(idx + 1)").font(NexusFont.orbitron(10, weight: .bold)).foregroundStyle(NexusColors.cyan)
                                }
                                .frame(width: 22, height: 22)
                                Text(step).font(.system(size: 12)).foregroundStyle(NexusColors.text)
                            }
                            .padding(.vertical, 4)
                            Divider().background(Color.white.opacity(0.03))
                        }
                    }
                    .padding(14)
                    .background(LinearGradient(colors: [NexusColors.cyan.opacity(0.04), NexusColors.purple.opacity(0.04)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(NexusColors.border, lineWidth: 1))
                    .padding(.horizontal, 12)
                    .padding(.bottom, 20)
                }
            }
        }
        .alert("Arrêter la session ?", isPresented: $showConfirmStop) {
            Button("Continuer", role: .cancel) {}
            Button("Oui, arrêter", role: .destructive) { state.stopFocus() }
        } message: {
            Text("Tu étais en pleine concentration. Es-tu vraiment sûr(e) ?")
        }
    }
}

// MARK: ============ NEXUS AI ============
struct NexusAIView: View {
    @StateObject private var state = AppStateManager.shared
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    @State private var scrollProxy: ScrollViewProxy?

    let quickPrompts = ["Réorganise ma journée", "Propose séance 45min", "Dois-je dormir plus tôt ?", "Lance focus 2h", "Que faire maintenant ?"]

    var body: some View {
        ZStack {
            NexusColors.bg.ignoresSafeArea()
            VStack(spacing: 0) {
                NexusPageHeader(title: "Nexus IA")

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Avatar
                            AIAvatarSection()
                                .padding(.bottom, 12)

                            // Context bar
                            AIContextBar()
                                .padding(.horizontal, 12)
                                .padding(.bottom, 10)

                            // Quick chips
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 6) {
                                    ForEach(quickPrompts, id: \.self) { p in
                                        Button(p) { inputText = p; Task { await sendChat() } }
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundStyle(NexusColors.purple)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 7)
                                            .background(NexusColors.purple.opacity(0.08))
                                            .clipShape(Capsule())
                                            .overlay(Capsule().stroke(NexusColors.purple.opacity(0.35), lineWidth: 1))
                                    }
                                }
                                .padding(.horizontal, 12)
                            }
                            .padding(.bottom, 10)

                            // Messages
                            VStack(spacing: 8) {
                                ForEach(messages) { msg in
                                    ChatBubble(message: msg)
                                }
                                if isLoading { LoadingBubble() }
                            }
                            .padding(.horizontal, 12)
                            .id("bottom")
                        }
                        .padding(.bottom, 80)
                    }
                    .onChange(of: messages.count) { _, _ in
                        withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                    }
                }

                // Input
                HStack(spacing: 8) {
                    TextField("Message à NEXUS AI...", text: $inputText)
                        .font(.system(size: 14))
                        .foregroundStyle(NexusColors.text)
                        .padding(10)
                        .background(NexusColors.cyan.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(NexusColors.border, lineWidth: 1))
                        .onSubmit { Task { await sendChat() } }

                    Button {
                        Task { await sendChat() }
                    } label: {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(LinearGradient(colors: [NexusColors.purple2, NexusColors.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(NexusColors.bg2.opacity(0.97))
                .overlay(alignment: .top) { Rectangle().fill(NexusColors.border).frame(height: 1) }
            }
        }
        .onAppear {
            if messages.isEmpty {
                messages.append(ChatMessage(
                    content: "Bonjour ! Je suis NEXUS AI — ton assistant personnel contextuel. J'ai accès à ta journée, ton sommeil (87/100) et tes données fitness. Comment puis-je t'aider aujourd'hui ?",
                    isUser: false
                ))
            }
        }
    }

    private func sendChat() async {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        inputText = ""
        messages.append(ChatMessage(content: text, isUser: true))
        isLoading = true

        let systemPrompt = buildSystemPrompt()

        do {
            let reply = try await ClaudeAPIService.sendMessage(text, systemPrompt: systemPrompt)
            messages.append(ChatMessage(content: reply, isUser: false))
        } catch {
            messages.append(ChatMessage(content: "Erreur de connexion. Vérifie ta connexion et réessaie.", isUser: false))
        }
        isLoading = false
    }

    private func buildSystemPrompt() -> String {
        """
        Tu es NEXUS AI, un assistant coach de vie ultra-personnalisé intégré à l'app NEXUS OS.

        Contexte utilisateur (mercredi 29 avril 2026):
        - Progression journée: tâches en cours
        - Sommeil: score 87/100 (Excellent), 7h32m, endormi 22h28, réveil 6h00
        - Fitness: 1840 kcal, 7230 pas, hydratation \(String(format: "%.1f", state.waterMl / 1000))L/2.5L, FC 72bpm
        - Session focus: \(state.focusIsRunning ? "Active" : "Inactive")
        - Programme fitness du jour: Salle Pectoraux & Triceps (1h15m), Vélo (45min)

        Réponds en français, concis (max 100 mots), actionnable et motivant. Style futuriste bienveillant. Utilise des emojis avec parcimonie.
        """
    }
}

struct AIAvatarSection: View {
    @State private var rotation: Double = 0
    @State private var offset: CGFloat = 0

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(NexusColors.purple.opacity(0.2), lineWidth: 1)
                    .frame(width: 84, height: 84)
                    .rotationEffect(.degrees(rotation))
                    .onAppear { withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) { rotation = 360 } }

                Circle()
                    .fill(LinearGradient(colors: [NexusColors.purple.opacity(0.3), NexusColors.cyan.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 72, height: 72)
                    .overlay(Circle().stroke(NexusColors.purple.opacity(0.5), lineWidth: 2))

                Text("🤖").font(.system(size: 32))
            }
            .offset(y: offset)
            .onAppear { withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) { offset = -6 } }

            Text("NEXUS AI").font(NexusFont.orbitron(16, weight: .bold)).foregroundStyle(.white).tracking(2)
            Text("Ton coach de vie intelligent — contexte injecté automatiquement")
                .font(.system(size: 11))
                .foregroundStyle(NexusColors.text2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
}

struct AIContextBar: View {
    @ObservedObject private var state = AppStateManager.shared
    var body: some View {
        HStack {
            AICtxItem(value: "8/12", label: "TÂCHES", color: NexusColors.cyan)
            AICtxItem(value: "87/100", label: "SOMMEIL", color: NexusColors.purple)
            AICtxItem(value: "1840", label: "KCAL", color: NexusColors.orange)
            AICtxItem(value: state.focusIsRunning ? "ON" : "OFF", label: "FOCUS", color: state.focusIsRunning ? NexusColors.green : NexusColors.red)
        }
        .padding(10)
        .background(LinearGradient(colors: [NexusColors.cyan.opacity(0.05), NexusColors.purple.opacity(0.05)], startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(NexusColors.border, lineWidth: 1))
    }
}

struct AICtxItem: View {
    let value: String; let label: String; let color: Color
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(NexusFont.orbitron(13, weight: .bold)).foregroundStyle(color)
            Text(label).font(.system(size: 9)).foregroundStyle(NexusColors.text3).tracking(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }
            Text(message.content)
                .font(.system(size: 13))
                .foregroundStyle(message.isUser ? NexusColors.cyan : NexusColors.text)
                .lineSpacing(3)
                .padding(12)
                .background(message.isUser ? NexusColors.cyan.opacity(0.12) : NexusColors.purple.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(message.isUser ? NexusColors.cyan.opacity(0.25) : NexusColors.purple.opacity(0.2), lineWidth: 1))
            if !message.isUser { Spacer(minLength: 40) }
        }
    }
}

struct LoadingBubble: View {
    @State private var opacity: Double = 0.3
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { i in
                    Circle().fill(NexusColors.purple).frame(width: 6, height: 6).opacity(opacity)
                        .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(i) * 0.2), value: opacity)
                }
            }
            .padding(12)
            .background(NexusColors.purple.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.purple.opacity(0.2), lineWidth: 1))
            .onAppear { opacity = 1.0 }
            Spacer()
        }
    }
}

// MARK: - Claude API Service
struct ClaudeAPIService {
    static func sendMessage(_ text: String, systemPrompt: String) async throws -> String {
        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Note: API key is injected at build time via Config.xcconfig
        // In production, never hardcode API keys — use a backend proxy
        request.setValue(APIConfig.anthropicKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 1000,
            "system": systemPrompt,
            "messages": [["role": "user", "content": text]]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let content = json?["content"] as? [[String: Any]]
        return content?.first?["text"] as? String ?? "Pas de réponse."
    }
}

// Placeholder — replace with real key via xcconfig
enum APIConfig {
    static let anthropicKey = Bundle.main.infoDictionary?["ANTHROPIC_API_KEY"] as? String ?? ""
}
