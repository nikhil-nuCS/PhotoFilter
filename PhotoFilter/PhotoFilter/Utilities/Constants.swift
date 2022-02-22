//
//  Constants.swift
//  PhotoFilter
//
//  Created by NK.
//

import Foundation
import UIKit

struct Constants {
    struct Filter {
        static let FILTER_COUNT = 11
        static let filterNameList = [
            "No Filter",
            "CIPhotoEffectChrome",
            "CIPhotoEffectFade",
            "CIPhotoEffectInstant",
            "CIPhotoEffectMono",
            "CIPhotoEffectNoir",
            "CIPhotoEffectProcess",
            "CIPhotoEffectTonal",
            "CIPhotoEffectTransfer",
            "CILinearToSRGBToneCurve",
            "CISRGBToneCurveToLinear"
        ]
        
        static let filterDisplayNameList = [
            "Normal",
            "Chrome",
            "Fade",
            "Instant",
            "Mono",
            "Noir",
            "Process",
            "Tonal",
            "Transfer",
            "Tone",
            "Linear"
        ]
    }
    
    struct ViewControllerID {
        static let PHOTO_EDITOR_VC_ID = "PhotoEditorViewControllerID"
        static let CROP_VC_ID = ""
        
    }
    
    struct XIB {
        static let MAIN_BUNDLE = "Main"
        static let FILTER_COLLECTION_CELL = "FilterImageCollectionCell"
        static let FILTER_COLLECTION_CELL_ID = "FilterPreviewCollectionCellID"
    }
    
    struct Details {
        static let resizeRatio: CGFloat = 0.3
    }
    
    struct Design {
        struct Color {
            static let PHOTO_EDITOR_BTN_COLOR = UIColor(red: 1, green: 81/255, blue: 81/255, alpha: 1)
        }
    }
    
    struct Images {
        static let ICON_CROP = "icon_crop"
        static let ICON_SAVE = "icon_save"
        static let SLIDER_THUMB = "sliderThumb"
        static let SAMPLE_IMAGE = "sample_image"
    }
}
