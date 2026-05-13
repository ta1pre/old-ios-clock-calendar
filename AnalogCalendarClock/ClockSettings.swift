import UIKit

enum ClockTheme: String {
    case light
    case dark

    var title: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }

    var palette: ClockPalette {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

enum WeekStartDay: String, CaseIterable {
    case sunday
    case monday
    case saturday

    var title: String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .saturday:
            return "Saturday"
        }
    }

    var shortSymbol: String {
        switch self {
        case .sunday:
            return "S"
        case .monday:
            return "M"
        case .saturday:
            return "S"
        }
    }

    var calendarFirstWeekday: Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .saturday:
            return 7
        }
    }
}

struct ClockSettings {
    var theme: ClockTheme
    var weekStartDay: WeekStartDay

    static let defaultValue = ClockSettings(theme: .dark, weekStartDay: .sunday)
}

struct ClockPalette {
    let background: UIColor
    let clockRing: UIColor
    let clockMajorTick: UIColor
    let clockMinorTick: UIColor
    let clockNumeral: UIColor
    let hourHand: UIColor
    let minuteHand: UIColor
    let secondHand: UIColor
    let centerOuter: UIColor
    let centerInner: UIColor
    let calendarTitle: UIColor
    let weekdayDefault: UIColor
    let dayDefault: UIColor
    let adjacentDay: UIColor
    let sunday: UIColor
    let saturday: UIColor
    let todayFill: UIColor
    let todayText: UIColor
    let settingsBackground: UIColor
    let settingsCardBackground: UIColor
    let settingsCardBorder: UIColor
    let settingsPrimaryText: UIColor
    let settingsSecondaryText: UIColor
    let settingsDivider: UIColor
    let selectionAccent: UIColor
    let lightModeShadow: UIColor

    static let dark = ClockPalette(
        background: UIColor(white: 0.0, alpha: 1.0),
        clockRing: UIColor(white: 0.22, alpha: 1.0),
        clockMajorTick: UIColor(white: 0.95, alpha: 1.0),
        clockMinorTick: UIColor(white: 0.88, alpha: 1.0),
        clockNumeral: UIColor(white: 0.97, alpha: 1.0),
        hourHand: UIColor(white: 0.98, alpha: 1.0),
        minuteHand: UIColor(white: 0.98, alpha: 1.0),
        secondHand: UIColor(red: 1.0, green: 0.18, blue: 0.16, alpha: 1.0),
        centerOuter: UIColor(white: 1.0, alpha: 1.0),
        centerInner: UIColor(red: 1.0, green: 0.18, blue: 0.16, alpha: 1.0),
        calendarTitle: UIColor(white: 0.96, alpha: 1.0),
        weekdayDefault: UIColor(white: 0.96, alpha: 1.0),
        dayDefault: UIColor(white: 0.97, alpha: 1.0),
        adjacentDay: UIColor(white: 0.46, alpha: 1.0),
        sunday: UIColor(red: 1.0, green: 0.22, blue: 0.20, alpha: 1.0),
        saturday: UIColor(red: 0.25, green: 0.58, blue: 1.0, alpha: 1.0),
        todayFill: UIColor(red: 0.26, green: 0.56, blue: 0.96, alpha: 1.0),
        todayText: UIColor(white: 1.0, alpha: 1.0),
        settingsBackground: UIColor(red: 0.10, green: 0.10, blue: 0.11, alpha: 1.0),
        settingsCardBackground: UIColor(red: 0.16, green: 0.16, blue: 0.17, alpha: 1.0),
        settingsCardBorder: UIColor(red: 0.24, green: 0.24, blue: 0.25, alpha: 1.0),
        settingsPrimaryText: UIColor(white: 0.98, alpha: 1.0),
        settingsSecondaryText: UIColor(white: 0.68, alpha: 1.0),
        settingsDivider: UIColor(red: 0.27, green: 0.27, blue: 0.28, alpha: 1.0),
        selectionAccent: UIColor(red: 0.26, green: 0.56, blue: 0.96, alpha: 1.0),
        lightModeShadow: UIColor.black.withAlphaComponent(0.0)
    )

    static let light = ClockPalette(
        background: UIColor(red: 0.985, green: 0.985, blue: 0.98, alpha: 1.0),
        clockRing: UIColor(red: 0.90, green: 0.90, blue: 0.89, alpha: 1.0),
        clockMajorTick: UIColor(red: 0.05, green: 0.05, blue: 0.06, alpha: 1.0),
        clockMinorTick: UIColor(red: 0.08, green: 0.08, blue: 0.09, alpha: 1.0),
        clockNumeral: UIColor(red: 0.03, green: 0.03, blue: 0.04, alpha: 1.0),
        hourHand: UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1.0),
        minuteHand: UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1.0),
        secondHand: UIColor(red: 1.0, green: 0.18, blue: 0.16, alpha: 1.0),
        centerOuter: UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1.0),
        centerInner: UIColor(red: 1.0, green: 0.18, blue: 0.16, alpha: 1.0),
        calendarTitle: UIColor(red: 0.05, green: 0.05, blue: 0.06, alpha: 1.0),
        weekdayDefault: UIColor(red: 0.08, green: 0.08, blue: 0.09, alpha: 1.0),
        dayDefault: UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1.0),
        adjacentDay: UIColor(red: 0.76, green: 0.76, blue: 0.77, alpha: 1.0),
        sunday: UIColor(red: 0.92, green: 0.18, blue: 0.14, alpha: 1.0),
        saturday: UIColor(red: 0.22, green: 0.48, blue: 0.92, alpha: 1.0),
        todayFill: UIColor(red: 0.26, green: 0.56, blue: 0.96, alpha: 1.0),
        todayText: UIColor(white: 1.0, alpha: 1.0),
        settingsBackground: UIColor(red: 0.985, green: 0.985, blue: 0.98, alpha: 1.0),
        settingsCardBackground: UIColor(white: 1.0, alpha: 1.0),
        settingsCardBorder: UIColor(red: 0.90, green: 0.90, blue: 0.89, alpha: 1.0),
        settingsPrimaryText: UIColor(red: 0.06, green: 0.06, blue: 0.07, alpha: 1.0),
        settingsSecondaryText: UIColor(red: 0.48, green: 0.48, blue: 0.50, alpha: 1.0),
        settingsDivider: UIColor(red: 0.90, green: 0.90, blue: 0.89, alpha: 1.0),
        selectionAccent: UIColor(red: 0.26, green: 0.56, blue: 0.96, alpha: 1.0),
        lightModeShadow: UIColor.black.withAlphaComponent(0.08)
    )
}

final class ClockSettingsStore {
    static let shared = ClockSettingsStore()

    private enum Keys {
        static let theme = "clock.theme"
        static let weekStartDay = "clock.weekStartDay"
    }

    private let defaults = UserDefaults.standard

    private(set) var settings: ClockSettings {
        didSet {
            save()
            NotificationCenter.default.post(name: .clockSettingsDidChange, object: self)
        }
    }

    private init() {
        let theme = ClockTheme(rawValue: defaults.string(forKey: Keys.theme) ?? "") ?? .dark
        let weekStartDay = WeekStartDay(rawValue: defaults.string(forKey: Keys.weekStartDay) ?? "") ?? .sunday
        settings = ClockSettings(theme: theme, weekStartDay: weekStartDay)
    }

    func updateTheme(_ theme: ClockTheme) {
        guard settings.theme != theme else { return }
        settings.theme = theme
    }

    func updateWeekStartDay(_ weekStartDay: WeekStartDay) {
        guard settings.weekStartDay != weekStartDay else { return }
        settings.weekStartDay = weekStartDay
    }

    private func save() {
        defaults.set(settings.theme.rawValue, forKey: Keys.theme)
        defaults.set(settings.weekStartDay.rawValue, forKey: Keys.weekStartDay)
    }
}

extension Notification.Name {
    static let clockSettingsDidChange = Notification.Name("clockSettingsDidChange")
}
