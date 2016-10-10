//
//  GoogleCalendarApi.swift
//  
//
//  Created by 中村祐太 on 2016/10/09.
//
//
import GoogleAPIClient
import GTMOAuth2
import UIKit

class GoogleCalendarApi {
    fileprivate let kKeychainItemName = "Google Calendar API keychain v3"
    fileprivate let kClientID = "577359574054-idbfg95lccqfkds8ouid5jf8ttm14c2p.apps.googleusercontent.com"
    
    fileprivate let service = GTLServiceCalendar()
    
    init() {
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(
            forName: kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            
            service.authorizer = auth
        }

    }
    
    func canAuth() -> Bool {
        let authorizer = service.authorizer
        let canAuth = authorizer?.canAuthorize
        return canAuth!
    }
    
    func getService() -> GTLServiceCalendar {
        return service
    }
}
