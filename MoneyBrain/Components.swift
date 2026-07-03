import UIKit

extension InvestorProfile {
    // Farbe je nach Profil: A grün, B orange, C rot
    var color: UIColor {
        switch self {
        case .conservative: return .systemGreen
        case .growth:       return .systemOrange
        case .risk:         return .systemRed
        }
    }
}

// Abgerundeter Karten-Hintergrund für Inhalte
final class CardBackground: UIView {
    override init(frame: CGRect) { super.init(frame: frame); setup() }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }
    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
    }
}

// UILabel mit Innenabstand
final class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10) {
        didSet { invalidateIntrinsicContentSize() }
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + insets.left + insets.right,
                      height: s.height + insets.top + insets.bottom)
    }
}

// Karte für die Testvariante auf dem Homescreen
final class TestCardView: UIControl {

    private let kind: TestKind
    private let lastLabel = UILabel()

    init(kind: TestKind) {
        self.kind = kind
        super.init(frame: .zero)
        setup()
        refreshLastResult()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous

        // Symbol, Texte und letztes Ergebnis
        let icon = UIImageView(image: UIImage(systemName: kind.symbolName))
        icon.tintColor = .tintColor
        icon.contentMode = .scaleAspectFit
        icon.preferredSymbolConfiguration = .init(pointSize: 26, weight: .semibold)
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let titleLabel = UILabel()
        titleLabel.text = kind.title
        titleLabel.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)

        let blurb = UILabel()
        blurb.text = kind.blurb
        blurb.font = .preferredFont(forTextStyle: .subheadline)
        blurb.textColor = .secondaryLabel
        blurb.numberOfLines = 0

        lastLabel.font = .preferredFont(forTextStyle: .footnote)
        lastLabel.textColor = .tertiaryLabel
        lastLabel.numberOfLines = 1

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .tertiaryLabel
        chevron.contentMode = .scaleAspectFit
        chevron.setContentHuggingPriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, blurb, lastLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        // Zeile zusammensetzen und einbetten
        let row = UIStackView(arrangedSubviews: [icon, textStack, chevron])
        row.axis = .horizontal
        row.spacing = 14
        row.alignment = .center
        row.isUserInteractionEnabled = false
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)

        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            icon.widthAnchor.constraint(equalToConstant: 34)
        ])
    }

    // Zeigt das zuletzt erreichte Ergebnis an
    func refreshLastResult() {
        if let result = ResultStore.shared.lastResult(for: kind) {
            lastLabel.text = "Letztes Ergebnis: \(result.totalScore)/100"
            lastLabel.isHidden = false
        } else {
            lastLabel.text = nil
            lastLabel.isHidden = true
        }
    }

    // Leichtes visuelles Feedback beim Antippen
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) { self.alpha = self.isHighlighted ? 0.6 : 1.0 }
        }
    }
}
