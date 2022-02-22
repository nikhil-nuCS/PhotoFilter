//
//  PFSlider.swift
//  PhotoFilter
//
//  Created by NK
//

import Foundation
import UIKit

class PFSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 3.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}
