import UIKit

// Startbildschirm -> erklärt den Test und bietet die zwei Testvarianten an
final class HomeViewController: UIViewController {

    private let standardCard = TestCardView(kind: .standard)
    private let kurzCard = TestCardView(kind: .kurz)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Money Brain"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupUI()

        // Karten mit ihren Aktionen verbinden
        standardCard.addAction(UIAction { [weak self] _ in self?.start(.standard) }, for: .touchUpInside)
        kurzCard.addAction(UIAction { [weak self] _ in self?.start(.kurz) }, for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Letztes Ergebnis nach einem Test refreshen
        standardCard.refreshLastResult()
        kurzCard.refreshLastResult()
    }

    private func setupUI() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)

        // Untertitel und Hinweis
        let subtitle = UILabel()
        subtitle.text = "Teste dein Finanzwissen und finde heraus, wie fit du für den Kapitalmarkt bist."
        subtitle.font = .preferredFont(forTextStyle: .body)
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0

        let chooseLabel = UILabel()
        chooseLabel.text = "Wähle deinen Test"
        chooseLabel.font = .preferredFont(forTextStyle: .headline)

        let disclaimer = UILabel()
        disclaimer.text = "Hinweis: Dieser Test dient ausschließlich der Selbsteinschätzung und ist keine Anlageberatung."
        disclaimer.font = .preferredFont(forTextStyle: .footnote)
        disclaimer.textColor = .tertiaryLabel
        disclaimer.numberOfLines = 0

        // Alles in einen scrollbaren Stack
        let stack = UIStackView(arrangedSubviews: [subtitle, makeInfoCard(), chooseLabel, standardCard, kurzCard, disclaimer])
        stack.axis = .vertical
        stack.spacing = 16
        stack.setCustomSpacing(26, after: stack.arrangedSubviews[1]) // nach der Info-Karte
        stack.setCustomSpacing(10, after: chooseLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    // Info-Karte mit der Erklärung des Tests
    private func makeInfoCard() -> UIView {
        let card = CardBackground()

        let heading = UILabel()
        heading.text = "Worum geht es?"
        heading.font = .preferredFont(forTextStyle: .headline)

        let body = UILabel()
        body.text = "Nach einer kurzen Selbsteinschätzung beantwortest du Multiple-Choice-Fragen zu ETFs, Aktien, Krypto, Zinsen, Altersvorsorge und anderen Grundlagen der Finanzwelt.\n\nAm Ende erhältst du eine Gesamtpunktzahl und ein Diagramm deiner Stärken.\n\nSo erfährst du, wie gut du auf das Investieren im Kapitalmarkt vorbereitet bist."
        body.font = .preferredFont(forTextStyle: .subheadline)
        body.textColor = .secondaryLabel
        body.numberOfLines = 0

        let inner = UIStackView(arrangedSubviews: [heading, body])
        inner.axis = .vertical
        inner.spacing = 8
        inner.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(inner)

        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            inner.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        return card
    }

    private func start(_ kind: TestKind) {
        navigationController?.pushViewController(ProfileSelectViewController(kind: kind), animated: true)
    }
}
