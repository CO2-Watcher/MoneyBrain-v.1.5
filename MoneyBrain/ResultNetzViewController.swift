import UIKit

// Seite 2 des Endscreens -> Das Diagramm mit Vergleich Ist/Soll-Niveaus
final class ResultNetzViewController: UIViewController {

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
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)

        let heading = UILabel()
        heading.text = "Wissen nach Gebiet"
        heading.font = .preferredFont(forTextStyle: .title2)
        heading.adjustsFontForContentSizeCategory = true

        // Diagramm mit eigenen und erforderlichen Werten füllen
        let netz = NetzDiagrammView()
        netz.labels = result.categoryScores.map { $0.category.shortTitle }
        netz.values = result.categoryScores.map { $0.fraction }
        netz.dataColor = .tintColor
        netz.requiredValues = result.categoryScores.map { result.requiredLevel(for: $0.category) }
        netz.requiredColor = result.profile.color
        netz.translatesAutoresizingMaskIntoConstraints = false
        netz.heightAnchor.constraint(equalToConstant: 320).isActive = true

        // Legende mit Prozentwerten je Gebiet
        let legendCard = CardBackground()
        let legendStack = UIStackView()
        legendStack.axis = .vertical
        legendStack.spacing = 10
        legendStack.translatesAutoresizingMaskIntoConstraints = false
        for score in result.categoryScores {
            legendStack.addArrangedSubview(legendRow(for: score))
        }
        legendCard.addSubview(legendStack)
        NSLayoutConstraint.activate([
            legendStack.topAnchor.constraint(equalTo: legendCard.topAnchor, constant: 16),
            legendStack.leadingAnchor.constraint(equalTo: legendCard.leadingAnchor, constant: 16),
            legendStack.trailingAnchor.constraint(equalTo: legendCard.trailingAnchor, constant: -16),
            legendStack.bottomAnchor.constraint(equalTo: legendCard.bottomAnchor, constant: -16)
        ])

        // Legende zur Überlagerung
        let note = UILabel()
        note.font = .preferredFont(forTextStyle: .footnote)
        note.textColor = .secondaryLabel
        note.numberOfLines = 0
        note.textAlignment = .center
        note.text = "Ausgefüllt: dein Wissen · Gestrichelt: erforderlich für Profil \(result.profile.letter) (\(result.profile.title))"

        let stack = UIStackView(arrangedSubviews: [heading, netz, legendCard, note])
        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    // Eine Legendenzeile: Symbol, Gebiet, Prozent
    private func legendRow(for score: CategoryScore) -> UIView {
        let icon = UIImageView(image: UIImage(systemName: score.category.symbolName))
        icon.tintColor = .tintColor
        icon.contentMode = .scaleAspectFit
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true

        let name = UILabel()
        name.text = score.category.title
        name.font = .preferredFont(forTextStyle: .body)

        // Prozent wird rot, wenn das Wissen unter dem Erforderlichen liegt
        let required = result.requiredLevel(for: score.category)
        let belowRequirement = score.fraction < required - 0.05
        let percent = UILabel()
        percent.text = "\(score.percent) %"
        percent.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize, weight: .semibold)
        percent.textColor = belowRequirement ? .systemRed : (score.possible > 0 ? .label : .tertiaryLabel)
        percent.setContentHuggingPriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [icon, name, percent])
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .center
        return row
    }
}
