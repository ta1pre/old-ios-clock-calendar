import UIKit

final class CalendarMonthView: UIView {
    enum LayoutMode {
        case compactPhone
        case regular
    }

    var layoutMode: LayoutMode = .regular {
        didSet {
            updateTypography()
        }
    }

    var palette: ClockPalette = .dark {
        didSet {
            applyPalette()
            configureMonth()
        }
    }

    var weekStartDay: WeekStartDay = .sunday {
        didSet {
            calendar.firstWeekday = weekStartDay.calendarFirstWeekday
            setupWeekdaySymbols()
            configureMonth()
        }
    }

    var displayDate = Date() {
        didSet {
            configureMonth()
        }
    }

    private let titleLabel = UILabel()
    private let weekdayStack = UIStackView()
    private let daysStack = UIStackView()
    private var weekdayLabels: [UILabel] = []
    private var dayCells: [CalendarDayCell] = []
    private var calendar = Calendar(identifier: .gregorian)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateTypography()
    }

    private func commonInit() {
        backgroundColor = .clear
        calendar.firstWeekday = weekStartDay.calendarFirstWeekday
        setupTitle()
        setupWeekdayStack()
        setupDaysGrid()
        setupConstraints()
        applyPalette()
        configureMonth()
    }

    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.72
        addSubview(titleLabel)
    }

    private func setupWeekdayStack() {
        weekdayStack.translatesAutoresizingMaskIntoConstraints = false
        weekdayStack.axis = .horizontal
        weekdayStack.distribution = .fillEqually
        weekdayStack.alignment = .fill
        weekdayStack.spacing = 0
        addSubview(weekdayStack)

        for _ in 0..<7 {
            let label = UILabel()
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.65
            weekdayStack.addArrangedSubview(label)
            weekdayLabels.append(label)
        }

        setupWeekdaySymbols()
    }

    private func setupDaysGrid() {
        daysStack.translatesAutoresizingMaskIntoConstraints = false
        daysStack.axis = .vertical
        daysStack.distribution = .fillEqually
        daysStack.alignment = .fill
        daysStack.spacing = 0
        addSubview(daysStack)

        for _ in 0..<6 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.alignment = .fill
            row.spacing = 0
            daysStack.addArrangedSubview(row)

            for _ in 0..<7 {
                let cell = CalendarDayCell()
                row.addArrangedSubview(cell)
                dayCells.append(cell)
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            weekdayStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdayStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdayStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            weekdayStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.12),

            daysStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            daysStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            daysStack.topAnchor.constraint(equalTo: weekdayStack.bottomAnchor, constant: 10),
            daysStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupWeekdaySymbols() {
        let symbols = ["S", "M", "T", "W", "T", "F", "S"]
        for (index, label) in weekdayLabels.enumerated() {
            let weekday = weekdayForColumn(index)
            label.text = symbols[weekday - 1]
            label.textColor = colorForWeekday(weekday, isCurrentMonth: true, isHeader: true)
        }
    }

    private func configureMonth() {
        let titleFormatter = DateFormatter()
        titleFormatter.locale = Locale(identifier: "en_US_POSIX")
        titleFormatter.dateFormat = "MMMM yyyy"
        titleLabel.text = titleFormatter.string(from: displayDate)

        let components = calendar.dateComponents([.year, .month], from: displayDate)
        guard let monthStart = calendar.date(from: components) else { return }

        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let leadingDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        guard let firstVisibleDate = calendar.date(byAdding: .day, value: -leadingDays, to: monthStart) else { return }

        for index in 0..<dayCells.count {
            guard let date = calendar.date(byAdding: .day, value: index, to: firstVisibleDate) else { continue }
            let isCurrentMonth = calendar.isDate(date, equalTo: monthStart, toGranularity: .month)
            let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
            let weekday = calendar.component(.weekday, from: date)
            let textColor = colorForWeekday(weekday, isCurrentMonth: isCurrentMonth, isHeader: false)

            let dayNumber = calendar.component(.day, from: date)
            dayCells[index].apply(
                text: "\(dayNumber)",
                textColor: isToday ? palette.todayText : textColor,
                markerColor: isToday && isCurrentMonth ? palette.todayFill : nil
            )
        }
    }

    private func applyPalette() {
        titleLabel.textColor = palette.calendarTitle
        backgroundColor = .clear
        titleLabel.textColor = palette.calendarTitle
        setupWeekdaySymbols()
        dayCells.forEach { $0.palette = palette }
    }

    private func updateTypography() {
        let height = bounds.height > 0 ? bounds.height : 320.0
        let titleSize: CGFloat
        let weekdaySize: CGFloat
        let daySize: CGFloat

        switch layoutMode {
        case .compactPhone:
            titleSize = max(18.0, min(24.0, height * 0.072))
            weekdaySize = max(10.0, min(14.0, height * 0.040))
            daySize = max(13.0, min(18.0, height * 0.053))
        case .regular:
            titleSize = max(24.0, min(38.0, height * 0.075))
            weekdaySize = max(12.0, min(18.0, height * 0.037))
            daySize = max(17.0, min(30.0, height * 0.052))
        }

        titleLabel.font = UIFont.systemFont(ofSize: titleSize, weight: .semibold)
        weekdayLabels.forEach {
            $0.font = UIFont.systemFont(ofSize: weekdaySize, weight: .medium)
        }
        dayCells.forEach {
            $0.font = UIFont.monospacedDigitSystemFont(ofSize: daySize, weight: .medium)
        }
    }

    private func weekdayForColumn(_ column: Int) -> Int {
        return ((calendar.firstWeekday - 1 + column) % 7) + 1
    }

    private func colorForWeekday(_ weekday: Int, isCurrentMonth: Bool, isHeader: Bool) -> UIColor {
        if !isCurrentMonth && !isHeader {
            return palette.adjacentDay
        }

        switch weekday {
        case 1:
            return palette.sunday
        case 7:
            return palette.saturday
        default:
            return isHeader ? palette.weekdayDefault : palette.dayDefault
        }
    }
}

private final class CalendarDayCell: UIView {
    var font: UIFont = UIFont.systemFont(ofSize: 18, weight: .medium) {
        didSet {
            dayLabel.font = font
        }
    }

    var palette: ClockPalette = .dark

    private let markerView = UIView()
    private let dayLabel = UILabel()
    private var markerWidthConstraint: NSLayoutConstraint?
    private var markerHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let markerSize = min(max(28.0, bounds.height * 0.72), 48.0)
        markerWidthConstraint?.constant = markerSize
        markerHeightConstraint?.constant = markerSize
        markerView.layer.cornerRadius = markerSize / 2.0
    }

    func apply(text: String, textColor: UIColor, markerColor: UIColor?) {
        dayLabel.text = text
        dayLabel.textColor = textColor
        markerView.backgroundColor = markerColor ?? .clear
    }

    private func commonInit() {
        backgroundColor = .clear
        markerView.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        markerView.backgroundColor = .clear
        markerView.layer.masksToBounds = true

        dayLabel.textAlignment = .center
        dayLabel.adjustsFontSizeToFitWidth = true
        dayLabel.minimumScaleFactor = 0.65

        addSubview(markerView)
        addSubview(dayLabel)

        markerWidthConstraint = markerView.widthAnchor.constraint(equalToConstant: 34)
        markerHeightConstraint = markerView.heightAnchor.constraint(equalToConstant: 34)

        NSLayoutConstraint.activate([
            markerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            markerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            markerWidthConstraint!,
            markerHeightConstraint!,

            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
