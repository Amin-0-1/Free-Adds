//
//  ReusableView.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import Foundation
import UIKit
protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UIView: ReusableView {}
