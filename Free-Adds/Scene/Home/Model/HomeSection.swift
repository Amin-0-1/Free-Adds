//
//  HomeSection.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import Foundation
enum HomeSection: Int, Hashable, CustomStringConvertible {
    case discover = 0
    case category
    case list
    
    var description: String {
        switch self {
            case .discover:
                return "Discover People"
            case .category:
                return "Categories"
            case .list:
                return ""
        }
    }
    }
