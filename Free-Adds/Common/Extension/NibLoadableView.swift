//
//  NibLoadable.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import Foundation
import UIKit

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}

extension UIView: NibLoadableView {}
