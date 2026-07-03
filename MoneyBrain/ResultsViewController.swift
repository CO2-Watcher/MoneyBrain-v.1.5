import UIKit

// Ergebniss-Tab -> Liste aller Tests
// Tippen öffnet die Auswertung, Swipe löscht sie
final class ResultsViewController: UITableViewController {

    private var results: [QuizResult] = []

    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ergebnisse"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        results = ResultStore.shared.results   // schon nach Datum absteigend sortiert
        tableView.reloadData()
    }

    // MARK: - Tabelle

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.isEmpty ? 1 : results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        // Leerzustand oder eine Ergebniszeile
        if results.isEmpty {
            content.text = "Noch keine Ergebnisse"
            content.secondaryText = "Schließe einen Test ab, um ihn hier zu sehen."
            content.textProperties.color = .secondaryLabel
            content.image = nil
            cell.selectionStyle = .none
            cell.accessoryType = .none
        } else {
            let result = results[indexPath.row]
            content.text = "\(result.kind.title) · \(result.totalScore)/100"
            content.secondaryText = "\(result.rating) · \(dateFormatter.string(from: result.date))"
            content.secondaryTextProperties.color = .secondaryLabel
            content.image = UIImage(systemName: result.kind.symbolName)
            content.imageProperties.tintColor = .tintColor
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
        }
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !results.isEmpty else { return }
        let result = results[indexPath.row]
        navigationController?.pushViewController(ResultPageViewController(result: result), animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        !results.isEmpty
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, !results.isEmpty else { return }
        ResultStore.shared.delete(at: indexPath.row)
        results = ResultStore.shared.results
        if results.isEmpty {
            tableView.reloadData()                       // Leerzustand anzeigen
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
