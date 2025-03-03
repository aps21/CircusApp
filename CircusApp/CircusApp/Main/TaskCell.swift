import UIKit

final class TaskCell: UICollectionViewCell {
    static let reuseIdentifier = "TaskCell"

    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? .lightGray : .clear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear

        let icon = UIImageView(image: .Common.arrow)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.setContentHuggingPriority(.init(1000), for: .horizontal)
        icon.setContentCompressionResistancePriority(.init(1000), for: .horizontal)

        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            icon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            icon.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            titleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    func setup(text: String) {
        titleLabel.text = text
    }
}
