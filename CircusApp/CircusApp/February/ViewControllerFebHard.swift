import UIKit

final class ViewControllerFebHard: UIViewController {
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

    private lazy var timerHeader = TimerHeader()
    private lazy var customView = CustomView()
    private lazy var customView2 = CustomView(itemWidth: 16)
    private lazy var customView3 = CustomView(itemWidth: 16, duration: 4)
    private lazy var customView4 = CustomView(itemWidth: 16, offset: 20, duration: 4)

    private func setup() {
        title = "Февраль hard"
        navigationItem.backButtonTitle = title
        view.backgroundColor = .systemBackground

        timerHeader.translatesAutoresizingMaskIntoConstraints = false
        customView.translatesAutoresizingMaskIntoConstraints = false

        let vStack = UIStackView(arrangedSubviews: [timerHeader, customView, customView2, customView3, customView4])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 20

        let stack = UIStackView(arrangedSubviews: [vStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            timerHeader.widthAnchor.constraint(equalToConstant: 200),
            timerHeader.heightAnchor.constraint(equalToConstant: 50),

            customView.widthAnchor.constraint(equalToConstant: 200),
            customView.heightAnchor.constraint(equalToConstant: 50),
            customView2.widthAnchor.constraint(equalToConstant: 200),
            customView2.heightAnchor.constraint(equalToConstant: 50),
            customView3.widthAnchor.constraint(equalToConstant: 200),
            customView3.heightAnchor.constraint(equalToConstant: 50),
            customView4.widthAnchor.constraint(equalToConstant: 200),
            customView4.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

private final class CustomView: UIView {
    private let itemWidth: CGFloat
    private let offset: CGFloat
    private var duration: Double

    init(itemWidth: CGFloat = 32, offset: CGFloat = 50, duration: Double = 1) {
        self.itemWidth = itemWidth
        self.offset = offset
        self.duration = duration
        super.init(frame: .zero)

        clipsToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1

        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                for indicator in (layer.sublayers ?? []) {
                    indicator.add(lineAnimation, forKey: animationKey)
                }
            }
        )
    }

    private let animationKey = "Animation.ScrollLines"

    private lazy var lineAnimation: CAAnimationGroup = {
        let moveX = CAKeyframeAnimation(keyPath: "transform.translation.x")
        moveX.values = [0, -2 * itemWidth]
        moveX.keyTimes = [0, 1]
        moveX.isAdditive = true

        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = .infinity
        group.animations = [moveX]
        return group
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let count = Int((frame.width / itemWidth).rounded(.down) + 2 * (offset / itemWidth).rounded(.up))
        setup(count: count)

        for (index, indicator) in (layer.sublayers ?? []).enumerated() {
            let mask = CAShapeLayer()
            let frame = CGRect(
                x: itemWidth * CGFloat(index) - offset,
                y: 0,
                width: itemWidth + offset,
                height: frame.height
            )
            mask.path = path(in: CGRect(origin: .zero, size: frame.size)).cgPath
            mask.strokeColor = mask.fillColor
            indicator.mask = mask
            indicator.backgroundColor = index % 2 == 0 ? UIColor.black.cgColor : UIColor.yellow.cgColor
            indicator.frame = frame
            indicator.add(lineAnimation, forKey: animationKey)
        }
    }

    private func setup(count: Int) {
        let currentCount = layer.sublayers?.count ?? 0
        let diff = currentCount - count
        if diff > 0 {
            layer.sublayers?.suffix(diff).forEach { $0.removeFromSuperlayer() }
        } else if diff < 0 {
            for _ in 0 ..< -diff {
                layer.addSublayer(CALayer())
            }
        }
    }

    private func path(in rect: CGRect) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.minX + offset, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - offset, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        bezierPath.close()
        return bezierPath
    }
}

private final class TimerHeader: UIView {
    private lazy var timerStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [
            createItemView(label1: timerLabelH, label2: timerLabelH2),
            createItemView(label1: timerLabelM, label2: timerLabelM2),
            createItemView(label1: timerLabelS, label2: timerLabelS2),
        ])
        hStack.spacing = 11
        hStack.distribution = .fillEqually

        let stack = UIStackView(arrangedSubviews: [hStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center

        let separator1 = createSeparator()
        let separator2 = createSeparator()

        stack.addSubview(separator1)
        stack.addSubview(separator2)

        NSLayoutConstraint.activate([
            separator1.centerYAnchor.constraint(equalTo: hStack.centerYAnchor),
            separator1.leadingAnchor.constraint(equalTo: hStack.arrangedSubviews[0].trailingAnchor, constant: 3),

            separator2.centerYAnchor.constraint(equalTo: hStack.centerYAnchor),
            separator2.leadingAnchor.constraint(equalTo: hStack.arrangedSubviews[1].trailingAnchor, constant: 3),
        ])
        return stack
    }()

    private lazy var timerLabelH = createLabel()
    private lazy var timerLabelH2 = createLabel()
    private lazy var timerLabelM = createLabel()
    private lazy var timerLabelM2 = createLabel()
    private lazy var timerLabelS = createLabel()
    private lazy var timerLabelS2 = createLabel()

    private let timerDefault = Double(8 * 60 * 60 + 0 * 60 + 5)
    private lazy var timerCellDate: Date = Date.now.addingTimeInterval(timerDefault)
    private var timer: Timer?

    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(timerStack)

        NSLayoutConstraint.activate([
            timerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            timerStack.topAnchor.constraint(equalTo: topAnchor),
            timerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        let timerDate = Date(timeIntervalSince1970: timerCellDate.timeIntervalSince1970 - Date.now.timeIntervalSince1970)
        setup(timer: timerDate)

        let timer = Timer(
            timeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                guard let self else {
                    return
                }
                DispatchQueue.main.async {
                    guard self.timerCellDate > Date.now else {
                        return
                    }
                    let timer = Date(timeIntervalSince1970: self.timerCellDate.timeIntervalSince1970 - Date.now.timeIntervalSince1970)
                    self.setup(timer: timer)
                }
            }
        )

        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
        timer.fire()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(timer: Date) {
        let components = calendar.dateComponents(
            [.hour, .minute, .second],
            from: timer
        )

        update(label1: timerLabelH, label2: timerLabelH2, unit: components.hour ?? 0, divide: nil)
        update(label1: timerLabelM, label2: timerLabelM2, unit: components.minute ?? 0, divide: 60)
        update(label1: timerLabelS, label2: timerLabelS2, unit: components.second ?? 0, divide: 60)

        UIView.animate(withDuration: 0.25) { [self] in
            timerLabelH2.transform = .init(translationX: 0, y: -timerLabelH2.frame.height)
            timerLabelM2.transform = .init(translationX: 0, y: -timerLabelM2.frame.height)
            timerLabelS2.transform = .init(translationX: 0, y: -timerLabelS2.frame.height)

            timerLabelH.transform = .identity
            timerLabelM.transform = .identity
            timerLabelS.transform = .identity
        }
    }

    // MARK: - Helpers

    private func update(label1: UILabel, label2: UILabel, unit: Int, divide: Int?) {
        let minutes = label1.text ?? ""
        label1.text = formatted(unit: unit)
        if minutes == label1.text {
            label1.transform = .identity
            label2.transform = .init(translationX: 0, y: -label2.frame.height)
        } else {
            label1.transform = .init(translationX: 0, y: label1.frame.height)
            let upUnit = if let divide {
                (unit + 1) % divide
            } else {
                (unit + 1)
            }
            label2.text = formatted(unit: upUnit)
            label2.transform = .identity
        }
    }

    private func formatted(unit: Int) -> String {
        String(format: "%02d", unit)
    }

    // MARK: - Create views

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body).monospacedDigitFont
        label.textColor = .black
        return label
    }

    private func createItemView(label1: UILabel, label2: UILabel) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label1)
        view.addSubview(label2)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true

        NSLayoutConstraint.activate([
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            label1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            label1.topAnchor.constraint(equalTo: view.topAnchor),
            label1.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            label2.topAnchor.constraint(equalTo: view.topAnchor),
            label2.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        return view
    }

    private func createSeparator() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ":"
        return label
    }
}
