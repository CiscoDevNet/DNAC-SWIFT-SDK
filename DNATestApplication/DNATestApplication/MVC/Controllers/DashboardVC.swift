//
//  DashboardVC.swift
//  DNATestApplication
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
import DNAAuthentication
import Alamofire

class DashboardVC: UIViewController, URLSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
     //MARK: Declaration Section
    
    @IBOutlet weak var tableViewDashboard: UITableView!
    var networkDeviceListing:NetworkDeviceListing? = nil
    
    //MARK: ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK: Helper Methods

    /* ** Register TableView with CustomCell ** */
    func registerTableView(){
        tableViewDashboard.register(UINib(nibName: "DashboardCell", bundle: Bundle.main), forCellReuseIdentifier: "DashboardCell")
        tableViewDashboard.rowHeight = UITableViewAutomaticDimension
        tableViewDashboard.tableFooterView = UIView(frame:CGRect.zero)
    }
    
    func showAlert(title titleText:String, message messageText:String){
        let alertController = UIAlertController(title: titleText, message:messageText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction!) in}
        alertController.addAction(okAction)
        self.present(alertController, animated: true) {}
    }
    
    //MARK: Action Methods

    /* ** User Action to get Network Devices ** */
    @IBAction func getNetworkDevices(_ sender: CusomButton) {
        self.swaggerGetNetworkDevicesCall() //Calling Service via Swagger
       // self.nativeGetNetworkDevicesCall() //Calling Service via Native Code
    }
    
    /* ** Service Call via Swagger ** */
    func swaggerGetNetworkDevicesCall() {
        
        /* ---*  Below Snippet Tells what DNAAuthenticationManager.shared.getAuthenticationHeaderDictioanry() is doing internally. *---
        
        var headerDictionary:Dictionary<String,String> = HTTPCookie.requestHeaderFields(with:     DNAAuthenticationManager.shared.getAuthenticationCookie())
        headerDictionary["verify"] = "False"
        headerDictionary["Content-Type"] = "application/json"
        
        */
    
        SwaggerClientAPI.basePath = DNAAuthenticationManager.shared.getBaseURL()
        SwaggerClientAPI.customHeaders = DNAAuthenticationManager.shared.getAuthenticationHeaderDictioanry()
        
        NetworkDeviceAPI.getNetworkDevice { (networkDevicesResponse, errorResponse) in
            
            guard errorResponse == nil else{
                print(errorResponse ?? "")
                return
            }
            
            let jsonDictionary = networkDevicesResponse?.encodeToJSON() as! Dictionary<String,Any>
            self.networkDeviceListing = NetworkDeviceListing(fromDictionary: jsonDictionary)
            self.tableViewDashboard.reloadData()
        }
    }
    
    /* ** Service Call via Native Code ** */
    func nativeGetNetworkDevicesCall(){
        
                let urlString = DNAAuthenticationManager.shared.getServiceURL(forApiPath: "/api/v1/network-device")
                let url = URL(string: urlString)!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.httpShouldHandleCookies = true
                let headerDictionary:Dictionary<String,String> = HTTPCookie.requestHeaderFields(with: DNAAuthenticationManager.shared.getAuthenticationCookie())
                request.allHTTPHeaderFields = headerDictionary

                let sessionConfiguration = URLSessionConfiguration.default
                let session =  URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
                let task = session.dataTask(with: request) { data, response, error in
        
                    guard let _ = data, error == nil else {
                        //print("Error=\(String(describing: error))")
                        self.showAlert(title: "Service Call Failed !!", message: error?.localizedDescription ?? "")
                        return
                    }
        
                    do{
                        let jsonObject:Any = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        
                        if let jsonDictionary = jsonObject as? Dictionary<String,Any>{
                           self.networkDeviceListing = NetworkDeviceListing(fromDictionary: jsonDictionary)
                           self.tableViewDashboard.reloadData()
                            //let responseString = String.init(data: data!, encoding: String.Encoding.utf8)
                            //print(responseString ?? "")
                        }
        
                    }catch{
                        //print(error.localizedDescription)
                    }
                }
                task.resume()
    }
    
    
    //MARK: URLSessionDelegate Methods
    
    /* ** Force trusting the server to avoid SSL problem ** */
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        /* Commented Part is to check if user wants to trust ssl or not based on his preferance. Currently we are always force trusting SSL */
        
        //if DNAAuthenticationManager.shared.shouldForceTrust == true {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        //}
    }
    
    //MARK: UITableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.networkDeviceListing?.devices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell:DashboardCell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardCell
        cell.setData(device: (self.networkDeviceListing?.devices[indexPath.row])!)
        return cell
    }
    
    //MARK: UITableView Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let dashboardDetailVC:DashboardDetailVC = storyboard.instantiateViewController(withIdentifier: "DashboardDetailVC") as! DashboardDetailVC
        dashboardDetailVC.navigationItem.title = "Device Details"
        self.navigationController?.pushViewController(dashboardDetailVC, animated: true)
        dashboardDetailVC.device = networkDeviceListing?.devices[indexPath.row]
    }
}

/* ** CusomButton designing for better user experience ** */

@IBDesignable class CusomButton:UIButton{
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderThickness: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderThickness
        }
    }
    
    @IBInspectable var borderColour: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColour.cgColor
        }
    }
}
