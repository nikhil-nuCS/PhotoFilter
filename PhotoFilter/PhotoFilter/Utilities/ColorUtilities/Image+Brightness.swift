//
//  Image+Brightness.swift
//  PhotoFilter
//
//  Created by NK.
//

import Foundation


import CoreImage

protocol ImageBrightnessProtocol: ImageToolsProtocol {
    var minBrightnessValue: Float { get }
    var maxBrightnessValue: Float { get }
    var currentBrightnessValue: Float { get }
    func brightness(_ brightness: Float)
}

extension ImageBrightnessProtocol {
    
    var minBrightnessValue: Float {
        -1.00
    }
    
    var maxBrightnessValue: Float {
        1.00
    }
    
    var currentBrightnessValue: Float {
        toolsForImages.value(forKey: kCIInputBrightnessKey) as? Float ?? 0.00
    }
    
    func brightness(_ brightness: Float) {
        toolsForImages.setValue(brightness, forKey: kCIInputBrightnessKey)
    }
}
