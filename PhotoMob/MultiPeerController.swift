//
//  MultiPeerController.swift
//  PhotoMob
//
//  Created by John Clem on 7/2/15.
//  Copyright © 2015 learnSwift.io. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiPeerController: NSObject {

    // name of service to broadcast / listen to
    let serviceType = "photomob-svc"
    // name of this local peer
    let localPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)

    var serviceAdvertiser : MCNearbyServiceAdvertiser?
    var serviceBrowser : MCNearbyServiceBrowser?
    
    //MARK: Nearby Networking
    func startNearbyNetworkingWithDelegate(advertiserDelegate: MCNearbyServiceAdvertiserDelegate?, browserDelegate: MCNearbyServiceBrowserDelegate?) {
        // initialize the advertiser
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: serviceType)
        // assign the provided delegate
        serviceAdvertiser?.delegate = advertiserDelegate
        // start advertising
        serviceAdvertiser?.startAdvertisingPeer()
        
        // start listening
        serviceBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceType)
        serviceBrowser?.delegate = browserDelegate
        serviceBrowser?.startBrowsingForPeers()
    }
    
    func stopNearbyNetworking() {
        
    }
    
}
