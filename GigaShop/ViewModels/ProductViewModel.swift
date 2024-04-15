//
//  ItemViewModel.swift
//  GigaShop
//
//

import Foundation
import UIKit

final class ProductViewModel{
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    private var image: UIImage?
    private var path: String?
    let price: Double?
    let review: Double?
    let reviewCount: Int?
    
    init(product: Product? = nil) {
        self.path = product?.productImagePath
        self.price = product?.price
        self.review = product?.review
        self.reviewCount = product?.reviewCount
    }
    
    private func gettingDataFromPath(completion: @escaping(Data?, Bool)->Void){
        if let path = path{
            NetworkService.shared.gettingDataOf(path, completion: {data in
                if let data = data{
                    //success here
                    completion(data, true)
                }else{
                    completion(nil, false)
                }
            })
        }else{
            completion(nil, false)
        }
        
    }
    
    private func gettingImageFromPath(completion: @escaping(Bool)->Void){
        gettingDataFromPath(completion: {[weak self] data, success in
            if let data = data{
                if let image = UIImage.imageFromData(data){
                    self?.isLoaded.value = true
                    self?.image = image
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        })
    }
    
    func fetchImage(){
        isLoading.value = true
        gettingImageFromPath(completion: {[weak self] _ in
            self?.isLoading.value = false
        })
    }
    
    func getImage() -> UIImage?{
        if let image = self.image{
            return image
        }else{
            return nil
        }
    }
    
    
}
