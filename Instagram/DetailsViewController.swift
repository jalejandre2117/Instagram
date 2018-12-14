//
//  DetailsViewController.swift
//  Instagram
//
//  Created by Jorge Alejandre on 12/13/18.
//  Copyright © 2018 Jorge Alejandre. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoCaption: UILabel!
    @IBOutlet weak var photoDate: UILabel!
    
    var post: Post?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let post = post {
            let image = post.media
            image.getDataInBackground(block: {(data, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                } else {
                    print("Image was found!")
                    self.photoImage.image = UIImage(data: data!)
                }
            })
            photoCaption.text = post.caption
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM d, yyyy h:mm a"
            photoDate.text = dateFormatterPrint.string(from: post.createdAt!)
            
            
        }

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
