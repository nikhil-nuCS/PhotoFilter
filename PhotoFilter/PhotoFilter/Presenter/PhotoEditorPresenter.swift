//
//  PhotoEditorPresenter.swift
//  PhotoFilter
//
//  Created by NK.
//
import Foundation
import UIKit

internal protocol PhotoEditorPresenterProtocol {
    func getFilterNameList() -> [String]
    func getFilterName(forIndex index: Int) -> String
    func getFilterDisplayName(forIndex index: Int) -> String
    func resizeImageForFilterPreviewCell(image: UIImage) -> UIImage?
    func getFilteredImage(forFilterIndex filterIndex: Int, forImage image: UIImage?, isIcon: Bool) -> UIImage?
    func createFilteredImage(forFilterIndex filterIndex: Int,forImage image: UIImage) -> UIImage?
    func createFilteredImageIcon(forFilterIndex filterIndex: Int, forImage image: UIImage) -> UIImage?
    func handleImageToolsSliderValueChanged(withValue value: Float, forSliderTag: Int) -> UIImage?
    func saveEditedImageToGallery(for image: UIImage)
}

internal class PhotoEditorPresenter: BasePresenter, PhotoEditorPresenterProtocol {
    let resizeRatio = Constants.Details.resizeRatio
    private let filterName = Constants.Filter.filterNameList
    private let filterDisplayName = Constants.Filter.filterDisplayNameList
    private var imageToolsUtility: ImageTools
    
    init(viewController: UIViewController?, imageTools: ImageTools) {
        imageToolsUtility = imageTools
        super.init(viewController: viewController)
    }

    func resizeImageForFilterPreviewCell(image: UIImage) -> UIImage? {
        let resizedSize = CGSize(width: Int(image.size.width * resizeRatio), height: Int(image.size.height * resizeRatio))
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? nil
    }
    
    func getFilterName(forIndex index: Int) -> String {
        filterName[index]
    }
    
    func getFilterNameList() -> [String] {
        filterName
    }
    
    func getFilterDisplayName(forIndex index: Int) -> String {
        filterDisplayName[index]
    }
    
    
    func createFilteredImage(forFilterIndex filterIndex: Int, forImage image: UIImage) -> UIImage? {
        imageToolsUtility.createFilterForImages(withImage: image, withFilter: getFilterName(forIndex: filterIndex))
        return imageToolsUtility.outputFilteredImage()
    }
    
    func createFilteredImageIcon(forFilterIndex filterIndex: Int, forImage image: UIImage) -> UIImage? {
        imageToolsUtility.createFilterForImages(withImage: image, withFilter: getFilterName(forIndex: filterIndex))
        return imageToolsUtility.outputFilterIconImage()
    }


    func getFilteredImage(forFilterIndex filterIndex: Int, forImage image: UIImage?, isIcon: Bool) -> UIImage? {
        if let preFilteredImage = image {
            if isIcon {
                return createFilteredImageIcon(forFilterIndex: filterIndex, forImage: preFilteredImage)
            } else {
                return createFilteredImage(forFilterIndex: filterIndex, forImage: preFilteredImage)
            }
        }
        return nil
    }
    
    func handleImageToolsSliderValueChanged(withValue value: Float, forSliderTag: Int) -> UIImage? {
        switch forSliderTag {
        case 0:
            imageToolsUtility.brightness(value)
        case 1:
            imageToolsUtility.contrast(value)
        case 2:
            imageToolsUtility.saturation(value)
        default:
            print("Invalid slider tag received")
        }
        return imageToolsUtility.outputUIImage()
    }
    
    func saveEditedImageToGallery(for image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }

    func showAlertWith(title: String, message: String){
        guard let viewController = presenterBaseViewController as? PhotoEditorViewController else {
            return
        }
        let uiAlert = UIAlertController(title: "Saved", message: "Your image has been saved to your photos", preferredStyle: .alert)
        let uiAlertAction = UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
            viewController.navigationController?.popViewController(animated: true)
        })
        uiAlert.addAction(uiAlertAction)
        viewController.present(uiAlert, animated: true, completion: nil)
    }
}
