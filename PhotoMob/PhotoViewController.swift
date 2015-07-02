//
//  PhotoViewController.swift
//  PhotoMob
//
//  Created by John Clem on 7/2/15.
//  Copyright © 2015 learnSwift.io. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var photo : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the photo, if available, to the image view
        imageView.image = photo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
