//
//  Image+Contrasts.swift
//  PhotoFilter
//
//  Created by NK.
//

import Foundation
import CoreImage

protocol ImageContrastProtocol: ImageToolsProtocol {
    var minContrastValue: Float { get }
    var maxContrastValue: Float { get }
    var currentContrastValue: Float { get }
    func contrast(_ contrast: Float)
}

extension ImageContrastProtocol {
    
    var minContrastValue: Float {
        0.00
    }
    
    var maxContrastValue: Float {
        4.00
    }
    
    var currentContrastValue: Float {
        toolsForImages.value(forKey: kCIInputContrastKey) as? Float ?? 1.00
    }
    
    func contrast(_ contrast: Float) {
        toolsForImages.setValue(contrast, forKey: kCIInputContrastKey)
    }
}
