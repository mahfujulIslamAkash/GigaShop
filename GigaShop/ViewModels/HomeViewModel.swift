//
//  HomeViewModel.swift
//  GigaShop
//
//

import Foundation
import UIKit

class HomeViewModel{
    
    init(_ searchText: String?){
        callApi(searchText)
    }
    var isLoaded: ObservableObject<Bool?> = ObservableObject(nil)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    var error: ObservableObject<Bool?> = ObservableObject(nil)
    
    
//    static var shared = NetworkService()
    
    private var results: [Item]?
    private var priceUp = true
    private var reviewUp = true
    private var reviewCountUp = true
    private var priceRange = 500.0
    
    //MARK: Support for collection View
    func countOfItemResults() -> Int{
        guard let results = results else{
            return 0
        }
        return results.filter{$0.price ?? 0 <= priceRange}.count
        
    }
    
    
    func sizeOfCell(_ parentWidget: CGFloat) -> CGSize{
        let width = (parentWidget-30)/2
        return CGSize(width: width, height: width)
    }
    
    func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        cell.itemViewModel = viewModelOfItem(indexPath)
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
    func priceFilter(){
        priceUp.toggle()
        //adding data toggle functionality here
        sortResult(priceUp, reviewUp, reviewCountUp)
        isLoaded.value = true
    }
    func reviewFilter(){
        reviewUp.toggle()
        //adding data toggle functionality here
        sortResult(priceUp, reviewUp, reviewCountUp)
        isLoaded.value = true
    }
    func reviewCountFilter(){
        reviewCountUp.toggle()
        //adding data toggle functionality here
        sortResult(priceUp, reviewUp, reviewCountUp)
        isLoaded.value = true
    }
    
    func searchFilter(_ priceRange: Double){
        self.priceRange = priceRange
        isLoaded.value = true
    }
    
    private func sortResult(_ highPrice: Bool, _ highReview: Bool, _ highReviewCount: Bool){
        
        if var results = results {
            results.sort { (item1, item2) in
                if item1.price != item2.price {
                    return highPrice ? (item1.price ?? 0.0 > item2.price ?? 0.0) : (item1.price ?? 0.0 < item2.price ?? 0.0)
                } else if item1.review != item2.review {
                    return highReview ? (item1.review ?? 0.0 > item2.review ?? 0.0) : (item1.review ?? 0.0 < item2.review ?? 0.0)
                } else {
                    return highReviewCount ? (item1.reviewCount ?? 0 > item2.reviewCount ?? 0) : (item1.reviewCount ?? 0 < item2.reviewCount ?? 0)
                }
            }
            
            
            // Update the result array
            self.results = results
        }
        
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
        NetworkService.shared.getSearchedGifs(searchedText, completion: {[weak self] success, results  in
            self?.results = results
            #warning("this is need to be maintain again later")
            self?.sortResult(true, true, true)

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
    
    private func getItem(_ indexPath: IndexPath) -> Item?{
        guard let results = results else{
            return nil
        }
        return results.filter{$0.price ?? 0 <= priceRange}[indexPath.row]
    }
    
    private func getOriginalGifPath(_ indexPath: IndexPath) -> String{
        guard let results = results else{
            return ""
        }
        guard let path = results.filter({$0.price ?? 0 <= priceRange})[indexPath.row].original else { return "" }
        return path
    }
    
    func viewModelOfItem(_ indexPath: IndexPath) -> ItemViewModel{
        let item = getItem(indexPath)
        return ItemViewModel(item: item)
    }
    
    //MARK: testing purpose for mine
    private func copyToClipboard(_ indexPath: IndexPath) {
        let path = getOriginalGifPath(indexPath)
        UIView.shared.copyToClipboard(path)
    }
    
    func showingErrorToast(){
        DispatchQueue.main.async {
            UIView.shared.showingToast("Error")
        }
        
    }
    
}
