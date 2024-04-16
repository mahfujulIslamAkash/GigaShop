//
//  HomeViewModel.swift
//  GigaShop
//
//

import Foundation
import UIKit

class HomeViewModel{
    
    // Initializer to initiate the view model with a search text
    init(_ searchText: String?){
        callApi(searchText)
    }
    
    // Observable property to indicate whether data is loaded
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    // Observable property to indicate whether data is being loading
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    // Observable property to indicate if an error occurred during data fetching
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    // Array to hold the search results
    private var results: [Product]?
    // Variable to hold the price range for filtering
    private var priceRange: Double?
    // Variable to hold the sorting type
    private var sortedBy: SortType?
    
    // MARK: Support for collection view
        
    // Function to calculate the number of item results based on price range filtering
    func countOfItemResults() -> Int {
        if let priceRange = priceRange {
            guard let results = results else {
                return 0
            }
            return results.filter { $0.price ?? 0 <= priceRange }.count
        } else {
            guard let results = results else {
                return 0
            }
            return results.count
        }
    }
    
    // Function to calculate the size of collection view cells
    func sizeOfCell(_ parentWidget: CGFloat) -> CGSize {
        let width = (parentWidget - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    // Function to dequeue and configure collection view cells
    func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        cell.productViewModel = viewModelOfItem(indexPath)
        cell.setupBinders()
        return cell
    }
    
    // MARK: Actions
        
    // Function to handle search action
    func SearchAction(_ textField: UITextField?) -> Bool {
        if let textField = textField {
            if textField.text != "" {
                callApi(textField.text)
            }
            return textField.resignFirstResponder()
        } else {
            callApi(nil)
            return true
        }
    }
    
    // MARK: Filters
    
    // Function to apply price range filter
    func priceRangeFilter(_ priceRange: Double) {
        self.priceRange = priceRange
        isLoaded.value = true
    }
    
    // Function to apply sorting
    func sortedBy(sortedBy: SortType){
        self.sortedBy = sortedBy
        if let results = results {
            
            if self.sortedBy == .lowPrice{
                self.results = results.sorted{$0.price ?? 0.0 < $1.price ?? 0.0}
            }else if self.sortedBy == .highPrice{
                self.results = results.sorted{$0.price ?? 0.0 > $1.price ?? 0.0}
            }
            else if self.sortedBy == .lowRating{
                self.results = results.sorted{$0.review ?? 0.0 < $1.review ?? 0.0}
            }
            else if self.sortedBy == .highRating{
                self.results = results.sorted{$0.review ?? 0.0 > $1.review ?? 0.0}
            }
            else if self.sortedBy == .lowReviews{
                self.results = results.sorted{$0.reviewCount ?? 0 < $1.reviewCount ?? 0}
            }else{
                self.results = results.sorted{$0.reviewCount ?? 0 > $1.reviewCount ?? 0}
            }
        }
        
        isLoaded.value = true
    }
    
    // MARK: Networking
        
    // Function to call the API based on the searched text
    private func callApi(_ searchedText: String?) {
        checkInternet(completion: { [weak self] success in
            if success {
                self?.fetchingData(searchedText)
            }
        })
    }
    
    // Function to fetch data from the network
    private func fetchingData(_ searchedText: String?){
        isLoading.value = true
        NetworkService.shared.getSearchedProductss(searchedText, completion: {[weak self] success, results  in
            self?.results = results
            
            if let sortedBy = self?.sortedBy{
                self?.sortedBy(sortedBy: sortedBy)
            }else{
                self?.sortedBy(sortedBy: .lowPrice)
            }
            

            if success{
                self?.isLoaded.value = success
                self?.isLoading.value = false
            }else{
                self?.error.value = true
                self?.isLoading.value = false
            }
            
        })
    }
    
    // Function to check internet connectivity
    private func checkInternet(completion: @escaping(Bool)->Void){
        NetworkService.shared.checkConnectivity(completion: {[weak self] havingInternet in
            if havingInternet{
                completion(true)
            }else{
                self?.error.value = true
            }
        })
    }
    
    // MARK: Helper
        
    // Function to get the product at a given index path
    private func getItem(_ indexPath: IndexPath) -> Product?{
        guard let results = results else{
            return nil
        }
        if let priceRange = priceRange{
            return results.filter{$0.price ?? 0 <= priceRange}[indexPath.row]
        }else{
            return results[indexPath.row]
        }
        
    }
    // Function to get the product link path at a given index path
    private func getProductPath(_ indexPath: IndexPath) -> String{
        guard let results = results else{
            return ""
        }
        if let priceRange = priceRange{
            guard let path = results.filter({$0.price ?? 0 <= priceRange})[indexPath.row].productPath else { return "" }
            return path
        }else{
            guard let path = results[indexPath.row].productPath else { return "" }
            return path
        }
        
    }
    
    // Function to create a ProductViewModel for a given index path
    func viewModelOfItem(_ indexPath: IndexPath) -> ProductViewModel {
        let product = getItem(indexPath)
        return ProductViewModel(product: product)
    }

    // MARK: Testing

    // Function to copy the product path to the clipboard
    private func copyToClipboard(_ indexPath: IndexPath) {
        let path = getProductPath(indexPath)
        UIView.shared.copyToClipboard(path)
    }

    // Function to display an error toast message
    func showingErrorToast() {
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
    }
    
}
