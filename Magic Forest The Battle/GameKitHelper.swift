//
//  GameKitHelper.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 09/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import Foundation
import GameKit

protocol GameKitHelperDelegate {
    func matchStarted()
    func matchEnded()
    func matchReceivedData(match: GKMatch, data: NSData,
    fromPlayer player: String)
}

let PresentAuthenticationViewController = "PresentAuthenticationViewController"
let singleton = GameKitHelper()


class GameKitHelper: NSObject, GKMatchmakerViewControllerDelegate, GKMatchDelegate {
    var authenticationViewController: UIViewController?
    var gameCenterEnabled = false
    var lastError: NSError?
    
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
    
    func reportAchievements(achievements: [GKAchievement], errorHandler: ((NSError?)->Void)? = nil) {
        guard gameCenterEnabled else {
            return
        }
            
        GKAchievement.reportAchievements(achievements, withCompletionHandler: errorHandler)
    }
    
    func showGKGameCenterViewController(viewController: UIViewController) {
        guard gameCenterEnabled else {
            return
        }
                
        let gameCenterViewController = GKGameCenterViewController()
                
        gameCenterViewController.gameCenterDelegate = self
                
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func findMatch(minPlayers: Int, maxPlayers: Int, presentingViewController viewController: UIViewController, delegate: GameKitHelperDelegate) {
        
        if !gameCenterEnabled {
            print("Local player is not authenticated")
            return
        }
        
        multiplayerMatchStarted = false
        multiplayerMatch = nil
        self.delegate = delegate
        presentingViewController = viewController
        
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = minPlayers
        matchRequest.maxPlayers = maxPlayers
        
        let matchMakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)
        matchMakerViewController!.matchmakerDelegate = self
        
        presentingViewController?.presentViewController(matchMakerViewController!, animated: false, completion: nil)
    }
    
    
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        delegate?.matchEnded()
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        print("Error creating match: \(error.localizedDescription)")
        delegate?.matchEnded()
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch match: GKMatch) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        multiplayerMatch = match
        multiplayerMatch!.delegate = self
        
        if !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0 {
            print("Ready to start the match")
        }
    }
    
    func match(match: GKMatch, didFailWithError error: NSError?) {
        if multiplayerMatch != match {
            return
        }
        
        multiplayerMatchStarted = false
        delegate?.matchEnded()
    }
    
    func match(match: GKMatch, player playerID: String, didChangeState state: GKPlayerConnectionState) {
        if multiplayerMatch != match {
            return
        }
        
        switch state {
        case .StateConnected:
            print("Player connected")
            if  !multiplayerMatchStarted && multiplayerMatch?.expectedPlayerCount == 0{
                print("Ready to start the match")
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
