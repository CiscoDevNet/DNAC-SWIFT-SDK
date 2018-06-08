//
// NetworkDeviceAPI.swift
//

//

import Foundation
import Alamofire


open class NetworkDeviceAPI: APIBase {
    /**
     Delete network device by ID
     - parameter id: (path) Device ID 
     - parameter isForceDelete: (query) isForceDelete (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteNetworkDeviceById(id: String, isForceDelete: Bool? = nil, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteNetworkDeviceByIdWithRequestBuilder(id: id, isForceDelete: isForceDelete).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Delete network device by ID
     - DELETE /api/v1/network-device/${id}
     - Removes the network device for the given ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter id: (path) Device ID 
     - parameter isForceDelete: (query) isForceDelete (optional)
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteNetworkDeviceByIdWithRequestBuilder(id: String, isForceDelete: Bool? = nil) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/network-device/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "isForceDelete": isForceDelete
        ])

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves all network devices
     - parameter hostname: (query) hostname (optional)
     - parameter managementIpAddress: (query) managementIpAddress (optional)
     - parameter macAddress: (query) macAddress (optional)
     - parameter locationName: (query) locationName (optional)
     - parameter serialNumber: (query) serialNumber (optional)
     - parameter location: (query) location (optional)
     - parameter family: (query) family (optional)
     - parameter type: (query) type (optional)
     - parameter series: (query) series (optional)
     - parameter collectionStatus: (query) collectionStatus (optional)
     - parameter collectionInterval: (query) collectionInterval (optional)
     - parameter notSyncedForMinutes: (query) notSyncedForMinutes (optional)
     - parameter errorCode: (query) errorCode (optional)
     - parameter errorDescription: (query) errorDescription (optional)
     - parameter softwareVersion: (query) softwareVersion (optional)
     - parameter softwareType: (query) softwareType (optional)
     - parameter platformId: (query) platformId (optional)
     - parameter role: (query) role (optional)
     - parameter reachabilityStatus: (query) reachabilityStatus (optional)
     - parameter upTime: (query) upTime (optional)
     - parameter associatedWlcIp: (query) associatedWlcIp (optional)
     - parameter licenseName: (query) licenseName (optional)
     - parameter licenseType: (query) licenseType (optional)
     - parameter licenseStatus: (query) licenseStatus (optional)
     - parameter modulename: (query) moduleName (optional)
     - parameter moduleequpimenttype: (query) moduleEqupimentType (optional)
     - parameter moduleservicestate: (query) moduleServiceState (optional)
     - parameter modulevendorequipmenttype: (query) moduleVendorEquipmentType (optional)
     - parameter modulepartnumber: (query) modulePartNumber (optional)
     - parameter moduleoperationstatecode: (query) moduleOperationStateCode (optional)
     - parameter id: (query) Accepts comma separated id&#39;s and return list of network-devices for the given id&#39;s. If invalid or not-found id&#39;s are provided, null entry will be returned in the list. (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDevice(hostname: [String]? = nil, managementIpAddress: [String]? = nil, macAddress: [String]? = nil, locationName: [String]? = nil, serialNumber: [String]? = nil, location: [String]? = nil, family: [String]? = nil, type: [String]? = nil, series: [String]? = nil, collectionStatus: [String]? = nil, collectionInterval: [String]? = nil, notSyncedForMinutes: [String]? = nil, errorCode: [String]? = nil, errorDescription: [String]? = nil, softwareVersion: [String]? = nil, softwareType: [String]? = nil, platformId: [String]? = nil, role: [String]? = nil, reachabilityStatus: [String]? = nil, upTime: [String]? = nil, associatedWlcIp: [String]? = nil, licenseName: [String]? = nil, licenseType: [String]? = nil, licenseStatus: [String]? = nil, modulename: [String]? = nil, moduleequpimenttype: [String]? = nil, moduleservicestate: [String]? = nil, modulevendorequipmenttype: [String]? = nil, modulepartnumber: [String]? = nil, moduleoperationstatecode: [String]? = nil, id: String? = nil, completion: @escaping ((_ data: NetworkDeviceListResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceWithRequestBuilder(hostname: hostname, managementIpAddress: managementIpAddress, macAddress: macAddress, locationName: locationName, serialNumber: serialNumber, location: location, family: family, type: type, series: series, collectionStatus: collectionStatus, collectionInterval: collectionInterval, notSyncedForMinutes: notSyncedForMinutes, errorCode: errorCode, errorDescription: errorDescription, softwareVersion: softwareVersion, softwareType: softwareType, platformId: platformId, role: role, reachabilityStatus: reachabilityStatus, upTime: upTime, associatedWlcIp: associatedWlcIp, licenseName: licenseName, licenseType: licenseType, licenseStatus: licenseStatus, modulename: modulename, moduleequpimenttype: moduleequpimenttype, moduleservicestate: moduleservicestate, modulevendorequipmenttype: modulevendorequipmenttype, modulepartnumber: modulepartnumber, moduleoperationstatecode: moduleoperationstatecode, id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves all network devices
     - GET /api/v1/network-device
     - Gets the list of first 500 network devices sorted lexicographically based on host name. It can be filtered using management IP address, mac address, hostname and location name. If id param is provided, it will be returning the list of network-devices for the given id's and other request params will be ignored. In case of autocomplete request, returns the list of specified attributes.

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "type" : "type",
    "apManagerInterfaceIp" : "apManagerInterfaceIp",
    "lastUpdated" : "lastUpdated",
    "hostname" : "hostname",
    "tunnelUdpPort" : "tunnelUdpPort",
    "instanceTenantId" : "instanceTenantId",
    "bootDateTime" : "bootDateTime",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "waasDeviceMode" : "waasDeviceMode",
    "inventoryStatusDetail" : "inventoryStatusDetail",
    "snmpLocation" : "snmpLocation",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "softwareType" : "softwareType",
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "associatedWlcIp" : "associatedWlcIp",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "collectionStatus" : "collectionStatus",
    "series" : "series",
    "instanceUuid" : "instanceUuid",
    "tagCount" : "tagCount",
    "location" : "location",
    "family" : "family",
    "collectionInterval" : "collectionInterval",
    "softwareVersion" : "softwareVersion",
    "lastUpdateTime" : "lastUpdateTime"
  }, {
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "type" : "type",
    "apManagerInterfaceIp" : "apManagerInterfaceIp",
    "lastUpdated" : "lastUpdated",
    "hostname" : "hostname",
    "tunnelUdpPort" : "tunnelUdpPort",
    "instanceTenantId" : "instanceTenantId",
    "bootDateTime" : "bootDateTime",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "waasDeviceMode" : "waasDeviceMode",
    "inventoryStatusDetail" : "inventoryStatusDetail",
    "snmpLocation" : "snmpLocation",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "softwareType" : "softwareType",
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "associatedWlcIp" : "associatedWlcIp",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "collectionStatus" : "collectionStatus",
    "series" : "series",
    "instanceUuid" : "instanceUuid",
    "tagCount" : "tagCount",
    "location" : "location",
    "family" : "family",
    "collectionInterval" : "collectionInterval",
    "softwareVersion" : "softwareVersion",
    "lastUpdateTime" : "lastUpdateTime"
  } ],
  "version" : "version"
}}]
     - parameter hostname: (query) hostname (optional)
     - parameter managementIpAddress: (query) managementIpAddress (optional)
     - parameter macAddress: (query) macAddress (optional)
     - parameter locationName: (query) locationName (optional)
     - parameter serialNumber: (query) serialNumber (optional)
     - parameter location: (query) location (optional)
     - parameter family: (query) family (optional)
     - parameter type: (query) type (optional)
     - parameter series: (query) series (optional)
     - parameter collectionStatus: (query) collectionStatus (optional)
     - parameter collectionInterval: (query) collectionInterval (optional)
     - parameter notSyncedForMinutes: (query) notSyncedForMinutes (optional)
     - parameter errorCode: (query) errorCode (optional)
     - parameter errorDescription: (query) errorDescription (optional)
     - parameter softwareVersion: (query) softwareVersion (optional)
     - parameter softwareType: (query) softwareType (optional)
     - parameter platformId: (query) platformId (optional)
     - parameter role: (query) role (optional)
     - parameter reachabilityStatus: (query) reachabilityStatus (optional)
     - parameter upTime: (query) upTime (optional)
     - parameter associatedWlcIp: (query) associatedWlcIp (optional)
     - parameter licenseName: (query) licenseName (optional)
     - parameter licenseType: (query) licenseType (optional)
     - parameter licenseStatus: (query) licenseStatus (optional)
     - parameter modulename: (query) moduleName (optional)
     - parameter moduleequpimenttype: (query) moduleEqupimentType (optional)
     - parameter moduleservicestate: (query) moduleServiceState (optional)
     - parameter modulevendorequipmenttype: (query) moduleVendorEquipmentType (optional)
     - parameter modulepartnumber: (query) modulePartNumber (optional)
     - parameter moduleoperationstatecode: (query) moduleOperationStateCode (optional)
     - parameter id: (query) Accepts comma separated id&#39;s and return list of network-devices for the given id&#39;s. If invalid or not-found id&#39;s are provided, null entry will be returned in the list. (optional)
     - returns: RequestBuilder<NetworkDeviceListResult> 
     */
    open class func getNetworkDeviceWithRequestBuilder(hostname: [String]? = nil, managementIpAddress: [String]? = nil, macAddress: [String]? = nil, locationName: [String]? = nil, serialNumber: [String]? = nil, location: [String]? = nil, family: [String]? = nil, type: [String]? = nil, series: [String]? = nil, collectionStatus: [String]? = nil, collectionInterval: [String]? = nil, notSyncedForMinutes: [String]? = nil, errorCode: [String]? = nil, errorDescription: [String]? = nil, softwareVersion: [String]? = nil, softwareType: [String]? = nil, platformId: [String]? = nil, role: [String]? = nil, reachabilityStatus: [String]? = nil, upTime: [String]? = nil, associatedWlcIp: [String]? = nil, licenseName: [String]? = nil, licenseType: [String]? = nil, licenseStatus: [String]? = nil, modulename: [String]? = nil, moduleequpimenttype: [String]? = nil, moduleservicestate: [String]? = nil, modulevendorequipmenttype: [String]? = nil, modulepartnumber: [String]? = nil, moduleoperationstatecode: [String]? = nil, id: String? = nil) -> RequestBuilder<NetworkDeviceListResult> {
        let path = "/api/v1/network-device"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "hostname": hostname, 
            "managementIpAddress": managementIpAddress, 
            "macAddress": macAddress, 
            "locationName": locationName, 
            "serialNumber": serialNumber, 
            "location": location, 
            "family": family, 
            "type": type, 
            "series": series, 
            "collectionStatus": collectionStatus, 
            "collectionInterval": collectionInterval, 
            "notSyncedForMinutes": notSyncedForMinutes, 
            "errorCode": errorCode, 
            "errorDescription": errorDescription, 
            "softwareVersion": softwareVersion, 
            "softwareType": softwareType, 
            "platformId": platformId, 
            "role": role, 
            "reachabilityStatus": reachabilityStatus, 
            "upTime": upTime, 
            "associatedWlcIp": associatedWlcIp, 
            "license.name": licenseName, 
            "license.type": licenseType, 
            "license.status": licenseStatus, 
            "module+name": modulename, 
            "module+equpimenttype": moduleequpimenttype, 
            "module+servicestate": moduleservicestate, 
            "module+vendorequipmenttype": modulevendorequipmenttype, 
            "module+partnumber": modulepartnumber, 
            "module+operationstatecode": moduleoperationstatecode, 
            "id": id
        ])

        let requestBuilder: RequestBuilder<NetworkDeviceListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves all network devices
     - parameter vrfName: (query) vrfName (optional)
     - parameter managementIpAddress: (query) managementIpAddress (optional)
     - parameter hostname: (query) hostname (optional)
     - parameter macAddress: (query) macAddress (optional)
     - parameter family: (query) family (optional)
     - parameter collectionStatus: (query) collectionStatus (optional)
     - parameter collectionInterval: (query) collectionInterval (optional)
     - parameter softwareVersion: (query) softwareVersion (optional)
     - parameter softwareType: (query) softwareType (optional)
     - parameter reachabilityStatus: (query) reachabilityStatus (optional)
     - parameter reachabilityFailureReason: (query) reachabilityFailureReason (optional)
     - parameter errorCode: (query) errorCode (optional)
     - parameter platformId: (query) platformId (optional)
     - parameter series: (query) series (optional)
     - parameter type: (query) type (optional)
     - parameter serialNumber: (query) serialNumber (optional)
     - parameter upTime: (query) upTime (optional)
     - parameter role: (query) role (optional)
     - parameter roleSource: (query) roleSource (optional)
     - parameter associatedWlcIp: (query) associatedWlcIp (optional)
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceAutocomplete(vrfName: String? = nil, managementIpAddress: String? = nil, hostname: String? = nil, macAddress: String? = nil, family: String? = nil, collectionStatus: String? = nil, collectionInterval: String? = nil, softwareVersion: String? = nil, softwareType: String? = nil, reachabilityStatus: String? = nil, reachabilityFailureReason: String? = nil, errorCode: String? = nil, platformId: String? = nil, series: String? = nil, type: String? = nil, serialNumber: String? = nil, upTime: String? = nil, role: String? = nil, roleSource: String? = nil, associatedWlcIp: String? = nil, offset: String? = nil, limit: String? = nil, completion: @escaping ((_ data: RetrievesAllNetworkDevicesResponse?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceAutocompleteWithRequestBuilder(vrfName: vrfName, managementIpAddress: managementIpAddress, hostname: hostname, macAddress: macAddress, family: family, collectionStatus: collectionStatus, collectionInterval: collectionInterval, softwareVersion: softwareVersion, softwareType: softwareType, reachabilityStatus: reachabilityStatus, reachabilityFailureReason: reachabilityFailureReason, errorCode: errorCode, platformId: platformId, series: series, type: type, serialNumber: serialNumber, upTime: upTime, role: role, roleSource: roleSource, associatedWlcIp: associatedWlcIp, offset: offset, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves all network devices
     - GET /api/v1/network-device/autocomplete
     - Gets the list of first 500 network devices sorted lexicographically based on host name. It can be filtered using management IP address, mac address, hostname and location name. If id param is provided, it will be returning the list of network-devices for the given id's and other request params will be ignored. In case of autocomplete request, returns the list of specified attributes.

     - examples: [{contentType=application/json, example={ }}]
     - parameter vrfName: (query) vrfName (optional)
     - parameter managementIpAddress: (query) managementIpAddress (optional)
     - parameter hostname: (query) hostname (optional)
     - parameter macAddress: (query) macAddress (optional)
     - parameter family: (query) family (optional)
     - parameter collectionStatus: (query) collectionStatus (optional)
     - parameter collectionInterval: (query) collectionInterval (optional)
     - parameter softwareVersion: (query) softwareVersion (optional)
     - parameter softwareType: (query) softwareType (optional)
     - parameter reachabilityStatus: (query) reachabilityStatus (optional)
     - parameter reachabilityFailureReason: (query) reachabilityFailureReason (optional)
     - parameter errorCode: (query) errorCode (optional)
     - parameter platformId: (query) platformId (optional)
     - parameter series: (query) series (optional)
     - parameter type: (query) type (optional)
     - parameter serialNumber: (query) serialNumber (optional)
     - parameter upTime: (query) upTime (optional)
     - parameter role: (query) role (optional)
     - parameter roleSource: (query) roleSource (optional)
     - parameter associatedWlcIp: (query) associatedWlcIp (optional)
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - returns: RequestBuilder<RetrievesAllNetworkDevicesResponse> 
     */
    open class func getNetworkDeviceAutocompleteWithRequestBuilder(vrfName: String? = nil, managementIpAddress: String? = nil, hostname: String? = nil, macAddress: String? = nil, family: String? = nil, collectionStatus: String? = nil, collectionInterval: String? = nil, softwareVersion: String? = nil, softwareType: String? = nil, reachabilityStatus: String? = nil, reachabilityFailureReason: String? = nil, errorCode: String? = nil, platformId: String? = nil, series: String? = nil, type: String? = nil, serialNumber: String? = nil, upTime: String? = nil, role: String? = nil, roleSource: String? = nil, associatedWlcIp: String? = nil, offset: String? = nil, limit: String? = nil) -> RequestBuilder<RetrievesAllNetworkDevicesResponse> {
        let path = "/api/v1/network-device/autocomplete"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "vrfName": vrfName, 
            "managementIpAddress": managementIpAddress, 
            "hostname": hostname, 
            "macAddress": macAddress, 
            "family": family, 
            "collectionStatus": collectionStatus, 
            "collectionInterval": collectionInterval, 
            "softwareVersion": softwareVersion, 
            "softwareType": softwareType, 
            "reachabilityStatus": reachabilityStatus, 
            "reachabilityFailureReason": reachabilityFailureReason, 
            "errorCode": errorCode, 
            "platformId": platformId, 
            "series": series, 
            "type": type, 
            "serialNumber": serialNumber, 
            "upTime": upTime, 
            "role": role, 
            "roleSource": roleSource, 
            "associatedWlcIp": associatedWlcIp, 
            "offset": offset, 
            "limit": limit
        ])

        let requestBuilder: RequestBuilder<RetrievesAllNetworkDevicesResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves network device brief by ID
     - parameter id: (path) Device ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceBriefById(id: String, completion: @escaping ((_ data: NetworkDeviceBriefNIOResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceBriefByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves network device brief by ID
     - GET /api/v1/network-device/${id}/brief
     - Gets brief network device info such as hostname, management IP address for the given device ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "role" : "role",
    "id" : "id",
    "roleSource" : "roleSource"
  },
  "version" : "version"
}}]
     - parameter id: (path) Device ID 
     - returns: RequestBuilder<NetworkDeviceBriefNIOResult> 
     */
    open class func getNetworkDeviceBriefByIdWithRequestBuilder(id: String) -> RequestBuilder<NetworkDeviceBriefNIOResult> {
        var path = "/api/v1/network-device/${id}/brief"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<NetworkDeviceBriefNIOResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves network device by ID
     - parameter id: (path) Device ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceById(id: String, completion: @escaping ((_ data: NetworkDeviceResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves network device by ID
     - GET /api/v1/network-device/${id}
     - Gets the network device for the given device ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "type" : "type",
    "apManagerInterfaceIp" : "apManagerInterfaceIp",
    "lastUpdated" : "lastUpdated",
    "hostname" : "hostname",
    "tunnelUdpPort" : "tunnelUdpPort",
    "instanceTenantId" : "instanceTenantId",
    "bootDateTime" : "bootDateTime",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "waasDeviceMode" : "waasDeviceMode",
    "inventoryStatusDetail" : "inventoryStatusDetail",
    "snmpLocation" : "snmpLocation",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "softwareType" : "softwareType",
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "associatedWlcIp" : "associatedWlcIp",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "collectionStatus" : "collectionStatus",
    "series" : "series",
    "instanceUuid" : "instanceUuid",
    "tagCount" : "tagCount",
    "location" : "location",
    "family" : "family",
    "collectionInterval" : "collectionInterval",
    "softwareVersion" : "softwareVersion",
    "lastUpdateTime" : "lastUpdateTime"
  },
  "version" : "version"
}}]
     - parameter id: (path) Device ID 
     - returns: RequestBuilder<NetworkDeviceResult> 
     */
    open class func getNetworkDeviceByIdWithRequestBuilder(id: String) -> RequestBuilder<NetworkDeviceResult> {
        var path = "/api/v1/network-device/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<NetworkDeviceResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the collection interval specified by device ID
     - parameter id: (path) Device ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceCollectionScheduleById(id: String, completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceCollectionScheduleByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the collection interval specified by device ID
     - GET /api/v1/network-device/${id}/collection-schedule
     - Retrieves collection interval by device id

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - parameter id: (path) Device ID 
     - returns: RequestBuilder<CountResult> 
     */
    open class func getNetworkDeviceCollectionScheduleByIdWithRequestBuilder(id: String) -> RequestBuilder<CountResult> {
        var path = "/api/v1/network-device/${id}/collection-schedule"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the collection interval of all devices
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceCollectionScheduleGlobal(completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceCollectionScheduleGlobalWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the collection interval of all devices
     - GET /api/v1/network-device/collection-schedule/global
     - Retrieves collection interval of all devices

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - returns: RequestBuilder<CountResult> 
     */
    open class func getNetworkDeviceCollectionScheduleGlobalWithRequestBuilder() -> RequestBuilder<CountResult> {
        let path = "/api/v1/network-device/collection-schedule/global"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves device config list
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceConfig(completion: @escaping ((_ data: RawCliInfoNIOListResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceConfigWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves device config list
     - GET /api/v1/network-device/config
     - Gets the config for all devices

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "ipIntfBrief" : "ipIntfBrief",
    "macAddressTable" : "macAddressTable",
    "attributeInfo" : "{}",
    "healthMonitor" : "healthMonitor",
    "intfDescription" : "intfDescription",
    "runningConfig" : "runningConfig",
    "cdpNeighbors" : "cdpNeighbors",
    "id" : "id",
    "snmp" : "snmp",
    "inventory" : "inventory",
    "version" : "version"
  }, {
    "ipIntfBrief" : "ipIntfBrief",
    "macAddressTable" : "macAddressTable",
    "attributeInfo" : "{}",
    "healthMonitor" : "healthMonitor",
    "intfDescription" : "intfDescription",
    "runningConfig" : "runningConfig",
    "cdpNeighbors" : "cdpNeighbors",
    "id" : "id",
    "snmp" : "snmp",
    "inventory" : "inventory",
    "version" : "version"
  } ],
  "version" : "version"
}}]
     - returns: RequestBuilder<RawCliInfoNIOListResult> 
     */
    open class func getNetworkDeviceConfigWithRequestBuilder() -> RequestBuilder<RawCliInfoNIOListResult> {
        let path = "/api/v1/network-device/config"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<RawCliInfoNIOListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves device config
     - parameter networkDeviceId: (path) networkDeviceId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceConfigByNetworkDeviceId(networkDeviceId: String, completion: @escaping ((_ data: SuccessResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceConfigByNetworkDeviceIdWithRequestBuilder(networkDeviceId: networkDeviceId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves device config
     - GET /api/v1/network-device/${networkDeviceId}/config
     - Gets the device config by device ID

     - examples: [{contentType=application/json, example={
  "response" : "response",
  "version" : "version"
}}]
     - parameter networkDeviceId: (path) networkDeviceId 
     - returns: RequestBuilder<SuccessResult> 
     */
    open class func getNetworkDeviceConfigByNetworkDeviceIdWithRequestBuilder(networkDeviceId: String) -> RequestBuilder<SuccessResult> {
        var path = "/api/v1/network-device/${networkDeviceId}/config"
        let networkDeviceIdPreEscape = "\(networkDeviceId)"
        let networkDeviceIdPostEscape = networkDeviceIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{networkDeviceId}", with: networkDeviceIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves config count
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceConfigCount(completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceConfigCountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves config count
     - GET /api/v1/network-device/config/count
     - Gets the count of device configs

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - returns: RequestBuilder<CountResult> 
     */
    open class func getNetworkDeviceConfigCountWithRequestBuilder() -> RequestBuilder<CountResult> {
        let path = "/api/v1/network-device/config/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves network device count
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceCount(completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceCountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves network device count
     - GET /api/v1/network-device/count
     - Gets the count of network devices filtered by management IP address, mac address, hostname and location name

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - returns: RequestBuilder<CountResult> 
     */
    open class func getNetworkDeviceCountWithRequestBuilder() -> RequestBuilder<CountResult> {
        let path = "/api/v1/network-device/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves all functional-capability of devices
     - parameter deviceId: (query) Accepts comma separated deviceid&#39;s and return list of functional-capabilities for the given id&#39;s. If invalid or not-found id&#39;s are provided, null entry will be returned in the list. (optional)
     - parameter functionName: (query) functionName (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceFunctionalCapability(deviceId: String? = nil, functionName: [String]? = nil, completion: @escaping ((_ data: FunctionalCapabilityListResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceFunctionalCapabilityWithRequestBuilder(deviceId: deviceId, functionName: functionName).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves all functional-capability of devices
     - GET /api/v1/network-device/functional-capability
     - Gets the functional-capability for given devices

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "attributeInfo" : "{}",
    "functionalCapability" : [ {
      "attributeInfo" : "{}",
      "functionOpState" : "UNKNOWN",
      "functionDetails" : [ {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      }, {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      } ],
      "functionName" : "functionName",
      "id" : "id"
    }, {
      "attributeInfo" : "{}",
      "functionOpState" : "UNKNOWN",
      "functionDetails" : [ {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      }, {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      } ],
      "functionName" : "functionName",
      "id" : "id"
    } ],
    "id" : "id",
    "deviceId" : "deviceId"
  }, {
    "attributeInfo" : "{}",
    "functionalCapability" : [ {
      "attributeInfo" : "{}",
      "functionOpState" : "UNKNOWN",
      "functionDetails" : [ {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      }, {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      } ],
      "functionName" : "functionName",
      "id" : "id"
    }, {
      "attributeInfo" : "{}",
      "functionOpState" : "UNKNOWN",
      "functionDetails" : [ {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      }, {
        "attributeInfo" : "{}",
        "stringValue" : "stringValue",
        "propertyName" : "propertyName",
        "id" : "id"
      } ],
      "functionName" : "functionName",
      "id" : "id"
    } ],
    "id" : "id",
    "deviceId" : "deviceId"
  } ],
  "version" : "version"
}}]
     - parameter deviceId: (query) Accepts comma separated deviceid&#39;s and return list of functional-capabilities for the given id&#39;s. If invalid or not-found id&#39;s are provided, null entry will be returned in the list. (optional)
     - parameter functionName: (query) functionName (optional)
     - returns: RequestBuilder<FunctionalCapabilityListResult> 
     */
    open class func getNetworkDeviceFunctionalCapabilityWithRequestBuilder(deviceId: String? = nil, functionName: [String]? = nil) -> RequestBuilder<FunctionalCapabilityListResult> {
        let path = "/api/v1/network-device/functional-capability"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "deviceId": deviceId, 
            "functionName": functionName
        ])

        let requestBuilder: RequestBuilder<FunctionalCapabilityListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Gets the functional capability by id
     - parameter id: (path) Device ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceFunctionalCapabilityById(id: String, completion: @escaping ((_ data: FunctionalCapabilityResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceFunctionalCapabilityByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gets the functional capability by id
     - GET /api/v1/network-device/functional-capability/${id}
     - Retrieve functional capability with given id

     - examples: [{contentType=application/json, example={
  "response" : {
    "attributeInfo" : "{}",
    "functionOpState" : "UNKNOWN",
    "functionDetails" : [ {
      "attributeInfo" : "{}",
      "stringValue" : "stringValue",
      "propertyName" : "propertyName",
      "id" : "id"
    }, {
      "attributeInfo" : "{}",
      "stringValue" : "stringValue",
      "propertyName" : "propertyName",
      "id" : "id"
    } ],
    "functionName" : "functionName",
    "id" : "id"
  },
  "version" : "version"
}}]
     - parameter id: (path) Device ID 
     - returns: RequestBuilder<FunctionalCapabilityResult> 
     */
    open class func getNetworkDeviceFunctionalCapabilityByIdWithRequestBuilder(id: String) -> RequestBuilder<FunctionalCapabilityResult> {
        var path = "/api/v1/network-device/functional-capability/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FunctionalCapabilityResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieve the values of given fields
     - parameter functionName: (query) functionName (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceFunctionalCcapabilityAutocomplete(functionName: [String]? = nil, completion: @escaping ((_ data: SuccessResultList?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceFunctionalCcapabilityAutocompleteWithRequestBuilder(functionName: functionName).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieve the values of given fields
     - GET /api/v1/network-device/functional-capability/autocomplete
     - Gets the field values based on given filter

     - examples: [{contentType=application/json, example={
  "response" : [ "response", "response" ],
  "version" : "version"
}}]
     - parameter functionName: (query) functionName (optional)
     - returns: RequestBuilder<SuccessResultList> 
     */
    open class func getNetworkDeviceFunctionalCcapabilityAutocompleteWithRequestBuilder(functionName: [String]? = nil) -> RequestBuilder<SuccessResultList> {
        let path = "/api/v1/network-device/functional-capability/autocomplete"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "functionName": functionName
        ])

        let requestBuilder: RequestBuilder<SuccessResultList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves network device by IP address
     - parameter ipAddress: (path) Device IP address 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceIpAddressByIpAddress(ipAddress: String, completion: @escaping ((_ data: NetworkDeviceResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceIpAddressByIpAddressWithRequestBuilder(ipAddress: ipAddress).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves network device by IP address
     - GET /api/v1/network-device/ip-address/${ipAddress}
     - Gets the network device with the given IP address

     - examples: [{contentType=application/json, example={
  "response" : {
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "type" : "type",
    "apManagerInterfaceIp" : "apManagerInterfaceIp",
    "lastUpdated" : "lastUpdated",
    "hostname" : "hostname",
    "tunnelUdpPort" : "tunnelUdpPort",
    "instanceTenantId" : "instanceTenantId",
    "bootDateTime" : "bootDateTime",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "waasDeviceMode" : "waasDeviceMode",
    "inventoryStatusDetail" : "inventoryStatusDetail",
    "snmpLocation" : "snmpLocation",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "softwareType" : "softwareType",
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "associatedWlcIp" : "associatedWlcIp",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "collectionStatus" : "collectionStatus",
    "series" : "series",
    "instanceUuid" : "instanceUuid",
    "tagCount" : "tagCount",
    "location" : "location",
    "family" : "family",
    "collectionInterval" : "collectionInterval",
    "softwareVersion" : "softwareVersion",
    "lastUpdateTime" : "lastUpdateTime"
  },
  "version" : "version"
}}]
     - parameter ipAddress: (path) Device IP address 
     - returns: RequestBuilder<NetworkDeviceResult> 
     */
    open class func getNetworkDeviceIpAddressByIpAddressWithRequestBuilder(ipAddress: String) -> RequestBuilder<NetworkDeviceResult> {
        var path = "/api/v1/network-device/ip-address/${ipAddress}"
        let ipAddressPreEscape = "\(ipAddress)"
        let ipAddressPostEscape = ipAddressPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{ipAddress}", with: ipAddressPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<NetworkDeviceResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get the organizations chosen while adding the meraki dashboard
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceMerakiOrganizationById(id: String, completion: @escaping ((_ data: SuccessResultList?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceMerakiOrganizationByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get the organizations chosen while adding the meraki dashboard
     - GET /api/v1/network-device/${id}/meraki-organization
     - This method is used to get the selected organizations for the meraki dashboard

     - examples: [{contentType=application/json, example={
  "response" : [ "response", "response" ],
  "version" : "version"
}}]
     - parameter id: (path) id 
     - returns: RequestBuilder<SuccessResultList> 
     */
    open class func getNetworkDeviceMerakiOrganizationByIdWithRequestBuilder(id: String) -> RequestBuilder<SuccessResultList> {
        var path = "/api/v1/network-device/${id}/meraki-organization"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResultList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Gives all the modules associated with given device id
     - parameter deviceId: (query) deviceId 
     - parameter limit: (query) limit (optional)
     - parameter offset: (query) offset (optional)
     - parameter nameList: (query) nameList (optional)
     - parameter vendorEquipmentTypeList: (query) vendorEquipmentTypeList (optional)
     - parameter partNumberList: (query) partNumberList (optional)
     - parameter operationalStateCodeList: (query) operationalStateCodeList (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceModule(deviceId: String, limit: String? = nil, offset: String? = nil, nameList: [String]? = nil, vendorEquipmentTypeList: [String]? = nil, partNumberList: [String]? = nil, operationalStateCodeList: [String]? = nil, completion: @escaping ((_ data: ModuleListResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceModuleWithRequestBuilder(deviceId: deviceId, limit: limit, offset: offset, nameList: nameList, vendorEquipmentTypeList: vendorEquipmentTypeList, partNumberList: partNumberList, operationalStateCodeList: operationalStateCodeList).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gives all the modules associated with given device id
     - GET /api/v1/network-device/module
     - Get modules of the given device id

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "serialNumber" : "serialNumber",
    "description" : "description",
    "moduleIndex" : 0,
    "containmentEntity" : "containmentEntity",
    "manufacturer" : "manufacturer",
    "isReportingAlarmsAllowed" : "UNKNOWN",
    "attributeInfo" : "{}",
    "entityPhysicalIndex" : "entityPhysicalIndex",
    "name" : "name",
    "partNumber" : "partNumber",
    "id" : "id",
    "isFieldReplaceable" : "UNKNOWN",
    "vendorEquipmentType" : "vendorEquipmentType",
    "assemblyNumber" : "assemblyNumber",
    "assemblyRevision" : "assemblyRevision",
    "operationalStateCode" : "operationalStateCode"
  }, {
    "serialNumber" : "serialNumber",
    "description" : "description",
    "moduleIndex" : 0,
    "containmentEntity" : "containmentEntity",
    "manufacturer" : "manufacturer",
    "isReportingAlarmsAllowed" : "UNKNOWN",
    "attributeInfo" : "{}",
    "entityPhysicalIndex" : "entityPhysicalIndex",
    "name" : "name",
    "partNumber" : "partNumber",
    "id" : "id",
    "isFieldReplaceable" : "UNKNOWN",
    "vendorEquipmentType" : "vendorEquipmentType",
    "assemblyNumber" : "assemblyNumber",
    "assemblyRevision" : "assemblyRevision",
    "operationalStateCode" : "operationalStateCode"
  } ],
  "version" : "version"
}}]
     - parameter deviceId: (query) deviceId 
     - parameter limit: (query) limit (optional)
     - parameter offset: (query) offset (optional)
     - parameter nameList: (query) nameList (optional)
     - parameter vendorEquipmentTypeList: (query) vendorEquipmentTypeList (optional)
     - parameter partNumberList: (query) partNumberList (optional)
     - parameter operationalStateCodeList: (query) operationalStateCodeList (optional)
     - returns: RequestBuilder<ModuleListResult> 
     */
    open class func getNetworkDeviceModuleWithRequestBuilder(deviceId: String, limit: String? = nil, offset: String? = nil, nameList: [String]? = nil, vendorEquipmentTypeList: [String]? = nil, partNumberList: [String]? = nil, operationalStateCodeList: [String]? = nil) -> RequestBuilder<ModuleListResult> {
        let path = "/api/v1/network-device/module"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "deviceId": deviceId, 
            "limit": limit, 
            "offset": offset, 
            "nameList": nameList, 
            "vendorEquipmentTypeList": vendorEquipmentTypeList, 
            "partNumberList": partNumberList, 
            "operationalStateCodeList": operationalStateCodeList
        ])

        let requestBuilder: RequestBuilder<ModuleListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Gives Module info by its id
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceModuleById(id: String, completion: @escaping ((_ data: ModuleResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceModuleByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gives Module info by its id
     - GET /api/v1/network-device/module/${id}
     - Get module by id

     - examples: [{contentType=application/json, example={
  "response" : {
    "serialNumber" : "serialNumber",
    "description" : "description",
    "moduleIndex" : 0,
    "containmentEntity" : "containmentEntity",
    "manufacturer" : "manufacturer",
    "isReportingAlarmsAllowed" : "UNKNOWN",
    "attributeInfo" : "{}",
    "entityPhysicalIndex" : "entityPhysicalIndex",
    "name" : "name",
    "partNumber" : "partNumber",
    "id" : "id",
    "isFieldReplaceable" : "UNKNOWN",
    "vendorEquipmentType" : "vendorEquipmentType",
    "assemblyNumber" : "assemblyNumber",
    "assemblyRevision" : "assemblyRevision",
    "operationalStateCode" : "operationalStateCode"
  },
  "version" : "version"
}}]
     - parameter id: (path) id 
     - returns: RequestBuilder<ModuleResult> 
     */
    open class func getNetworkDeviceModuleByIdWithRequestBuilder(id: String) -> RequestBuilder<ModuleResult> {
        var path = "/api/v1/network-device/module/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ModuleResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Gives total number of Modules
     - parameter deviceId: (query) deviceId 
     - parameter nameList: (query) nameList (optional)
     - parameter vendorEquipmentTypeList: (query) vendorEquipmentTypeList (optional)
     - parameter partNumberList: (query) partNumberList (optional)
     - parameter operationalStateCodeList: (query) operationalStateCodeList (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceModuleCount(deviceId: String, nameList: [String]? = nil, vendorEquipmentTypeList: [String]? = nil, partNumberList: [String]? = nil, operationalStateCodeList: [String]? = nil, completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceModuleCountWithRequestBuilder(deviceId: deviceId, nameList: nameList, vendorEquipmentTypeList: vendorEquipmentTypeList, partNumberList: partNumberList, operationalStateCodeList: operationalStateCodeList).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gives total number of Modules
     - GET /api/v1/network-device/module/count
     - Get Module Count

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - parameter deviceId: (query) deviceId 
     - parameter nameList: (query) nameList (optional)
     - parameter vendorEquipmentTypeList: (query) vendorEquipmentTypeList (optional)
     - parameter partNumberList: (query) partNumberList (optional)
     - parameter operationalStateCodeList: (query) operationalStateCodeList (optional)
     - returns: RequestBuilder<CountResult> 
     */
    open class func getNetworkDeviceModuleCountWithRequestBuilder(deviceId: String, nameList: [String]? = nil, vendorEquipmentTypeList: [String]? = nil, partNumberList: [String]? = nil, operationalStateCodeList: [String]? = nil) -> RequestBuilder<CountResult> {
        let path = "/api/v1/network-device/module/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "deviceId": deviceId, 
            "nameList": nameList, 
            "vendorEquipmentTypeList": vendorEquipmentTypeList, 
            "partNumberList": partNumberList, 
            "operationalStateCodeList": operationalStateCodeList
        ])

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get all keywords of CLIs accepted by command runner
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDevicePollerCliLegitReads(completion: @escaping ((_ data: LegitCliKeyResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDevicePollerCliLegitReadsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get all keywords of CLIs accepted by command runner
     - GET /api/v1/network-device-poller/cli/legit-reads
     - Get valid keywords

     - examples: [{contentType=application/json, example={
  "response" : [ "response", "response" ],
  "version" : "version"
}}]
     - returns: RequestBuilder<LegitCliKeyResult> 
     */
    open class func getNetworkDevicePollerCliLegitReadsWithRequestBuilder() -> RequestBuilder<LegitCliKeyResult> {
        let path = "/api/v1/network-device-poller/cli/legit-reads"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<LegitCliKeyResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves network device by range
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceRange(startIndex: Int32, recordsToReturn: Int32, completion: @escaping ((_ data: NetworkDeviceListResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceRangeWithRequestBuilder(startIndex: startIndex, recordsToReturn: recordsToReturn).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves network device by range
     - GET /api/v1/network-device/${startIndex}/${recordsToReturn}
     - Gets the list of network devices for the given range

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "type" : "type",
    "apManagerInterfaceIp" : "apManagerInterfaceIp",
    "lastUpdated" : "lastUpdated",
    "hostname" : "hostname",
    "tunnelUdpPort" : "tunnelUdpPort",
    "instanceTenantId" : "instanceTenantId",
    "bootDateTime" : "bootDateTime",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "waasDeviceMode" : "waasDeviceMode",
    "inventoryStatusDetail" : "inventoryStatusDetail",
    "snmpLocation" : "snmpLocation",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "softwareType" : "softwareType",
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "associatedWlcIp" : "associatedWlcIp",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "collectionStatus" : "collectionStatus",
    "series" : "series",
    "instanceUuid" : "instanceUuid",
    "tagCount" : "tagCount",
    "location" : "location",
    "family" : "family",
    "collectionInterval" : "collectionInterval",
    "softwareVersion" : "softwareVersion",
    "lastUpdateTime" : "lastUpdateTime"
  }, {
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "type" : "type",
    "apManagerInterfaceIp" : "apManagerInterfaceIp",
    "lastUpdated" : "lastUpdated",
    "hostname" : "hostname",
    "tunnelUdpPort" : "tunnelUdpPort",
    "instanceTenantId" : "instanceTenantId",
    "bootDateTime" : "bootDateTime",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "waasDeviceMode" : "waasDeviceMode",
    "inventoryStatusDetail" : "inventoryStatusDetail",
    "snmpLocation" : "snmpLocation",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "softwareType" : "softwareType",
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "associatedWlcIp" : "associatedWlcIp",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "collectionStatus" : "collectionStatus",
    "series" : "series",
    "instanceUuid" : "instanceUuid",
    "tagCount" : "tagCount",
    "location" : "location",
    "family" : "family",
    "collectionInterval" : "collectionInterval",
    "softwareVersion" : "softwareVersion",
    "lastUpdateTime" : "lastUpdateTime"
  } ],
  "version" : "version"
}}]
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - returns: RequestBuilder<NetworkDeviceListResult> 
     */
    open class func getNetworkDeviceRangeWithRequestBuilder(startIndex: Int32, recordsToReturn: Int32) -> RequestBuilder<NetworkDeviceListResult> {
        var path = "/api/v1/network-device/${startIndex}/${recordsToReturn}"
        let startIndexPreEscape = "\(startIndex)"
        let startIndexPostEscape = startIndexPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{startIndex}", with: startIndexPostEscape, options: .literal, range: nil)
        let recordsToReturnPreEscape = "\(recordsToReturn)"
        let recordsToReturnPostEscape = recordsToReturnPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{recordsToReturn}", with: recordsToReturnPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<NetworkDeviceListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves network device by serial number
     - parameter serialNumber: (path) Device serial number 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceSerialNumberBySerialNumber(serialNumber: String, completion: @escaping ((_ data: NetworkDeviceResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceSerialNumberBySerialNumberWithRequestBuilder(serialNumber: serialNumber).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves network device by serial number
     - GET /api/v1/network-device/serial-number/${serialNumber}
     - Gets the network device with the given serial number

     - examples: [{contentType=application/json, example={
  "response" : {
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "type" : "type",
    "apManagerInterfaceIp" : "apManagerInterfaceIp",
    "lastUpdated" : "lastUpdated",
    "hostname" : "hostname",
    "tunnelUdpPort" : "tunnelUdpPort",
    "instanceTenantId" : "instanceTenantId",
    "bootDateTime" : "bootDateTime",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "waasDeviceMode" : "waasDeviceMode",
    "inventoryStatusDetail" : "inventoryStatusDetail",
    "snmpLocation" : "snmpLocation",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "softwareType" : "softwareType",
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "associatedWlcIp" : "associatedWlcIp",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "collectionStatus" : "collectionStatus",
    "series" : "series",
    "instanceUuid" : "instanceUuid",
    "tagCount" : "tagCount",
    "location" : "location",
    "family" : "family",
    "collectionInterval" : "collectionInterval",
    "softwareVersion" : "softwareVersion",
    "lastUpdateTime" : "lastUpdateTime"
  },
  "version" : "version"
}}]
     - parameter serialNumber: (path) Device serial number 
     - returns: RequestBuilder<NetworkDeviceResult> 
     */
    open class func getNetworkDeviceSerialNumberBySerialNumberWithRequestBuilder(serialNumber: String) -> RequestBuilder<NetworkDeviceResult> {
        var path = "/api/v1/network-device/serial-number/${serialNumber}"
        let serialNumberPreEscape = "\(serialNumber)"
        let serialNumberPostEscape = serialNumberPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{serialNumber}", with: serialNumberPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<NetworkDeviceResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Updates certificate validation status and returns tenantId
     - parameter serialNumber: (query) Serial number of the device (optional)
     - parameter macaddress: (query) Mac addres of the device (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceTenantinfoMacaddress(serialNumber: String? = nil, macaddress: String? = nil, completion: @escaping ((_ data: RegisterNetworkDeviceResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceTenantinfoMacaddressWithRequestBuilder(serialNumber: serialNumber, macaddress: macaddress).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates certificate validation status and returns tenantId
     - GET /api/v1/network-device/tenantinfo/macaddress
     - Registers a device for WSA notification

     - examples: [{contentType=application/json, example={
  "response" : {
    "macAddress" : "macAddress",
    "serialNumber" : "serialNumber",
    "name" : "name",
    "tenantId" : "tenantId",
    "modelNumber" : "modelNumber"
  },
  "version" : "version"
}}]
     - parameter serialNumber: (query) Serial number of the device (optional)
     - parameter macaddress: (query) Mac addres of the device (optional)
     - returns: RequestBuilder<RegisterNetworkDeviceResult> 
     */
    open class func getNetworkDeviceTenantinfoMacaddressWithRequestBuilder(serialNumber: String? = nil, macaddress: String? = nil) -> RequestBuilder<RegisterNetworkDeviceResult> {
        let path = "/api/v1/network-device/tenantinfo/macaddress"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "serialNumber": serialNumber, 
            "macaddress": macaddress
        ])

        let requestBuilder: RequestBuilder<RegisterNetworkDeviceResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves list of VLAN data that are associated with interface for a device
     - parameter id: (path) deviceUUID 
     - parameter interfaceType: (query) Vlan assocaited with sub-interface (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceVlanById(id: String, interfaceType: String? = nil, completion: @escaping ((_ data: VlanListResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceVlanByIdWithRequestBuilder(id: id, interfaceType: interfaceType).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves list of VLAN data that are associated with interface for a device
     - GET /api/v1/network-device/${id}/vlan
     - getDeviceVLANData

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "prefix" : "prefix",
    "ipAddress" : "ipAddress",
    "vlanNumber" : 1,
    "vlanType" : "vlanType",
    "interfaceName" : "interfaceName",
    "networkAddress" : "networkAddress",
    "numberOfIPs" : 6,
    "mask" : 0
  }, {
    "prefix" : "prefix",
    "ipAddress" : "ipAddress",
    "vlanNumber" : 1,
    "vlanType" : "vlanType",
    "interfaceName" : "interfaceName",
    "networkAddress" : "networkAddress",
    "numberOfIPs" : 6,
    "mask" : 0
  } ],
  "version" : "version"
}}]
     - parameter id: (path) deviceUUID 
     - parameter interfaceType: (query) Vlan assocaited with sub-interface (optional)
     - returns: RequestBuilder<VlanListResult> 
     */
    open class func getNetworkDeviceVlanByIdWithRequestBuilder(id: String, interfaceType: String? = nil) -> RequestBuilder<VlanListResult> {
        var path = "/api/v1/network-device/${id}/vlan"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "interfaceType": interfaceType
        ])

        let requestBuilder: RequestBuilder<VlanListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves wireless lan conrtoller info by Device ID
     - parameter id: (path) Device ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceWirelessInfoById(id: String, completion: @escaping ((_ data: WirelessInfoResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceWirelessInfoByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves wireless lan conrtoller info by Device ID
     - GET /api/v1/network-device/${id}/wireless-info
     - Gets the wireless lan controller info using the given device ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "lagModeEnabled" : true,
    "instanceTenantId" : "instanceTenantId",
    "wirelessLicenseInfo" : "ADVANTAGE",
    "apGroupName" : "apGroupName",
    "instanceUuid" : "instanceUuid",
    "adminEnabledPorts" : [ 0, 0 ],
    "flexGroupName" : "flexGroupName",
    "id" : "id",
    "wirelessPackageInstalled" : true,
    "ethMacAddress" : "ethMacAddress",
    "deviceId" : "deviceId",
    "netconfEnabled" : true
  },
  "version" : "version"
}}]
     - parameter id: (path) Device ID 
     - returns: RequestBuilder<WirelessInfoResult> 
     */
    open class func getNetworkDeviceWirelessInfoByIdWithRequestBuilder(id: String) -> RequestBuilder<WirelessInfoResult> {
        var path = "/api/v1/network-device/${id}/wireless-info"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<WirelessInfoResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Network device POST api
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postNetworkDevice(request: InventoryDeviceInfo, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postNetworkDeviceWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Network device POST api
     - POST /api/v1/network-device
     - Adds the device with given credential

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func postNetworkDeviceWithRequestBuilder(request: InventoryDeviceInfo) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/network-device"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Export network-device to file
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postNetworkDeviceFile(request: ExportDeviceDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postNetworkDeviceFileWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Export network-device to file
     - POST /api/v1/network-device/file
     - Export the selected network-device to a file

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func postNetworkDeviceFileWithRequestBuilder(request: ExportDeviceDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/network-device/file"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Run read-only commands on devices to get their real-time configuration
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postNetworkDevicePollerCliReadRequest(request: CommandRunnerDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postNetworkDevicePollerCliReadRequestWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Run read-only commands on devices to get their real-time configuration
     - POST /api/v1/network-device-poller/cli/read-request
     - Submit request for read-only CLIs

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func postNetworkDevicePollerCliReadRequestWithRequestBuilder(request: CommandRunnerDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/network-device-poller/cli/read-request"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Network device sync api
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putNetworkDevice(request: InventoryDeviceInfo, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putNetworkDeviceWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Network device sync api
     - PUT /api/v1/network-device
     - Sync the devices provided as input

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func putNetworkDeviceWithRequestBuilder(request: InventoryDeviceInfo) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/network-device"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates network device role
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putNetworkDeviceBrief(request: NetworkDeviceBriefNIO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putNetworkDeviceBriefWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates network device role
     - PUT /api/v1/network-device/brief
     - Updates the role of the device as access, core, distribution, border router

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func putNetworkDeviceBriefWithRequestBuilder(request: NetworkDeviceBriefNIO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/network-device/brief"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Network device sync api
     - parameter request: (body) request 
     - parameter forceSync: (query) forceSync (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putNetworkDeviceSync(request: NetworkDeviceSyncApiRequest, forceSync: Bool? = nil, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putNetworkDeviceSyncWithRequestBuilder(request: request, forceSync: forceSync).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Network device sync api
     - PUT /api/v1/network-device/sync
     - Sync's the devices. If forceSync param is false (default) then the sync would run in normal priority thread. If forceSync param is true then the sync would run in high priority thread if avaiable, else the sync will fail. Result can be seen in the child task of each device

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - parameter forceSync: (query) forceSync (optional)
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func putNetworkDeviceSyncWithRequestBuilder(request: NetworkDeviceSyncApiRequest, forceSync: Bool? = nil) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/network-device/sync"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "forceSync": forceSync
        ])

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
