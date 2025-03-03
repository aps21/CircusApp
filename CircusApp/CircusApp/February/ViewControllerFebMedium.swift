import UIKit

final class ViewControllerFebMedium: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collection.register(
            InsetView.self,
            forSupplementaryViewOfKind: InsetView.reuseIdentifierL,
            withReuseIdentifier: InsetView.reuseIdentifierL
        )
        collection.register(
            InsetView.self,
            forSupplementaryViewOfKind: InsetView.reuseIdentifierR,
            withReuseIdentifier: InsetView.reuseIdentifierR
        )
        collection.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )
        collection.dataSource = self
        return collection
    }()

    private lazy var collectionViewLayout = UICollectionViewCompositionalLayout { _, _ in
        let width = UIScreen.main.bounds.width
        let height = width * 91 / 393 + 12

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(294 / 393),
            heightDimension: .fractionalWidth(91 / 393)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 24, trailing: 24)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 6

        section.boundarySupplementaryItems = [
            // full width
//            {
//                let view = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: .init(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .fractionalWidth(472 / 369)
//                    ),
//                    elementKind: UICollectionView.elementKindSectionHeader,
//                    alignment: .top
//                )
//                view.contentInsets = .init(top: height, leading: -24, bottom: -height, trailing: -24)
//                view.zIndex = -1
//                return view
//            }(),
            {
                let view = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(472 / (369 ))
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                view.contentInsets = .init(top: height, leading: -12, bottom: -height - 4, trailing: -12)
                view.zIndex = -1
                return view
            }(),
            {
                let view = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .absolute(12),
                        heightDimension: .absolute(height)
                    ),
                    elementKind: InsetView.reuseIdentifierL,
                    alignment: .leading
                )
                view.contentInsets = .init(top: -6, leading: -24, bottom: 6, trailing: 24)
                return view
            }(),
            {
                let view = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .absolute(12),
                        heightDimension: .absolute(height)
                    ),
                    elementKind: InsetView.reuseIdentifierR,
                    alignment: .trailing
                )
                view.contentInsets = .init(top: -6, leading: 24, bottom: 6, trailing: -24)
                return view
            }(),
        ]

        return section
    }

    private var colors = [
        UIColor.red,
        .green
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
        title = "Февраль medium"
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

extension ViewControllerFebMedium: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.reuseIdentifier,
            for: indexPath
        ) as! ProductCell
        cell.setup(color: colors[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == InsetView.reuseIdentifierR || kind == InsetView.reuseIdentifierL {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: kind,
                for: indexPath
            ) as! InsetView
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseIdentifier,
                for: indexPath
            ) as! HeaderView
            return view
        }
    }
}

final private class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setup(color: UIColor) {
        contentView.backgroundColor = color
    }
}

final private class InsetView: UICollectionViewCell {
    static let reuseIdentifierL = "InsetViewLeft"
    static let reuseIdentifierR = "InsetViewRight"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final private class HeaderView: UICollectionViewCell {
    static let reuseIdentifier = "HeaderView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 12
        layer.zPosition = -1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        false
    }
}
