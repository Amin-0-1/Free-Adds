//
//  AppCoordinator.swift
//  Free-Adds
//
//  Created by Amin on 25/11/2023.
//

import UIKit

protocol Coordinator {
    var nav: UINavigationController {get}
    func start()
}

struct AppCoordinator: Coordinator {
    var nav: UINavigationController
    
    func start() {
        let coordinator = HomeCoordinator(nav: nav)
        coordinator.start()
    }
}
