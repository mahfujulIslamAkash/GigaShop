//
//  ItemViewModel.swift
//  GigaShop
//
//

import Foundation
import UIKit

final class ProductViewModel {
    // Observers for tracking loading state
    var isLoaded: ObservableObject<Bool> = ObservableObject(false)
    var isLoading: ObservableObject<Bool> = ObservableObject(true)
    
    // Image and product instance
    private var image: UIImage?
    private let product: Product?
    
    // Initializer with optional product parameter
    init(product: Product? = nil) {
        self.product = product
    }
    
    // MARK: - Data Access Methods
    
    // Get formatted price string
    func getPrice() -> String {
        if let price = product?.price, let currency = product?.currency {
            return price.asString() + currency.uppercased()
        } else {
            return "Free"
        }
    }
    
    // Get formatted review rating string
    func getReview() -> String {
        if let review = product?.review {
            return review.asString()
        } else {
            return "0.0"
        }
    }
    
    // Get formatted total reviews string
    func getTotalReviews() -> String {
        if let reviews = product?.reviewCount {
            return reviews.asString()
        } else {
            return "0.0"
        }
    }
    
    // Get product title or default if not available
    func getTitle() -> String {
        if let title = product?.title {
            return title
        } else {
            return "N/A"
        }
    }
    
    // Get product description or default if not available
    func getDescription() -> String {
        if let description = product?.description {
            return description
        } else {
            return "N/A"
        }
    }
    
    // Get product's link/url
    func getProductLink() -> String? {
        if let path = product?.productPath {
            return path
        } else {
            return nil
        }
    }
    
    // MARK: - Image Fetching
    
    // Fetch image data from the network
    private func getDataFromPath(completion: @escaping (Data?, Bool) -> Void) {
        if let path = product?.productImagePath {
            NetworkService.shared.gettingDataOf(path) { data in
                if let data = data {
                    // Success
                    completion(data, true)
                } else {
                    completion(nil, false)
                }
            }
        } else {
            completion(nil, false)
        }
    }
    
    // Fetch image from the network and handle loading state
    private func getImageFromPath(completion: @escaping (Bool) -> Void) {
        getDataFromPath { [weak self] data, success in
            if let data = data {
                if let image = UIImage.imageFromData(data) {
                    self?.isLoaded.value = true
                    self?.image = image
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    // Fetch image and update loading state
    func fetchImage() {
        isLoading.value = true
        getImageFromPath { [weak self] _ in
            self?.isLoading.value = false
        }
    }
    
    // Get the fetched image
    func getImage() -> UIImage? {
        return image
    }
    // Get the placeholder image
    func getPlaceholder() -> UIImage {
        return UIImage()
    }
    
    //MARK: Copy link
    func copyToClipboard() {
        if let path = getProductLink(){
            UIView.shared.copyToClipboard(path)
        }else{
            showingErrorToast("Invalid link")
        }
        
    }
    // Function to display an error toast message
    func showingErrorToast(_ message: String = "Error") {
        DispatchQueue.main.async {
            UIView.shared.showingToast(message)
        }
    }
    
    func tryingToOpenBrowser(){
        if let link = getProductLink(){
            if let url = URL(string: link) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Unable to open URL: \(url)")
                }
            } else {
                print("Invalid URL: \(link)")
            }
        }else{
            showingErrorToast("Unable to open")
        }
    }
}
