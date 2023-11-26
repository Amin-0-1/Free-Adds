//
//  PersonModel.swift
//  Free-Adds
//
//  Created by Amin on 25/11/2023.
//

import Foundation

struct PersonModel: Equatable {
    var image: String {
        person.image
    }
    var name: String {
        person.rawValue
    }
    var position: String {
        person.position
    }
    
    let person: PersonType
    var isFollowed = false
    
    enum PersonType: String, CaseIterable {
        case amr = "Amr Salama"
        case ana = "Ana de Armas"
        case ben = "Ben Affleck"
        case white = "Walter white"
        case fred = "Fred alberto"
    
        var image: String {
            switch self {
                case .amr:
                    return "amr"
                case .ana:
                    return "ana"
                case .ben:
                    return "ben"
                case .white:
                    return "amr"
                case .fred:
                    return "ben"
            }
        }
        var position: String {
            switch self {
                case .amr:
                    return "Film Director"
                case .ana:
                    return "Spanish Actress"
                case .ben:
                    return "American Actor"
                case .white:
                    return "American Actor"
                case .fred:
                    return "Anonymous"
            }
        }
    }
}
