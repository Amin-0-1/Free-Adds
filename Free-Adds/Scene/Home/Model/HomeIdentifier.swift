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
    
    init(
        person: PersonModel? = nil,
        tag: String? = nil
    ) {
        self.person = person
        self.tag = tag
    }
    static func == (lhs: HomeIdentifier, rhs: HomeIdentifier) -> Bool {
        (lhs.person == rhs.person && lhs.person != nil) || (lhs.tag == rhs.tag && lhs.tag != nil)
    }
    private var uuid = UUID()
    func hash(into hasher: inout Hasher) {
        uuid.hash(into: &hasher)
    }
}
