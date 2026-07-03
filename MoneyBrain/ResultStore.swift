import Foundation

// Speichert die Testergebnisse über UserDefaults -> neueste zuerst
final class ResultStore {

    static let shared = ResultStore()

    private let key = "MoneyBrain.results"
    private let defaults = UserDefaults.standard

    // Alle Ergebnisse -> nach Datum absteigend
    private(set) var results: [QuizResult] = []
    private init() { load() }
    // Fügt ein Ergebnis hinzu und speichert
    func add(_ result: QuizResult) {
        results.append(result)
        sortAndSave()
    }
    // Löscht das Ergebnis an der Position
    func delete(at index: Int) {
        guard results.indices.contains(index) else { return }
        results.remove(at: index)
        save()
    }
    // Neuestes Ergebnis einer Testvariante -> für den Homescreen
    func lastResult(for kind: TestKind) -> QuizResult? {
        results.first { $0.kind == kind }
    }
    // Löscht alle gespeicherten Ergebnisse (Einstellungen → Zurücksetzen)
    func clear() {
        results.removeAll()
        defaults.removeObject(forKey: key)
    }

    // MARK: - Persistenz
    private func sortAndSave() {
        results.sort { $0.date > $1.date }   // neueste oben
        save()
    }
    private func load() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([QuizResult].self, from: data) else { return }
        results = decoded.sorted { $0.date > $1.date }
    }
    private func save() {
        if let data = try? JSONEncoder().encode(results) {
            defaults.set(data, forKey: key)
        }
    }
}
