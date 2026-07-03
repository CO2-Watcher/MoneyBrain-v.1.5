import UIKit

// Teststart -> Selbsteinschätzung des Anlegertyps per Schieberegler
final class ProfileSelectViewController: UIViewController {

    private let kind: TestKind
    private var profile: InvestorProfile = .growth

    private let slider = UISlider()
    private let letterLabel = UILabel()
    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private let card = CardBackground()

    init(kind: TestKind) {
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = kind.title
        setupUI()
        update()
    }

    // MARK: - Aufbau

    private func setupUI() {
        // Überschrift und Hinweistext
        let heading = UILabel()
        heading.text = "Wie schätzt du dich als Anleger ein?"
        heading.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold)
        heading.numberOfLines = 0

        let info = UILabel()
        info.text = "Wähle dein Profil, davon hängt ab, welches Wissen für dich als angemessen gilt."
        info.font = .preferredFont(forTextStyle: .subheadline)
        info.textColor = .secondaryLabel
        info.numberOfLines = 0

        // Profilkarte -> großer Buchstabe + Titel + Stichpunkte
        letterLabel.font = .systemFont(ofSize: 56, weight: .heavy)
        letterLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        summaryLabel.font = .preferredFont(forTextStyle: .subheadline)
        summaryLabel.textColor = .secondaryLabel
        summaryLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, summaryLabel])
        textStack.axis = .vertical
        textStack.spacing = 6
        let cardRow = UIStackView(arrangedSubviews: [letterLabel, textStack])
        cardRow.axis = .horizontal
        cardRow.spacing = 16
        cardRow.alignment = .center
        cardRow.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(cardRow)
        NSLayoutConstraint.activate([
            cardRow.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            cardRow.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            cardRow.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            cardRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            letterLabel.widthAnchor.constraint(equalToConstant: 56)
        ])

        // Schieberegler mit drei Stufen
        slider.minimumValue = 0
        slider.maximumValue = 2
        slider.value = 1
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)

        let scaleRow = UIStackView(arrangedSubviews: [tick("A"), tick("B"), tick("C")])
        scaleRow.axis = .horizontal
        scaleRow.distribution = .equalSpacing

        // Start-Button
        let startButton = UIButton(configuration: .filled())
        startButton.configuration?.title = "Test starten"
        startButton.configuration?.buttonSize = .large
        startButton.configuration?.cornerStyle = .large
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        // Alles vertikal anordnen
        let stack = UIStackView(arrangedSubviews: [heading, info, card, slider, scaleRow, startButton])
        stack.axis = .vertical
        stack.spacing = 18
        stack.setCustomSpacing(6, after: slider)
        stack.setCustomSpacing(28, after: scaleRow)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func tick(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    // Rastet den Regler auf die drei Stufen A/B/C ein
    @objc private func sliderChanged() {
        let snapped = slider.value.rounded()
        slider.value = snapped
        profile = InvestorProfile(rawValue: Int(snapped)) ?? .growth
        update()
    }

    private func update() {
        letterLabel.text = profile.letter
        letterLabel.textColor = profile.color
        slider.minimumTrackTintColor = profile.color
        titleLabel.text = profile.title
        summaryLabel.text = profile.summary
    }

    @objc private func startTapped() {
        navigationController?.pushViewController(QuizViewController(kind: kind, profile: profile), animated: true)
    }
}
