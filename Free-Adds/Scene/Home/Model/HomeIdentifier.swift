//
//  HomeDataItem.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import Foundation
struct HomeIdentifier: Hashable {
    var person: PersonModel?
    var tag: String?
    var add: AddModel?
    
    init(
        person: PersonModel? = nil,
        tag: String? = nil,
        addModel: AddModel? = nil
    ) {
        self.person = person
        self.add = addModel
        self.tag = tag
    }
    static func == (lhs: HomeIdentifier, rhs: HomeIdentifier) -> Bool {
        lhs.uuid == rhs.uuid
    }
    private var uuid = UUID()
    func hash(into hasher: inout Hasher) {
        uuid.hash(into: &hasher)
    }
}
