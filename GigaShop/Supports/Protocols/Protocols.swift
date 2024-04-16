//
//  Protocols.swift
//  GigaShop
//
//

import Foundation

/// Protocol for filtering and sorting products
protocol FilterDelegate {
    
    /// Filter products based on price range
    /// - Parameter price: The maximum price for filtering
    func priceRangeFilter(price: Double)
    
    /// Sort products based on a specified criteria
    /// - Parameter sortedBy: The sorting criteria
    func sortedBy(sortedBy: SortType)
}
