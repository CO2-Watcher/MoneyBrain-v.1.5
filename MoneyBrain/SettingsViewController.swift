import UIKit

// Erscheinungsbild Auswahl -> persistiert über UserDefaults
enum AppTheme: Int, CaseIterable {
    case system, light, dark

    var title: String {
        switch self {
        case .system: return "System"
        case .light:  return "Hell"
        case .dark:   return "Dunkel"
        }
    }

    var style: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    // wendet das gewählte Erscheinungsbild auf das Fenster an
    func apply(to window: UIWindow?) {
        window?.overrideUserInterfaceStyle = style
    }

    private static let key = "MoneyBrain.theme"
    static var current: AppTheme {
        get { AppTheme(rawValue: UserDefaults.standard.integer(forKey: key)) ?? .system }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: key) }
    }
}

// Einstellungen-Tab
final class SettingsViewController: UIViewController {

    private let themeControl = UISegmentedControl(items: AppTheme.allCases.map { $0.title })

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Einstellungen"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupUI()
    }

    // MARK: - Aufbau

    private func setupUI() {
        // Erscheinungsbild: System / Hell / Dunkel
        let themeHeading = sectionLabel("Erscheinungsbild")
        themeControl.selectedSegmentIndex = AppTheme.current.rawValue
        themeControl.addTarget(self, action: #selector(themeChanged), for: .valueChanged)

        // Daten -> alle Ergebnisse löschen
        let dataHeading = sectionLabel("Daten")
        var cfg = UIButton.Configuration.tinted()
        cfg.title = "Zurücksetzen"
        cfg.baseForegroundColor = .systemRed
        cfg.baseBackgroundColor = .systemRed
        cfg.buttonSize = .large
        cfg.cornerStyle = .large
        let resetButton = UIButton(configuration: cfg)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        let hint = UILabel()
        hint.text = "Löscht alle gespeicherten Testergebnisse unwiderruflich."
        hint.font = .preferredFont(forTextStyle: .footnote)
        hint.textColor = .secondaryLabel
        hint.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [themeHeading, themeControl, dataHeading, resetButton, hint])
        stack.axis = .vertical
        stack.spacing = 10
        stack.setCustomSpacing(28, after: themeControl)
        stack.setCustomSpacing(6, after: resetButton)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }

    // MARK: - Aktionen

    // Erscheinungsbild wählen -> anwenden -> merken
    @objc private func themeChanged() {
        let theme = AppTheme(rawValue: themeControl.selectedSegmentIndex) ?? .system
        AppTheme.current = theme
        theme.apply(to: view.window)
    }

    // Sicherheitsabfrage -> versehentliches Löschen verhindern
    @objc private func resetTapped() {
        let alert = UIAlertController(
            title: "Ergebnisse zurücksetzen?",
            message: "Alle gespeicherten Testergebnisse werden gelöscht. Das lässt sich nicht rückgängig machen.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
        alert.addAction(UIAlertAction(title: "Löschen", style: .destructive) { _ in
            ResultStore.shared.clear()
        })
        present(alert, animated: true)
    }
}
