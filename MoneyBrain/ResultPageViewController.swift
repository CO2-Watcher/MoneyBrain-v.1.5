import UIKit

// Mehrseitiger Endscreen -> blättert zwischen Auswertung und Diagramm
final class ResultPageViewController: UIViewController {

    private let result: QuizResult
    private let pages: [UIViewController]
    private let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let pageControl = UIPageControl()

    init(result: QuizResult) {
        self.result = result
        self.pages = [ResultSummaryViewController(result: result),
                      ResultNetzViewController(result: result)]
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Auswertung"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Fertig", style: .done, target: self, action: #selector(doneTapped))

        // Seiten-Controller einrichten und einbetten
        pageVC.dataSource = self
        pageVC.delegate = self
        pageVC.setViewControllers([pages[0]], direction: .forward, animated: false)
        addChild(pageVC)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)

        // Seitenindikator unten
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .tintColor
        pageControl.pageIndicatorTintColor = .tertiaryLabel
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            pageControl.topAnchor.constraint(equalTo: pageVC.view.bottomAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func doneTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func pageControlChanged() {
        let target = pageControl.currentPage
        let current = pages.firstIndex { $0 === pageVC.viewControllers?.first } ?? 0
        guard target != current else { return }
        pageVC.setViewControllers([pages[target]],
                                  direction: target > current ? .forward : .reverse,
                                  animated: true)
    }
}

// MARK: - Blättern

extension ResultPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pvc: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let i = pages.firstIndex(of: viewController), i > 0 else { return nil }
        return pages[i - 1]
    }

    func pageViewController(_ pvc: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let i = pages.firstIndex(of: viewController), i < pages.count - 1 else { return nil }
        return pages[i + 1]
    }

    func pageViewController(_ pvc: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed, let vc = pvc.viewControllers?.first, let i = pages.firstIndex(of: vc) {
            pageControl.currentPage = i
        }
    }
}
