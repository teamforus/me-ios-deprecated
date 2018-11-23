import UIKit
@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 14
            self.backgroundColor = OffTint
        }
    }
}
