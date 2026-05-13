import UIKit

final class MainViewController: UIViewController {
    private let settingsStore = ClockSettingsStore.shared

    private let contentView = UIView()
    private let clockColumn = UIView()
    private let calendarColumn = UIView()
    private let clockView = AnalogClockView()
    private let calendarView = CalendarMonthView()
    private let settingsButton = UIButton(type: .system)

    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var horizontalGapConstraint: NSLayoutConstraint?
    private var verticalGapConstraint: NSLayoutConstraint?
    private var settingsButtonTopConstraint: NSLayoutConstraint?
    private var settingsButtonTrailingConstraint: NSLayoutConstraint?
    private var horizontalClockWidthConstraint: NSLayoutConstraint?
    private var verticalClockHeightConstraint: NSLayoutConstraint?
    private var clockPreferredConstraint: NSLayoutConstraint?
    private var calendarHeightConstraint: NSLayoutConstraint?

    private var horizontalLayoutConstraints: [NSLayoutConstraint] = []
    private var verticalLayoutConstraints: [NSLayoutConstraint] = []
    private var usesPortraitLayout = false
    private var clockPreferredUsesHeightConstraint = false

    private var clockTimer: Timer?
    private var currentDate = ScreenshotOptions.shared.fixedDate ?? Date()
    private var hasPresentedLaunchSettings = false

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        applySettings()
        applySizingRules(for: view.bounds.size)
        startClockTimer()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSettingsChanged),
            name: .clockSettingsDidChange,
            object: settingsStore
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        clockTimer?.invalidate()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        applySizingRules(for: view.bounds.size)
        updateLightModeShadow()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ScreenshotOptions.shared.showsSettingsOnLaunch && !hasPresentedLaunchSettings {
            hasPresentedLaunchSettings = true
            presentSettings(animated: false)
        }
    }

    private func setupHierarchy() {
        [contentView, clockColumn, calendarColumn, clockView, calendarView, settingsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(contentView)
        view.addSubview(settingsButton)
        contentView.addSubview(clockColumn)
        contentView.addSubview(calendarColumn)
        clockColumn.addSubview(clockView)
        calendarColumn.addSubview(calendarView)

        settingsButton.setTitle("i", for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        settingsButton.layer.cornerRadius = 17
        settingsButton.layer.borderWidth = 0.8
        settingsButton.clipsToBounds = true
        settingsButton.accessibilityLabel = "Settings"
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        leadingConstraint = contentView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        trailingConstraint = contentView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        topConstraint = contentView.topAnchor.constraint(equalTo: guide.topAnchor)
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        horizontalGapConstraint = calendarColumn.leadingAnchor.constraint(equalTo: clockColumn.trailingAnchor)
        verticalGapConstraint = calendarColumn.topAnchor.constraint(equalTo: clockColumn.bottomAnchor)
        settingsButtonTopConstraint = settingsButton.topAnchor.constraint(equalTo: guide.topAnchor)
        settingsButtonTrailingConstraint = settingsButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor)

        horizontalClockWidthConstraint = clockColumn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.49)
        verticalClockHeightConstraint = clockColumn.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.40)
        clockPreferredConstraint = clockView.widthAnchor.constraint(equalTo: clockColumn.widthAnchor, multiplier: 0.88)
        clockPreferredConstraint?.priority = .defaultHigh
        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalTo: calendarColumn.heightAnchor, multiplier: 0.90)

        horizontalLayoutConstraints = [
            clockColumn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clockColumn.topAnchor.constraint(equalTo: contentView.topAnchor),
            clockColumn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalGapConstraint!,
            calendarColumn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            calendarColumn.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendarColumn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        verticalLayoutConstraints = [
            clockColumn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            clockColumn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            clockColumn.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalGapConstraint!,
            calendarColumn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            calendarColumn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            calendarColumn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate([
            leadingConstraint!,
            trailingConstraint!,
            topConstraint!,
            bottomConstraint!,
            settingsButtonTopConstraint!,
            settingsButtonTrailingConstraint!,

            settingsButton.widthAnchor.constraint(equalToConstant: 34),
            settingsButton.heightAnchor.constraint(equalToConstant: 34),

            clockView.centerXAnchor.constraint(equalTo: clockColumn.centerXAnchor),
            clockView.centerYAnchor.constraint(equalTo: clockColumn.centerYAnchor),
            clockView.widthAnchor.constraint(equalTo: clockView.heightAnchor),
            clockView.widthAnchor.constraint(lessThanOrEqualTo: clockColumn.widthAnchor, multiplier: 0.90),
            clockView.heightAnchor.constraint(lessThanOrEqualTo: clockColumn.heightAnchor, multiplier: 0.90),
            clockPreferredConstraint!,

            calendarView.leadingAnchor.constraint(equalTo: calendarColumn.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarColumn.trailingAnchor),
            calendarView.centerYAnchor.constraint(equalTo: calendarColumn.centerYAnchor),
            calendarHeightConstraint!,
            calendarView.heightAnchor.constraint(lessThanOrEqualTo: calendarColumn.heightAnchor, multiplier: 0.97)
        ])

        NSLayoutConstraint.activate(horizontalLayoutConstraints + [horizontalClockWidthConstraint!])
    }

    private func startClockTimer() {
        updateClock()
        guard ScreenshotOptions.shared.fixedDate == nil else { return }
        clockTimer?.invalidate()
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateClock()
        }
    }

    private func updateClock() {
        let now = ScreenshotOptions.shared.fixedDate ?? Date()
        clockView.displayDate = now
        if !Calendar.current.isDate(now, inSameDayAs: currentDate) {
            calendarView.displayDate = now
        }
        currentDate = now
    }

    @objc private func settingsButtonTapped() {
        presentSettings(animated: true)
    }

    @objc private func handleSettingsChanged() {
        applySettings()
    }

    private func presentSettings(animated: Bool) {
        guard presentedViewController == nil else { return }
        let controller = SettingsViewController(settingsStore: settingsStore)
        present(controller, animated: animated)
    }

    private func applySettings() {
        let settings = settingsStore.settings
        let palette = settings.theme.palette

        view.backgroundColor = palette.background
        contentView.backgroundColor = palette.background
        clockColumn.backgroundColor = palette.background
        calendarColumn.backgroundColor = palette.background

        clockView.palette = palette
        calendarView.palette = palette
        calendarView.weekStartDay = settings.weekStartDay
        calendarView.displayDate = currentDate

        let textAlpha: CGFloat = settings.theme == .light ? 0.44 : 0.62
        let borderAlpha: CGFloat = settings.theme == .light ? 0.42 : 0.58
        let fillAlpha: CGFloat = settings.theme == .light ? 0.18 : 0.12
        settingsButton.setTitleColor(palette.calendarTitle.withAlphaComponent(textAlpha), for: .normal)
        settingsButton.layer.borderColor = palette.clockRing.withAlphaComponent(borderAlpha).cgColor
        settingsButton.backgroundColor = palette.background.withAlphaComponent(fillAlpha)

        updateLightModeShadow()
    }

    private func updateLightModeShadow() {
        let palette = settingsStore.settings.theme.palette
        if settingsStore.settings.theme == .light {
            clockView.layer.shadowColor = palette.lightModeShadow.cgColor
            clockView.layer.shadowOpacity = 1.0
            clockView.layer.shadowRadius = 18
            clockView.layer.shadowOffset = CGSize(width: 0, height: 6)
            clockView.layer.shadowPath = UIBezierPath(ovalIn: clockView.bounds.insetBy(dx: 8, dy: 8)).cgPath
        } else {
            clockView.layer.shadowOpacity = 0.0
            clockView.layer.shadowPath = nil
        }
    }

    private func applySizingRules(for size: CGSize) {
        let shorterSide = min(size.width, size.height)
        let isPad = traitCollection.userInterfaceIdiom == .pad
        let isVerySmallPhone = shorterSide <= 320.0
        let isPortrait = size.height > size.width

        let edgePadding: CGFloat
        let verticalPadding: CGFloat
        let sectionGap: CGFloat
        let sectionRatio: CGFloat
        let settingsInset: CGFloat
        let clockPreferredScale: CGFloat
        let calendarHeightScale: CGFloat

        if isPortrait {
            if isPad {
                edgePadding = 34.0
                verticalPadding = 28.0
                sectionGap = 24.0
                sectionRatio = 0.36
                settingsInset = 18.0
                clockPreferredScale = 0.82
                calendarHeightScale = 0.95
            } else if isVerySmallPhone {
                edgePadding = 14.0
                verticalPadding = 12.0
                sectionGap = 12.0
                sectionRatio = 0.39
                settingsInset = 10.0
                clockPreferredScale = 0.80
                calendarHeightScale = 0.97
            } else {
                edgePadding = 18.0
                verticalPadding = 14.0
                sectionGap = 14.0
                sectionRatio = 0.40
                settingsInset = 12.0
                clockPreferredScale = 0.82
                calendarHeightScale = 0.95
            }
        } else {
            if isPad {
                edgePadding = 52.0
                verticalPadding = 34.0
                sectionGap = 34.0
                sectionRatio = 0.47
                settingsInset = 24.0
                clockPreferredScale = 0.88
                calendarHeightScale = 0.90
            } else if isVerySmallPhone {
                edgePadding = 12.0
                verticalPadding = 10.0
                sectionGap = 10.0
                sectionRatio = 0.50
                settingsInset = 10.0
                clockPreferredScale = 0.86
                calendarHeightScale = 0.92
            } else {
                edgePadding = 18.0
                verticalPadding = 14.0
                sectionGap = 16.0
                sectionRatio = 0.49
                settingsInset = 14.0
                clockPreferredScale = 0.88
                calendarHeightScale = 0.90
            }
        }

        leadingConstraint?.constant = edgePadding
        trailingConstraint?.constant = -edgePadding
        topConstraint?.constant = verticalPadding
        bottomConstraint?.constant = -verticalPadding
        horizontalGapConstraint?.constant = sectionGap
        verticalGapConstraint?.constant = sectionGap
        settingsButtonTopConstraint?.constant = verticalPadding
        settingsButtonTrailingConstraint?.constant = -settingsInset

        updateHorizontalClockWidthConstraint(multiplier: sectionRatio)
        updateVerticalClockHeightConstraint(multiplier: sectionRatio)
        updateClockPreferredConstraint(isPortrait: isPortrait, multiplier: clockPreferredScale)
        updateCalendarHeightConstraint(multiplier: calendarHeightScale)
        updateLayoutOrientation(isPortrait: isPortrait)

        if isPortrait && !isPad {
            calendarView.layoutMode = .compactPhone
        } else {
            calendarView.layoutMode = isVerySmallPhone ? .compactPhone : .regular
        }
    }

    private func updateLayoutOrientation(isPortrait: Bool) {
        guard usesPortraitLayout != isPortrait else { return }

        if isPortrait {
            NSLayoutConstraint.deactivate(horizontalLayoutConstraints)
            horizontalClockWidthConstraint?.isActive = false
            NSLayoutConstraint.activate(verticalLayoutConstraints)
            verticalClockHeightConstraint?.isActive = true
        } else {
            NSLayoutConstraint.deactivate(verticalLayoutConstraints)
            verticalClockHeightConstraint?.isActive = false
            NSLayoutConstraint.activate(horizontalLayoutConstraints)
            horizontalClockWidthConstraint?.isActive = true
        }

        usesPortraitLayout = isPortrait
    }

    private func updateHorizontalClockWidthConstraint(multiplier: CGFloat) {
        guard horizontalClockWidthConstraint?.multiplier != multiplier else { return }
        let wasActive = horizontalClockWidthConstraint?.isActive ?? false
        horizontalClockWidthConstraint?.isActive = false
        horizontalClockWidthConstraint = clockColumn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: multiplier)
        horizontalClockWidthConstraint?.isActive = wasActive
    }

    private func updateVerticalClockHeightConstraint(multiplier: CGFloat) {
        guard verticalClockHeightConstraint?.multiplier != multiplier else { return }
        let wasActive = verticalClockHeightConstraint?.isActive ?? false
        verticalClockHeightConstraint?.isActive = false
        verticalClockHeightConstraint = clockColumn.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: multiplier)
        verticalClockHeightConstraint?.isActive = wasActive
    }

    private func updateClockPreferredConstraint(isPortrait: Bool, multiplier: CGFloat) {
        if clockPreferredConstraint?.multiplier == multiplier,
           clockPreferredUsesHeightConstraint == isPortrait {
            return
        }

        let wasActive = clockPreferredConstraint?.isActive ?? false
        clockPreferredConstraint?.isActive = false
        if isPortrait {
            clockPreferredConstraint = clockView.widthAnchor.constraint(equalTo: clockColumn.heightAnchor, multiplier: multiplier)
        } else {
            clockPreferredConstraint = clockView.widthAnchor.constraint(equalTo: clockColumn.widthAnchor, multiplier: multiplier)
        }
        clockPreferredConstraint?.priority = .defaultHigh
        clockPreferredUsesHeightConstraint = isPortrait
        clockPreferredConstraint?.isActive = wasActive
    }

    private func updateCalendarHeightConstraint(multiplier: CGFloat) {
        guard calendarHeightConstraint?.multiplier != multiplier else { return }
        let wasActive = calendarHeightConstraint?.isActive ?? false
        calendarHeightConstraint?.isActive = false
        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalTo: calendarColumn.heightAnchor, multiplier: multiplier)
        calendarHeightConstraint?.isActive = wasActive
    }
}
