//
//  ImageTools.swift
//  PhotoFilter
//
//  Created by NK.
//

import CoreImage
import Foundation
import UIKit

protocol ImageToolsProtocol: class {
    var context: CIContext? { get set }
    var currentImageForProcessing: CIImage? { get set }
    var toolsForImages: CIFilter { get }
    var filterForImages: CIFilter? { get }
    func createFilterWithImage(_ image: UIImage)
    func createFilterForImages(withImage: UIImage, withFilter: String)
}

extension ImageToolsProtocol {
    func createFilterWithImage(_ image: UIImage) {
        guard let currentImage = currentImageForProcessing else {
            if let cgImage = image.cgImage {
                let ciImage = CIImage(cgImage: cgImage)
                toolsForImages.setValue(ciImage, forKey: kCIInputImageKey)
            }
            return
        }
        toolsForImages.setValue(currentImage, forKey: kCIInputImageKey)
    }
    
    func createInputImageWithImage(_ updatedImage: UIImage) {
        if let cgImage = updatedImage.cgImage {
            let ciImage = CIImage(cgImage: cgImage)
            toolsForImages.setValue(ciImage, forKey: kCIInputImageKey)
            currentImageForProcessing = ciImage
        }
    }
    
    func outputUIImage() -> UIImage? {
        if let outputImage = toolsForImages.outputImage {
            currentImageForProcessing = outputImage
            if let cgimg = context?.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                return processedImage
            }
        }
        return nil
    }
    
    func outputFilterIconImage() -> UIImage? {
        let outputFilterIcon = filterForImages?.outputImage
        return UIImage(ciImage: outputFilterIcon!)
    }
    
    func outputFilteredImage() -> UIImage? {
        let outputFilteredImage = filterForImages?.outputImage
        currentImageForProcessing = outputFilteredImage
        return UIImage(ciImage: outputFilteredImage!)
    }
}

class ImageTools : ImageContrastProtocol, ImageBrightnessProtocol, ImageSaturationProtocol {
    var currentImageForProcessing: CIImage?
    var filterForImages: CIFilter?
    var toolsForImages: CIFilter = CIFilter(name: "CIColorControls")!
    var context: CIContext? = CIContext()
    
    func createFilterForImages(withImage: UIImage, withFilter: String) {
        let ciImage =  CIImage(cgImage: withImage.cgImage!)
        filterForImages = CIFilter(name: withFilter)!
        filterForImages?.setValue(ciImage, forKey: kCIInputImageKey)
    }
}
