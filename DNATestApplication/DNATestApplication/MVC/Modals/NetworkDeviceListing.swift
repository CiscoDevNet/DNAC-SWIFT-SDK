//
//	NetworkDeviceListing.swift
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


import Foundation


class NetworkDeviceListing : NSObject{

	var devices : [DeviceModalItem]!
	var version : String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		devices = [DeviceModalItem]()
        
		if let DeviceArray = dictionary["response"] as? [[String:Any]]{
            for dic in DeviceArray{
				let value = DeviceModalItem(fromDictionary: dic)
				devices.append(value)
			}
		}
		version = dictionary["version"] as? String
	}
    
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if devices != nil{
			var dictionaryElements = [[String:Any]]()
			for DeviceElement in devices {
				dictionaryElements.append(DeviceElement.toDictionary())
			}
			dictionary["response"] = dictionaryElements
		}
		if version != nil{
			dictionary["version"] = version
		}
		return dictionary
	}
}
