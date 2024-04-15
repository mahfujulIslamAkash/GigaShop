//
//  HomeViewModel.swift
//  GigaShop
//
//

import Foundation
import UIKit

class HomeViewModel{
    //initial constructor
    init(_ searchText: String?){
        callApi(searchText)
    }
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    private var results: [Product]?
    private var priceRange: Double?
    
    //MARK: Support for collection View
    func countOfItemResults() -> Int{
        if let priceRange = priceRange{
            guard let results = results else{
                return 0
            }
            return results.filter{$0.price ?? 0 <= priceRange}.count
        }else{
            guard let results = results else{
                return 0
            }
            return results.count
        }
        
        
    }
    
    
    func sizeOfCell(_ parentWidget: CGFloat) -> CGSize{
        let width = (parentWidget-30)/2
        return CGSize(width: width, height: width)
    }
    
    func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        cell.productViewModel = viewModelOfItem(indexPath)
        cell.setupBinders()
        return cell
    }
    
    //MARK: Actions
    func SearchAction(_ textField: UITextField?) -> Bool{
        
        if let textField = textField{
            if textField.text != ""{
                callApi(textField.text)
            }
            
            return textField.resignFirstResponder()
        }else{
            callApi(nil)
            return true
        }
        
    }
    
    //MARK: Filters
    func priceRangeFilter(_ priceRange: Double){
        self.priceRange = priceRange
        isLoaded.value = true
    }
    
    
    func sortedBy(sortedBy: SortType){
        if let results = results {
            
            if sortedBy == .lowPrice{
                self.results = results.sorted{$0.price ?? 0.0 < $1.price ?? 0.0}
            }else if sortedBy == .highPrice{
                self.results = results.sorted{$0.price ?? 0.0 > $1.price ?? 0.0}
            }
            else if sortedBy == .lowRating{
                self.results = results.sorted{$0.review ?? 0.0 < $1.review ?? 0.0}
            }
            else if sortedBy == .highRating{
                self.results = results.sorted{$0.review ?? 0.0 > $1.review ?? 0.0}
            }
            else if sortedBy == .lowReviews{
                self.results = results.sorted{$0.reviewCount ?? 0 < $1.reviewCount ?? 0}
            }else{
                self.results = results.sorted{$0.reviewCount ?? 0 > $1.reviewCount ?? 0}
            }
        }
        
        isLoaded.value = true
    }
    
    
    private func callApi(_ searchedText: String?){
        checkInternet(completion: {[weak self] success in
            if success{
                self?.fetchingData(searchedText)
            }
        })
    }
    
    private func fetchingData(_ searchedText: String?){
        isLoading.value = true
        NetworkService.shared.getSearchedProductss(searchedText, completion: {[weak self] success, results  in
            self?.results = results
            self?.sortedBy(sortedBy: .lowPrice)

            if success{
                self?.isLoaded.value = success
                self?.isLoading.value = false
            }else{
                self?.error.value = true
                self?.isLoading.value = false
            }
            
        })
    }
    
    private func checkInternet(completion: @escaping(Bool)->Void){
        NetworkService.shared.checkConnectivity(completion: {[weak self] havingInternet in
            if havingInternet{
                completion(true)
            }else{
                self?.error.value = true
            }
        })
    }
    
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
    
    func viewModelOfItem(_ indexPath: IndexPath) -> ProductViewModel{
        let product = getItem(indexPath)
        return ProductViewModel(product: product)
    }
    
    //MARK: testing purpose for mine
    private func copyToClipboard(_ indexPath: IndexPath) {
        let path = getProductPath(indexPath)
        UIView.shared.copyToClipboard(path)
    }
    
    func showingErrorToast(){
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
        
    }
    
}
