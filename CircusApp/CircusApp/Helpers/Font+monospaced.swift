import UIKit

extension UIFont {
    var monospacedDigitFont: UIFont {
        UIFont(descriptor: fontDescriptor.monospacedDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDescriptor: UIFontDescriptor {
        let featureSettings = [
            UIFontDescriptor.FeatureKey.type: kNumberSpacingType,
            .selector: kMonospacedNumbersSelector,
        ]
        return addingAttributes([.featureSettings: [featureSettings]])
    }
}
