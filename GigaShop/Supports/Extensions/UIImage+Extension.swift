//
//  UIImage+Extension.swift
//  GigaShop

import Foundation
import UIKit

extension UIImage {
    class func imageFromData(_ data: Data) -> UIImage? {
        if let image = UIImage(data: data) {
            return image
        } else {
            // If unable to create UIImage from data, return nil
            return nil
        }
    }
}

