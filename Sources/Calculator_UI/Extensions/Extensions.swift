//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-11.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
    func addArrangedSubviews(_ views:[UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
            NSLayoutConstraint.activate($0.constraints)
        }
    }
}

extension Formatter {
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 8
        formatter.locale = Locale.englishUS
        return formatter
    }()
}
extension Decimal {
    var withCommas: String { Formatter.numberFormatter.string(for: self) ?? "" }
}
//MARK: add localization for formatting
extension Locale {
    static let englishUS: Locale = .init(identifier: "en_US")
    static let frenchFR: Locale = .init(identifier: "fr_FR")
    static let swedenSE: Locale = .init(identifier: "sv_SE")
    // ... and so on
}


//extension UIApplication {
//    
//    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
//        if let nav = base as? UINavigationController {
//            return topViewController(base: nav.visibleViewController)
//        }
//        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
//            return topViewController(base: selected)
//        }
//        if let presented = base?.presentedViewController {
//            return topViewController(base: presented)
//        }
//        return base
//    }
//    
//}
//extension UIView {
//    class func fromNib<T: UIView>() -> T {
//        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
//    }
//}
