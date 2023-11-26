//
//  AddCell.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import UIKit

class AddCell: UICollectionViewCell {

    @IBOutlet weak var uiImage: UIImageView!

    func configure(model: HomeIdentifier) {
        guard let image = model.add?.image else {return}
        uiImage.image = UIImage(data: image)
    }

}
