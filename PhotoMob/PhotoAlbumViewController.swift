//
//  ViewController.swift
//  PhotoMob
//
//  Created by John Clem on 7/2/15.
//  Copyright © 2015 learnSwift.io. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func joinLocalMob(sender: UIBarButtonItem) {
        print("join local mob")
    }
    
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        print("take picture")
    }
}

