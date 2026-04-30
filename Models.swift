import Foundation
import SwiftData

// MARK: - Task
@Model
final class TaskItem {
    var id: UUID
    var title: String
    var category: TaskCategory
    var colorHex: String
    var hour: String
    var duration: String
    var importance: TaskImportance
    var isDone: Bool
    var note: String
    var createdAt: Date

    init(
        title: String,
        category: TaskCategory = .travail,
        colorHex: String = "#4fc3f7",
        hour: String = "09:00",
        duration: String = "1h",
        importance: TaskImportance = .normal,
        note: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.colorHex = colorHex
        self.hour = hour
        self.duration = duration
        self.importance = importance
        self.isDone = false
        self.note = note
        self.createdAt = Date()
    }
}

enum TaskCategory: String, Codable, CaseIterable {
    case etudes   = "Études"
    case travail  = "Travail"
    case salle    = "Salle"
    case velo     = "Vélo"
    case marche   = "Marche"
    case priere   = "Prière"
    case cuisine  = "Cuisine"
    case sommeil  = "Sommeil"
    case perso    = "Personnel"

    var icon: String {
        switch self {
        case .etudes:  return "📖"
        case .travail: return "💼"
        case .salle:   return "🏋️"
        case .velo:    return "🚴"
        case .marche:  return "🚶"
        case .priere:  return "🙏"
        case .cuisine: return "🍳"
        case .sommeil: return "🌙"
        case .perso:   return "⭐"
        }
    }

    var defaultColor: String {
        switch self {
        case .etudes:  return "#4fc3f7"
        case .travail: return "#ff3b5c"
        case .salle:   return "#00ff9d"
        case .velo:    return "#00ff9d"
        case .marche:  return "#00e5ff"
        case .priere:  return "#9d4edd"
        case .cuisine: return "#ff9500"
        case .sommeil: return "#9d4edd"
        case .perso:   return "#ffd60a"
        }
    }
}

enum TaskImportance: String, Codable, CaseIterable {
    case faible         = "Faible"
    case normal         = "Normal"
    case important      = "Important"
    case tresImportant  = "Très important"
    case critique       = "Critique"

    var icon: String {
        switch self {
        case .faible:        return "⭐"
        case .normal:        return "★★"
        case .important:     return "★★★"
        case .tresImportant: return "★★★★"
        case .critique:      return "★★★★★"
        }
    }

    var colorName: String {
        switch self {
        case .faible:        return "text2"
        case .normal:        return "blue"
        case .important:     return "cyan"
        case .tresImportant: return "orange"
        case .critique:      return "red"
        }
    }
}

// MARK: - Sleep Entry
@Model
final class SleepEntry {
    var id: UUID
    var date: Date
    var bedtime: Date
    var wakeTime: Date
    var score: Int
    var deepMinutes: Int
    var remMinutes: Int
    var lightMinutes: Int
    var awakeMinutes: Int
    var hrv: Double
    var avgHeartRate: Int
    var spo2: Double

    var totalMinutes: Int {
        deepMinutes + remMinutes + lightMinutes
    }

    var totalHours: Double {
        Double(totalMinutes) / 60.0
    }

    init(date: Date = Date(), bedtime: Date, wakeTime: Date,
         score: Int = 0, deepMinutes: Int = 0, remMinutes: Int = 0,
         lightMinutes: Int = 0, awakeMinutes: Int = 0,
         hrv: Double = 0, avgHeartRate: Int = 0, spo2: Double = 97) {
        self.id = UUID()
        self.date = date
        self.bedtime = bedtime
        self.wakeTime = wakeTime
        self.score = score
        self.deepMinutes = deepMinutes
        self.remMinutes = remMinutes
        self.lightMinutes = lightMinutes
        self.awakeMinutes = awakeMinutes
        self.hrv = hrv
        self.avgHeartRate = avgHeartRate
        self.spo2 = spo2
    }
}

// MARK: - Focus Session
@Model
final class FocusSession {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var durationMinutes: Int
    var blockedApps: [String]
    var isCompleted: Bool
    var wasInterrupted: Bool

    var actualMinutes: Int {
        guard let end = endDate else { return 0 }
        return Int(end.timeIntervalSince(startDate) / 60)
    }

    init(durationMinutes: Int, blockedApps: [String]) {
        self.id = UUID()
        self.startDate = Date()
        self.endDate = nil
        self.durationMinutes = durationMinutes
        self.blockedApps = blockedApps
        self.isCompleted = false
        self.wasInterrupted = false
    }
}

// MARK: - Exercise (static data)
struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let muscle: String
    let icon: String
    let level: String
    let equipment: String
    let repsScheme: String
    let steps: [String]
    let errors: [String]
    let category: WorkoutCategory
}

enum WorkoutCategory: String, CaseIterable {
    case force    = "💪 Force"
    case cardio   = "🏃 Cardio"
    case hiit     = "⚡ HIIT"
    case mobility = "🧘 Mobilité"
    case fullBody = "🏋️ Full Body"
}

// MARK: - Chat Message
struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date = Date()
}

// MARK: - App Blocker
struct BlockedApp: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let subtitle: String
    var isBlocked: Bool
}
