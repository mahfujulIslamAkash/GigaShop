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
    
    static var shared = NetworkService()
    
    private var priceUp = true
    private var reviewUp = true
    private var reviewCountUp = true
    
    //MARK: Support for collection View
    func countOfGifsResult() -> Int{
        guard let gifs = HomeViewModel.shared.getGifResults() else{
            return 0
        }
        return gifs.count
        
    }
    
    func havingGifsResult() -> Bool{
        return false
    }
    
    func sizeOfCell(_ parentWidget: CGFloat) -> CGSize{
        let width = (parentWidget-40)/3
        return CGSize(width: width, height: width)
    }
    
    func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        cell.itemViewModel = viewModelOfGif(indexPath)
        cell.setupBinders()
        return cell
    }
    
    //MARK: Actions
    func SearchAction(_ textField: UITextField?) -> Bool{
        if let textField = textField{
            callApi(textField.text)
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
        HomeViewModel.shared.sortResult(priceUp, reviewUp, reviewCountUp)
        isLoaded.value = true
    }
    func reviewFilter(){
        reviewUp.toggle()
        //adding data toggle functionality here
        HomeViewModel.shared.sortResult(priceUp, reviewUp, reviewCountUp)
        isLoaded.value = true
    }
    func reviewCountFilter(){
        reviewCountUp.toggle()
        //adding data toggle functionality here
        HomeViewModel.shared.sortResult(priceUp, reviewUp, reviewCountUp)
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
        HomeViewModel.shared.getSearchedGifs(searchedText, completion: {[weak self] success in
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
        HomeViewModel.shared.checkConnectivity(completion: {[weak self] havingInternet in
            if havingInternet{
                completion(true)
            }else{
                self?.error.value = true
            }
        })
    }
    
    private func getPreviewGifPath(_ indexPath: IndexPath) -> Item?{
        guard let gifs = HomeViewModel.shared.getGifResults() else{
            return nil
        }
        return gifs[indexPath.row]
    }
    
    private func getOriginalGifPath(_ indexPath: IndexPath) -> String{
        guard let gifs = HomeViewModel.shared.getGifResults() else{
            return ""
        }
        guard let path = gifs[indexPath.row].original else { return "" }
        return path
    }
    
    private func viewModelOfGif(_ indexPath: IndexPath) -> ItemViewModel{
        let item = getPreviewGifPath(indexPath)
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
