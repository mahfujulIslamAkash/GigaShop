//
//  NetworkService.swift
//  GigaShop
//
//

import Foundation
import UIKit

#warning("Here I implemented 2 API providers because I was getting some warning from gify, thats why I added 2nd one for testing purposes")

final class NetworkService{
    static var shared = NetworkService()
    private let providerType: ProviderType = .gify
    private lazy var basePath: String = providerType == .gify ? "https://api.giphy.com/v1/gifs/search?api_key=229ac3e932794695b695e71a9076f4e5&limit=25&offset=0&rating=G&lang=en&q=" : "https://g.tenor.com/v1/search?q="
    private let searchText: String = "Trending"
    private var result: [Item]?
    
    
    private func getPath(_ searchText: String?) -> String{
        if let text = searchText{
            if providerType == .gify{
                return basePath+text
            }else{
                return basePath+text+"&key=LIVDSRZULELA"
            }
            
        }
        else{
            //Default path
            if providerType == .gify{
                return basePath+self.searchText
            }else{
                return basePath+self.searchText+"&key=LIVDSRZULELA"
            }
            
        }
    }
    
    //MARK: Respose for gify, tenor
    private func getResponse(_ searchFor: String?, completion: @escaping(_ success: Bool)-> Void){
        guard let url = URL(string: getPath(searchFor)) else{
            return
        }
        let ulrRequest = URLRequest(url: url)
        let urlSession = URLSession.shared.dataTask(with: ulrRequest, completionHandler: { [weak self] data, response, error in
            
            if let _ = error{
                completion(false)
            }else{
                if self?.providerType == .gify{
                    self?.parsingForGify(data: data, completion: {result in
                        completion(result)
                    })
                }else{
                    self?.parsingForTenor(data: data, completion: {result in
                        completion(result)
                    })
                }
            }

            
            
        })
        
        urlSession.resume()
    }
    
    //MARK: Gify Data fetch using JSONSerialization
    private func parsingForGify(data: Data?, completion: @escaping(_ success: Bool)-> Void){
        if let data = data{
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["data"] as? [[String: Any]] {
                        if dataArray.isEmpty{
                            completion(false)
                        }else{
                            var gifs: [Item] = []
                            for data in dataArray {
                                var gif = Item()
                                if let id = data["id"] as? String{
                                    gif.id = id
                                }
                                if let url = data["url"] as? String{
                                    gif.url = url
                                }
                                if let image = data["images"] as? [String: Any]{
                                    if let original = image["original"] as? [String: Any]{
                                        if let url = original["url"] as? String{
                                            gif.original = url
                                        }
                                    }
                                    
                                    if let preview = image["preview_gif"] as? [String: Any]{
                                        if let url = preview["url"] as? String{
                                            gif.placeHolder = url
                                        }
                                    }
                                    
                                    
                                }
                                gifs.append(modified(gif))
                            }
                            result = gifs
                            completion(true)
                        }
                        
                        
                    }else {
                        //invalid data
                        completion(false)
                    }
                } else {
                    //print("Invalid JSON format")
                    completion(false)
                }
            } catch {
                //print("Error parsing JSON: \(error)")
                completion(false)
            }
        }
    }
    
    //MARK: Tenor Data fetch using JSONSerialization
    private func parsingForTenor(data: Data?, completion: @escaping(_ success: Bool)-> Void){
        if let data = data{
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["results"] as? [[String: Any]] {
                        if dataArray.isEmpty{
                            completion(false)
                        }else{
                            var gifs: [Item] = []
                            for data in dataArray {
                                var gif = Item()
                                if let id = data["id"] as? String{
                                    gif.id = id
                                }
                                if let url = data["url"] as? String{
                                    gif.url = url
                                }
                                if let medias = data["media"] as? [[String: Any]]{
                                    for media in medias{
                                        if let nanoGif = media["nanogif"] as? [String: Any]{
                                            if let previewUrl = nanoGif["url"] as? String{
                                                gif.placeHolder = previewUrl
                                            }
                                        }
                                        
                                        if let gifObjc = media["gif"] as? [String: Any]{
                                            if let originalUrl = gifObjc["url"] as? String{
                                                gif.original = originalUrl
                                            }
                                        }
                                    }
                                    
                                    
                                }
                                gifs.append(modified(gif))
                            }
                            result = gifs
                            completion(true)
                        }
                        
                        
                    }else {
                        //invalid data
                        completion(false)
                    }
                } else {
                    //print("Invalid JSON format")
                    completion(false)
                }
            } catch {
                //print("Error parsing JSON: \(error)")
                completion(false)
            }
        }
    }
    
    //This func will be called by the VM
    func getSearchedGifs(_ searchFor: String?, completion: @escaping(_ success: Bool)-> Void){
        getResponse(searchFor, completion: {success in
            completion(success)
        })
    }
    
    //This func will be called by the VM
    func getGifResults()->[Item]?{
        return result
    }
    
//    func sortResult(_ highReview: Bool, _ lowPrice: Bool, _ highReviewCount: Bool) {
//        if var result = result {
//            result.sort { (item1, item2) in
//                // Sort by review count
//                if item1.reviewCount == item2.reviewCount {
//                    // If review count is the same, sort by review
//                    if item1.review == item2.review {
//                        // If review is the same, sort by price
//                        return lowPrice ? (item1.price ?? 0.0 < item2.price ?? 0.0) : (item1.price ?? 0.0 > item2.price ?? 0.0)
//                    } else {
//                        // Sort by review
//                        return highReview ? (item1.review ?? 0.0 > item2.review ?? 0.0) : (item1.review ?? 0.0 < item2.review ?? 0.0)
//                    }
//                } else {
//                    // Sort by review count
//                    return highReviewCount ? (item1.reviewCount ?? 0 > item2.reviewCount ?? 0) : (item1.reviewCount ?? 0 < item2.reviewCount ?? 0)
//                }
//            }
//            
//            // Update the result array
//            self.result = result
//        }
//    }
    func sortResult(_ highPrice: Bool, _ highReview: Bool, _ highReviewCount: Bool) {
        if var result = result {
            // Sort by price
            if highPrice {
                result.sort { $0.price ?? 0.0 > $1.price ?? 0.0 }
            } else {
                result.sort { $0.price ?? 0.0 < $1.price ?? 0.0 }
            }
            
            // Sort by review
            if highReview {
                result.sort { $0.review ?? 0.0 > $1.review ?? 0.0 }
            } else {
                result.sort { $0.review ?? 0.0 < $1.review ?? 0.0 }
            }
            
            // Sort by review count
            if highReviewCount {
                result.sort { $0.reviewCount ?? 0 > $1.reviewCount ?? 0 }
            } else {
                result.sort { $0.reviewCount ?? 0 < $1.reviewCount ?? 0 }
            }
            
            // Update the result array
            self.result = result
        }
    }


    
    func modified(_ main: Item)-> Item{
        var item = main
        item.price = ((Double.random(in: 10..<1000)*100).rounded())/100
        item.review = ((Double.random(in: 0..<5)*100).rounded())/100
        item.reviewCount = Int.random(in: 0..<1000)
        return item
    }
    
    //This function fetch the data from URL_path
    //Using for fetching gif file data
    //This func will be called by the VM
    func gettingDataOf(_ dataPath: String, completion: @escaping(Data?)->Void){
        if let url = URL(string: dataPath){
            URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
                if let _ = error{
                    completion(nil)
                }else{
                    if let data = data{
                        completion(data)
                    }else{
                        completion(nil)
                    }
                    
                }
            }).resume()
        }else{
            completion(nil)
        }
    }
    
    //This func is helping to detect internet connection
    func checkConnectivity(completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "https://www.apple.com") else {
                completion(false) // Invalid URL
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    // Error occurred, indicating no internet connection
                    completion(false)
                } else {
                    // No error, internet connection is available
                    completion(true)
                }
            }
            task.resume()
        }
     
}

//MARK: Provider Type
enum ProviderType{
    case gify
    case tenor
}
