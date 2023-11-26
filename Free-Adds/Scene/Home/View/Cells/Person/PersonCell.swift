//
//  PersonCell.swift
//  Free-Adds
//
//  Created by Amin on 25/11/2023.
//

import UIKit

class PersonCell: UICollectionViewCell {

    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var uiName: UILabel!
    @IBOutlet weak var uiPosition: UILabel!
    
    @IBAction func followPressed(_ sender: UIButton) {
        
    }
    func configure(model: HomeIdentifier) {
        guard let model = model.person else {return}
        uiImage.image = UIImage(named: model.image)
        uiName.text = model.name
        uiPosition.text = model.position
    }
}
