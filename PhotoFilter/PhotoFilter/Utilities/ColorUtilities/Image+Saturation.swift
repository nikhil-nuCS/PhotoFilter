//
//  Image+Saturation.swift
//  PhotoFilter
//
//  Created by NK.
//

import Foundation
import CoreImage

protocol ImageSaturationProtocol : ImageToolsProtocol {
    var minSaturationValue: Float { get }
    var maxSaturationValue: Float { get }
    var currentSaturationValue: Float { get }
    func saturation(_ saturation: Float)
}

extension ImageSaturationProtocol {
    
    var minSaturationValue: Float {
        0.00
    }
    
    var maxSaturationValue: Float {
        2.00
    }
    
    var currentSaturationValue: Float {
        toolsForImages.value(forKey: kCIInputSaturationKey) as? Float ?? 1.00
    }
    
    func saturation(_ saturation: Float) {
        toolsForImages.setValue(saturation, forKey: kCIInputSaturationKey)
    }
}

