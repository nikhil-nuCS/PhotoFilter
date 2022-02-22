//
//  FilterCollectionView.swift
//  PhotoFilter
//
//  Created by NK.
//

import Foundation
import UIKit

class FilterImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var imagePreviewView: UIImageView!
    
    func updateTextForSelectedCell() {
        filterName.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func updateTextForUnselectedCell() {
        filterName.font = UIFont.systemFont(ofSize: 14.0, weight: .thin)
    }
}
