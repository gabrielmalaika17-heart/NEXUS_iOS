import SwiftUI

struct AccueilView: View {
    @StateObject private var state = AppStateManager.shared

    var body: some View {
        ZStack {
            NexusColors.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header
                    AccueilHeader()

                    // Hero Row
                    AccueilHeroRow()
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)

                    // Hydratation + Nutrition
                    HStack(spacing: 8) {
                        HydratationCard()
                        NutritionCard()
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)

                    // Zones du corps
                    ZonesCard()
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)

                    // Objectifs du jour
                    ObjectifsCard()
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)

                    // NEXUS IA mini
                    NexusIABannerCard()
                        .padding(.horizontal, 12)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - Header
struct AccueilHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("NEXUS OS")
                        .font(NexusFont.orbitron(11, weight: .bold))
                        .foregroundStyle(NexusColors.cyan)
                        .tracking(3)
                    Text("Centre de commande")
                        .font(NexusFont.orbitron(20, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Ton corps. Tes données. Ton évolution.")
                        .font(.system(size: 11))
                        .foregroundStyle(NexusColors.text2)
                }
                Spacer()
                HStack(spacing: 8) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(NexusColors.text2)
                            .padding(8)
                            .background(NexusColors.card)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(NexusColors.border2, lineWidth: 1))
                        Text("3")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 14, height: 14)
                            .background(NexusColors.red)
                            .clipShape(Circle())
                            .offset(x: 4, y: -4)
                    }
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(NexusColors.text2)
                        .padding(8)
                        .background(NexusColors.card)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(NexusColors.border2, lineWidth: 1))
                }
            }

            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 11))
                    .foregroundStyle(NexusColors.text2)
                Text("Mercredi 29 avril 2026")
                    .font(.system(size: 11))
                    .foregroundStyle(NexusColors.text)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(NexusColors.card)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(NexusColors.border, lineWidth: 1))
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(LinearGradient(colors: [NexusColors.bg2.opacity(0.95), .clear], startPoint: .top, endPoint: .bottom))
    }
}

// MARK: - Hero Row
struct AccueilHeroRow: View {
    var body: some View {
        HStack(spacing: 8) {
            // Left - Score global
            ScoreGlobalCard()
                .frame(width: 106)

            // Center - Body viz
            BodyVizCard()

            // Right - Activité + État
            VStack(spacing: 7) {
                ActiviteCard()
                EtatCard()
            }
            .frame(width: 106)
        }
    }
}

struct ScoreGlobalCard: View {
    var body: some View {
        VStack(spacing: 6) {
            NexusCardTitle(title: "APERÇU GLOBAL")

            ZStack {
                Circle().stroke(Color.white.opacity(0.05), lineWidth: 7)
                Circle()
                    .trim(from: 0, to: 0.72)
                    .stroke(NexusColors.cyan, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 1) {
                    Text("72%")
                        .font(NexusFont.orbitron(15, weight: .bold))
                        .foregroundStyle(NexusColors.cyan)
                    Text("global")
                        .font(.system(size: 8))
                        .foregroundStyle(NexusColors.text2)
                }
            }
            .frame(width: 66, height: 66)

            VStack(spacing: 3) {
                MiniMetricRow(label: "🏃 Corps", value: "74%", color: NexusColors.text)
                MiniMetricRow(label: "⚡ Énergie", value: "68%", color: NexusColors.orange)
                MiniMetricRow(label: "🔋 Récup.", value: "70%", color: NexusColors.green)
                MiniMetricRow(label: "🧠 Mental", value: "78%", color: NexusColors.purple)
            }
        }
        .padding(10)
        .background(NexusColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))
    }
}

struct MiniMetricRow: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        HStack {
            Text(label).font(.system(size: 9)).foregroundStyle(NexusColors.text2)
            Spacer()
            Text(value).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
        }
    }
}

struct BodyVizCard: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(RadialGradient(colors: [NexusColors.cyan.opacity(0.08), NexusColors.card], center: .top, startRadius: 20, endRadius: 120))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(NexusColors.border, lineWidth: 1))

            VStack(spacing: 10) {
                Text("🫀")
                    .font(.system(size: 72))
                    .shadow(color: NexusColors.cyan.opacity(0.6), radius: 24)
                    .shadow(color: NexusColors.purple.opacity(0.3), radius: 48)
                    .offset(y: offset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            offset = -6
                        }
                    }

                VStack(spacing: 2) {
                    HStack(spacing: 8) {
                        Text("● Musc.").font(.system(size: 8)).foregroundStyle(NexusColors.red)
                        Text("● Hydrat.").font(.system(size: 8)).foregroundStyle(NexusColors.cyan)
                    }
                    HStack(spacing: 8) {
                        Text("● Nutrit.").font(.system(size: 8)).foregroundStyle(NexusColors.green)
                        Text("● Énergie").font(.system(size: 8)).foregroundStyle(NexusColors.orange)
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 260)
    }
}

struct ActiviteCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            NexusCardTitle(title: "ACTIVITÉ")
            VStack(spacing: 3) {
                SmallRow(icon: "🏋️", label: "Salle", value: "1h15")
                SmallRow(icon: "🚴", label: "Vélo", value: "45m")
                SmallRow(icon: "🚶", label: "Marche", value: "30m")
            }
            NexusProgressBar(value: 0.68, color: NexusColors.orange)
            Text("680 kcal").font(NexusFont.orbitron(9)).foregroundStyle(NexusColors.orange).frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(10)
        .background(NexusColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))
    }
}

struct EtatCard: View {
    @State private var heartScale: CGFloat = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            NexusCardTitle(title: "ÉTAT")
            HStack { Text("♥ FC").font(.system(size: 9)).foregroundStyle(NexusColors.text2); Spacer(); Text("72").font(.system(size: 10, weight: .semibold)).foregroundStyle(NexusColors.red).scaleEffect(heartScale).onAppear { withAnimation(.easeInOut(duration: 0.9).repeatForever()) { heartScale = 1.2 } } }
            Text("Bonne").font(.system(size: 8)).foregroundStyle(NexusColors.green).frame(maxWidth: .infinity, alignment: .trailing)
            SmallRow(icon: "🌡", label: "", value: "36.6°")
            SmallRow(icon: "💧", label: "O2", value: "97%")
            HStack { Text("🧘").font(.system(size: 9)); Spacer(); Text("32%").font(.system(size: 10, weight: .semibold)).foregroundStyle(NexusColors.green) }
        }
        .padding(10)
        .background(NexusColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NexusColors.border, lineWidth: 1))
    }
}

struct SmallRow: View {
    let icon: String; let label: String; let value: String
    var body: some View {
        HStack {
            Text(icon + (label.isEmpty ? "" : " " + label)).font(.system(size: 9)).foregroundStyle(NexusColors.text2)
            Spacer()
            Text(value).font(.system(size: 10, weight: .semibold)).foregroundStyle(NexusColors.text)
        }
    }
}

// MARK: - Hydratation
struct HydratationCard: View {
    @ObservedObject private var state = AppStateManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NexusCardTitle(title: "HYDRATATION")
            HStack(alignment: .top, spacing: 6) {
                Text("💧").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(String(format: "%.1fL", state.waterMl / 1000))
                            .font(NexusFont.orbitron(14, weight: .bold))
                            .foregroundStyle(NexusColors.cyan)
                        Text("/2.5L").font(.system(size: 9)).foregroundStyle(NexusColors.text2)
                    }
                    Text(state.waterStatus).font(.system(size: 9, weight: .semibold)).foregroundStyle(state.waterStatusColor)
                }
                Spacer()
                Text(String(Int(state.waterProgress * 100)) + "%")
                    .font(NexusFont.orbitron(15, weight: .bold))
                    .foregroundStyle(NexusColors.orange)
            }
            NexusProgressBar(value: state.waterProgress, color: NexusColors.cyan)
            Text(state.waterMessage).font(.system(size: 9)).foregroundStyle(state.waterStatusColor).lineLimit(2)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 4), spacing: 3) {
                ForEach([250.0, 500.0, 750.0, 1000.0], id: \.self) { ml in
                    Button(ml < 1000 ? "\(Int(ml))ml" : "1L") { state.addWater(ml) }
                        .font(.system(size: 9))
                        .foregroundStyle(NexusColors.text2)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                        .background(NexusColors.bg3)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(NexusColors.border, lineWidth: 1))
                }
            }
        }
        .nexusCard()
    }
}

// MARK: - Nutrition
struct NutritionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NexusCardTitle(title: "NUTRITION")
            HStack(spacing: 6) {
                ZStack {
                    Circle().stroke(Color.white.opacity(0.05), lineWidth: 5)
                    Circle().trim(from: 0, to: 0.69).stroke(NexusColors.purple, style: StrokeStyle(lineWidth: 5, lineCap: .round)).rotationEffect(.degrees(-90))
                    VStack(spacing: 0) {
                        Text("1658").font(NexusFont.orbitron(9, weight: .bold)).foregroundStyle(NexusColors.purple)
                        Text("kcal").font(.system(size: 7)).foregroundStyle(NexusColors.text3)
                    }
                }
                .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 4) {
                    NutrRow(dot: NexusColors.cyan,   label: "Prot.", value: "128g")
                    NutrRow(dot: NexusColors.green,  label: "Gluc.", value: "180g")
                    NutrRow(dot: NexusColors.orange, label: "Lip.",  value: "58g")
                }
            }
            Divider().background(NexusColors.border)
            NexusCardTitle(title: "SOMMEIL")
            HStack(spacing: 6) {
                ZStack {
                    Circle().stroke(Color.white.opacity(0.05), lineWidth: 5)
                    Circle().trim(from: 0, to: 0.87).stroke(NexusColors.purple, style: StrokeStyle(lineWidth: 5, lineCap: .round)).rotationEffect(.degrees(-90))
                    VStack(spacing: 0) {
                        Text("87").font(NexusFont.orbitron(10, weight: .bold)).foregroundStyle(NexusColors.purple)
                        Text("/100").font(.system(size: 7)).foregroundStyle(NexusColors.text3)
                    }
                }
                .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Excellente").font(.system(size: 9, weight: .semibold)).foregroundStyle(NexusColors.green)
                    Text("7h 32m").font(.system(size: 10)).foregroundStyle(NexusColors.text2)
                }
            }
        }
        .nexusCard()
    }
}

struct NutrRow: View {
    let dot: Color; let label: String; let value: String
    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(dot).frame(width: 5, height: 5)
            Text(label).font(.system(size: 9)).foregroundStyle(NexusColors.text2)
            Spacer()
            Text(value).font(.system(size: 9, weight: .semibold)).foregroundStyle(NexusColors.text)
        }
    }
}

// MARK: - Zones du corps
struct ZonesCard: View {
    let zones: [(icon: String, name: String, status: String, color: Color)] = [
        ("🧠", "Cerveau",    "Bonne activité",   NexusColors.green),
        ("💪", "Épaules",    "Très sollicités",  NexusColors.orange),
        ("🏋️","Bras",        "Très sollicités",  NexusColors.red),
        ("🫁", "Pectoraux",  "Sollicités",       NexusColors.orange),
        ("🦴", "Dos",        "Sollicité",        NexusColors.yellow),
        ("🫀", "Cardio",     "Bonne santé",      NexusColors.green),
        ("🦵", "Jambes",     "Sollicitées",      NexusColors.yellow),
        ("🦶", "Mollets",    "Peu sollicités",   NexusColors.text2),
        ("🎯", "Abdos",      "Actifs",           NexusColors.cyan),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NexusCardTitle(title: "ZONES DU CORPS")
            Text("Appuyez sur une zone pour plus de détails")
                .font(.system(size: 11))
                .foregroundStyle(NexusColors.text2)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                ForEach(zones, id: \.name) { zone in
                    VStack(spacing: 4) {
                        Text(zone.icon).font(.system(size: 20))
                        Text(zone.name).font(.system(size: 11, weight: .semibold)).foregroundStyle(NexusColors.text)
                        Text(zone.status).font(.system(size: 9)).foregroundStyle(zone.color)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(NexusColors.card2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(zone.color.opacity(0.25), lineWidth: 1))
                }
            }
        }
        .nexusCard()
    }
}

// MARK: - Objectifs
struct ObjectifsCard: View {
    let objectifs: [(icon: String, label: String, pct: Double, color: Color)] = [
        ("💧", "Boire 2.5L d'eau", 0.40, NexusColors.cyan),
        ("🔥", "2 400 kcal",       0.69, NexusColors.orange),
        ("💪", "Protéines 180g",   0.71, NexusColors.green),
        ("🌙", "Sommeil 7-8h",     0.87, NexusColors.purple),
        ("👟", "10 000 pas",       0.62, NexusColors.cyan),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            NexusCardTitle(title: "OBJECTIFS DU JOUR")
            ForEach(objectifs, id: \.label) { obj in
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(obj.color.opacity(0.15))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(obj.color.opacity(0.3), lineWidth: 1))
                            .frame(width: 18, height: 18)
                        Text(obj.pct >= 1 ? "✓" : "○").font(.system(size: 10)).foregroundStyle(obj.color)
                    }
                    Text(obj.label).font(.system(size: 12)).foregroundStyle(NexusColors.text)
                    Spacer()
                    NexusProgressBar(value: obj.pct, color: obj.color).frame(width: 60)
                    Text("\(Int(obj.pct * 100))%").font(.system(size: 12, weight: .semibold)).foregroundStyle(obj.color).frame(width: 36, alignment: .trailing)
                }
                .padding(.vertical, 6)
                Divider().background(Color.white.opacity(0.04))
            }
            Button("Voir tous les objectifs") {}
                .buttonStyle(NexusPrimaryButtonStyle())
                .padding(.top, 6)
        }
        .nexusCard()
    }
}

// MARK: - NEXUS IA Banner
struct NexusIABannerCard: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [NexusColors.purple2, NexusColors.cyan2], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 36, height: 36)
                    Text("IA").font(NexusFont.orbitron(11, weight: .bold)).foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("NEXUS IA").font(NexusFont.orbitron(11, weight: .semibold)).foregroundStyle(NexusColors.purple).tracking(1)
                    Text("Tu as bien travaillé tes bras aujourd'hui ! Pense à t'hydrater et à manger assez de protéines. Ton sommeil était de qualité.")
                        .font(.system(size: 12))
                        .foregroundStyle(NexusColors.text)
                        .lineSpacing(3)
                }
            }
            Button("Voir recommandations →") {}
                .buttonStyle(NexusPrimaryButtonStyle(color: NexusColors.purple))
        }
        .padding(14)
        .background(LinearGradient(colors: [NexusColors.purple.opacity(0.1), NexusColors.cyan.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(NexusColors.purple.opacity(0.25), lineWidth: 1))
    }
}
