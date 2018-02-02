//
//  AddJobViewController.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import AVFoundation
import Toucan

class AddJobViewController: UITableViewController {
    
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var jobDescription: UITextView!
    @IBOutlet weak var photoLibraryButtonItem: UIBarButtonItem!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var jobImage: UIImageView!
    
    private let imagePickerViewController = UIImagePickerController()
    
    private var currentSelectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButtonItem.isEnabled = false
        }
    }
    
    public static func storyboardInstance() -> AddJobViewController {
        let storyboard = UIStoryboard(name: "AddJob", bundle: nil)
        let addJobViewController = storyboard.instantiateViewController(withIdentifier: "AddJobViewController") as! AddJobViewController
        return addJobViewController
    }
    
    @IBAction func showPhotoLibrary(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .photoLibrary
        checkAVAuthorization()
    }
    
    @IBAction func showCamera(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .camera
        checkAVAuthorization()
    }
    
    private func checkAVAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.showImagePicker()
                } else {
                    print("not granted")
                }
            })
        case .denied:
            print("denied")
        case .authorized:
            print("authorized")
            showImagePicker()
        case .restricted:
            print("restricted")
        }
    }
    
    private func showImagePicker() {
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: UIBarButtonItem) {
        guard let image = currentSelectedImage else { print("don't have an image"); return }
        // create job
        DBService.manager.addJob(title: "Need Swift Help", description: "I am struggling with closures", image: image)
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddJobViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { print("image is nil"); return }
        jobImage.image = image
        
        // resize the image
        let sizeOfImage: CGSize = CGSize(width: 200, height: 200)
        let toucanImage = Toucan.Resize.resizeImage(image, size: sizeOfImage)
        
        currentSelectedImage = toucanImage
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
