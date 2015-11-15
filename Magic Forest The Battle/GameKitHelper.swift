//
//  GameKitHelper.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 09/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import Foundation
import GameKit

let PresentAuthenticationViewController = "PresentAuthenticationViewController"
let singleton = GameKitHelper()

protocol GameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
    func matchReceivedData(match: GKMatch, data: NSData, fromPlayer player: GKPlayer)
}

class GameKitHelper: NSObject, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    var authenticationViewController: UIViewController?
    var gameCenterEnabled = false
    var lastError: NSError?
    
    // Match variables
    var delegate: GameKitHelperDelegate?
    var multiplayerMatch: GKMatch?
    var presentingViewController:  UIViewController?
    var multiplayerMatchStarted: Bool
    
    class var sharedInstance: GameKitHelper {
        return singleton
    }
    
    override init(){
        multiplayerMatchStarted = false
        gameCenterEnabled = true

        super.init()
    }
    
    /**
     Authenticate the local player. If he is authenticated, enable game center features
     */
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) in
            self.lastError = error
            
            if viewController != nil {
                self.authenticationViewController = viewController
                
                NSNotificationCenter.defaultCenter().postNotificationName(PresentAuthenticationViewController, object: self)
            } else if localPlayer.authenticated {
                self.gameCenterEnabled = true
            } else {
                self.gameCenterEnabled = false
            }
        }
    }
    
    
    /**
     Find a match with game center
     - parameter minPlayers: Define the min players
     - parameter maxPlayers: Define the max players
     - parameter viewController: Define the preseinting view controller
     - parameter delegate: Define who will be the delegate (GameKitHelperDelegate)
     */
    func findMatch(minPlayers: Int, maxPlayers: Int, presentingViewController viewController: UIViewController, delegate: GameKitHelperDelegate) {
        
        // Cheke if player is authenticated
        guard gameCenterEnabled else {
            print("Local player is not authenticated")
            return
        }
        
        multiplayerMatchStarted = false
        multiplayerMatch = nil
        self.delegate = delegate
        presentingViewController = viewController
        
        // Create a match request
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = minPlayers
        matchRequest.maxPlayers = maxPlayers
        
        let matchMakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)
        matchMakerViewController!.matchmakerDelegate = self
        
        presentingViewController?.presentViewController(matchMakerViewController!, animated: false, completion: nil)
    }
    
    func reportAchievements(achievements: [GKAchievement], errorHandler: ((NSError?)->Void)? = nil) {
        guard gameCenterEnabled else {
            return
        }
            
        GKAchievement.reportAchievements(achievements, withCompletionHandler: errorHandler)
    }
    
    func showGKGameCenterViewController(viewController: UIViewController) {
        // Cheke if player is authenticated
        guard gameCenterEnabled else {
            print("Local player is not authenticated")
            return
        }
                
        let gameCenterViewController = GKGameCenterViewController()
        
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = .Default
                
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // This method is called when user canel the GKMatchmakerViewController
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        delegate?.matchEnded()
    }
    
    // This method is called when the matchmaker API  fails to create a match
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        print("Error creating match: \(error.localizedDescription)")
        delegate?.matchEnded()
    }
    
    
    // This method is called when Game Center successfully finds a match
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch match: GKMatch) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        multiplayerMatch = match
        multiplayerMatch!.delegate = self
        
        if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
            print("Ready to start the match")
            multiplayerMatchStarted = true
            delegate?.matchStarted()
        }
    }
    
    // The game call this method when received data from another player device's
    func match(match: GKMatch, didReceiveData data: NSData, fromRemotePlayer player: GKPlayer) {
        if multiplayerMatch != match {
            print("Something wrong with the match")
            return
        }
        
        // Send the data to delegate
        delegate?.matchReceivedData(match, data: data, fromPlayer: player)
    }
    
    // The game call this method when there is an error during the match
    func match(match: GKMatch, didFailWithError error: NSError?) {
        if multiplayerMatch != match {
            print("Something wrong with the match")
            return
        }
        
        multiplayerMatchStarted = false
        delegate?.matchEnded()
    }
    
    // The game invoke this method every time  a player's status changes
    func match(match: GKMatch, player: GKPlayer, didChangeConnectionState state: GKPlayerConnectionState) {
        if multiplayerMatch != match {
            print("Something wrong with the match")
            return
        }
        
        switch state {
        case .StateConnected:
            print("Player connected")
            if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
                print("Ready to start the match")
                multiplayerMatchStarted = true
                delegate?.matchStarted()
            }
        case .StateDisconnected:
            print("Player disconnected")
            multiplayerMatchStarted = false
            delegate?.matchEnded()
        case .StateUnknown:
            print("Initial player state")
        }
    }
    
}

extension GameKitHelper: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
