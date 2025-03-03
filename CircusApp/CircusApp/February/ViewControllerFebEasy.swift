import UIKit

final class ViewControllerFebEasy: UIViewController {
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

    private lazy var starHImageView = UIImageView(image: currentImage)
    private lazy var starVImageView = UIImageView(image: currentImage)

    private lazy var titleLabel = UILabel()

    private lazy var slider: UISlider = {
        let view = UISlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didChangeProgress(slider:)), for: .valueChanged)
        return view
    }()

    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }()

    private lazy var customView = CustomView()

    private let currentImage = UIImage.FebruaryEasy.star

    private func setup() {
        title = "Февраль easy"
        navigationItem.backButtonTitle = title
        view.backgroundColor = .systemBackground

        slider.sendActions(for: .valueChanged)
        customView.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView(arrangedSubviews: [starHImageView, starVImageView, customView])
        stack.spacing = 20

        let vStack = UIStackView(arrangedSubviews: [stack, slider, titleLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 20

        let contentStack = UIStackView(arrangedSubviews: [vStack])
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: view.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),

            customView.widthAnchor.constraint(equalToConstant: 64),
            customView.heightAnchor.constraint(equalToConstant: 64),
        ])
    }

    @objc
    private func didChangeProgress(slider: UISlider) {
        titleLabel.text = formatter.string(from: NSNumber(value: slider.value))
        redraw(percent: slider.value, view: starHImageView, isVertical: false)
        redraw(percent: slider.value, view: starVImageView, isVertical: true)

        customView.set(progress: slider.value)
    }

    private func redraw(percent: Float, view: UIImageView, isVertical: Bool) {
        let size = currentImage.size
        let coef = 1 - CGFloat(percent)
        let top = isVertical ? size.height * coef : 0
        let left = isVertical ? 0 : size.width * coef
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if let con = UIGraphicsGetCurrentContext() {
            UIColor.red.setFill()
            con.fill(
                CGRect(
                    x: 0,
                    y: top,
                    width: size.width - left,
                    height: size.height - top
                )
            )
            currentImage.draw(at: CGPoint(x: 0, y: 0), blendMode: CGBlendMode.destinationAtop, alpha: 1)
            view.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
    }
}

private final class CustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.green
        let mask = UIImageView(image: UIImage.FebruaryEasy.star)
        layer.mask = mask.layer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var percent: Float = 0
    private var isVertical: Bool = true

    func set(progress percent: Float, isVertical: Bool = true) {
        self.percent = percent
        self.isVertical = isVertical
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let size = rect.size
        let coef = 1 - CGFloat(percent)
        let top = isVertical ? size.height * coef : 0
        let left = isVertical ? 0 : size.width * coef
        let bottomRect = CGRect(
            x: 0,
            y: top,
            width: size.width - left,
            height: size.height - top
        )
        UIColor.red.set()
        UIRectFill(bottomRect)
    }
}
