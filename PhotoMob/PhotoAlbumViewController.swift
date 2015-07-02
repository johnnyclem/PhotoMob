//
//  ViewController.swift
//  PhotoMob
//
//  Created by John Clem on 7/2/15.
//  Copyright © 2015 learnSwift.io. All rights reserved.
//

import UIKit

class User {
    
}

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [UIImage]()
    var users = [User]()
    let thisUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func joinLocalMob(sender: UIBarButtonItem) {
        
        if sender.title == "Join Mob" {
            self.startNearbyNetworking()
            sender.title = "Leave Mob"
            print("joined local mob")
            users.append(thisUser)
        } else {
            self.stopNearbyNetworking()
            sender.title = "Join Mob"
            print("left local mob")
            
        }
        
    }
    
    
    @IBAction func takePicture(sender: UIBarButtonItem) {
        print("take picture")
        
        
    }
    
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // request a reusable header from the collectionView
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "PhotosHeader", forIndexPath: indexPath) as! PhotosHeaderView
        
        // update the header label
        header.titleLabel.text = "Local Mob - \(users.count) Users"
        
        // return the configured header
        return header
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return number of photos
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        // request a reusable cell from the collectionView
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        // set the image for the cell
        cell.imageView.image = photos[indexPath.row]
        
        // return the configured cell
        return cell
    }
    
    
    //MARK: Nearby Networking
    
    func startNearbyNetworking() {
        
    }
    
    func stopNearbyNetworking() {
        
    }

}

