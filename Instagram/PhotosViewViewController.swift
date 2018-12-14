//
//  PhotosViewViewController.swift
//  Instagram
//
//  Created by Jorge Alejandre on 12/9/18.
//  Copyright © 2018 Jorge Alejandre. All rights reserved.
//

import UIKit
import Parse

class PhotosViewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickedPhoto: UIImageView!
    @IBOutlet weak var imageCaption: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)


        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the image captured by the UIImagePickerController
        guard let originalImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Do something with the images (based on your use case)
        pickedPhoto.image = originalImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
         self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
    }
    
    
    @IBAction func onShare(_ sender: Any) {
        Post.postUserImage(image: pickedPhoto.image, withCaption: imageCaption.text) {( success: Bool, error: Error?) in
            if success {
                print("Post Success")
            } else {
                print("Posting error: \(error!.localizedDescription)")
            }
        }
        self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
