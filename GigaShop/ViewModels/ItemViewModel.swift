//
//  ItemViewModel.swift
//  GigaShop
//
//

import Foundation
import UIKit

final class ItemViewModel{
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    private var image: UIImage?
    private var path: String?
    init(path: String? = nil) {
        self.path = path
    }
    
    private func gettingGifDataOf(completion: @escaping(Data?, Bool)->Void){
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
        gettingGifDataOf(completion: {[weak self] data, success in
            if let data = data{
                if let image = UIImage.gifImageWithData(data){
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
    
    func fetchGifImage(){
        isLoading.value = true
        gettingImageFromPath(completion: {[weak self] _ in
            self?.isLoading.value = false
        })
    }
    
    func getGifImage() -> UIImage?{
        if let image = self.image{
            return image
        }else{
            return nil
        }
    }
}
