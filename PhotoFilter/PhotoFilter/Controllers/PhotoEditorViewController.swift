//
//  GalleryViewController.swift
//  PhotoFilter
//
//  Created by NK.
//

import Foundation
import UIKit

class PhotoEditorViewController : UIViewController, CropViewControllerDelegate {
    private var currentFilterSelectedIndex = 0
    private let context = CIContext(options: nil)
    var originalImage: UIImage?
    var filterPreviewCellImage: UIImage?
    var filter: CIFilter?
    var presenter: PhotoEditorPresenterProtocol?
    var imageTools = ImageTools()
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cropOptionButton: UIButton!
    @IBOutlet weak var saveOptionButton: UIButton!
    @IBOutlet weak var brightnessSlider: PFSlider!
    @IBOutlet weak var contrastSlider: PFSlider!
    @IBOutlet weak var saturationSlider: PFSlider!
    @IBOutlet weak var editingWorkArea: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PhotoEditorPresenter(viewController: self, imageTools: imageTools)
        setupUI()
        registerUI()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        editingWorkArea.layer.cornerRadius = 15.0
        editingWorkArea.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setupUI() {
        guard let currentPreviewImage = originalImage else {
            return
        }
        previewImageView.image = currentPreviewImage
        imageTools.createFilterWithImage(currentPreviewImage)
        filterPreviewCellImage = presenter?.resizeImageForFilterPreviewCell(image: currentPreviewImage) ?? currentPreviewImage
        title = "Editor"
    }
    
    func configureUI() {
        let kRedColor = Constants.Design.Color.PHOTO_EDITOR_BTN_COLOR
        
        let cropOptionIcon = UIImage(named: Constants.Images.ICON_CROP, in: .main, with: nil)?.withRenderingMode(.alwaysTemplate)
        cropOptionButton.setImage(cropOptionIcon, for: .normal)
        cropOptionButton.setTitleColor(kRedColor, for: .normal)
        cropOptionButton.tintColor = kRedColor
        
        let saveOptionIcon = UIImage(named: Constants.Images.ICON_SAVE, in: .main, with: nil)?.withRenderingMode(.alwaysTemplate)
        saveOptionButton.setImage(saveOptionIcon, for: .normal)
        saveOptionButton.setTitleColor(kRedColor, for: .normal)
        saveOptionButton.tintColor = kRedColor
        
        brightnessSlider.minimumTrackTintColor = .red
        brightnessSlider.maximumTrackTintColor = .gray
        brightnessSlider.setThumbImage(UIImage(named: Constants.Images.SLIDER_THUMB), for: .normal)
        brightnessSlider.setThumbImage(UIImage(named: Constants.Images.SLIDER_THUMB), for: .highlighted)
        brightnessSlider.isContinuous = false
        
        contrastSlider.minimumTrackTintColor = .red
        contrastSlider.maximumTrackTintColor = .gray
        contrastSlider.setThumbImage(UIImage(named: Constants.Images.SLIDER_THUMB), for: .normal)
        contrastSlider.setThumbImage(UIImage(named: Constants.Images.SLIDER_THUMB), for: .highlighted)
        contrastSlider.isContinuous = false

        
        saturationSlider.minimumTrackTintColor = .red
        saturationSlider.maximumTrackTintColor = .gray
        saturationSlider.setThumbImage(UIImage(named: Constants.Images.SLIDER_THUMB), for: .normal)
        saturationSlider.setThumbImage(UIImage(named: Constants.Images.SLIDER_THUMB), for: .highlighted)
        saturationSlider.isContinuous = false
    }
    
    func setupSlidersUI() {
        DispatchQueue.main.async {
            self.brightnessSlider.maximumValue = self.imageTools.maxBrightnessValue
            self.brightnessSlider.minimumValue = self.imageTools.minBrightnessValue
            self.brightnessSlider.value = 0
            
            self.contrastSlider.maximumValue = self.imageTools.maxContrastValue
            self.contrastSlider.minimumValue = self.imageTools.minContrastValue
            self.contrastSlider.value = 2

            self.saturationSlider.maximumValue = self.imageTools.maxSaturationValue
            self.saturationSlider.minimumValue = self.imageTools.minSaturationValue
            self.saturationSlider.value = 1
        }
    }
    
    func registerUI() {
        let nib = UINib(nibName: Constants.XIB.FILTER_COLLECTION_CELL, bundle: Bundle(for: self.classForCoder))
        collectionView?.register(nib, forCellWithReuseIdentifier: Constants.XIB.FILTER_COLLECTION_CELL_ID)
    }
    
    @IBAction func cropIt(_ sender: Any) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = previewImageView.image
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func saveImage(_ sender: Any) {
        guard let imageToSave = imageTools.outputUIImage() else {
            return
        }
        presenter?.saveEditedImageToGallery(for: imageToSave)
    }

    @IBAction func sliderValueChanged(_ sender: PFSlider) {
        let updatedImage = presenter?.handleImageToolsSliderValueChanged(withValue: sender.value, forSliderTag: sender.tag)
        if let image = updatedImage {
            previewImageView.image = image
        }
    }
    
    func applyFilterWithSelectedFilter(withIndex: Int) {
        let currentImage = originalImage
        if let filteredImage = presenter?.getFilteredImage(forFilterIndex: withIndex, forImage: currentImage, isIcon: false) {
            previewImageView.image = filteredImage
            imageTools.createFilterWithImage(filteredImage)
            setupSlidersUI()
        }
    }
}

extension PhotoEditorViewController {
    func cropViewDidFinishCropping(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        previewImageView.image = image
        originalImage = image
        imageTools.createInputImageWithImage(image)
        setupSlidersUI()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func cropViewControllerCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension PhotoEditorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.XIB.FILTER_COLLECTION_CELL_ID, for: indexPath) as? FilterImageCollectionCell else {
            return UICollectionViewCell()
        }
        var filteredCellImage = filterPreviewCellImage
        if indexPath.row != 0, let unfilteredImage = filteredCellImage {
            filteredCellImage = presenter?.createFilteredImageIcon(forFilterIndex: indexPath.row, forImage: unfilteredImage)
        }
        cell.imagePreviewView.image = filteredCellImage
        cell.imagePreviewView.layer.borderWidth = 1.5
        cell.imagePreviewView.layer.borderColor = UIColor.red.cgColor
        cell.imagePreviewView.layer.cornerRadius = cell.imagePreviewView.frame.height / 2
        cell.imagePreviewView.layer.masksToBounds = true
        cell.filterName.text = presenter?.getFilterDisplayName(forIndex: indexPath.row)
        if indexPath.row == 0 {
            cell.updateTextForSelectedCell()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            return Constants.Filter.FILTER_COUNT
        }
        return presenter.getFilterNameList().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentFilterSelectedIndex = indexPath.row
        if currentFilterSelectedIndex != 0 {
            applyFilterWithSelectedFilter(withIndex: indexPath.row)
        } else {
            previewImageView?.image = originalImage
        }
        updateFilterCellFont()
        scrollCollectionViewToIndex(itemIndex: indexPath.item)
    }
    
    func updateFilterCellFont() {
        guard let presenter = presenter else {
            return
        }
        let filterNameList = presenter.getFilterNameList()
        for i in 0...filterNameList.count - 1 {
            guard let filterPreviewCell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? FilterImageCollectionCell else {
                return
            }
            if i != currentFilterSelectedIndex {
                filterPreviewCell.updateTextForUnselectedCell()
            } else {
                filterPreviewCell.updateTextForSelectedCell()
            }
        }
    }
    
    func scrollCollectionViewToIndex(itemIndex: Int) {
        let indexPath = IndexPath(item: itemIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

