//
//  File.swift
//  
//
//  Created by Jorge Alejandre on 12/12/18.
//

import Foundation
import UIKit
import Parse

class Post: PFObject, PFSubclassing {
    @NSManaged var media : PFFile
    @NSManaged var author: PFUser
    @NSManaged var caption: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Post"
    }
    
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        
        let post = Post()
        
        post.media = getPFFileFromImage(image: image)!
        post.author = PFUser.current()!
        if let caption = caption {
            post.caption = caption
        }
        post.likesCount = 0
        post.commentsCount = 0
        post.saveInBackground(block: completion)
        
        let vc = UIApplication.shared.keyWindow?.rootViewController?.children[0]
        if (vc?.isKind(of: HomeFeedViewController.self))! {
            
        }
        
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = image.pngData() {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
}

