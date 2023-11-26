//
//  LabledTagg.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import UIKit

class LabeledTag: UICollectionViewCell {
    
    @IBOutlet weak var uiLabel: UILabel!
    func configure(model: HomeIdentifier) {
        guard let tag = model.tag else {return}
        uiLabel.text = tag
    }
    override var isSelected: Bool {
        willSet {
            if newValue {
                uiLabel.textColor = .accent
            } else {
                uiLabel.textColor = .white
            }
        }
    }
}
