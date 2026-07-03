import UIKit

// Führt Frage für Frage durch den Test -> mit Sofort-Feedback nach jeder Antwort
final class QuizViewController: UIViewController {

    private let kind: TestKind
    private let profile: InvestorProfile
    private let questions: [PreparedQuestion]
    private var index = 0
    private var correctness: [Bool] = []
    private var hasAnswered = false

    // UI-Elemente
    private let progress = UIProgressView(progressViewStyle: .bar)
    private let counterLabel = UILabel()
    private let categoryChip = PaddingLabel()
    private let promptLabel = UILabel()
    private let optionsStack = UIStackView()
    private let feedbackCard = CardBackground()
    private let feedbackTitle = UILabel()
    private let feedbackText = UILabel()
    private let nextButton = UIButton(configuration: .filled())
    private let scrollView = UIScrollView()
    private var optionButtons: [UIButton] = []

    init(kind: TestKind, profile: InvestorProfile) {
        self.kind = kind
        self.profile = profile
        self.questions = FragenSpeicher.prepared(for: kind)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = kind.title
        setupUI()
        showQuestion()
    }

    // MARK: - Aufbau

    private func setupUI() {
        // Fortschrittsbalken und Frage-Zähler oben
        progress.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progress)

        counterLabel.font = .preferredFont(forTextStyle: .caption1)
        counterLabel.textColor = .secondaryLabel
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(counterLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        // Kategorie-Chip -> links ausgerichtet
        categoryChip.font = .systemFont(ofSize: 13, weight: .semibold)
        categoryChip.textColor = .tintColor
        categoryChip.backgroundColor = UIColor.tintColor.withAlphaComponent(0.15)
        categoryChip.layer.cornerRadius = 8
        categoryChip.layer.masksToBounds = true
        let chipRow = UIStackView(arrangedSubviews: [categoryChip, UIView()])
        chipRow.axis = .horizontal

        promptLabel.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize, weight: .semibold)
        promptLabel.numberOfLines = 0
        promptLabel.adjustsFontForContentSizeCategory = true

        // Vier Antwort Buttons erzeugen
        optionsStack.axis = .vertical
        optionsStack.spacing = 10
        optionsStack.alignment = .fill
        for i in 0..<4 {
            let button = UIButton(configuration: optionBaseConfig(title: ""))
            button.contentHorizontalAlignment = .leading
            button.titleLabel?.numberOfLines = 0
            button.tag = i
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            optionButtons.append(button)
            optionsStack.addArrangedSubview(button)
        }

        // Feedback-Karte -> am Anfang versteckt
        feedbackTitle.font = .preferredFont(forTextStyle: .headline)
        feedbackText.font = .preferredFont(forTextStyle: .subheadline)
        feedbackText.textColor = .secondaryLabel
        feedbackText.numberOfLines = 0
        let feedbackStack = UIStackView(arrangedSubviews: [feedbackTitle, feedbackText])
        feedbackStack.axis = .vertical
        feedbackStack.spacing = 6
        feedbackStack.translatesAutoresizingMaskIntoConstraints = false
        feedbackCard.addSubview(feedbackStack)
        feedbackCard.isHidden = true
        NSLayoutConstraint.activate([
            feedbackStack.topAnchor.constraint(equalTo: feedbackCard.topAnchor, constant: 14),
            feedbackStack.leadingAnchor.constraint(equalTo: feedbackCard.leadingAnchor, constant: 14),
            feedbackStack.trailingAnchor.constraint(equalTo: feedbackCard.trailingAnchor, constant: -14),
            feedbackStack.bottomAnchor.constraint(equalTo: feedbackCard.bottomAnchor, constant: -14)
        ])

        // Frageinhalte in den Scrollbereich legen
        let content = UIStackView(arrangedSubviews: [chipRow, promptLabel, optionsStack, feedbackCard])
        content.axis = .vertical
        content.spacing = 18
        content.setCustomSpacing(22, after: optionsStack)
        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)

        // Weiter-Button unten
        nextButton.configuration?.cornerStyle = .large
        nextButton.configuration?.buttonSize = .large
        nextButton.isHidden = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progress.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            counterLabel.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 6),
            counterLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),

            scrollView.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10),

            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -8),
            content.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            nextButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }

    // Basis-Konfiguration einer Antwort-Schaltfläche
    private func optionBaseConfig(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.gray()
        config.title = title
        config.baseBackgroundColor = .secondarySystemGroupedBackground
        config.baseForegroundColor = .label
        config.titleLineBreakMode = .byWordWrapping
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var out = incoming
            out.font = .preferredFont(forTextStyle: .body)
            return out
        }
        return config
    }

    // MARK: - Ablauf

    private func showQuestion() {
        // Zustand für die neue Frage zurücksetzen
        hasAnswered = false
        optionsStack.isUserInteractionEnabled = true
        feedbackCard.isHidden = true
        nextButton.isHidden = true

        // Aktuelle Frage und Optionen anzeigen
        let prepared = questions[index]
        counterLabel.text = "Frage \(index + 1) von \(questions.count)"
        progress.setProgress(Float(index) / Float(questions.count), animated: true)
        categoryChip.text = prepared.question.category.title
        promptLabel.text = prepared.question.prompt

        for (i, button) in optionButtons.enumerated() {
            button.configuration = optionBaseConfig(title: prepared.options[i])
            button.tag = i
        }
        scrollView.setContentOffset(.zero, animated: false)
    }

    @objc private func optionTapped(_ sender: UIButton) {
        guard !hasAnswered else { return }
        hasAnswered = true
        optionsStack.isUserInteractionEnabled = false

        let prepared = questions[index]
        let chosen = sender.tag
        let isCorrect = (chosen == prepared.correctIndex)
        correctness.append(isCorrect)

        // Richtige Antwort grün, falsche rot, Rest abblenden
        for (i, button) in optionButtons.enumerated() {
            if i == prepared.correctIndex {
                style(button, .correct)
            } else if i == chosen {
                style(button, .wrong)
            } else {
                style(button, .dimmed)
            }
        }

        // Feedback anzeigen und Weiter-Button einblenden
        feedbackTitle.text = isCorrect ? "Richtig" : "Nicht richtig"
        feedbackTitle.textColor = isCorrect ? .systemGreen : .systemRed
        feedbackText.text = prepared.question.explanation
        feedbackCard.isHidden = false

        let isLast = (index == questions.count - 1)
        nextButton.configuration?.title = isLast ? "Ergebnis ansehen" : "Weiter"
        nextButton.isHidden = false
    }

    @objc private func nextTapped() {
        if index < questions.count - 1 {
            index += 1
            showQuestion()
        } else {
            finish()
        }
    }

    private func finish() {
        // Ergebnis berechnen, speichern und Endscreen öffnen
        progress.setProgress(1, animated: true)
        let asked = questions.map { $0.question }
        let result = FragenSpeicher.makeResult(kind: kind, profile: profile, asked: asked, correctness: correctness)
        ResultStore.shared.add(result)
        navigationController?.pushViewController(ResultPageViewController(result: result), animated: true)
    }

    // MARK: - Farbzustände

    private enum OptionState { case correct, wrong, dimmed }

    private func style(_ button: UIButton, _ state: OptionState) {
        var config = button.configuration ?? optionBaseConfig(title: button.configuration?.title ?? "")
        switch state {
        case .correct:
            config.baseBackgroundColor = UIColor.systemGreen.withAlphaComponent(0.22)
            config.baseForegroundColor = .label
        case .wrong:
            config.baseBackgroundColor = UIColor.systemRed.withAlphaComponent(0.22)
            config.baseForegroundColor = .label
        case .dimmed:
            config.baseBackgroundColor = .secondarySystemGroupedBackground
            config.baseForegroundColor = .tertiaryLabel
        }
        button.configuration = config
    }
}
