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

internal let apiPath:String = "/api/system/v1/auth/login"
internal let apiProtocol:String = "https://"

public class DNAAuthenticationManager: NSObject, URLSessionDelegate {
   
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
        return apiProtocol + DNAC_IP + apiPath
    }
    
    /* ** Returns API Base URL ** */
    public func getBaseURL() -> String{
        return apiProtocol + DNAC_IP
    }
    
    /* ** Returns User DNAC ID ** */
    public func getDNAC_IP() -> String{
        return DNAC_IP
    }
    
    /* ** Called Internally once Login Button is Clicked. ** */
    public func statAuthentication(DNAC_IPAddress: String, username: String, password: String) -> Void {
        DNAC_IP = DNAC_IPAddress
        self.authentication(authenticationAPI: DNAC_IPAddress.getAuthenticationAPI(), userName: username, password: password)
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
    
    //MARK: Helper Methods
    
    /* ** Internally called to save authentication cookie ** */
    internal func saveAuthenticationCookie(response: URLResponse){
     
       //print("Framework: Cookie Saved !!")
        let urlKey = URL(string: DNAC_IP)
        
        if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                    
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response.url!)
            HTTPCookieStorage.shared.setCookies(cookies, for: urlKey, mainDocumentURL: nil)
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: cookies), forKey: DNAC_IP)
            //print("Framework: Saved Cookie : \(cookies)")
            UserDefaults.standard.synchronize()
            delegate?.authenticationCookieSaved()
            }
    }
    
    /* ** Internally called to authenticate user ** */
    private func authentication (authenticationAPI: String, userName: String, password: String) {
        
        let encodedValue = userName + ":" + password
       //print("Original string: \"\(encodedValue)\"")
        
        let base64Str = encodedValue.base64Encoded()
       //print("Base64 encoded string: \"\(String(describing: base64Str))\"")
    
        let urlString = authenticationAPI
        let url = URL(string: urlString)!
        
        let authorizationString = "Basic " + base64Str!
        //print("Aauthorization String : \"\(authorizationString)\"")
        
        //Fires DNAC Delegate Callback
        if shouldForceTrust == true {DNAAuthenticationManager.shared.delegate?.didStartAuthenticating()}

        var request = URLRequest(url: url)
        request.setValue(authorizationString, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("False", forHTTPHeaderField: "verify")
        
        request.httpMethod = "GET"
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, response, error in
         
            guard let _ = data, error == nil else {
                //print("error=\(String(describing: error))")
                self.delegate?.authenticationDidFail()
                return
            }
            
            if let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode != 200 {
                //Fire Delegate
                self.delegate?.authenticationDidFail()
                
            }else if let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 {
              
                //print("Framework: \(response!) StatusCode: \(urlResponse.statusCode)")
                self.saveAuthenticationCookie(response: response!)
                self.delegate?.authenticationDidSucceed()
            }
        }
        task.resume()
    }
    
    /* ** Force trusting the server to avoid SSL problem ** */
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if self.shouldForceTrust == true {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
}

/* ** String extension for codeing ease ** */

extension String {
    //MARK: Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //MARK: Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    //MARK: Construct AuthenticationAPI
    func getAuthenticationAPI() -> String! {
        return "\(apiProtocol)\(self)\(apiPath)"
    }
}
