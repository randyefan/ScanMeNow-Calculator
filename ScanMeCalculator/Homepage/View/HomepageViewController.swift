//
//  HomepageViewController.swift
//  ScanMeCalculator
//
//  Created by Randy Efan Jayaputra on 27/03/23.
//

import UIKit

class HomepageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var resourceImage: UIImage?
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupRightNavbarItem()
    }
    
    // MARK: - Private Function
    
    private func setupNavbar() {
        title = "Scan Me! Calculator"
        
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupRightNavbarItem() {
        let plusImage = UIImage(systemName: "plus")
        
        let plusButton = UIButton(type: .custom)
        plusButton.setImage(plusImage, for: .normal)
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        plusButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        let plusBarButtonItem = UIBarButtonItem(customView: plusButton)
        
        navigationItem.rightBarButtonItem = plusBarButtonItem
    }
    
}

// MARK: - @objc Func

extension HomepageViewController {
    @objc func didTapPlusButton() {
        #if GreenBuiltInCamera || RedBuiltInCamera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            // Handle Error
        }
        #elseif GreenCameraRoll || RedCameraRoll
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Handle Error
        }
        #endif
    }
}

// MARK: - ImagePickerControllerDelegate

extension HomepageViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        switch picker.sourceType {
        case .camera:
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            
            resourceImage = image
            
            dismiss(animated: true, completion: nil)
        case .photoLibrary:
            guard let selectedImage = info[.editedImage] as? UIImage else {
                return
            }
            
            resourceImage = selectedImage
            
            dismiss(animated: true, completion: nil)
        default: break
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}