//
//  CoreDataManager.swift
//  Football-Leagues
//
//  Created by Amin on 19/10/2023.
//

import Foundation
import CoreData
import Combine

enum LocalEndPoint {
    case ads(AddModel?)
}
protocol CoreDataManagerProtocol {
    func insert(localEndPoint: LocalEndPoint) -> Future<Bool, Error>
    func fetch(localEndPoint: LocalEndPoint) -> Future<[AddModel], Error>
}

extension CoreDataManager: CoreDataManagerProtocol {
    
    func fetch(localEndPoint: LocalEndPoint) -> Future<[AddModel], Error> {
        var allData: [NSFetchRequestResult] = []
        let request = AddEntity.fetchRequest()
        switch localEndPoint {
            case .ads(let model):
                if let myModel = model, let category = myModel.category {
                    let attr = "category"
                    request.predicate = NSPredicate(format: "%K == %@", attr, category)
                }
        }
        return Future<[AddModel], Error> { promise in
            do {
                allData = try self.mainContext.fetch(request)
                guard let adds = allData as? [AddEntity] else {
                    promise(.failure(Errors.empty))
                    return
                }
                let models = adds.map { AddModel(category: $0.category, image: $0.image) }
                DispatchQueue.main.async {
                    promise(.success(models))
                }
            } catch {
                promise(.failure(error))
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func insert(localEndPoint: LocalEndPoint) -> Future<Bool, Error> {
        
        return .init { promise in
            self.performBackgroundTask { context in
                switch localEndPoint {
                    case .ads(let model):
                        let obj = AddEntity(context: context)
                        obj.category = model?.category
                        obj.image = model?.image
                }
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        promise(.success(true))
                    }
                } catch {
                    promise(.failure(error))
                    debugPrint(error)
                }
            }
        }
    }
}

extension CoreDataManager {
    
    enum Errors: Error {
        case empty
        case uncompleted
        var localizedDscription: String {
            switch self {
                case .empty:
                    return "no local data found"
                case .uncompleted:
                    return "Uncompleted process, please try again later"
            }
        }
    }
}
