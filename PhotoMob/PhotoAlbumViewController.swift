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

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [UIImage]()
    var users = [User]()
    let thisUser = User()
    var imagePicker = UIImagePickerController()
    
    // View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UI Actions
    @IBAction func joinLocalMob(sender: UIBarButtonItem) {
        
        if sender.title == "Join Mob" {
            // startup network discovery
            self.startNearbyNetworking()
            // update the button title
            sender.title = "Leave Mob"
            // init the users array
            users = [User]()
            // add "this user" to the list of users
            users.append(thisUser)
            // reload the collectionView
            collectionView.reloadData()
            // update the header label
            self.title = "Local Mob - \(users.count) Users"
            // animate backdrop
            UIView.animateWithDuration(0.4, animations: {
                self.collectionView.backgroundColor = UIColor.lightGrayColor()
            })
        } else {
            // stop network discovery
            self.stopNearbyNetworking()
            // update the button title
            sender.title = "Join Mob"
            // re-initialize the users array
            users = [User]()
            // add "this user" back to the list of users
            users.append(thisUser)
            // reload the collectionView
            collectionView.reloadData()
            // update the header label
            self.title = "Local Mob - Disconnected"
            // animate backdrop
            UIView.animateWithDuration(0.4, animations: {
                self.collectionView.backgroundColor = UIColor.blackColor()
            })
        }
        
    }
    
    
    @IBAction func takePicture(sender: UIBarButtonItem) {

        // configure the imagePicker source type
        imagePicker.sourceType = .PhotoLibrary
        // set this class as the delegate
        imagePicker.delegate = self
        // present the picker
        self.presentViewController(imagePicker, animated: true) {
            print("presented image picker")
        }
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // check segue identifier
        if segue.identifier == "showPhotoView" {
            // ensure the destination class is PhotoViewController
            guard let destinationViewController = segue.destinationViewController as? PhotoViewController else { return }
            // get the selected photo index
            guard let selectedIndex = collectionView.indexPathsForSelectedItems()?.first else { return }
            // get the selected photo
            let selectedPhoto = photos[selectedIndex.row]
            // pass the selected photo to the photo view controller
            destinationViewController.photo = selectedPhoto
        }
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // request a reusable header from the collectionView
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "PhotosHeader", forIndexPath: indexPath) as! PhotosHeaderView
        
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
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // add the new image to the Photos array
        photos.append(image)
        // reload the collection view
        self.collectionView.reloadData()
        // dismiss the image picker
        picker.dismissViewControllerAnimated(true) {
            print("picked photo: \(image)")
        }
    }
    
    
    //MARK: Nearby Networking
    func startNearbyNetworking() {
        
    }
    
    func stopNearbyNetworking() {
        
    }

}

