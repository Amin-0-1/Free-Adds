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
    var addFreeAdPressed: PassthroughSubject<Void, Never> {get}
    var discoverData: AnyPublisher<[HomeIdentifier], Never> {get}
    var categoryData: AnyPublisher<[HomeIdentifier], Never> {get}
    var adsData: AnyPublisher<[HomeIdentifier], Never> {get}
    var onCategorySelected: PassthroughSubject<Int, Never> {get}
}

class HomeViewModel: HomeViewModelInterface {
    var onScreenAppeared: PassthroughSubject<Void, Never> = .init()
    var addFreeAdPressed: PassthroughSubject<Void, Never> = .init()
    var onCategorySelected: PassthroughSubject<Int, Never> = .init()
    
    var adsData: AnyPublisher<[HomeIdentifier], Never> {
        adsDataSubject.eraseToAnyPublisher()
    }
    var discoverData: AnyPublisher<[HomeIdentifier], Never> {
        return discoverDataSubject.eraseToAnyPublisher()
    }
    var categoryData: AnyPublisher<[HomeIdentifier], Never> {
        return categoryDataSubject.eraseToAnyPublisher()
    }
    
    private var discoverDataSubject: PassthroughSubject<[HomeIdentifier], Never> = .init()
    private var categoryDataSubject: CurrentValueSubject<[HomeIdentifier], Never> = .init([])
    private var adsDataSubject: PassthroughSubject<[HomeIdentifier], Never> = .init()
    private var coordinator: HomeCoordinatorInterface
    private var localDatasource: CoreDataManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    private var personsModel: [PersonModel] = []
    init(
        coordinator: HomeCoordinatorInterface,
        localDatasource: CoreDataManagerProtocol = CoreDataManager.configure(store: .memory)
    ) {
        self.coordinator = coordinator
        self.localDatasource = localDatasource
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
        
        addFreeAdPressed.sink {[weak self] _ in
            guard let self = self else {return}
            coordinator.navigateToAd()
        }.store(in: &cancellables)
        
        onCategorySelected.sink { [weak self] index in
            guard let self = self else {return}
            guard let category = self.categoryDataSubject.value[index].tag else {return}
            let categories = getCategories()
            let addModel: AddModel?
            print(category)
            if categories.contains(category), categories.first != category {
                addModel = .init(category: category, image: nil)
            } else {
                addModel = nil
            }
            localDatasource.fetch(localEndPoint: .ads(addModel)).sink { completion in
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        print(error)
                }
            } receiveValue: { model in
                print(model)
                let adsIdentifier = model.map { HomeIdentifier(addModel: $0) }
                self.adsDataSubject.send(adsIdentifier)
            }.store(in: &cancellables)

        }.store(in: &cancellables)
    }
    private func getCategories() -> [String] {
        let categories: [String] = Bundle.main.decode("Categories.json")
        return categories
    }
}
