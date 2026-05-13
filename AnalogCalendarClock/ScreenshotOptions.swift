import Foundation

struct ScreenshotOptions {
    static let shared = ScreenshotOptions()

    let fixedDate: Date?
    let theme: ClockTheme?
    let weekStartDay: WeekStartDay?
    let showsSettingsOnLaunch: Bool

    private init(processInfo: ProcessInfo = .processInfo) {
        let environment = processInfo.environment

        if let rawDate = environment["CLOCK_SCREENSHOT_ISO8601"] {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            fixedDate = formatter.date(from: rawDate)
        } else {
            fixedDate = nil
        }

        if let rawTheme = environment["CLOCK_SCREENSHOT_THEME"] {
            theme = ClockTheme(rawValue: rawTheme.lowercased())
        } else {
            theme = nil
        }

        if let rawWeekStart = environment["CLOCK_SCREENSHOT_WEEK_START"] {
            weekStartDay = WeekStartDay(rawValue: rawWeekStart.lowercased())
        } else {
            weekStartDay = nil
        }

        let rawShowSettings = environment["CLOCK_SCREENSHOT_SHOW_SETTINGS"] ?? "0"
        showsSettingsOnLaunch = ["1", "true", "yes"].contains(rawShowSettings.lowercased())
    }
}
