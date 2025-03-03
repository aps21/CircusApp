import UIKit

final class ViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.reuseIdentifier)
        collection.register(
            TaskHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TaskHeader.reuseIdentifier
        )
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    private lazy var collectionViewLayout = UICollectionViewCompositionalLayout { _, _ in
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        return section
    }

    private var tasks = [
        (
            title: "Февраль",
            variants: [
                "easy",
                "medium",
                "hard",
            ]
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        title = "Задания"
        navigationItem.backButtonTitle = title

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        tasks.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks[section].variants.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskCell.reuseIdentifier,
            for: indexPath
        ) as! TaskCell
        cell.setup(text: tasks[indexPath.section].variants[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TaskHeader.reuseIdentifier,
            for: indexPath
        ) as! TaskHeader
        view.setup(text: tasks[indexPath.section].title)
        return view
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = ViewControllerFebEasy()
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = ViewControllerFebMedium()
                navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = ViewControllerFebHard()
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}
