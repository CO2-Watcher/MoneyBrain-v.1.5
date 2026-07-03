import UIKit

// Seite 1 des Endscreens -> Punktzahl, Bewertung und Einschätzung
final class ResultSummaryViewController: UIViewController {

    private let result: QuizResult

    init(result: QuizResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupUI()
    }

    // MARK: - Aufbau

    private func setupUI() {
        let caption = UILabel()
        caption.text = "Deine Punktzahl"
        caption.font = .preferredFont(forTextStyle: .subheadline)
        caption.textColor = .secondaryLabel
        caption.textAlignment = .center

        // Große Punktzahl
        let scoreLabel = UILabel()
        scoreLabel.attributedText = scoreText()
        scoreLabel.textAlignment = .center

        // Bewertung und Trefferquote
        let ratingLabel = UILabel()
        ratingLabel.text = result.rating
        ratingLabel.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold)
        ratingLabel.textColor = .tintColor
        ratingLabel.textAlignment = .center

        let detailLabel = UILabel()
        detailLabel.text = "\(result.correctCount) von \(result.totalCount) Fragen richtig"
        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .secondaryLabel
        detailLabel.textAlignment = .center

        // Gewähltes Anlegerprofil
        let profileLabel = UILabel()
        profileLabel.text = "Profil: \(result.profile.letter) · \(result.profile.title)"
        profileLabel.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize, weight: .semibold)
        profileLabel.textColor = result.profile.color
        profileLabel.textAlignment = .center
        profileLabel.numberOfLines = 0

        // Eignungs-Einschätzung
        let card = CardBackground()
        let cardHeading = UILabel()
        cardHeading.text = "Bist du bereit für den Kapitalmarkt?"
        cardHeading.font = .preferredFont(forTextStyle: .headline)
        cardHeading.numberOfLines = 0
        let cardBody = UILabel()
        cardBody.text = result.suitability
        cardBody.font = .preferredFont(forTextStyle: .body)
        cardBody.textColor = .secondaryLabel
        cardBody.numberOfLines = 0
        let cardStack = UIStackView(arrangedSubviews: [cardHeading, cardBody])
        cardStack.axis = .vertical
        cardStack.spacing = 8
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(cardStack)
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            cardStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            cardStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            cardStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])

        let hint = UILabel()
        hint.text = "Wische nach links für dein Diagramm →"
        hint.font = .preferredFont(forTextStyle: .footnote)
        hint.textColor = .tertiaryLabel
        hint.textAlignment = .center

        // Alles vertikal anordnen
        let stack = UIStackView(arrangedSubviews: [caption, scoreLabel, ratingLabel, detailLabel, profileLabel, card, hint])
        stack.axis = .vertical
        stack.spacing = 10
        stack.setCustomSpacing(2, after: caption)
        stack.setCustomSpacing(4, after: scoreLabel)
        stack.setCustomSpacing(6, after: detailLabel)
        stack.setCustomSpacing(24, after: profileLabel)
        stack.setCustomSpacing(16, after: card)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    // Setzt die große Punktzahl und das kleinere /100 zusammen
    private func scoreText() -> NSAttributedString {
        let big: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 80, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        let small: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 28, weight: .semibold),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let text = NSMutableAttributedString(string: "\(result.totalScore)", attributes: big)
        text.append(NSAttributedString(string: " / 100", attributes: small))
        return text
    }
}
