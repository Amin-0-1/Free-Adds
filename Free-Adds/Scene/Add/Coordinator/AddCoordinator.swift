//
//  AddCoordinator.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import UIKit

protocol AddCoordinatorInterface: Coordinator {
    func pop()
}
struct AddCoordinator: AddCoordinatorInterface {
    var nav: UINavigationController
    
    func start() {
        let viewModel = AddViewModel(coordinator: self)
        let vc = AddVC(viewModel: viewModel)
        nav.pushViewController(vc, animated: true)
    }
    func pop() {
        nav.popViewController(animated: true)
    }
}
