//
//  HomeViewModel.swift
//  Free-Adds
//
//  Created by Amin on 25/11/2023.
//

import Foundation
import Combine
protocol HomeViewModelInterface {
    var onScreenAppeared: PassthroughSubject<Void, Never> {get}
    var discoverData: AnyPublisher<[HomeIdentifier], Never> {get}
    var categoryData: AnyPublisher<[HomeIdentifier], Never> {get}
}

class HomeViewModel: HomeViewModelInterface {
    var onScreenAppeared: PassthroughSubject<Void, Never> = .init()
    
    var discoverData: AnyPublisher<[HomeIdentifier], Never> {
        return discoverDataSubject.eraseToAnyPublisher()
    }
    var categoryData: AnyPublisher<[HomeIdentifier], Never> {
        return categoryDataSubject.eraseToAnyPublisher()
    }
    
    private var discoverDataSubject: PassthroughSubject<[HomeIdentifier], Never> = .init()
    private var categoryDataSubject: PassthroughSubject<[HomeIdentifier], Never> = .init()
    
    private var coordinator: HomeCoordinatorInterface
    private var cancellables: Set<AnyCancellable> = []
    private var personsModel: [PersonModel] = []
    init(coordinator: HomeCoordinatorInterface) {
        self.coordinator = coordinator
        loadInitialPersons()
        bind()
    }
    private func loadInitialPersons() {
        self.personsModel = [
            .init(person: .amr),
            .init(person: .ben),
            .init(person: .ana),
            .init(person: .white),
            .init(person: .fred)
        ]
    }
    private func bind() {
        onScreenAppeared.sink {[weak self] _ in
            guard let self = self else {return}
            
            let identifiers = personsModel.map { HomeIdentifier(person: $0) }
            discoverDataSubject.send(identifiers)
            
            let categories = getCategories()
            let categoryIdentifiers = categories.map { HomeIdentifier(tag: $0) }
            categoryDataSubject.send(categoryIdentifiers)
        }.store(in: &cancellables)
    }
    private func getCategories() -> [String] {
        let categories: [String] = Bundle.main.decode("Categories.json")
        return categories
    }
}
