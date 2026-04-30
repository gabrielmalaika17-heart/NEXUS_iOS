import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .accueil

    enum Tab {
        case accueil, planif, fitness, sommeil, bloquer, nexusAI
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                AccueilView()
                    .tag(Tab.accueil)

                PlanifView()
                    .tag(Tab.planif)

                FitnessView()
                    .tag(Tab.fitness)

                SommeilView()
                    .tag(Tab.sommeil)

                BloquerView()
                    .tag(Tab.bloquer)

                NexusAIView()
                    .tag(Tab.nexusAI)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Nav Bar
            CustomNavBar(selectedTab: $selectedTab)
        }
        .background(NexusColors.bg)
        .ignoresSafeArea()
    }
}

// MARK: - Custom NavBar
struct CustomNavBar: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack(spacing: 0) {
            NavItem(icon: "house.fill",     label: "ACCUEIL",  tab: .accueil,  selected: $selectedTab)
            NavItem(icon: "calendar",       label: "PLANIF.",  tab: .planif,   selected: $selectedTab)
            NavItem(icon: "bolt.fill",      label: "FITNESS",  tab: .fitness,  selected: $selectedTab)
            NavItem(icon: "moon.fill",      label: "SOMMEIL",  tab: .sommeil,  selected: $selectedTab)
            NavItem(icon: "shield.fill",    label: "BLOQUER",  tab: .bloquer,  selected: $selectedTab)
            NavItem(icon: "hexagon.fill",   label: "NEXUS IA", tab: .nexusAI,  selected: $selectedTab)
        }
        .frame(height: 72)
        .background(
            Rectangle()
                .fill(Color(red: 0.01, green: 0.04, blue: 0.1).opacity(0.97))
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [NexusColors.cyan.opacity(0.4), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                }
        )
        .padding(.bottom, 0)
    }
}

struct NavItem: View {
    let icon: String
    let label: String
    let tab: ContentView.Tab
    @Binding var selected: ContentView.Tab

    var isActive: Bool { selected == tab }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selected = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(isActive ? NexusColors.cyan : NexusColors.text3)
                    .shadow(color: isActive ? NexusColors.cyan.opacity(0.8) : .clear, radius: 6)

                Text(label)
                    .font(.system(size: 7, weight: .bold, design: .monospaced))
                    .foregroundStyle(isActive ? NexusColors.cyan : NexusColors.text3)
                    .tracking(1)

                Rectangle()
                    .fill(isActive ? NexusColors.cyan : .clear)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8)
                    .shadow(color: NexusColors.cyan, radius: 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
        .buttonStyle(.plain)
    }
}
