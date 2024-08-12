//
//  UIImage+Extension.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 12.08.2024.
//

import UIKit
import CoreImage

extension UIImage {
    func blurredImage(radius: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let outputImage = filter?.outputImage else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
