//
// DiscoveryAPI.swift
//

//

import Foundation
import Alamofire


open class DiscoveryAPI: APIBase {
    /**
     Deletes all discovery
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteDiscovery(completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteDiscoveryWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deletes all discovery
     - DELETE /api/v1/discovery
     - Stops all the discoveries and removes them

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteDiscoveryWithRequestBuilder() -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/discovery"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Deletes the discovery specified by id
     - parameter id: (path) Discovery ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteDiscoveryById(id: String, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteDiscoveryByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deletes the discovery specified by id
     - DELETE /api/v1/discovery/${id}
     - Stops the discovery for the given ID and removes it

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter id: (path) Discovery ID 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteDiscoveryByIdWithRequestBuilder(id: String) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/discovery/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Deletes the discovery in the given range
     - parameter startIndex: (path) Start index 
     - parameter recordsToDelete: (path) Number of records to delete 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteDiscoveryRange(startIndex: Int32, recordsToDelete: Int32, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteDiscoveryRangeWithRequestBuilder(startIndex: startIndex, recordsToDelete: recordsToDelete).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deletes the discovery in the given range
     - DELETE /api/v1/discovery/${startIndex}/${recordsToDelete}
     - Stops discovery for the given range and removes them

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter startIndex: (path) Start index 
     - parameter recordsToDelete: (path) Number of records to delete 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteDiscoveryRangeWithRequestBuilder(startIndex: Int32, recordsToDelete: Int32) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/discovery/${startIndex}/${recordsToDelete}"
        let startIndexPreEscape = "\(startIndex)"
        let startIndexPostEscape = startIndexPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{startIndex}", with: startIndexPostEscape, options: .literal, range: nil)
        let recordsToDeletePreEscape = "\(recordsToDelete)"
        let recordsToDeletePostEscape = recordsToDeletePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{recordsToDelete}", with: recordsToDeletePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieve autoComplete values from a discovery based on id
     - parameter id: (path) id 
     - parameter taskId: (query) taskId (optional)
     - parameter ipAddress: (query) ipAddress (optional)
     - parameter pingStatus: (query) pingStatus (optional)
     - parameter snmpStatus: (query) snmpStatus (optional)
     - parameter cliStatus: (query) cliStatus (optional)
     - parameter netconfStatus: (query) netconfStatus (optional)
     - parameter httpStatus: (query) httpStatus (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryAutoCompleteById(id: String, taskId: String? = nil, ipAddress: String? = nil, pingStatus: String? = nil, snmpStatus: String? = nil, cliStatus: String? = nil, netconfStatus: String? = nil, httpStatus: String? = nil, completion: @escaping ((_ data: SuccessResultList?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryAutoCompleteByIdWithRequestBuilder(id: id, taskId: taskId, ipAddress: ipAddress, pingStatus: pingStatus, snmpStatus: snmpStatus, cliStatus: cliStatus, netconfStatus: netconfStatus, httpStatus: httpStatus).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieve autoComplete values from a discovery based on id
     - GET /api/v1/discovery/${id}/autoComplete
     - Gets the autoComplete values from a discovery job

     - examples: [{contentType=application/json, example={
  "response" : [ "response", "response" ],
  "version" : "version"
}}]
     - parameter id: (path) id 
     - parameter taskId: (query) taskId (optional)
     - parameter ipAddress: (query) ipAddress (optional)
     - parameter pingStatus: (query) pingStatus (optional)
     - parameter snmpStatus: (query) snmpStatus (optional)
     - parameter cliStatus: (query) cliStatus (optional)
     - parameter netconfStatus: (query) netconfStatus (optional)
     - parameter httpStatus: (query) httpStatus (optional)
     - returns: RequestBuilder<SuccessResultList> 
     */
    open class func getDiscoveryAutoCompleteByIdWithRequestBuilder(id: String, taskId: String? = nil, ipAddress: String? = nil, pingStatus: String? = nil, snmpStatus: String? = nil, cliStatus: String? = nil, netconfStatus: String? = nil, httpStatus: String? = nil) -> RequestBuilder<SuccessResultList> {
        var path = "/api/v1/discovery/${id}/autoComplete"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "taskId": taskId, 
            "ipAddress": ipAddress, 
            "pingStatus": pingStatus, 
            "snmpStatus": snmpStatus, 
            "cliStatus": cliStatus, 
            "netconfStatus": netconfStatus, 
            "httpStatus": httpStatus
        ])

        let requestBuilder: RequestBuilder<SuccessResultList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the discovery specified by id
     - parameter id: (path) Discovery ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryById(id: String, completion: @escaping ((_ data: DiscoveryNIOResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the discovery specified by id
     - GET /api/v1/discovery/${id}
     - Gets discovery by ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "deviceIds" : "deviceIds",
    "netconfPort" : "netconfPort",
    "snmpRoCommunityDesc" : "snmpRoCommunityDesc",
    "discoveryStatus" : "discoveryStatus",
    "globalCredentialIdList" : [ "globalCredentialIdList", "globalCredentialIdList" ],
    "preferredMgmtIPMethod" : "preferredMgmtIPMethod",
    "snmpAuthPassphrase" : "snmpAuthPassphrase",
    "ipAddressList" : "ipAddressList",
    "updateMgmtIp" : true,
    "passwordList" : "passwordList",
    "snmpRwCommunityDesc" : "snmpRwCommunityDesc",
    "numDevices" : 5,
    "lldpLevel" : 1,
    "discoveryCondition" : "discoveryCondition",
    "httpWriteCredential" : {
      "credentialType" : "GLOBAL",
      "password" : "password",
      "comments" : "comments",
      "instanceTenantId" : "instanceTenantId",
      "port" : 6,
      "instanceUuid" : "instanceUuid",
      "description" : "description",
      "id" : "id",
      "secure" : true,
      "username" : "username"
    },
    "snmpAuthProtocol" : "snmpAuthProtocol",
    "cdpLevel" : 0,
    "enablePasswordList" : "enablePasswordList",
    "ipFilterList" : "ipFilterList",
    "id" : "id",
    "protocolOrder" : "protocolOrder",
    "isAutoCdp" : true,
    "parentDiscoveryId" : "parentDiscoveryId",
    "discoveryType" : "discoveryType",
    "userNameList" : "userNameList",
    "snmpMode" : "snmpMode",
    "retryCount" : 5,
    "snmpPrivPassphrase" : "snmpPrivPassphrase",
    "snmpUserName" : "snmpUserName",
    "timeOut" : 2,
    "attributeInfo" : "{}",
    "name" : "name",
    "snmpRwCommunity" : "snmpRwCommunity",
    "snmpRoCommunity" : "snmpRoCommunity",
    "httpReadCredential" : {
      "credentialType" : "GLOBAL",
      "password" : "password",
      "comments" : "comments",
      "instanceTenantId" : "instanceTenantId",
      "port" : 6,
      "instanceUuid" : "instanceUuid",
      "description" : "description",
      "id" : "id",
      "secure" : true,
      "username" : "username"
    },
    "snmpPrivProtocol" : "snmpPrivProtocol"
  },
  "version" : "version"
}}]
     - parameter id: (path) Discovery ID 
     - returns: RequestBuilder<DiscoveryNIOResult> 
     */
    open class func getDiscoveryByIdWithRequestBuilder(id: String) -> RequestBuilder<DiscoveryNIOResult> {
        var path = "/api/v1/discovery/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DiscoveryNIOResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the number of discoveries
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryCount(completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryCountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the number of discoveries
     - GET /api/v1/discovery/count
     - Gets the count of all available discovery jobs

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - returns: RequestBuilder<CountResult> 
     */
    open class func getDiscoveryCountWithRequestBuilder() -> RequestBuilder<CountResult> {
        let path = "/api/v1/discovery/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the list of discovery jobs for the given IP
     - parameter ipAddress: (query) ipAddress 
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - parameter name: (query) name (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryJob(ipAddress: String, offset: Int32? = nil, limit: Int32? = nil, name: String? = nil, completion: @escaping ((_ data: DiscoveryJobNIOListResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryJobWithRequestBuilder(ipAddress: ipAddress, offset: offset, limit: limit, name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the list of discovery jobs for the given IP
     - GET /api/v1/discovery/job
     - Gets the list of discovery jobs for the given IP

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "jobStatus" : "jobStatus",
    "snmpStatus" : "snmpStatus",
    "cliStatus" : "cliStatus",
    "discoveryStatus" : "discoveryStatus",
    "ipAddress" : "ipAddress",
    "pingStatus" : "pingStatus",
    "attributeInfo" : "{}",
    "netconfStatus" : "netconfStatus",
    "httpStatus" : "httpStatus",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "taskId" : "taskId"
  }, {
    "jobStatus" : "jobStatus",
    "snmpStatus" : "snmpStatus",
    "cliStatus" : "cliStatus",
    "discoveryStatus" : "discoveryStatus",
    "ipAddress" : "ipAddress",
    "pingStatus" : "pingStatus",
    "attributeInfo" : "{}",
    "netconfStatus" : "netconfStatus",
    "httpStatus" : "httpStatus",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "taskId" : "taskId"
  } ],
  "version" : "version"
}}]
     - parameter ipAddress: (query) ipAddress 
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - parameter name: (query) name (optional)
     - returns: RequestBuilder<DiscoveryJobNIOListResult> 
     */
    open class func getDiscoveryJobWithRequestBuilder(ipAddress: String, offset: Int32? = nil, limit: Int32? = nil, name: String? = nil) -> RequestBuilder<DiscoveryJobNIOListResult> {
        let path = "/api/v1/discovery/job"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "offset": offset?.encodeToJSON(), 
            "limit": limit?.encodeToJSON(), 
            "ipAddress": ipAddress, 
            "name": name
        ])

        let requestBuilder: RequestBuilder<DiscoveryJobNIOListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves list of discovery jobs for the specified discovery id
     - parameter id: (path) Discovery ID 
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - parameter ipAddress: (query) ipAddress (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryJobById(id: String, offset: Int32? = nil, limit: Int32? = nil, ipAddress: String? = nil, completion: @escaping ((_ data: DiscoveryJobNIOListResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryJobByIdWithRequestBuilder(id: id, offset: offset, limit: limit, ipAddress: ipAddress).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves list of discovery jobs for the specified discovery id
     - GET /api/v1/discovery/${id}/job
     - Gets the list of discovery jobs for the given id. The result can optionally be filtered based on IP

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "jobStatus" : "jobStatus",
    "snmpStatus" : "snmpStatus",
    "cliStatus" : "cliStatus",
    "discoveryStatus" : "discoveryStatus",
    "ipAddress" : "ipAddress",
    "pingStatus" : "pingStatus",
    "attributeInfo" : "{}",
    "netconfStatus" : "netconfStatus",
    "httpStatus" : "httpStatus",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "taskId" : "taskId"
  }, {
    "jobStatus" : "jobStatus",
    "snmpStatus" : "snmpStatus",
    "cliStatus" : "cliStatus",
    "discoveryStatus" : "discoveryStatus",
    "ipAddress" : "ipAddress",
    "pingStatus" : "pingStatus",
    "attributeInfo" : "{}",
    "netconfStatus" : "netconfStatus",
    "httpStatus" : "httpStatus",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "taskId" : "taskId"
  } ],
  "version" : "version"
}}]
     - parameter id: (path) Discovery ID 
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - parameter ipAddress: (query) ipAddress (optional)
     - returns: RequestBuilder<DiscoveryJobNIOListResult> 
     */
    open class func getDiscoveryJobByIdWithRequestBuilder(id: String, offset: Int32? = nil, limit: Int32? = nil, ipAddress: String? = nil) -> RequestBuilder<DiscoveryJobNIOListResult> {
        var path = "/api/v1/discovery/${id}/job"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "offset": offset?.encodeToJSON(), 
            "limit": limit?.encodeToJSON(), 
            "ipAddress": ipAddress
        ])

        let requestBuilder: RequestBuilder<DiscoveryJobNIOListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the range of network devices discovered for the given discovery
     - parameter id: (path) Discovery ID 
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - parameter taskId: (query) taskId (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryNetworkDeviceByIdRange(id: String, startIndex: Int32, recordsToReturn: Int32, taskId: String? = nil, completion: @escaping ((_ data: NetworkDeviceNIOListResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryNetworkDeviceByIdRangeWithRequestBuilder(id: id, startIndex: startIndex, recordsToReturn: recordsToReturn, taskId: taskId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the range of network devices discovered for the given discovery
     - GET /api/v1/discovery/${id}/network-device/${startIndex}/${recordsToReturn}
     - Gets the network devices discovered for the given discovery and for the given range. The maximum number of records that could be retrieved is 500

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "portRange" : "portRange",
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "ingressQueueConfig" : "ingressQueueConfig",
    "pingStatus" : "pingStatus",
    "type" : "type",
    "numUpdates" : 6,
    "lastUpdated" : "lastUpdated",
    "qosStatus" : "qosStatus",
    "hostname" : "hostname",
    "authModelId" : "authModelId",
    "netconfStatus" : "netconfStatus",
    "vendor" : "vendor",
    "bootDateTime" : "bootDateTime",
    "duplicateDeviceId" : "duplicateDeviceId",
    "httpStatus" : "httpStatus",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "tag" : "tag",
    "snmpLocation" : "snmpLocation",
    "snmpStatus" : "snmpStatus",
    "imageName" : "imageName",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "cliStatus" : "cliStatus",
    "avgUpdateFrequency" : 0,
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "wlcApDeviceStatus" : "wlcApDeviceStatus",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "anchorWlcForAp" : "anchorWlcForAp",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "tagCount" : 1,
    "location" : "location",
    "family" : "family",
    "softwareVersion" : "softwareVersion"
  }, {
    "portRange" : "portRange",
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "ingressQueueConfig" : "ingressQueueConfig",
    "pingStatus" : "pingStatus",
    "type" : "type",
    "numUpdates" : 6,
    "lastUpdated" : "lastUpdated",
    "qosStatus" : "qosStatus",
    "hostname" : "hostname",
    "authModelId" : "authModelId",
    "netconfStatus" : "netconfStatus",
    "vendor" : "vendor",
    "bootDateTime" : "bootDateTime",
    "duplicateDeviceId" : "duplicateDeviceId",
    "httpStatus" : "httpStatus",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "tag" : "tag",
    "snmpLocation" : "snmpLocation",
    "snmpStatus" : "snmpStatus",
    "imageName" : "imageName",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "cliStatus" : "cliStatus",
    "avgUpdateFrequency" : 0,
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "wlcApDeviceStatus" : "wlcApDeviceStatus",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "anchorWlcForAp" : "anchorWlcForAp",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "tagCount" : 1,
    "location" : "location",
    "family" : "family",
    "softwareVersion" : "softwareVersion"
  } ],
  "version" : "version"
}}]
     - parameter id: (path) Discovery ID 
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - parameter taskId: (query) taskId (optional)
     - returns: RequestBuilder<NetworkDeviceNIOListResult> 
     */
    open class func getDiscoveryNetworkDeviceByIdRangeWithRequestBuilder(id: String, startIndex: Int32, recordsToReturn: Int32, taskId: String? = nil) -> RequestBuilder<NetworkDeviceNIOListResult> {
        var path = "/api/v1/discovery/${id}/network-device/${startIndex}/${recordsToReturn}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let startIndexPreEscape = "\(startIndex)"
        let startIndexPostEscape = startIndexPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{startIndex}", with: startIndexPostEscape, options: .literal, range: nil)
        let recordsToReturnPreEscape = "\(recordsToReturn)"
        let recordsToReturnPostEscape = recordsToReturnPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{recordsToReturn}", with: recordsToReturnPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "taskId": taskId
        ])

        let requestBuilder: RequestBuilder<NetworkDeviceNIOListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the number of network devices discovered in the discovery specified by id
     - parameter id: (path) Discovery ID 
     - parameter taskId: (query) taskId (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryNetworkDeviceCountById(id: String, taskId: String? = nil, completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryNetworkDeviceCountByIdWithRequestBuilder(id: id, taskId: taskId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the number of network devices discovered in the discovery specified by id
     - GET /api/v1/discovery/${id}/network-device/count
     - Gets the count of network devices discovered in the given discovery

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - parameter id: (path) Discovery ID 
     - parameter taskId: (query) taskId (optional)
     - returns: RequestBuilder<CountResult> 
     */
    open class func getDiscoveryNetworkDeviceCountByIdWithRequestBuilder(id: String, taskId: String? = nil) -> RequestBuilder<CountResult> {
        var path = "/api/v1/discovery/${id}/network-device/count"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "taskId": taskId
        ])

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the network devices discovered in the discovery specified by id
     - parameter id: (path) id 
     - parameter taskId: (query) taskId (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryNetworkNetworkDeviceById(id: String, taskId: String? = nil, completion: @escaping ((_ data: NetworkDeviceNIOListResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryNetworkNetworkDeviceByIdWithRequestBuilder(id: id, taskId: taskId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the network devices discovered in the discovery specified by id
     - GET /api/v1/discovery/${id}/network-device
     - Gets the network devices discovered for the given discovery

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "portRange" : "portRange",
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "ingressQueueConfig" : "ingressQueueConfig",
    "pingStatus" : "pingStatus",
    "type" : "type",
    "numUpdates" : 6,
    "lastUpdated" : "lastUpdated",
    "qosStatus" : "qosStatus",
    "hostname" : "hostname",
    "authModelId" : "authModelId",
    "netconfStatus" : "netconfStatus",
    "vendor" : "vendor",
    "bootDateTime" : "bootDateTime",
    "duplicateDeviceId" : "duplicateDeviceId",
    "httpStatus" : "httpStatus",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "tag" : "tag",
    "snmpLocation" : "snmpLocation",
    "snmpStatus" : "snmpStatus",
    "imageName" : "imageName",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "cliStatus" : "cliStatus",
    "avgUpdateFrequency" : 0,
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "wlcApDeviceStatus" : "wlcApDeviceStatus",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "anchorWlcForAp" : "anchorWlcForAp",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "tagCount" : 1,
    "location" : "location",
    "family" : "family",
    "softwareVersion" : "softwareVersion"
  }, {
    "portRange" : "portRange",
    "role" : "role",
    "errorDescription" : "errorDescription",
    "errorCode" : "errorCode",
    "reachabilityFailureReason" : "reachabilityFailureReason",
    "ingressQueueConfig" : "ingressQueueConfig",
    "pingStatus" : "pingStatus",
    "type" : "type",
    "numUpdates" : 6,
    "lastUpdated" : "lastUpdated",
    "qosStatus" : "qosStatus",
    "hostname" : "hostname",
    "authModelId" : "authModelId",
    "netconfStatus" : "netconfStatus",
    "vendor" : "vendor",
    "bootDateTime" : "bootDateTime",
    "duplicateDeviceId" : "duplicateDeviceId",
    "httpStatus" : "httpStatus",
    "interfaceCount" : "interfaceCount",
    "id" : "id",
    "lineCardId" : "lineCardId",
    "roleSource" : "roleSource",
    "tag" : "tag",
    "snmpLocation" : "snmpLocation",
    "snmpStatus" : "snmpStatus",
    "imageName" : "imageName",
    "locationName" : "locationName",
    "serialNumber" : "serialNumber",
    "snmpContact" : "snmpContact",
    "cliStatus" : "cliStatus",
    "avgUpdateFrequency" : 0,
    "lineCardCount" : "lineCardCount",
    "managementIpAddress" : "managementIpAddress",
    "wlcApDeviceStatus" : "wlcApDeviceStatus",
    "platformId" : "platformId",
    "reachabilityStatus" : "reachabilityStatus",
    "upTime" : "upTime",
    "macAddress" : "macAddress",
    "memorySize" : "memorySize",
    "anchorWlcForAp" : "anchorWlcForAp",
    "inventoryCollectionStatus" : "inventoryCollectionStatus",
    "inventoryReachabilityStatus" : "inventoryReachabilityStatus",
    "tagCount" : 1,
    "location" : "location",
    "family" : "family",
    "softwareVersion" : "softwareVersion"
  } ],
  "version" : "version"
}}]
     - parameter id: (path) id 
     - parameter taskId: (query) taskId (optional)
     - returns: RequestBuilder<NetworkDeviceNIOListResult> 
     */
    open class func getDiscoveryNetworkNetworkDeviceByIdWithRequestBuilder(id: String, taskId: String? = nil) -> RequestBuilder<NetworkDeviceNIOListResult> {
        var path = "/api/v1/discovery/${id}/network-device"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "taskId": taskId
        ])

        let requestBuilder: RequestBuilder<NetworkDeviceNIOListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves the discovery in the given range
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoveryRange(startIndex: Int32, recordsToReturn: Int32, completion: @escaping ((_ data: DiscoveryNIOListResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoveryRangeWithRequestBuilder(startIndex: startIndex, recordsToReturn: recordsToReturn).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves the discovery in the given range
     - GET /api/v1/discovery/${startIndex}/${recordsToReturn}
     - Gets the discovery for the range specified

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "deviceIds" : "deviceIds",
    "netconfPort" : "netconfPort",
    "snmpRoCommunityDesc" : "snmpRoCommunityDesc",
    "discoveryStatus" : "discoveryStatus",
    "globalCredentialIdList" : [ "globalCredentialIdList", "globalCredentialIdList" ],
    "preferredMgmtIPMethod" : "preferredMgmtIPMethod",
    "snmpAuthPassphrase" : "snmpAuthPassphrase",
    "ipAddressList" : "ipAddressList",
    "updateMgmtIp" : true,
    "passwordList" : "passwordList",
    "snmpRwCommunityDesc" : "snmpRwCommunityDesc",
    "numDevices" : 5,
    "lldpLevel" : 1,
    "discoveryCondition" : "discoveryCondition",
    "httpWriteCredential" : {
      "credentialType" : "GLOBAL",
      "password" : "password",
      "comments" : "comments",
      "instanceTenantId" : "instanceTenantId",
      "port" : 6,
      "instanceUuid" : "instanceUuid",
      "description" : "description",
      "id" : "id",
      "secure" : true,
      "username" : "username"
    },
    "snmpAuthProtocol" : "snmpAuthProtocol",
    "cdpLevel" : 0,
    "enablePasswordList" : "enablePasswordList",
    "ipFilterList" : "ipFilterList",
    "id" : "id",
    "protocolOrder" : "protocolOrder",
    "isAutoCdp" : true,
    "parentDiscoveryId" : "parentDiscoveryId",
    "discoveryType" : "discoveryType",
    "userNameList" : "userNameList",
    "snmpMode" : "snmpMode",
    "retryCount" : 5,
    "snmpPrivPassphrase" : "snmpPrivPassphrase",
    "snmpUserName" : "snmpUserName",
    "timeOut" : 2,
    "attributeInfo" : "{}",
    "name" : "name",
    "snmpRwCommunity" : "snmpRwCommunity",
    "snmpRoCommunity" : "snmpRoCommunity",
    "httpReadCredential" : {
      "credentialType" : "GLOBAL",
      "password" : "password",
      "comments" : "comments",
      "instanceTenantId" : "instanceTenantId",
      "port" : 6,
      "instanceUuid" : "instanceUuid",
      "description" : "description",
      "id" : "id",
      "secure" : true,
      "username" : "username"
    },
    "snmpPrivProtocol" : "snmpPrivProtocol"
  }, {
    "deviceIds" : "deviceIds",
    "netconfPort" : "netconfPort",
    "snmpRoCommunityDesc" : "snmpRoCommunityDesc",
    "discoveryStatus" : "discoveryStatus",
    "globalCredentialIdList" : [ "globalCredentialIdList", "globalCredentialIdList" ],
    "preferredMgmtIPMethod" : "preferredMgmtIPMethod",
    "snmpAuthPassphrase" : "snmpAuthPassphrase",
    "ipAddressList" : "ipAddressList",
    "updateMgmtIp" : true,
    "passwordList" : "passwordList",
    "snmpRwCommunityDesc" : "snmpRwCommunityDesc",
    "numDevices" : 5,
    "lldpLevel" : 1,
    "discoveryCondition" : "discoveryCondition",
    "httpWriteCredential" : {
      "credentialType" : "GLOBAL",
      "password" : "password",
      "comments" : "comments",
      "instanceTenantId" : "instanceTenantId",
      "port" : 6,
      "instanceUuid" : "instanceUuid",
      "description" : "description",
      "id" : "id",
      "secure" : true,
      "username" : "username"
    },
    "snmpAuthProtocol" : "snmpAuthProtocol",
    "cdpLevel" : 0,
    "enablePasswordList" : "enablePasswordList",
    "ipFilterList" : "ipFilterList",
    "id" : "id",
    "protocolOrder" : "protocolOrder",
    "isAutoCdp" : true,
    "parentDiscoveryId" : "parentDiscoveryId",
    "discoveryType" : "discoveryType",
    "userNameList" : "userNameList",
    "snmpMode" : "snmpMode",
    "retryCount" : 5,
    "snmpPrivPassphrase" : "snmpPrivPassphrase",
    "snmpUserName" : "snmpUserName",
    "timeOut" : 2,
    "attributeInfo" : "{}",
    "name" : "name",
    "snmpRwCommunity" : "snmpRwCommunity",
    "snmpRoCommunity" : "snmpRoCommunity",
    "httpReadCredential" : {
      "credentialType" : "GLOBAL",
      "password" : "password",
      "comments" : "comments",
      "instanceTenantId" : "instanceTenantId",
      "port" : 6,
      "instanceUuid" : "instanceUuid",
      "description" : "description",
      "id" : "id",
      "secure" : true,
      "username" : "username"
    },
    "snmpPrivProtocol" : "snmpPrivProtocol"
  } ],
  "version" : "version"
}}]
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - returns: RequestBuilder<DiscoveryNIOListResult> 
     */
    open class func getDiscoveryRangeWithRequestBuilder(startIndex: Int32, recordsToReturn: Int32) -> RequestBuilder<DiscoveryNIOListResult> {
        var path = "/api/v1/discovery/${startIndex}/${recordsToReturn}"
        let startIndexPreEscape = "\(startIndex)"
        let startIndexPostEscape = startIndexPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{startIndex}", with: startIndexPostEscape, options: .literal, range: nil)
        let recordsToReturnPreEscape = "\(recordsToReturn)"
        let recordsToReturnPostEscape = recordsToReturnPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{recordsToReturn}", with: recordsToReturnPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DiscoveryNIOListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieve network devices from a discovery on given filters
     - parameter id: (path) id 
     - parameter taskId: (query) taskId (optional)
     - parameter sortBy: (query) sortBy (optional)
     - parameter sortOrder: (query) sortOrder (optional)
     - parameter ipAddress: (query) ipAddress (optional)
     - parameter pingStatus: (query) pingStatus (optional)
     - parameter snmpStatus: (query) snmpStatus (optional)
     - parameter cliStatus: (query) cliStatus (optional)
     - parameter netconfStatus: (query) netconfStatus (optional)
     - parameter httpStatus: (query) httpStatus (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDiscoverySummaryById(id: String, taskId: String? = nil, sortBy: String? = nil, sortOrder: String? = nil, ipAddress: [String]? = nil, pingStatus: [String]? = nil, snmpStatus: [String]? = nil, cliStatus: [String]? = nil, netconfStatus: [String]? = nil, httpStatus: [String]? = nil, completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getDiscoverySummaryByIdWithRequestBuilder(id: id, taskId: taskId, sortBy: sortBy, sortOrder: sortOrder, ipAddress: ipAddress, pingStatus: pingStatus, snmpStatus: snmpStatus, cliStatus: cliStatus, netconfStatus: netconfStatus, httpStatus: httpStatus).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieve network devices from a discovery on given filters
     - GET /api/v1/discovery/${id}/summary
     - Gets the network devices from a discovery job based on given filters

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - parameter id: (path) id 
     - parameter taskId: (query) taskId (optional)
     - parameter sortBy: (query) sortBy (optional)
     - parameter sortOrder: (query) sortOrder (optional)
     - parameter ipAddress: (query) ipAddress (optional)
     - parameter pingStatus: (query) pingStatus (optional)
     - parameter snmpStatus: (query) snmpStatus (optional)
     - parameter cliStatus: (query) cliStatus (optional)
     - parameter netconfStatus: (query) netconfStatus (optional)
     - parameter httpStatus: (query) httpStatus (optional)
     - returns: RequestBuilder<CountResult> 
     */
    open class func getDiscoverySummaryByIdWithRequestBuilder(id: String, taskId: String? = nil, sortBy: String? = nil, sortOrder: String? = nil, ipAddress: [String]? = nil, pingStatus: [String]? = nil, snmpStatus: [String]? = nil, cliStatus: [String]? = nil, netconfStatus: [String]? = nil, httpStatus: [String]? = nil) -> RequestBuilder<CountResult> {
        var path = "/api/v1/discovery/${id}/summary"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "taskId": taskId, 
            "sortBy": sortBy, 
            "sortOrder": sortOrder, 
            "ipAddress": ipAddress, 
            "pingStatus": pingStatus, 
            "snmpStatus": snmpStatus, 
            "cliStatus": cliStatus, 
            "netconfStatus": netconfStatus, 
            "httpStatus": httpStatus
        ])

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Starts a new discovery process and returns a task-id
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postDiscovery(request: InventoryRequest, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postDiscoveryWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Starts a new discovery process and returns a task-id
     - POST /api/v1/discovery
     - Initiates discovery with the given parameters

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
    open class func postDiscoveryWithRequestBuilder(request: InventoryRequest) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/discovery"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates an existing discovery specified by id - only for starting/stopping the discovery
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putDiscovery(request: DiscoveryNIO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putDiscoveryWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates an existing discovery specified by id - only for starting/stopping the discovery
     - PUT /api/v1/discovery
     - Stops or starts an existing discovery

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
    open class func putDiscoveryWithRequestBuilder(request: DiscoveryNIO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/discovery"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
