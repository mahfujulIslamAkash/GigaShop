//
//  NetworkService.swift
//  GigaShop
//
//

import Foundation

final class NetworkService {
    
    // Singleton instance of NetworkService
    static var shared = NetworkService()
    
    // Base URL for API requests
    private let basePath: String = "https://api.doozie.shop/v1/items/search"
    
    // Default search text
    private let searchText: String = "shirt"
    
    // MARK: - Private Methods
    
    // Convert search text to HTTP body JSON data
    private func getHttpBodyfromJSON(_ searchText: String?) -> Data? {
        var jsonDictionary: [String: Any] = [
            "rakuten_query_parameters": ["keyword": "shirt"],
            "yahoo_query_parameters": ["query": "shirt"],
            "from_scheduler": false
        ]
        
        if let searchText = searchText {
            jsonDictionary = [
                "rakuten_query_parameters": ["keyword": searchText],
                "yahoo_query_parameters": ["query": searchText],
                "from_scheduler": false
            ]
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            return jsonData
        } catch {
            return nil
        }
    }
    // Construct URL request with HTTP body
    private func getURLRequest(_ searchFor: String?) -> URLRequest?{
        guard let url = URL(string: basePath) else { return nil }
        
        guard let httpBody = getHttpBodyfromJSON(searchFor) else{
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    // Parse response data for Product objects
    private func getResponse(_ searchFor: String?, completion: @escaping(_ success: Bool, _ result: [Product]?)-> Void){
        
        guard let request = getURLRequest(searchFor) else{
            completion(false, nil)
            return
        }
        let urlSession = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            
            if let _ = error{
                completion(false, nil)
            }else{
                if let data = data {
                    self?.parsingProducts(data: data, completion: {success, results  in
                        completion(success, results)
                    })
                }
                
            }

            
            
        })
        
        urlSession.resume()
        
        
    }
    
    // Handle response
    private func parsingProducts(data: Data?, completion: @escaping(_ success: Bool, [Product]?)-> Void){
        if let data = data{
            do {
                // Deserialize JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Accessing the entire JSON dictionary
                    if let dataArray = json["result"] as? [[String: Any]] {
                        if dataArray.isEmpty{
                            completion(false, nil)
                        }else{
                            var products: [Product] = []
                            for data in dataArray {
                                var product = Product()
                                if let id = data["item_id"] as? String{
                                    product.id = id
                                }
                                if let title = data["title"] as? String{
                                    product.title = title
                                }
                                if let description = data["description"] as? String{
                                    product.description = description
                                }
                                if let headline = data["headline"] as? String{
                                    product.headline = headline
                                }
                                if let review = data["review_average"] as? Double{
                                    product.review = review
                                }
                                if let reviewCount = data["review_count"] as? Int{
                                    product.reviewCount = reviewCount
                                }
                                if let price = data["price"] as? Double{
                                    product.price = price
                                }
                                if let currency = data["currency"] as? String{
                                    product.currency = currency
                                }
                                if let shopURL = data["shop_url"] as? String{
                                    product.shopPath = shopURL
                                }
                                if let productPath = data["item_url"] as? String{
                                    product.productPath = productPath
                                }
                                if let images = data["image_urls"] as? [String]{
                                    if !images.isEmpty{
                                        product.productImagePath = images[0]
                                    }
                                }
                                products.append(product)
                            }
                            completion(true, products)
                        }
                        
                        
                    }else {
                        //invalid data
                        completion(false, nil)
                    }
                } else {
                    //print("Invalid JSON format")
                    completion(false, nil)
                }
            } catch {
                //print("Error parsing JSON: \(error)")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Public Methods
        
    // Fetch searched products
    func getSearchedProductss(_ searchFor: String?, completion: @escaping(_ success: Bool,_ result: [Product]?)-> Void){
        getResponse(searchFor, completion: {success, result  in
            completion(success, result)
        })
    }
    
    // Fetch data from URL path
    func gettingDataOf(_ dataPath: String, completion: @escaping(Data?)->Void){
        if let url = URL(string: dataPath){
            var request = URLRequest(url: url)
            request.timeoutInterval = 180
            URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
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
    
    // Check internet connectivity
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
