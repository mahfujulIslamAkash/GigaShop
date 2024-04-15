//
//  ItemViewModel.swift
//  GigaShop
//
//

import Foundation
import UIKit

final class ProductViewModel{
    //Observers
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    
    private var image: UIImage?
    private let product: Product?
    
    init(product: Product? = nil) {
        self.product = product
    }
    
    func getPrice() -> String{
        if let price = product?.price, let currency = product?.currency{
            return price.asString() + currency.uppercased()
        }else{
            return "Free"
        }
        
    }
    func getReview() -> String{
        if let review = product?.review{
            return review.asString()
        }else{
            return "0.0"
        }
    }
    
    func getTotalReviews() -> String{
        if let reviews = product?.reviewCount{
            return reviews.asString()
        }else{
            return "0.0"
        }
    }
    
    func getTitle() -> String{
        if let title = product?.title{
            return title
        }else{
            return "N/A"
        }
    }
    func getDescription() -> String{
        if let description = product?.description{
            return description
        }else{
            return "N/A"
        }
    }
    
    private func gettingDataFromPath(completion: @escaping(Data?, Bool)->Void){
        if let path = product?.productImagePath{
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
