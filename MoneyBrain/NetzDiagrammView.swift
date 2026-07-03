import UIKit

// Netzdiagramm -> mit Core Graphics gezeichnet
final class NetzDiagrammView: UIView {

    // Achsenbeschriftungen -> im Uhrzeigersinn ab oben
    var labels: [String] = [] { didSet { setNeedsDisplay() } }
    // Werte je Achse (0…1)
    var values: [Double] = [] { didSet { setNeedsDisplay() } }
    // Farbe von Datenfläche und Linie
    var dataColor: UIColor = .tintColor { didSet { setNeedsDisplay() } }
    // Optionale erforderliche Werte je Achse
    var requiredValues: [Double] = [] { didSet { setNeedsDisplay() } }
    // Farbe der gestrichelten Linie
    var requiredColor: UIColor = .label { didSet { setNeedsDisplay() } }
    // Anzahl der Gitterringe
    var rings: Int = 4 { didSet { setNeedsDisplay() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        let n = min(labels.count, values.count)
        // Erst ab drei Achsen zeichnen
        guard n >= 3 else { return }

        // Rand für die Beschriftungen freihalten
        let labelInset: CGFloat = 58
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(10, (min(rect.width, rect.height) - 2 * labelInset) / 2)

        // Winkel der Achse
        func angle(_ i: Int) -> CGFloat {
            -CGFloat.pi / 2 + 2 * .pi * CGFloat(i) / CGFloat(n)
        }
        func point(axis i: Int, fraction f: CGFloat) -> CGPoint {
            let a = angle(i)
            return CGPoint(x: center.x + cos(a) * radius * f,
                           y: center.y + sin(a) * radius * f)
        }

        // Gitter -> Die konzentrischen Vielecke
        UIColor.separator.setStroke()
        for r in 1...rings {
            let f = CGFloat(r) / CGFloat(rings)
            let path = UIBezierPath()
            for i in 0..<n {
                let p = point(axis: i, fraction: f)
                if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
            }
            path.close()
            path.lineWidth = 1
            path.stroke()
        }

        // Achsenlinien -> vom Zentrum nach außen
        for i in 0..<n {
            let path = UIBezierPath()
            path.move(to: center)
            path.addLine(to: point(axis: i, fraction: 1))
            path.lineWidth = 1
            path.stroke()
        }

        // Datenfläche
        let dataPath = UIBezierPath()
        for i in 0..<n {
            let f = CGFloat(min(max(values[i], 0), 1))
            let p = point(axis: i, fraction: f)
            if i == 0 { dataPath.move(to: p) } else { dataPath.addLine(to: p) }
        }
        dataPath.close()
        dataColor.withAlphaComponent(0.25).setFill()
        dataPath.fill()
        dataColor.setStroke()
        dataPath.lineWidth = 2
        dataPath.stroke()

        // Datenpunkte
        dataColor.setFill()
        for i in 0..<n {
            let f = CGFloat(min(max(values[i], 0), 1))
            let p = point(axis: i, fraction: f)
            UIBezierPath(arcCenter: p, radius: 3, startAngle: 0, endAngle: 2 * .pi, clockwise: true).fill()
        }

        // Anforderungs-Linie (gestrichelt) -> falls vorhanden
        if requiredValues.count == n {
            let reqPath = UIBezierPath()
            for i in 0..<n {
                let f = CGFloat(min(max(requiredValues[i], 0), 1))
                let p = point(axis: i, fraction: f)
                if i == 0 { reqPath.move(to: p) } else { reqPath.addLine(to: p) }
            }
            reqPath.close()
            reqPath.lineWidth = 2
            reqPath.setLineDash([5, 4], count: 2, phase: 0)
            requiredColor.setStroke()
            reqPath.stroke()
        }

        // Achsenbeschriftungen
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
            .foregroundColor: UIColor.secondaryLabel
        ]
        for i in 0..<n {
            let a = angle(i)
            let anchor = CGPoint(x: center.x + cos(a) * (radius + 16),
                                 y: center.y + sin(a) * (radius + 16))
            let text = labels[i] as NSString
            let size = text.size(withAttributes: attrs)
            // Horizontale Ausrichtung -> je nach Lage zur Mitte
            var x = anchor.x - size.width / 2
            if cos(a) > 0.3 { x = anchor.x }
            else if cos(a) < -0.3 { x = anchor.x - size.width }
            let y = anchor.y - size.height / 2
            text.draw(in: CGRect(x: x, y: y, width: size.width, height: size.height), withAttributes: attrs)
        }
    }
}
