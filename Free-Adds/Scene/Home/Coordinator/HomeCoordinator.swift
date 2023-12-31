//
//  HomeCoordinator.swift
//  Free-Adds
//
//  Created by Amin on 25/11/2023.
//

import UIKit

protocol HomeCoordinatorInterface: Coordinator {
    func navigateToAd()
}
struct HomeCoordinator: HomeCoordinatorInterface {
    var nav: UINavigationController
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let vc = HomeVC(viewModel: viewModel)
        nav.setViewControllers([vc], animated: true)
    }
    func navigateToAd() {
        let coordinator = AddCoordinator(nav: nav)
        coordinator.start()
    }
}
