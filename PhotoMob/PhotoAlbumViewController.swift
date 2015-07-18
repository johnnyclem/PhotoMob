//
//  ViewController.swift
//  PhotoMob
//
//  Created by John Clem on 7/2/15.
//  Copyright © 2015 learnSwift.io. All rights reserved.
//  https://github.com/johnnyclem/PhotoMob
//

import UIKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PLPartyTimeDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [UIImage]()
    var imagePicker = UIImagePickerController()
    
    var peers = [MCPeerID]()
    
    // View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var partyTime = PLPartyTime(serviceType: "com-ga-photoMob")
    
    // UI Actions
    @IBAction func joinLocalMob(sender: UIBarButtonItem) {
        
        if sender.title == "Join Mob" {
            // start advertising
            partyTime.delegate = self
            partyTime.joinParty()
            // update the button title
            sender.title = "Leave Mob"
            // reload the collectionView
            collectionView.reloadData()
            // update the header label
            self.title = "Local Mob - \(peers.count + 1) Users"
            // animate backdrop
            UIView.animateWithDuration(0.4, animations: {
                self.collectionView.backgroundColor = UIColor.lightGrayColor()
            })
        } else {
            // stop advertising
            partyTime.leaveParty()
            // update the button title
            sender.title = "Join Mob"
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
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        // turn on photo editing
        imagePicker.allowsEditing = true
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
    
    //MARK: PLPartyTimeDelegate
    func partyTime(partyTime: PLPartyTime!, failedToJoinParty error: NSError!) {
        print("couldn't join party")
    }
    
    func partyTime(partyTime: PLPartyTime!, peer: MCPeerID!, changedState state: MCSessionState, currentPeers: [AnyObject]!) {
        guard let peerList: [MCPeerID] = currentPeers as? [MCPeerID] else { return }
        self.peers = peerList
        // update the header label on the main thread
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.title = "Local Mob - \(self.peers.count + 1) Users"
        }
    }
    
    func partyTime(partyTime: PLPartyTime!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        // unwrap the raw image date into a UIImage structure
        guard let image = UIImage(data: data) else { return }
        // add the image to photos
        self.photos.append(image)
        // update the collectionView on the main thread
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.collectionView.reloadData()
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
            // send the image to connected peers
            do {
                let imageData = UIImageJPEGRepresentation(image, 0.5)
                try self.partyTime.sendData(imageData, toPeers: self.peers, withMode: MCSessionSendDataMode.Reliable)
            } catch {
                print(error)
            }
        }
    }
}

