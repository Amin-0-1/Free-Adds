//
//  AddViewModel.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import Foundation
import Combine

protocol AddViewModelInterface {
    var backTapped: PassthroughSubject<Void, Never> {get}
    var categories: CurrentValueSubject<[String], Never> {get}
    var selectCategory: CurrentValueSubject<String?, Never> {get}
    var selectedImage: CurrentValueSubject<Data?, Never> {get}
    var onCreatTapped: PassthroughSubject<Void, Never> {get}
    var validAd: AnyPublisher<Bool, Never> {get}
}
class AddViewModel: AddViewModelInterface {
    
    var backTapped: PassthroughSubject<Void, Never> = .init()
    var categories: CurrentValueSubject<[String], Never> = .init([])
    var selectCategory: CurrentValueSubject<String?, Never> = .init(nil)
    var selectedImage: CurrentValueSubject<Data?, Never> = .init(nil)
    var onCreatTapped: PassthroughSubject<Void, Never> = .init()
    
    var validAd: AnyPublisher<Bool, Never> {
        validAdSubject.eraseToAnyPublisher()
    }
    private var validAdSubject: PassthroughSubject<Bool, Never> = .init()
    private var coordinator: AddCoordinatorInterface
    private var cancellables: Set<AnyCancellable> = []
    private var localDatasource: CoreDataManagerProtocol
    init(
        coordinator: AddCoordinatorInterface,
        localDatasource: CoreDataManager = CoreDataManager.configure(store: .sqlite)
    ) {
        self.coordinator = coordinator
        self.localDatasource = localDatasource
        updateCategories()
        bind()
    }
    private func updateCategories() {
        let categories: [String] = Bundle.main.decode("Categories.json")
        
        self.categories.send(Array(categories.dropFirst()))
    }
    private func bind() {
        backTapped.sink { [weak self] _ in
            guard let self = self else {return}
            coordinator.pop()
        }.store(in: &cancellables)
        selectedImage.sink { [weak self] _ in
            guard let self = self else {return}
            checkValidAd()
        }.store(in: &cancellables)
        selectCategory.sink { [weak self] _ in
            guard let self = self else {return}
            checkValidAd()
        }.store(in: &cancellables)
        onCreatTapped.sink { [weak self] _ in
            guard let self = self else {return}
            if let category = selectCategory.value, let image = selectedImage.value {
                localDatasource.insert(
                    localEndPoint: .ads(.init(category: category, image: image))
                ).sink { completion in
                    switch completion {
                        case .finished: break
                        case .failure(let error):
                            print(error)
                    }
                } receiveValue: { _ in
                    self.coordinator.pop()
                }.store(in: &cancellables)

            }
        }.store(in: &cancellables)
    }
    private func checkValidAd() {
        guard selectedImage.value != nil, selectCategory.value != nil else {
            validAdSubject.send(false)
            return
        }
        validAdSubject.send(true)
    }
}
