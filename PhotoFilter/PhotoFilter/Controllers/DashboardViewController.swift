//
//  ViewController.swift
//  PhotoFilter
//
//  Created by NK.
//

import UIKit

class DashboardViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var launchGalleryCard: UIView!
    @IBOutlet weak var launchSampleImageCard: UIView!
    var loadingVIew: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        let tapActionOnGallery = UITapGestureRecognizer(target: self, action: #selector(handleGalleryTapAction))
        launchGalleryCard.addGestureRecognizer(tapActionOnGallery)
        let tapActionOnSampleImage = UITapGestureRecognizer(target: self, action: #selector(handleDemoCardAction))
        launchSampleImageCard.addGestureRecognizer(tapActionOnSampleImage)
        title = "Dashboard"
    }
    
    @objc
    func handleDemoCardAction() {
        let sampleImage = UIImage(named: Constants.Images.SAMPLE_IMAGE)
        navigateToFilterEditorViewController(withImage: sampleImage, withDelay: 0.0)
    }
    
    
    @objc
    func handleGalleryTapAction() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        showSpinner()
        dismiss(animated:true, completion: nil)
        navigateToFilterEditorViewController(withImage: selectedImage, withDelay: 0.5)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        removeSpinnerView()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSpinner() {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        ai.color = .white
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.view.addSubview(spinnerView)
        }
        loadingVIew = spinnerView
    }
    
    func removeSpinnerView() {
        DispatchQueue.main.async {
            self.loadingVIew?.removeFromSuperview()
            self.loadingVIew = nil
        }
    }
    
    func navigateToFilterEditorViewController(withImage imageToEdit: UIImage?, withDelay: Double) {
        let storyboard = UIStoryboard(name: Constants.XIB.MAIN_BUNDLE, bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerID.PHOTO_EDITOR_VC_ID)
        guard let photoEditorViewController = viewcontroller as? PhotoEditorViewController else {
            return
        }
        photoEditorViewController.originalImage = imageToEdit
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + withDelay, execute: {
            self.removeSpinnerView()
            self.navigationController?.pushViewController(photoEditorViewController, animated: true)
        })
    }
}

