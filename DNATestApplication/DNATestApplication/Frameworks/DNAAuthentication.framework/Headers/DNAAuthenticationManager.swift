//
//  DNAAuthenticationManager.swift
//  DNAAuthentication
//
//  Copyright (c) 2018 Cisco.
//
// This software is licensed to you under the terms of the Cisco Sample
// Code License, Version 1.0 (the "License"). You may obtain a copy of the
// License at
//
// https://developer.cisco.com/docs/licenses
//
// All use of the material herein must be in accordance with the terms of
// the License. All rights not expressly granted by the License are
// reserved. Unless required by applicable law or agreed to separately in
// writing, software distributed under the License is distributed on an "AS
// IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
// or implied.
//
// All rights reserved.
//


import UIKit
import Foundation

protocol DNAAuthenticationManagerDelegate {
    func didStartAuthenticating()
    func authenticationDidSucceed()
    func authenticationDidFail()
    func authenticationCookieSaved()
}

public class DNAAuthenticationManager: NSObject, HelperDelegate {
    
    //MARK: HelperDelegate Section
    
    func didStartAuthenticating() {
        delegate?.didStartAuthenticating()
    }
    
    func authenticationDidSucceed() {
        delegate?.authenticationDidSucceed()
    }
    
    func authenticationDidFail() {
        delegate?.authenticationDidFail()
    }
    
    func authenticationCookieSaved() {
        delegate?.authenticationCookieSaved()
    }
   
    //MARK: Declaration Section
    
    public static let shared = DNAAuthenticationManager()
    public var shouldForceTrust = true
    
    var delegate:DNAAuthenticationManagerDelegate?
    var DNAC_IP = ""
    
    //MARK: Exposed Methods
    
    /* ** Returns DNALoginViewController Instance ** */
    public func getDNALoginController() -> DNALoginViewController{
        let loginVC:DNALoginViewController = DNALoginViewController(nibName: "DNALoginViewController", bundle: Bundle(for: DNALoginViewController.self))
        return loginVC
    }
    
    /* ** Returns API URL for specified API path ** */
    public func getServiceURL(forApiPath apiPath:String) -> String{
        return Helper.shared.apiProtocol + DNAC_IP +  Helper.shared.apiPath
    }
    
    /* ** Returns API Base URL ** */
    public func getBaseURL() -> String{
        return  Helper.shared.apiProtocol + DNAC_IP
    }
    
    /* ** Returns User DNAC ID ** */
    public func getDNAC_IP() -> String{
        return DNAC_IP
    }
    
    /* ** Called Internally once Login Button is Clicked. ** */
    public func statAuthentication(DNAC_IPAddress: String, username: String, password: String) -> Void {
        DNAC_IP = DNAC_IPAddress
        Helper.shared.delegate = self
        Helper.shared.authentication(authenticationAPI: DNAC_IPAddress.getAuthenticationAPI(), userName: username, password: password)
    }
    
    /* ** Clears authentication cookie to end the session. ** */
    public func endSession(){
        UserDefaults.standard.set(nil, forKey: DNAC_IP)
    }
    
    /* ** Returns authentication cookie ** */
    public func getAuthenticationCookie() -> [HTTPCookie] {
        let cookie: [HTTPCookie] = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: DNAC_IP) as! Data) as! [HTTPCookie]
        //print("Framework: Cookie Received !!")
        return cookie
    }
    
    /* ** Internally HeaderDictionary for current authentication cookie ** */
    public func getAuthenticationHeaderDictioanry() -> Dictionary<String,String>!{
        var headerDictionary:Dictionary<String,String> = HTTPCookie.requestHeaderFields(with: self.getAuthenticationCookie())
        headerDictionary["verify"] = "False"
        headerDictionary["Content-Type"] = "application/json"
        return headerDictionary
    }
}


