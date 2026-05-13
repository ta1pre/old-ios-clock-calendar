import UIKit

final class SettingsViewController: UIViewController {
    private let settingsStore: ClockSettingsStore

    private let titleLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let formView = UIView()
    private let displayModeLabel = UILabel()
    private let displayCard = OptionCardView()
    private let weekStartLabel = UILabel()
    private let weekStartCard = OptionCardView()

    private let lightRow = OptionRowView()
    private let darkRow = OptionRowView()
    private let sundayRow = OptionRowView()
    private let mondayRow = OptionRowView()
    private let saturdayRow = OptionRowView()

    init(settingsStore: ClockSettingsStore) {
        self.settingsStore = settingsStore
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return settingsStore.settings.theme == .dark ? .lightContent : .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupRows()
        applyTheme()
        reloadSelectionState()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSettingsChanged),
            name: .clockSettingsDidChange,
            object: settingsStore
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupHierarchy() {
        [scrollView, contentView, formView, titleLabel, doneButton, displayModeLabel, displayCard, weekStartLabel, weekStartCard].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(doneButton)
        contentView.addSubview(formView)
        formView.addSubview(displayModeLabel)
        formView.addSubview(displayCard)
        formView.addSubview(weekStartLabel)
        formView.addSubview(weekStartCard)

        titleLabel.text = "Settings"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)

        displayModeLabel.text = "Display Mode"
        displayModeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        weekStartLabel.text = "Week Starts On"
        weekStartLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            doneButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            formView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34),
            formView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 24),
            formView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -24),
            formView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            formView.widthAnchor.constraint(equalToConstant: 720).withPriority(.defaultHigh),

            displayModeLabel.topAnchor.constraint(equalTo: formView.topAnchor),
            displayModeLabel.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            displayModeLabel.trailingAnchor.constraint(equalTo: formView.trailingAnchor),

            displayCard.topAnchor.constraint(equalTo: displayModeLabel.bottomAnchor, constant: 14),
            displayCard.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            displayCard.trailingAnchor.constraint(equalTo: formView.trailingAnchor),

            weekStartLabel.topAnchor.constraint(equalTo: displayCard.bottomAnchor, constant: 34),
            weekStartLabel.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            weekStartLabel.trailingAnchor.constraint(equalTo: formView.trailingAnchor),

            weekStartCard.topAnchor.constraint(equalTo: weekStartLabel.bottomAnchor, constant: 14),
            weekStartCard.leadingAnchor.constraint(equalTo: formView.leadingAnchor),
            weekStartCard.trailingAnchor.constraint(equalTo: formView.trailingAnchor),
            weekStartCard.bottomAnchor.constraint(equalTo: formView.bottomAnchor),

            formView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func setupRows() {
        lightRow.configure(iconText: "☀︎", iconColor: nil, title: "Light")
        darkRow.configure(iconText: "☾", iconColor: nil, title: "Dark")
        sundayRow.configure(iconText: "S", iconColor: settingsStore.settings.theme.palette.sunday, title: "Sunday")
        mondayRow.configure(iconText: "M", iconColor: nil, title: "Monday")
        saturdayRow.configure(iconText: "S", iconColor: settingsStore.settings.theme.palette.saturday, title: "Saturday")

        [lightRow, darkRow].forEach { displayCard.addRow($0) }
        [sundayRow, mondayRow, saturdayRow].forEach { weekStartCard.addRow($0) }

        lightRow.addTarget(self, action: #selector(selectLightMode), for: .touchUpInside)
        darkRow.addTarget(self, action: #selector(selectDarkMode), for: .touchUpInside)
        sundayRow.addTarget(self, action: #selector(selectSundayStart), for: .touchUpInside)
        mondayRow.addTarget(self, action: #selector(selectMondayStart), for: .touchUpInside)
        saturdayRow.addTarget(self, action: #selector(selectSaturdayStart), for: .touchUpInside)
    }

    @objc private func doneTapped() {
        dismiss(animated: true)
    }

    @objc private func selectLightMode() {
        settingsStore.updateTheme(.light)
    }

    @objc private func selectDarkMode() {
        settingsStore.updateTheme(.dark)
    }

    @objc private func selectSundayStart() {
        settingsStore.updateWeekStartDay(.sunday)
    }

    @objc private func selectMondayStart() {
        settingsStore.updateWeekStartDay(.monday)
    }

    @objc private func selectSaturdayStart() {
        settingsStore.updateWeekStartDay(.saturday)
    }

    @objc private func handleSettingsChanged() {
        applyTheme()
        reloadSelectionState()
        setNeedsStatusBarAppearanceUpdate()
    }

    private func applyTheme() {
        let palette = settingsStore.settings.theme.palette
        view.backgroundColor = palette.settingsBackground
        scrollView.backgroundColor = palette.settingsBackground
        contentView.backgroundColor = palette.settingsBackground
        titleLabel.textColor = palette.settingsPrimaryText
        displayModeLabel.textColor = palette.settingsSecondaryText
        weekStartLabel.textColor = palette.settingsSecondaryText
        doneButton.tintColor = palette.selectionAccent

        displayCard.applyPalette(palette)
        weekStartCard.applyPalette(palette)

        [lightRow, darkRow, sundayRow, mondayRow, saturdayRow].forEach {
            $0.applyPalette(palette)
        }

        sundayRow.leadingTintColor = palette.sunday
        mondayRow.leadingTintColor = palette.settingsPrimaryText
        saturdayRow.leadingTintColor = palette.saturday
    }

    private func reloadSelectionState() {
        let settings = settingsStore.settings
        lightRow.isOptionSelected = settings.theme == .light
        darkRow.isOptionSelected = settings.theme == .dark
        sundayRow.isOptionSelected = settings.weekStartDay == .sunday
        mondayRow.isOptionSelected = settings.weekStartDay == .monday
        saturdayRow.isOptionSelected = settings.weekStartDay == .saturday
    }
}

private final class OptionCardView: UIView {
    private let stackView = UIStackView()
    private var rows: [OptionRowView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 18
        layer.borderWidth = 1
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addRow(_ row: OptionRowView) {
        row.showsSeparator = !rows.isEmpty
        rows.append(row)
        stackView.addArrangedSubview(row)
    }

    func applyPalette(_ palette: ClockPalette) {
        backgroundColor = palette.settingsCardBackground
        layer.borderColor = palette.settingsCardBorder.cgColor
    }
}

private final class OptionRowView: UIControl {
    private let separatorView = UIView()
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let indicatorView = SelectionIndicatorView()

    var leadingTintColor: UIColor?

    var isOptionSelected: Bool = false {
        didSet {
            indicatorView.isOptionSelected = isOptionSelected
        }
    }

    var showsSeparator: Bool = false {
        didSet {
            separatorView.isHidden = !showsSeparator
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 76).isActive = true

        [separatorView, iconLabel, titleLabel, indicatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        iconLabel.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        iconLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            iconLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            iconLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 34),

            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 28),
            indicatorView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(iconText: String, iconColor: UIColor?, title: String) {
        iconLabel.text = iconText
        leadingTintColor = iconColor
        titleLabel.text = title
    }

    func applyPalette(_ palette: ClockPalette) {
        backgroundColor = .clear
        separatorView.backgroundColor = palette.settingsDivider
        iconLabel.textColor = leadingTintColor ?? palette.settingsPrimaryText
        titleLabel.textColor = palette.settingsPrimaryText
        indicatorView.applyPalette(palette)
    }
}

private final class SelectionIndicatorView: UIView {
    private let outerRing = UIView()
    private let innerDot = UIView()
    private var palette: ClockPalette = .dark

    var isOptionSelected: Bool = false {
        didSet {
            outerRing.layer.borderColor = (isOptionSelected ? palette.selectionAccent : palette.settingsSecondaryText).cgColor
            innerDot.isHidden = !isOptionSelected
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        [outerRing, innerDot].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            outerRing.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerRing.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerRing.topAnchor.constraint(equalTo: topAnchor),
            outerRing.bottomAnchor.constraint(equalTo: bottomAnchor),

            innerDot.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerDot.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerDot.widthAnchor.constraint(equalToConstant: 12),
            innerDot.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        outerRing.layer.cornerRadius = bounds.width / 2
        innerDot.layer.cornerRadius = innerDot.bounds.width / 2
    }

    func applyPalette(_ palette: ClockPalette) {
        self.palette = palette
        outerRing.layer.borderWidth = 2
        outerRing.layer.borderColor = (isOptionSelected ? palette.selectionAccent : palette.settingsSecondaryText).cgColor
        innerDot.backgroundColor = palette.selectionAccent
        innerDot.isHidden = !isOptionSelected
    }
}

private extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
