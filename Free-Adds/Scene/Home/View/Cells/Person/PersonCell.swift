//
//  PersonCell.swift
//  Free-Adds
//
//  Created by Amin on 25/11/2023.
//

import UIKit

class PersonCell: UICollectionViewCell {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiName: UILabel!
    @IBOutlet private weak var uiPosition: UILabel!
    @IBOutlet private weak var uiFollowButton: UIButton!
    
    override var isSelected: Bool {
        willSet(value) {
            UIView.transition(with: uiFollowButton, duration: 0.3) {
                self.uiFollowButton.backgroundColor = value ? .accent : .clear
                self.uiFollowButton.tintColor = value ? .white : .accent
            }
        }
    }
    func configure(model: HomeIdentifier) {
        guard let model = model.person else {return}
        uiImage.image = UIImage(named: model.image)
        uiName.text = model.name
        uiPosition.text = model.position
        self.isSelected = model.isFollowed
    }
    @IBAction func followPressed(_ sender: UIButton) {
        isSelected.toggle()
//        sender.backgroundColor = sender.isSelected ? .accent : .clear
//        sender.tintColor = sender.isSelected ? .white : .accent
    }
}
