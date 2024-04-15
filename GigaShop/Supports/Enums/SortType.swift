//
//  SortType.swift
//  GigaShop
//
//  Created by Appnap Mahfuj on 15/4/24.
//

import Foundation

enum SortType{
    case lowPrice
    case highPrice
    case lowRating
    case highRating
    case lowReviews
    case highReviews
    
    var description: String{
        switch self{
        case .lowPrice:
            return "Low Price"
        case .highPrice:
            return "High Price"
        case .lowRating:
            return "Low Rating"
        case .highRating:
            return "High Rating"
        case .lowReviews:
            return "Low Reviews"
        default:
            return "High Reviews"
        }
    }
}
