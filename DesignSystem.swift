import SwiftUI

// MARK: - Color System
enum NexusColors {
    static let bg        = Color(red: 0.008, green: 0.031, blue: 0.078)
    static let bg2       = Color(red: 0.016, green: 0.051, blue: 0.102)
    static let bg3       = Color(red: 0.027, green: 0.063, blue: 0.133)
    static let card      = Color(red: 0.031, green: 0.078, blue: 0.149)
    static let card2     = Color(red: 0.047, green: 0.102, blue: 0.188)

    static let cyan      = Color(red: 0.0,   green: 0.898, blue: 1.0)
    static let cyan2     = Color(red: 0.0,   green: 0.706, blue: 0.8)
    static let purple    = Color(red: 0.616, green: 0.306, blue: 0.929)
    static let purple2   = Color(red: 0.482, green: 0.188, blue: 0.745)
    static let green     = Color(red: 0.0,   green: 1.0,   blue: 0.616)
    static let orange    = Color(red: 1.0,   green: 0.584, blue: 0.0)
    static let red       = Color(red: 1.0,   green: 0.231, blue: 0.361)
    static let yellow    = Color(red: 1.0,   green: 0.839, blue: 0.039)
    static let blue      = Color(red: 0.310, green: 0.765, blue: 0.969)
    static let pink      = Color(red: 1.0,   green: 0.431, blue: 0.706)

    static let text      = Color(red: 0.816, green: 0.910, blue: 0.973)
    static let text2     = Color(red: 0.478, green: 0.604, blue: 0.722)
    static let text3     = Color(red: 0.290, green: 0.416, blue: 0.533)

    static let border    = Color(red: 0.0, green: 0.898, blue: 1.0).opacity(0.12)
    static let border2   = Color(red: 0.0, green: 0.898, blue: 1.0).opacity(0.25)
}

// MARK: - Typography
enum NexusFont {
    static func orbitron(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }
    static func rajdhani(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}

// MARK: - Shared Card Modifier
struct NexusCardStyle: ViewModifier {
    var padding: CGFloat = 14

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(NexusColors.card)
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [NexusColors.cyan.opacity(0.4), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(NexusColors.border, lineWidth: 1)
            )
    }
}

extension View {
    func nexusCard(padding: CGFloat = 14) -> some View {
        modifier(NexusCardStyle(padding: padding))
    }
}

// MARK: - Card Title
struct NexusCardTitle: View {
    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(NexusColors.cyan)
                .frame(width: 3, height: 10)
                .cornerRadius(2)
                .shadow(color: NexusColors.cyan, radius: 4)

            Text(title)
                .font(NexusFont.orbitron(10, weight: .semibold))
                .foregroundStyle(NexusColors.cyan)
                .tracking(2)
        }
    }
}

// MARK: - Progress Bar
struct NexusProgressBar: View {
    let value: Double // 0.0 to 1.0
    let color: Color
    var height: CGFloat = 4

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.white.opacity(0.06))

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.7), color],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * min(max(value, 0), 1))
                    .animation(.easeInOut(duration: 0.8), value: value)
            }
        }
        .frame(height: height)
    }
}

// MARK: - Ring (Circular Progress)
struct NexusRing: View {
    let progress: Double // 0.0 to 1.0
    let color: Color
    var size: CGFloat = 70
    var lineWidth: CGFloat = 7
    var label: String = ""
    var sublabel: String = ""

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.15), lineWidth: lineWidth)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress)

                VStack(spacing: 1) {
                    Text(label)
                        .font(NexusFont.orbitron(12, weight: .bold))
                        .foregroundStyle(color)
                    if !sublabel.isEmpty {
                        Text(sublabel)
                            .font(NexusFont.orbitron(7))
                            .foregroundStyle(NexusColors.text3)
                    }
                }
            }
            .frame(width: size, height: size)
        }
    }
}

// MARK: - Badge
struct NexusBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.12))
            .overlay(
                Capsule().stroke(color.opacity(0.25), lineWidth: 1)
            )
            .clipShape(Capsule())
    }
}

// MARK: - Toggle
struct NexusToggle: View {
    @Binding var isOn: Bool
    var color: Color = NexusColors.cyan

    var body: some View {
        ZStack {
            Capsule()
                .fill(isOn ? color.opacity(0.25) : Color.white.opacity(0.08))
                .overlay(Capsule().stroke(isOn ? color : NexusColors.border2, lineWidth: 1))
                .frame(width: 44, height: 24)
                .shadow(color: isOn ? color.opacity(0.3) : .clear, radius: 6)

            Circle()
                .fill(isOn ? color : NexusColors.text3)
                .frame(width: 18, height: 18)
                .shadow(color: isOn ? color : .clear, radius: 4)
                .offset(x: isOn ? 10 : -10)
                .animation(.spring(response: 0.3), value: isOn)
        }
        .frame(width: 44, height: 24)
        .onTapGesture { isOn.toggle() }
    }
}

// MARK: - Button Styles
struct NexusPrimaryButtonStyle: ButtonStyle {
    var color: Color = NexusColors.cyan

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(NexusFont.orbitron(11, weight: .semibold))
            .foregroundStyle(color)
            .tracking(1)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(color.opacity(configuration.isPressed ? 0.2 : 0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.4), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: configuration.isPressed ? color.opacity(0.3) : .clear, radius: 8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct NexusSolidButtonStyle: ButtonStyle {
    var color: Color = NexusColors.purple

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(NexusFont.orbitron(12, weight: .bold))
            .foregroundStyle(.white)
            .tracking(1)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [color.opacity(0.8), color],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: color.opacity(configuration.isPressed ? 0.5 : 0.2), radius: 10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Page Header
struct NexusPageHeader: View {
    let title: String
    var subtitle: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("NEXUS OS")
                .font(NexusFont.orbitron(11, weight: .bold))
                .foregroundStyle(NexusColors.cyan)
                .tracking(3)

            Text(title)
                .font(NexusFont.orbitron(22, weight: .bold))
                .foregroundStyle(.white)
                .tracking(1)

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(NexusColors.text2)
                    .tracking(0.5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(
            LinearGradient(
                colors: [NexusColors.bg2.opacity(0.95), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Stat Row
struct NexusStatRow: View {
    let label: String
    let value: String
    var valueColor: Color = NexusColors.text

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(NexusColors.text2)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(valueColor)
        }
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.white.opacity(0.04))
                .frame(height: 1)
        }
    }
}

// MARK: - Section Title
struct NexusSectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(NexusFont.orbitron(9, weight: .semibold))
            .foregroundStyle(NexusColors.text2)
            .tracking(2)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 4)
    }
}
