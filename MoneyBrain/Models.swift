import Foundation

// Wissensgebiete der Fragen
// Die Reihenfolge hier legt auch die im Diagramm fest
enum Category: String, Codable, CaseIterable {
    case etf, aktien, krypto, zinsen, grundlagen, vorsorge

    // Anzeigename
    var title: String {
        switch self {
        case .etf:        return "ETFs"
        case .aktien:     return "Aktien"
        case .krypto:     return "Krypto"
        case .zinsen:     return "Zinsen & Geldpolitik"
        case .grundlagen: return "Grundlagen & Risiko"
        case .vorsorge:   return "Altersvorsorge"
        }
    }

    // name für die Achsen im Diagramm
    var shortTitle: String {
        switch self {
        case .etf:        return "ETFs"
        case .aktien:     return "Aktien"
        case .krypto:     return "Krypto"
        case .zinsen:     return "Zinsen"
        case .grundlagen: return "Grundlagen"
        case .vorsorge:   return "Vorsorge"
        }
    }

    // Symbole für Karten und Chips
    var symbolName: String {
        switch self {
        case .etf:        return "chart.pie.fill"
        case .aktien:     return "chart.line.uptrend.xyaxis"
        case .krypto:     return "bitcoinsign.circle.fill"
        case .zinsen:     return "percent"
        case .grundlagen: return "shield.lefthalf.filled"
        case .vorsorge:   return "hourglass"
        }
    }
}

// Eine Multiple-Choice-Frage mit einer richtigen Antwort
struct Question {
    let category: Category
    let prompt: String
    let options: [String]
    let correctIndex: Int
    // Gewichtung: 3 = essenziell, 2 = wichtig, 1 = generisch
    let weight: Int
    // Erklärung nach dem Antworten als Feedback
    let explanation: String
    // true, wenn die Frage auch im Kurz-Test vorkommt
    let inShort: Bool
}

// Testvariante -> wird auf dem Homescreen gewählt
enum TestKind: String, Codable {
    case standard
    case kurz

    var title: String {
        switch self {
        case .standard: return "Standard-Test"
        case .kurz:     return "Kurz-Test"
        }
    }

    var blurb: String {
        switch self {
        case .standard: return "Alle Themen ausführlich – rund 30 Fragen."
        case .kurz:     return "Die wichtigsten Basics – 15 Fragen."
        }
    }

    var symbolName: String {
        switch self {
        case .standard: return "list.bullet.rectangle.portrait"
        case .kurz:     return "bolt.fill"
        }
    }
}

// Frage für einen Durchlauf
// Antworten mischen
// correctIndex zeigt auf die richtige Position
struct PreparedQuestion {
    let question: Question
    let options: [String]
    let correctIndex: Int
}

// Punktzahl in einem Wissensgebiet
// Datengrundlage fürs Diagramm
struct CategoryScore: Codable {
    let category: Category
    let earned: Int      // erreichte Punkte
    let possible: Int    // maximal mögliche punkte

    // Anteil 0 bis 1
    var fraction: Double {
        possible > 0 ? Double(earned) / Double(possible) : 0
    }
    var percent: Int { Int((fraction * 100).rounded()) }
}

// Anlegertyp -> wird zu Beginn per Schieberegler gewählt
enum InvestorProfile: Int, Codable, CaseIterable {
    case conservative, growth, risk

    var letter: String {
        switch self {
        case .conservative: return "A"
        case .growth:       return "B"
        case .risk:         return "C"
        }
    }

    var title: String {
        switch self {
        case .conservative: return "Konservativer Anleger"
        case .growth:       return "Wachstumsorientierter Anleger"
        case .risk:         return "Risikoorientierter Anleger"
        }
    }

    // Stichpunkte
    var summary: String {
        switch self {
        case .conservative: return "• sicherheitsorientiert\n• geringe Renditeziele\n• langer Anlagehorizont"
        case .growth:       return "• mittlere Risikobereitschaft\n• Rendite & Sicherheit\n• mittlerer Anlagehorizont"
        case .risk:         return "• hohe Risikobereitschaft\n• kurzfristige Investments, hohe Renditeziele\n• kurzer Anlagehorizont"
        }
    }

    // Erwartetes Mindestwissen je Gebiet (0 bis 1)
    func requiredLevel(for category: Category) -> Double {
        let table: [Category: [Double]] = [
            .etf:        [0.5, 0.6, 0.6],
            .aktien:     [0.3, 0.6, 0.8],
            .krypto:     [0.2, 0.4, 0.8],
            .zinsen:     [0.6, 0.6, 0.6],
            .grundlagen: [0.6, 0.7, 0.8],
            .vorsorge:   [0.7, 0.5, 0.4]
        ]
        return table[category]?[rawValue] ?? 0.5
    }
}

// Gesamtergebnis eines Tests
struct QuizResult: Codable {
    let id: UUID
    let kind: TestKind
    let profile: InvestorProfile
    let date: Date
    let totalScore: Int
    let correctCount: Int
    let totalCount: Int
    let categoryScores: [CategoryScore]

    // Bewertung anhand der Gesamtpunktzahl
    var rating: String {
        switch totalScore {
        case 90...100: return "Sehr gut"
        case 75..<90:  return "Gut"
        case 60..<75:  return "Befriedigend"
        case 45..<60:  return "Ausreichend"
        default:       return "Ausbaufähig"
        }
    }

    // Erforderliche Wissensschwelle des Profils je Gebiet
    func requiredLevel(for category: Category) -> Double {
        profile.requiredLevel(for: category)
    }

    // Gebiete unter dem erforderlichen Niveau -> größte Lücke zuerst
    var requirementGaps: [Category] {
        categoryScores
            .filter { $0.fraction < profile.requiredLevel(for: $0.category) - 0.05 }
            .sorted { profile.requiredLevel(for: $0.category) - $0.fraction
                    > profile.requiredLevel(for: $1.category) - $1.fraction }
            .map { $0.category }
    }

    // Ist das Wissen für das Profil angemessen?
    var isAppropriate: Bool { requirementGaps.isEmpty }

    // Einschätzung nach Punktzahl
    var suitability: String {
        let base: String
        switch totalScore {
        case 90...100: base = "Du verfügst über ein sehr solides Finanzwissen und bist gut für den Einstieg in den Kapitalmarkt gerüstet."
        case 75..<90:  base = "Dein Grundwissen ist gut. Für den Einstieg reicht es in den meisten Bereichen."
        case 60..<75:  base = "Du kennst viele Grundlagen, hast aber noch spürbare Wissenslücken."
        case 45..<60:  base = "Erste Grundlagen sind vorhanden, für einen sicheren Einstieg solltest du aber noch üben."
        default:       base = "Dein Finanzwissen ist noch ausbaufähig. Bevor du investierst, lohnt es sich, die Grundlagen zu lernen."
        }
        let pointer = isAppropriate
            ? "Sieh dir deine Stärken auf dem Diagramm an."
            : "Sieh dir auf dem Diagramm an, in welchen Wissensgebieten du noch Nachholbedarf hast."
        return base + " " + pointer
    }
}
