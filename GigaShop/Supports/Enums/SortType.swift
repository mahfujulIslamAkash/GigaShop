//
//  SortType.swift
//  GigaShop
//
//

import Foundation

/// Enum defining different sorting criteria for products
enum SortType {
    case lowPrice
    case highPrice
    case lowRating
    case highRating
    case lowReviews
    case highReviews
    
    /// A textual description of the sort type.
    var description: String {
        switch self {
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
        case .highReviews:
            return "High Reviews"
        }
    }
}
