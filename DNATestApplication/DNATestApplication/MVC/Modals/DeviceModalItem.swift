//
//	Device.swift
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


class DeviceModalItem : NSObject{

	var apManagerInterfaceIp : String!
	var associatedWlcIp : String!
	var bootDateTime : String!
	var collectionInterval : String!
	var collectionStatus : String!
	var errorCode : AnyObject!
	var errorDescription : AnyObject?
	var family : String!
	var hostname : String!
	var id : String!
	var instanceTenantId : String!
	var instanceUuid : String!
	var interfaceCount : String!
	var inventoryStatusDetail : String!
	var lastUpdateTime : Int!
	var lastUpdated : String!
	var lineCardCount : AnyObject?
	var lineCardId : AnyObject?
	var location : AnyObject?
	var locationName : AnyObject?
	var macAddress : String!
	var managementIpAddress : String!
	var memorySize : String!
	var platformId : String!
	var reachabilityFailureReason : String!
	var reachabilityStatus : String!
	var role : String!
	var roleSource : String!
	var serialNumber : String!
	var series : String!
	var snmpContact : String!
	var snmpLocation : String!
	var softwareType : String!
	var softwareVersion : String!
	var tagCount : String!
	var tunnelUdpPort : String!
	var type : String!
	var upTime : String!
	var waasDeviceMode : AnyObject?


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		apManagerInterfaceIp = dictionary["apManagerInterfaceIp"] as? String
		associatedWlcIp = dictionary["associatedWlcIp"] as? String
		bootDateTime = dictionary["bootDateTime"] as? String
		collectionInterval = dictionary["collectionInterval"] as? String
		collectionStatus = dictionary["collectionStatus"] as? String
        errorCode = dictionary["errorCode"] as AnyObject
        errorDescription = dictionary["errorDescription"] as AnyObject
		family = dictionary["family"] as? String
		hostname = dictionary["hostname"] as? String
		id = dictionary["id"] as? String
		instanceTenantId = dictionary["instanceTenantId"] as? String
		instanceUuid = dictionary["instanceUuid"] as? String
		interfaceCount = dictionary["interfaceCount"] as? String
		inventoryStatusDetail = dictionary["inventoryStatusDetail"] as? String
		lastUpdateTime = dictionary["lastUpdateTime"] as? Int
		lastUpdated = dictionary["lastUpdated"] as? String
        lineCardCount = dictionary["lineCardCount"] as AnyObject
        lineCardId = dictionary["lineCardId"] as AnyObject
        location = dictionary["location"] as AnyObject
        locationName = dictionary["locationName"] as AnyObject
		macAddress = dictionary["macAddress"] as? String
		managementIpAddress = dictionary["managementIpAddress"] as? String
		memorySize = dictionary["memorySize"] as? String
		platformId = dictionary["platformId"] as? String
		reachabilityFailureReason = dictionary["reachabilityFailureReason"] as? String
		reachabilityStatus = dictionary["reachabilityStatus"] as? String
		role = dictionary["role"] as? String
		roleSource = dictionary["roleSource"] as? String
		serialNumber = dictionary["serialNumber"] as? String
		series = dictionary["series"] as? String
		snmpContact = dictionary["snmpContact"] as? String
		snmpLocation = dictionary["snmpLocation"] as? String
		softwareType = dictionary["softwareType"] as? String
		softwareVersion = dictionary["softwareVersion"] as? String
		tagCount = dictionary["tagCount"] as? String
		tunnelUdpPort = dictionary["tunnelUdpPort"] as? String
		type = dictionary["type"] as? String
		upTime = dictionary["upTime"] as? String
        waasDeviceMode = dictionary["waasDeviceMode"] as AnyObject
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if apManagerInterfaceIp != nil{
			dictionary["apManagerInterfaceIp"] = apManagerInterfaceIp
		}
		if associatedWlcIp != nil{
			dictionary["associatedWlcIp"] = associatedWlcIp
		}
		if bootDateTime != nil{
			dictionary["bootDateTime"] = bootDateTime
		}
		if collectionInterval != nil{
			dictionary["collectionInterval"] = collectionInterval
		}
		if collectionStatus != nil{
			dictionary["collectionStatus"] = collectionStatus
		}
		if errorCode != nil{
			dictionary["errorCode"] = errorCode
		}
		if errorDescription != nil{
			dictionary["errorDescription"] = errorDescription
		}
		if family != nil{
			dictionary["family"] = family
		}
		if hostname != nil{
			dictionary["hostname"] = hostname
		}
		if id != nil{
			dictionary["id"] = id
		}
		if instanceTenantId != nil{
			dictionary["instanceTenantId"] = instanceTenantId
		}
		if instanceUuid != nil{
			dictionary["instanceUuid"] = instanceUuid
		}
		if interfaceCount != nil{
			dictionary["interfaceCount"] = interfaceCount
		}
		if inventoryStatusDetail != nil{
			dictionary["inventoryStatusDetail"] = inventoryStatusDetail
		}
		if lastUpdateTime != nil{
			dictionary["lastUpdateTime"] = lastUpdateTime
		}
		if lastUpdated != nil{
			dictionary["lastUpdated"] = lastUpdated
		}
		if lineCardCount != nil{
			dictionary["lineCardCount"] = lineCardCount
		}
		if lineCardId != nil{
			dictionary["lineCardId"] = lineCardId
		}
		if location != nil{
			dictionary["location"] = location
		}
		if locationName != nil{
			dictionary["locationName"] = locationName
		}
		if macAddress != nil{
			dictionary["macAddress"] = macAddress
		}
		if managementIpAddress != nil{
			dictionary["managementIpAddress"] = managementIpAddress
		}
		if memorySize != nil{
			dictionary["memorySize"] = memorySize
		}
		if platformId != nil{
			dictionary["platformId"] = platformId
		}
		if reachabilityFailureReason != nil{
			dictionary["reachabilityFailureReason"] = reachabilityFailureReason
		}
		if reachabilityStatus != nil{
			dictionary["reachabilityStatus"] = reachabilityStatus
		}
		if role != nil{
			dictionary["role"] = role
		}
		if roleSource != nil{
			dictionary["roleSource"] = roleSource
		}
		if serialNumber != nil{
			dictionary["serialNumber"] = serialNumber
		}
		if series != nil{
			dictionary["series"] = series
		}
		if snmpContact != nil{
			dictionary["snmpContact"] = snmpContact
		}
		if snmpLocation != nil{
			dictionary["snmpLocation"] = snmpLocation
		}
		if softwareType != nil{
			dictionary["softwareType"] = softwareType
		}
		if softwareVersion != nil{
			dictionary["softwareVersion"] = softwareVersion
		}
		if tagCount != nil{
			dictionary["tagCount"] = tagCount
		}
		if tunnelUdpPort != nil{
			dictionary["tunnelUdpPort"] = tunnelUdpPort
		}
		if type != nil{
			dictionary["type"] = type
		}
		if upTime != nil{
			dictionary["upTime"] = upTime
		}
		if waasDeviceMode != nil{
			dictionary["waasDeviceMode"] = waasDeviceMode
		}
		return dictionary
	}
}
