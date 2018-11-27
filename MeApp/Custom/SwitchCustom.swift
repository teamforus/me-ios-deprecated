import UIKit
@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = .white
            self.layer.cornerRadius = 14
            self.backgroundColor = OffTint
        }
    }
}
