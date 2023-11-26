//
//  Header.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import UIKit

class Header: UICollectionReusableView {
    @IBOutlet private weak var uiTitle: UILabel!
    
    func configure(title: String) {
        uiTitle.text = title
    }
}
