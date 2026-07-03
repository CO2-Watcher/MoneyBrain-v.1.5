import Foundation

// Fester Fragenpool des Tests
// Grundlagen sind höher gewichtet als Detailfragen
// Jeder Durchlauf nutzt dieselben Fragen aber neu gemischt
enum FragenSpeicher {

    static let all: [Question] = [

        // MARK: - ETFs
        Question(category: .etf,
                 prompt: "Was ist ein ETF?",
                 options: [
                    "Ein aktiv gemanagter Fonds mit hohen Gebühren",
                    "Ein börsengehandelter Fonds, der meist passiv einen Index nachbildet",
                    "Eine einzelne Aktie eines Technologieunternehmens",
                    "Ein fest verzinstes Sparkonto bei der Bank"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "ETF steht für „Exchange Traded Fund” – ein an der Börse gehandelter Fonds, der meist passiv einen Index (z. B. MSCI World) nachbildet.",
                 inShort: true),
        Question(category: .etf,
                 prompt: "Worin liegt der Hauptvorteil eines ETFs gegenüber einer einzelnen Aktie?",
                 options: [
                    "Eine garantierte Rendite",
                    "Breite Streuung über viele Unternehmen",
                    "Es gibt keine Kursschwankungen",
                    "Erträge sind grundsätzlich steuerfrei"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Ein ETF bündelt viele Werte – das Risiko wird automatisch über viele Unternehmen gestreut (Diversifikation).",
                 inShort: true),
        Question(category: .etf,
                 prompt: "Was beschreibt die TER eines ETFs?",
                 options: [
                    "Die jährliche Gesamtkostenquote",
                    "Die garantierte Rendite",
                    "Den Ausgabeaufschlag beim Kauf",
                    "Die Anzahl der enthaltenen Aktien"
                 ],
                 correctIndex: 0, weight: 2,
                 explanation: "TER = Total Expense Ratio, die laufende jährliche Kostenquote eines Fonds.",
                 inShort: false),
        Question(category: .etf,
                 prompt: "Was unterscheidet einen thesaurierenden von einem ausschüttenden ETF?",
                 options: [
                    "Thesaurierend zahlt Erträge aus, ausschüttend legt sie wieder an",
                    "Thesaurierend legt Erträge automatisch wieder an, ausschüttend zahlt sie aus",
                    "Es gibt keinen Unterschied",
                    "Ausschüttende ETFs sind immer steuerfrei"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Thesaurierende ETFs reinvestieren Erträge automatisch; ausschüttende zahlen sie auf das Verrechnungskonto aus.",
                 inShort: false),
        Question(category: .etf,
                 prompt: "Was bildet ein „MSCI World”-ETF im Wesentlichen ab?",
                 options: [
                    "Nur deutsche Unternehmen",
                    "Rund 1.500 große Unternehmen aus Industrieländern weltweit",
                    "Ausschließlich Schwellenländer",
                    "Staatsanleihen aus aller Welt"
                 ],
                 correctIndex: 1, weight: 1,
                 explanation: "Der MSCI World enthält ca. 1.500 große und mittelgroße Unternehmen aus Industrieländern – Schwellenländer sind nicht enthalten.",
                 inShort: false),

        // MARK: - Aktien
        Question(category: .aktien,
                 prompt: "Was ist eine Aktie?",
                 options: [
                    "Ein Kredit, den man einem Unternehmen gibt",
                    "Ein Anteil am Eigenkapital eines Unternehmens",
                    "Eine staatliche Anleihe",
                    "Ein fester Sparvertrag"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Eine Aktie verbrieft einen Anteil am Eigenkapital einer Aktiengesellschaft – man wird Miteigentümer.",
                 inShort: true),
        Question(category: .aktien,
                 prompt: "Was ist eine Dividende?",
                 options: [
                    "Eine Strafgebühr beim Verkauf",
                    "Ein Anteil am Gewinn, der an die Aktionäre ausgeschüttet wird",
                    "Der aktuelle Kurs der Aktie",
                    "Eine Sondersteuer auf Aktien"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Die Dividende ist die Gewinnbeteiligung, die ein Unternehmen an seine Aktionäre auszahlt.",
                 inShort: true),
        Question(category: .aktien,
                 prompt: "Was sagt das Kurs-Gewinn-Verhältnis (KGV) aus?",
                 options: [
                    "Wie teuer eine Aktie im Verhältnis zum Gewinn ist",
                    "Wie hoch die Dividende ausfällt",
                    "Wie hoch das Handelsvolumen ist",
                    "Wie hoch die Schulden des Unternehmens sind"
                 ],
                 correctIndex: 0, weight: 2,
                 explanation: "Das KGV setzt den Kurs ins Verhältnis zum Gewinn je Aktie – ein grober Maßstab für die Bewertung.",
                 inShort: false),
        Question(category: .aktien,
                 prompt: "Was bedeutet „Marktkapitalisierung” eines Unternehmens?",
                 options: [
                    "Der Gesamtwert aller Aktien des Unternehmens",
                    "Der Gewinn eines einzelnen Tages",
                    "Die Dividendenrendite",
                    "Der Buchwert des Anlagevermögens"
                 ],
                 correctIndex: 0, weight: 2,
                 explanation: "Marktkapitalisierung = Aktienkurs × Anzahl der Aktien; also der Börsenwert des Unternehmens.",
                 inShort: false),
        Question(category: .aktien,
                 prompt: "Was versteht man unter einem „Blue Chip”?",
                 options: [
                    "Eine hochspekulative Pennystock-Aktie",
                    "Die Aktie eines großen, etablierten Unternehmens",
                    "Eine Kryptowährung",
                    "Einen Börsenindex"
                 ],
                 correctIndex: 1, weight: 1,
                 explanation: "Als Blue Chips bezeichnet man Aktien großer, etablierter und umsatzstarker Unternehmen.",
                 inShort: false),

        // MARK: - Krypto
        Question(category: .krypto,
                 prompt: "Was ist eine Blockchain?",
                 options: [
                    "Eine zentrale Datenbank einer einzelnen Bank",
                    "Ein dezentrales, verteiltes und schwer manipulierbares Netzwerk",
                    "Ein klassischer Aktienindex",
                    "Eine staatlich herausgegebene Währung"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Eine Blockchain ist ein dezentral geführtes, fortlaufend verkettetes Register von Transaktionen ohne zentrale Instanz.",
                 inShort: true),
        Question(category: .krypto,
                 prompt: "Wodurch ist die Geldmenge von Bitcoin begrenzt?",
                 options: [
                    "Durch eine Vorgabe der EZB",
                    "Auf maximal 21 Millionen Coins",
                    "Sie ist unbegrenzt",
                    "Durch den jeweiligen Goldpreis"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Das Bitcoin-Protokoll begrenzt die Gesamtmenge fest auf 21 Millionen Coins, das macht Bitcoin künstlich knapp.",
                 inShort: true),
        Question(category: .krypto,
                 prompt: "Was ist eine „Wallet” im Kryptobereich?",
                 options: [
                    "Eine Kryptobörse",
                    "Eine digitale Geldbörse zur Verwahrung der Schlüssel",
                    "Ein Kredit in Kryptowährung",
                    "Eine Steuer auf Kryptogewinne"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Eine Wallet verwaltet die privaten und öffentlichen Schlüssel, mit denen man über sein Kryptoguthaben verfügt.",
                 inShort: false),
        Question(category: .krypto,
                 prompt: "Welche Aussage zu Kryptowährungen trifft zu?",
                 options: [
                    "Sie sind staatlich garantiert",
                    "Sie unterliegen oft sehr hohen Kursschwankungen",
                    "Sie sind durch die Einlagensicherung geschützt",
                    "Ihr Kurs ist fest an den Euro gekoppelt"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Kryptowährungen sind meist sehr volatil und nicht durch die Einlagensicherung geschützt. Nur Stablecoins koppeln gezielt an eine Währung",
                 inShort: false),

        // MARK: - Zinsen & Geldpolitik
        Question(category: .zinsen,
                 prompt: "Du legst 100 € zu 2 % Zinsen pro Jahr an. Wie viel hast du nach 5 Jahren mit Zinseszins ungefähr?",
                 options: [
                    "Genau 110 €",
                    "Etwas mehr als 110 €",
                    "Weniger als 102 €",
                    "Rund 200 €"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Mit Zinseszins: 100 € × 1,02⁵ ≈ 110,40 €, also etwas mehr als die 110 € ohne Zinseszins.",
                 inShort: true),
        Question(category: .zinsen,
                 prompt: "Dein Konto bringt 1 % Zinsen pro Jahr, die Inflation liegt bei 2 %. Was kannst du nach einem Jahr kaufen?",
                 options: [
                    "Mehr als heute",
                    "Weniger als heute",
                    "Genau gleich viel",
                    "Doppelt so viel"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Liegt die Inflation über dem Zinssatz, sinkt die Kaufkraft und du kannst dir real weniger leisten",
                 inShort: true),
        Question(category: .zinsen,
                 prompt: "Was ist der Leitzins?",
                 options: [
                    "Der Zins, zu dem die Zentralbank den Geschäftsbanken Geld leiht",
                    "Der Zins für private Konsumkredite",
                    "Die Dividende der Zentralbank",
                    "Ein anderes Wort für die Inflationsrate"
                 ],
                 correctIndex: 0, weight: 3,
                 explanation: "Der Leitzins ist der von der Zentralbank (z. B. EZB) festgelegte Zinssatz, ein zentrales Werkzeug, um die Geldmenge zu steuern.",
                 inShort: false),
        Question(category: .zinsen,
                 prompt: "Was passiert tendenziell, wenn die Zentralbank den Leitzins erhöht?",
                 options: [
                    "Kredite werden teurer, Sparen wird attraktiver",
                    "Kredite werden günstiger",
                    "Die Inflation steigt zwangsläufig",
                    "Aktien steigen garantiert"
                 ],
                 correctIndex: 0, weight: 2,
                 explanation: "Höhere Leitzinsen verteuern Kredite und sollen die Inflation dämpfen; Sparen wird relativ attraktiver.",
                 inShort: false),
        Question(category: .zinsen,
                 prompt: "Welche Institution legt den Leitzins im Euroraum fest?",
                 options: [
                    "Die Bundesregierung",
                    "Die Europäische Zentralbank (EZB)",
                    "Die Deutsche Börse",
                    "Der Internationale Währungsfonds (IWF)"
                 ],
                 correctIndex: 1, weight: 1,
                 explanation: "Im Euroraum ist die Europäische Zentralbank (EZB) für die Geldpolitik und damit für den Leitzins zuständig.",
                 inShort: false),

        // MARK: - Grundlagen & Risiko (inkl. Anleihen)
        Question(category: .grundlagen,
                 prompt: "Was bedeutet Diversifikation bei der Geldanlage?",
                 options: [
                    "Das gesamte Kapital in eine einzelne Aktie stecken",
                    "Das Kapital auf viele verschiedene Anlagen verteilen",
                    "Ausschließlich in Gold investieren",
                    "So oft wie möglich handeln"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Diversifikation verteilt das Kapital über viele Werte/Anlageklassen und senkt so das Risiko",
                 inShort: true),
        Question(category: .grundlagen,
                 prompt: "Welche Aussage ist richtig?",
                 options: [
                    "Eine einzelne Aktie ist meist sicherer als ein breit gestreuter Fonds",
                    "Ein breit gestreuter Fonds ist meist weniger riskant als eine einzelne Aktie",
                    "Beide sind exakt gleich riskant",
                    "Fonds haben überhaupt kein Risiko"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Ein breit gestreuter Fonds verteilt das Risiko über viele Werte – eine einzelne Aktie ist dagegen riskanter",
                 inShort: true),
        Question(category: .grundlagen,
                 prompt: "Welcher Zusammenhang gilt bei der Geldanlage grundsätzlich?",
                 options: [
                    "Höhere Renditechancen gehen meist mit höherem Risiko einher",
                    "Hohe Rendite ist immer risikolos",
                    "Risiko und Rendite hängen nicht zusammen",
                    "Niedriges Risiko bringt immer hohe Rendite"
                 ],
                 correctIndex: 0, weight: 3,
                 explanation: "Das Rendite-Risiko-Prinzip: Wer höhere Renditen anstrebt, muss in der Regel auch ein höheres Risiko akzeptieren.",
                 inShort: true),
        Question(category: .grundlagen,
                 prompt: "Was beschreibt der Cost-Average-Effekt bei einem Sparplan?",
                 options: [
                    "Man kauft immer genau zum Höchstkurs",
                    "Durch regelmäßiges Investieren kauft man mal teurer, mal günstiger ein",
                    "Die Gebühren sinken automatisch auf null",
                    "Die Rendite ist dadurch garantiert"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Bei festen Sparraten erhält man mal mehr, mal weniger Anteile – das glättet den Einstiegszeitpunkt über die Zeit.",
                 inShort: false),
        Question(category: .grundlagen,
                 prompt: "Was ist eine Anleihe (Bond)?",
                 options: [
                    "Ein Eigenkapitalanteil an einem Unternehmen",
                    "Ein verzinstes Darlehen an einen Staat oder ein Unternehmen",
                    "Eine Kryptowährung",
                    "Ein ETF auf Rohstoffe"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Mit einer Anleihe leiht man dem Emittenten (Staat oder Unternehmen) Geld und erhält dafür Zinsen (den Kupon).",
                 inShort: false),
        Question(category: .grundlagen,
                 prompt: "Was ist ein „Notgroschen” in der Finanzplanung?",
                 options: [
                    "Geld, das man komplett in Aktien anlegt",
                    "Eine schnell verfügbare Reserve für Notfälle",
                    "Ein spekulativer Einsatz in Krypto",
                    "Ein langfristiger Immobilienkredit"
                 ],
                 correctIndex: 1, weight: 1,
                 explanation: "Der Notgroschen ist eine liquide Reserve (oft 3–6 Monatsausgaben) für Unvorhergesehenes. Idealerweise vorhanden, bevor man investiert.",
                 inShort: false),

        // MARK: - Steuern & Recht (zählt mit zu Grundlagen & Risiko)
        Question(category: .grundlagen,
                 prompt: "Wie heißt die Steuer auf Kapitalerträge (z. B. Kursgewinne, Dividenden) in Deutschland?",
                 options: [
                    "Mehrwertsteuer",
                    "Abgeltungssteuer",
                    "Gewerbesteuer",
                    "Grundsteuer"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Kapitalerträge werden in Deutschland mit der Abgeltungssteuer (25 % zzgl. Solidaritätszuschlag, ggf. Kirchensteuer) belastet.",
                 inShort: true),
        Question(category: .grundlagen,
                 prompt: "Was ist der Sparer-Pauschbetrag?",
                 options: [
                    "Ein jährlich steuerfreier Betrag für Kapitalerträge",
                    "Eine Gebühr des Brokers",
                    "Eine vorgeschriebene Mindesteinlage",
                    "Ein staatlicher Bonus auf jede Sparrate"
                 ],
                 correctIndex: 0, weight: 2,
                 explanation: "Bis zum Sparer-Pauschbetrag (1.000 € pro Person) bleiben Kapitalerträge steuerfrei, geregelt über einen Freistellungsauftrag.",
                 inShort: true),
        Question(category: .grundlagen,
                 prompt: "Was schützt die gesetzliche Einlagensicherung in der EU?",
                 options: [
                    "Aktienkurse vor Verlusten",
                    "Bankguthaben bis 100.000 € pro Kunde und Bank",
                    "Krypto-Wallets",
                    "Jegliche Anlageverluste"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Die EU-Einlagensicherung schützt Bankeinlagen bis 100.000 € je Kunde und Institut, nicht jedoch Kursverluste von Wertpapieren.",
                 inShort: false),

        // MARK: - Altersvorsorge
        Question(category: .vorsorge,
                 prompt: "Warum ist es bei der Altersvorsorge so wichtig, früh anzufangen?",
                 options: [
                    "Weil junge Menschen mehr Steuern zahlen",
                    "Wegen des Zinseszinseffekts über lange Zeiträume",
                    "Weil Aktien nur für Junge erlaubt sind",
                    "Weil die Rente garantiert sinkt"
                 ],
                 correctIndex: 1, weight: 3,
                 explanation: "Je länger der Anlagehorizont, desto stärker wirkt der Zinseszins – früh angelegtes Geld wächst überproportional.",
                 inShort: true),
        Question(category: .vorsorge,
                 prompt: "Was ist typisch für einen ETF-Sparplan zur Altersvorsorge?",
                 options: [
                    "Kurzfristiges Trading mit hohem Risiko",
                    "Regelmäßiges, langfristiges Investieren in breit gestreute ETFs",
                    "Eine garantierte feste Verzinsung",
                    "Eine einmalige Spekulation auf einen Kurs"
                 ],
                 correctIndex: 1, weight: 2,
                 explanation: "Zur Altersvorsorge eignet sich regelmäßiges, langfristiges Investieren in breit gestreute ETFs, Schwankungen werden über die Zeit ausgesessen.",
                 inShort: true),
        Question(category: .vorsorge,
                 prompt: "Auf welchen drei Säulen ruht die Altersvorsorge in Deutschland klassischerweise?",
                 options: [
                    "Gesetzliche, betriebliche und private Vorsorge",
                    "Aktien, Krypto und Gold",
                    "Bank, Versicherung und Staat",
                    "Tagesgeld, Festgeld und Girokonto"
                 ],
                 correctIndex: 0, weight: 1,
                 explanation: "Das deutsche System kennt drei Säulen: die gesetzliche Rente, die betriebliche Altersvorsorge und die private Vorsorge.",
                 inShort: false)
    ]

    // Fragen der gewählten Variante, pro Durchlauf neu mischen
    static func questions(for kind: TestKind) -> [Question] {
        let pool = (kind == .kurz) ? all.filter { $0.inShort } : all
        return pool.shuffled()
    }

    // Mischt Reihenfolge und Antwortoptionen ->  correctIndex wird neu berechnet
    static func prepared(for kind: TestKind) -> [PreparedQuestion] {
        questions(for: kind).map { q in
            // Optionen mit ursprünglichem Index mischen -> richtige Position neu finden
            let shuffled = Array(q.options.enumerated()).shuffled()
            let options = shuffled.map { $0.element }
            let correct = shuffled.firstIndex { $0.offset == q.correctIndex } ?? 0
            return PreparedQuestion(question: q, options: options, correctIndex: correct)
        }
    }

    // Wertet die Antworten aus
    static func makeResult(kind: TestKind,
                           profile: InvestorProfile,
                           asked: [Question],
                           correctness: [Bool]) -> QuizResult {
        var earned: [Category: Int] = [:]
        var possible: [Category: Int] = [:]
        var correctCount = 0

        // Erreichte und mögliche Punkte pro Gebiet summieren
        for (q, isCorrect) in zip(asked, correctness) {
            possible[q.category, default: 0] += q.weight
            if isCorrect {
                earned[q.category, default: 0] += q.weight
                correctCount += 1
            }
        }

        // Gesamtpunktzahl auf 0 bis 100 transferieren
        let totalEarned = earned.values.reduce(0, +)
        let totalPossible = possible.values.reduce(0, +)
        let score = totalPossible > 0
            ? Int((Double(totalEarned) / Double(totalPossible) * 100).rounded())
            : 0

        // Alle Kategorien zurückgeben -> damit jede als Achse im Diagramm erscheint
        let scores = Category.allCases.map { c in
            CategoryScore(category: c, earned: earned[c] ?? 0, possible: possible[c] ?? 0)
        }

        return QuizResult(id: UUID(), kind: kind, profile: profile, date: Date(), totalScore: score,
                          correctCount: correctCount, totalCount: asked.count,
                          categoryScores: scores)
    }
}
