//
// DnaIntentAPI.swift
//

//

import Foundation
import Alamofire


open class DnaIntentAPI: APIBase {
    /**
     Delete Application
     - parameter applicationId: (header)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteDnaIntentDeleteApplication(applicationId: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        deleteDnaIntentDeleteApplicationWithRequestBuilder(applicationId: applicationId, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Delete Application
     - DELETE /dna/intent/api/v1/delete-application
     - Invoke the API to delete a custom application

     - parameter applicationId: (header)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func deleteDnaIntentDeleteApplicationWithRequestBuilder(applicationId: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/delete-application"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout,
            "applicationId": applicationId
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Delete Application Set
     - parameter applicationSetId: (header)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteDnaIntentDeleteApplicationSet(applicationSetId: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        deleteDnaIntentDeleteApplicationSetWithRequestBuilder(applicationSetId: applicationSetId, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Delete Application Set
     - DELETE /dna/intent/api/v1/delete-application-set
     - Invoke the API to delete a custom application

     - parameter applicationSetId: (header)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func deleteDnaIntentDeleteApplicationSetWithRequestBuilder(applicationSetId: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/delete-application-set"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout,
            "applicationSetId": applicationSetId
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Delete SSID
     - parameter deviceName: (path)  
     - parameter wirelessNetworkProfileName: (path)  
     - parameter ssidName: (path)  
     - parameter interfaceName: (path)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteDnaIntentDeleteSsid(deviceName: String, wirelessNetworkProfileName: String, ssidName: String, interfaceName: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ data: DeleteSSIDResponse?, _ error: ErrorResponse?) -> Void)) {
        deleteDnaIntentDeleteSsidWithRequestBuilder(deviceName: deviceName, wirelessNetworkProfileName: wirelessNetworkProfileName, ssidName: ssidName, interfaceName: interfaceName, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Delete SSID
     - DELETE /dna/intent/api/v1/delete-ssid/${deviceName}/${wirelessNetworkProfileName}/${ssidName}/${interfaceName}
     - De-provision WLC, also removes wireless network profile, SSID and dynamic interface

     - examples: [{contentType=application/json, example={
  "isError" : true,
  "failureReason" : "failureReason",
  "successMessage" : "successMessage"
}}]
     - parameter deviceName: (path)  
     - parameter wirelessNetworkProfileName: (path)  
     - parameter ssidName: (path)  
     - parameter interfaceName: (path)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<DeleteSSIDResponse> 
     */
    open class func deleteDnaIntentDeleteSsidWithRequestBuilder(deviceName: String, wirelessNetworkProfileName: String, ssidName: String, interfaceName: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<DeleteSSIDResponse> {
        var path = "/dna/intent/api/v1/delete-ssid/${deviceName}/${wirelessNetworkProfileName}/${ssidName}/${interfaceName}"
        let deviceNamePreEscape = "\(deviceName)"
        let deviceNamePostEscape = deviceNamePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{deviceName}", with: deviceNamePostEscape, options: .literal, range: nil)
        let wirelessNetworkProfileNamePreEscape = "\(wirelessNetworkProfileName)"
        let wirelessNetworkProfileNamePostEscape = wirelessNetworkProfileNamePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{wirelessNetworkProfileName}", with: wirelessNetworkProfileNamePostEscape, options: .literal, range: nil)
        let ssidNamePreEscape = "\(ssidName)"
        let ssidNamePostEscape = ssidNamePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{ssidName}", with: ssidNamePostEscape, options: .literal, range: nil)
        let interfaceNamePreEscape = "\(interfaceName)"
        let interfaceNamePostEscape = interfaceNamePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{interfaceName}", with: interfaceNamePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<DeleteSSIDResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get Applications Count
     - parameter count: (path)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentApplicationCount(count: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        getDnaIntentApplicationCountWithRequestBuilder(count: count, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Get Applications Count
     - GET /dna/intent/api/v1/application/count
     - Invoke the API to return the number of defined applications

     - parameter count: (path)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func getDnaIntentApplicationCountWithRequestBuilder(count: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        var path = "/dna/intent/api/v1/application/count"
        let countPreEscape = "\(count)"
        let countPostEscape = countPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{count}", with: countPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get Application Policies
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter offset: (header)  (optional, default to 1)
     - parameter limit: (header)  (optional, default to 500)
     - parameter applicationPolicyNamespace: (header)  (optional, default to )
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentApplicationPolicy(runsync: Bool? = nil, timeout: Double? = nil, offset: Double? = nil, limit: Double? = nil, applicationPolicyNamespace: String? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        getDnaIntentApplicationPolicyWithRequestBuilder(runsync: runsync, timeout: timeout, offset: offset, limit: limit, applicationPolicyNamespace: applicationPolicyNamespace).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Get Application Policies
     - GET /dna/intent/api/v1/application-policy
     - Invoke the API to return all (or specific) application-policy(ies)

     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter offset: (header)  (optional, default to 1)
     - parameter limit: (header)  (optional, default to 500)
     - parameter applicationPolicyNamespace: (header)  (optional, default to )
     - returns: RequestBuilder<Void> 
     */
    open class func getDnaIntentApplicationPolicyWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil, offset: Double? = nil, limit: Double? = nil, applicationPolicyNamespace: String? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/application-policy"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout,
            "offset": offset,
            "limit": limit,
            "applicationPolicyNamespace": applicationPolicyNamespace
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get Application Sets Count
     - parameter count: (path)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentApplicationSetCount(count: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        getDnaIntentApplicationSetCountWithRequestBuilder(count: count, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Get Application Sets Count
     - GET /dna/intent/api/v1/application-set/count
     - Invoke the API to return the number of defined application sets

     - parameter count: (path)  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func getDnaIntentApplicationSetCountWithRequestBuilder(count: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        var path = "/dna/intent/api/v1/application-set/count"
        let countPreEscape = "\(count)"
        let countPostEscape = countPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{count}", with: countPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get Application Sets
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter offset: (header)  (optional, default to 1)
     - parameter limit: (header)  (optional, default to 500)
     - parameter applicationSetName: (header)  (optional, default to )
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentApplicationSets(runsync: Bool? = nil, timeout: Double? = nil, offset: Double? = nil, limit: Double? = nil, applicationSetName: String? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        getDnaIntentApplicationSetsWithRequestBuilder(runsync: runsync, timeout: timeout, offset: offset, limit: limit, applicationSetName: applicationSetName).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Get Application Sets
     - GET /dna/intent/api/v1/application-sets
     - Invoke the API to return all (or specific) defined application-set(s)

     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter offset: (header)  (optional, default to 1)
     - parameter limit: (header)  (optional, default to 500)
     - parameter applicationSetName: (header)  (optional, default to )
     - returns: RequestBuilder<Void> 
     */
    open class func getDnaIntentApplicationSetsWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil, offset: Double? = nil, limit: Double? = nil, applicationSetName: String? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/application-sets"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout,
            "offset": offset,
            "limit": limit,
            "applicationSetName": applicationSetName
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Get Applications
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter offset: (header)  (optional, default to 1)
     - parameter limit: (header)  (optional, default to 500)
     - parameter applicationName: (header)  (optional, default to )
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentApplications(runsync: Bool? = nil, timeout: Double? = nil, offset: Double? = nil, limit: Double? = nil, applicationName: String? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        getDnaIntentApplicationsWithRequestBuilder(runsync: runsync, timeout: timeout, offset: offset, limit: limit, applicationName: applicationName).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Get Applications
     - GET /dna/intent/api/v1/applications
     - Invoke the API to return the list of all (or specific) defined application(s)

     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter offset: (header)  (optional, default to 1)
     - parameter limit: (header)  (optional, default to 500)
     - parameter applicationName: (header)  (optional, default to )
     - returns: RequestBuilder<Void> 
     */
    open class func getDnaIntentApplicationsWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil, offset: Double? = nil, limit: Double? = nil, applicationName: String? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/applications"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout,
            "offset": offset,
            "limit": limit,
            "applicationName": applicationName
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Client Detail
     - parameter timestamp: (query) timestamp 
     - parameter macAddress: (query) MAC Address of the client 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentClieDetail(timestamp: String, macAddress: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ data: ClientDetailResponse?, _ error: ErrorResponse?) -> Void)) {
        getDnaIntentClieDetailWithRequestBuilder(timestamp: timestamp, macAddress: macAddress, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Client Detail
     - GET /dna/intent/api/v1/client-detail
     - Get Client Details for a single client

     - examples: [{contentType=application/json, example={
  "response" : {
    "topology" : {
      "nodes" : [ {
        "deviceType" : "deviceType",
        "connectedDevice" : "connectedDevice",
        "role" : "role",
        "clients" : "clients",
        "level" : "level",
        "ip" : "ip",
        "count" : "count",
        "description" : "description",
        "platformId" : "platformId",
        "nodeType" : "nodeType",
        "healthScore" : "healthScore",
        "userId" : "userId",
        "name" : "name",
        "radioFrequency" : "radioFrequency",
        "id" : "id",
        "family" : "family",
        "fabricGroup" : "fabricGroup",
        "softwareVersion" : "softwareVersion"
      }, {
        "deviceType" : "deviceType",
        "connectedDevice" : "connectedDevice",
        "role" : "role",
        "clients" : "clients",
        "level" : "level",
        "ip" : "ip",
        "count" : "count",
        "description" : "description",
        "platformId" : "platformId",
        "nodeType" : "nodeType",
        "healthScore" : "healthScore",
        "userId" : "userId",
        "name" : "name",
        "radioFrequency" : "radioFrequency",
        "id" : "id",
        "family" : "family",
        "fabricGroup" : "fabricGroup",
        "softwareVersion" : "softwareVersion"
      } ],
      "links" : [ {
        "linkStatus" : "linkStatus",
        "portUtilization" : "portUtilization",
        "source" : "source",
        "label" : [ "label", "label" ],
        "id" : "id",
        "target" : "target"
      }, {
        "linkStatus" : "linkStatus",
        "portUtilization" : "portUtilization",
        "source" : "source",
        "label" : [ "label", "label" ],
        "id" : "id",
        "target" : "target"
      } ]
    },
    "detail" : {
      "hostName" : "hostName",
      "channel" : "channel",
      "dataRate" : "dataRate",
      "healthScore" : [ {
        "reason" : "reason",
        "score" : "score",
        "healthType" : "healthType"
      }, {
        "reason" : "reason",
        "score" : "score",
        "healthType" : "healthType"
      } ],
      "ssid" : "ssid",
      "issueCount" : "issueCount",
      "frequency" : "frequency",
      "lastUpdated" : "lastUpdated",
      "dnsFailure" : "dnsFailure",
      "onboardingTime" : "onboardingTime",
      "hostType" : "hostType",
      "onboarding" : {
        "averageDhcpDuration" : "averageDhcpDuration",
        "averageRunDuration" : "averageRunDuration",
        "maxDhcpDuration" : "maxDhcpDuration",
        "maxRunDuration" : "maxRunDuration",
        "dhcpServerIp" : "dhcpServerIp",
        "assocDoneTime" : "assocDoneTime",
        "authDoneTime" : "authDoneTime",
        "averageAuthDuration" : "averageAuthDuration",
        "maxAssocDuration" : "maxAssocDuration",
        "maxAuthDuration" : "maxAuthDuration",
        "dhcpDoneTime" : "dhcpDoneTime",
        "averageAssocDuration" : "averageAssocDuration",
        "aaaServerIp" : "aaaServerIp"
      },
      "id" : "id",
      "authType" : "authType",
      "hostIpV4" : "hostIpV4",
      "hostIpV6" : [ "hostIpV6", "hostIpV6" ],
      "connectedDevice" : [ "connectedDevice", "connectedDevice" ],
      "rssi" : "rssi",
      "avgRssi" : "avgRssi",
      "rxBytes" : "rxBytes",
      "hostVersion" : "hostVersion",
      "vlanId" : "vlanId",
      "hostOs" : "hostOs",
      "clientConnection" : "clientConnection",
      "apGroup" : "apGroup",
      "userId" : "userId",
      "avgSnr" : "avgSnr",
      "txBytes" : "txBytes",
      "port" : "port",
      "snr" : "snr",
      "dnsSuccess" : "dnsSuccess",
      "connectionStatus" : "connectionStatus",
      "subType" : "subType",
      "location" : "location",
      "hostMac" : "hostMac"
    },
    "connectionInfo" : {
      "protocol" : "protocol",
      "spatialStream" : "spatialStream",
      "wmm" : "wmm",
      "hostType" : "hostType",
      "channelWidth" : "channelWidth",
      "nwDeviceName" : "nwDeviceName",
      "channel" : "channel",
      "nwDeviceMac" : "nwDeviceMac",
      "band" : "band",
      "uapsd" : "uapsd",
      "timestamp" : "timestamp"
    }
  }
}}]
     - parameter timestamp: (query) timestamp 
     - parameter macAddress: (query) MAC Address of the client 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<ClientDetailResponse> 
     */
    open class func getDnaIntentClieDetailWithRequestBuilder(timestamp: String, macAddress: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<ClientDetailResponse> {
        let path = "/dna/intent/api/v1/client-detail"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "timestamp": timestamp, 
            "macAddress": macAddress
        ])
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ClientDetailResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Client Health
     - parameter startTime: (query) Start Time 
     - parameter endTime: (query) End Time 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentClientHealth(startTime: String, endTime: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ data: ClientHealthResponse?, _ error: ErrorResponse?) -> Void)) {
        getDnaIntentClientHealthWithRequestBuilder(startTime: startTime, endTime: endTime, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Client Health
     - GET /dna/intent/api/v1/client-health
     - Get overall Client Health along with beak down on categories of wired and wireless

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "siteId" : "siteId",
    "scoreDetail" : [ {
      "scoreList" : [ "scoreList", "scoreList" ],
      "clientUniqueCount" : "clientUniqueCount",
      "scoreCategory" : {
        "scoreCategory" : "scoreCategory",
        "value" : "value"
      },
      "endtime" : "endtime",
      "starttime" : "starttime",
      "clientCount" : "clientCount",
      "scoreValue" : "scoreValue"
    }, {
      "scoreList" : [ "scoreList", "scoreList" ],
      "clientUniqueCount" : "clientUniqueCount",
      "scoreCategory" : {
        "scoreCategory" : "scoreCategory",
        "value" : "value"
      },
      "endtime" : "endtime",
      "starttime" : "starttime",
      "clientCount" : "clientCount",
      "scoreValue" : "scoreValue"
    } ]
  }, {
    "siteId" : "siteId",
    "scoreDetail" : [ {
      "scoreList" : [ "scoreList", "scoreList" ],
      "clientUniqueCount" : "clientUniqueCount",
      "scoreCategory" : {
        "scoreCategory" : "scoreCategory",
        "value" : "value"
      },
      "endtime" : "endtime",
      "starttime" : "starttime",
      "clientCount" : "clientCount",
      "scoreValue" : "scoreValue"
    }, {
      "scoreList" : [ "scoreList", "scoreList" ],
      "clientUniqueCount" : "clientUniqueCount",
      "scoreCategory" : {
        "scoreCategory" : "scoreCategory",
        "value" : "value"
      },
      "endtime" : "endtime",
      "starttime" : "starttime",
      "clientCount" : "clientCount",
      "scoreValue" : "scoreValue"
    } ]
  } ]
}}]
     - parameter startTime: (query) Start Time 
     - parameter endTime: (query) End Time 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<ClientHealthResponse> 
     */
    open class func getDnaIntentClientHealthWithRequestBuilder(startTime: String, endTime: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<ClientHealthResponse> {
        let path = "/dna/intent/api/v1/client-health"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "startTime": startTime, 
            "endTime": endTime
        ])
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ClientHealthResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Network Device Detail
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter timestamp: (query) timestamp (optional, default to )
     - parameter searchBy: (query) MAC Address or UUID or Name of the Device (optional, default to )
     - parameter identifier: (query) macAddress or uuid or nwDeviceName (optional, default to )
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentNetworkDeviceDetail(runsync: Bool? = nil, timeout: Double? = nil, timestamp: String? = nil, searchBy: String? = nil, identifier: String? = nil, completion: @escaping ((_ data: NetworkDeviceDetailResponse?, _ error: ErrorResponse?) -> Void)) {
        getDnaIntentNetworkDeviceDetailWithRequestBuilder(runsync: runsync, timeout: timeout, timestamp: timestamp, searchBy: searchBy, identifier: identifier).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Network Device Detail
     - GET /dna/intent/api/v1/network-device-detail
     - Get Network Device Detail

     - examples: [{contentType=application/json, example={
  "response" : {
    "overallHealth" : "overallHealth",
    "managementIpAddr" : "managementIpAddr",
    "serialNumber" : "serialNumber",
    "nwDeviceName" : "nwDeviceName",
    "opState" : "opState",
    "platformId" : "platformId",
    "nwDeviceId" : "nwDeviceId",
    "sysUptime" : "sysUptime",
    "mode" : "mode",
    "resetReason" : "resetReason",
    "nwDeviceRole" : "nwDeviceRole",
    "upTime" : "upTime",
    "memoryScore" : "memoryScore",
    "nwDeviceFamily" : "nwDeviceFamily",
    "macAddress" : "macAddress",
    "connectedTime" : "connectedTime",
    "softwareVersion" : "softwareVersion",
    "subMode" : "subMode",
    "nwDeviceType" : "nwDeviceType",
    "cpuScore" : "cpuScore"
  }
}}]
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter timestamp: (query) timestamp (optional, default to )
     - parameter searchBy: (query) MAC Address or UUID or Name of the Device (optional, default to )
     - parameter identifier: (query) macAddress or uuid or nwDeviceName (optional, default to )
     - returns: RequestBuilder<NetworkDeviceDetailResponse> 
     */
    open class func getDnaIntentNetworkDeviceDetailWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil, timestamp: String? = nil, searchBy: String? = nil, identifier: String? = nil) -> RequestBuilder<NetworkDeviceDetailResponse> {
        let path = "/dna/intent/api/v1/network-device-detail"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "timestamp": timestamp, 
            "searchBy": searchBy, 
            "identifier": identifier
        ])
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<NetworkDeviceDetailResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Network Health
     - parameter startTime: (query) Start Time 
     - parameter endTime: (query) End Time 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentNetworkHealth(startTime: String, endTime: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        getDnaIntentNetworkHealthWithRequestBuilder(startTime: startTime, endTime: endTime, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Network Health
     - GET /dna/intent/api/v1/network-health
     - Network Devices and their health by category

     - parameter startTime: (query) Start Time 
     - parameter endTime: (query) End Time 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func getDnaIntentNetworkHealthWithRequestBuilder(startTime: String, endTime: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/network-health"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "startTime": startTime, 
            "endTime": endTime
        ])
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Site Hierarchy
     - parameter timestamp: (query) Timestamp  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getDnaIntentSiteHierarchy(timestamp: String, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ data: SiteHierarchyResponse?, _ error: ErrorResponse?) -> Void)) {
        getDnaIntentSiteHierarchyWithRequestBuilder(timestamp: timestamp, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Site Hierarchy
     - GET /dna/intent/api/v1/site-hierarchy
     - Site Hierarchy along with health Info

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "networkHealthDistribution" : "networkHealthDistribution",
    "parentSiteId" : "parentSiteId",
    "clientIssueCount" : "clientIssueCount",
    "applicationTotalCount" : "applicationTotalCount",
    "siteName" : "siteName",
    "wirelessDeviceGoodCount" : "wirelessDeviceGoodCount",
    "coreGoodCount" : "coreGoodCount",
    "coreTotalCount" : "coreTotalCount",
    "accessGoodCount" : "accessGoodCount",
    "numberOfClients" : "numberOfClients",
    "applicationBytesTotalCount" : "applicationBytesTotalCount",
    "applicationHealth" : "applicationHealth",
    "parentSiteName" : "parentSiteName",
    "networkHealthAccess" : "networkHealthAccess",
    "applicationGoodCount" : "applicationGoodCount",
    "clientNumberOfIssues" : "clientNumberOfIssues",
    "clientHealthWireless" : "clientHealthWireless",
    "networkHealthCore" : "networkHealthCore",
    "wiredGoodClients" : "wiredGoodClients",
    "siteType" : "siteType",
    "routerGoodCount" : "routerGoodCount",
    "numberOfNetworkDevice" : "numberOfNetworkDevice",
    "wirelessDeviceTotalCount" : "wirelessDeviceTotalCount",
    "networkHealthOthers" : "networkHealthOthers",
    "numberOfWiredClients" : "numberOfWiredClients",
    "healthyClientsPercentage" : "healthyClientsPercentage",
    "distributionGoodCount" : "distributionGoodCount",
    "distributionTotalCount" : "distributionTotalCount",
    "wirelessGoodClients" : "wirelessGoodClients",
    "routerTotalCount" : "routerTotalCount",
    "networkHealthWireless" : "networkHealthWireless",
    "networkHealthAverage" : "networkHealthAverage",
    "accessTotalCount" : "accessTotalCount",
    "numberOfWirelessClients" : "numberOfWirelessClients",
    "siteId" : "siteId",
    "networkHealthRouter" : "networkHealthRouter",
    "overallGoodDevices" : "overallGoodDevices",
    "healthyNetworkDevicePercentage" : "healthyNetworkDevicePercentage",
    "clientHealthWired" : "clientHealthWired",
    "networkNumberOfIssues" : "networkNumberOfIssues"
  }, {
    "networkHealthDistribution" : "networkHealthDistribution",
    "parentSiteId" : "parentSiteId",
    "clientIssueCount" : "clientIssueCount",
    "applicationTotalCount" : "applicationTotalCount",
    "siteName" : "siteName",
    "wirelessDeviceGoodCount" : "wirelessDeviceGoodCount",
    "coreGoodCount" : "coreGoodCount",
    "coreTotalCount" : "coreTotalCount",
    "accessGoodCount" : "accessGoodCount",
    "numberOfClients" : "numberOfClients",
    "applicationBytesTotalCount" : "applicationBytesTotalCount",
    "applicationHealth" : "applicationHealth",
    "parentSiteName" : "parentSiteName",
    "networkHealthAccess" : "networkHealthAccess",
    "applicationGoodCount" : "applicationGoodCount",
    "clientNumberOfIssues" : "clientNumberOfIssues",
    "clientHealthWireless" : "clientHealthWireless",
    "networkHealthCore" : "networkHealthCore",
    "wiredGoodClients" : "wiredGoodClients",
    "siteType" : "siteType",
    "routerGoodCount" : "routerGoodCount",
    "numberOfNetworkDevice" : "numberOfNetworkDevice",
    "wirelessDeviceTotalCount" : "wirelessDeviceTotalCount",
    "networkHealthOthers" : "networkHealthOthers",
    "numberOfWiredClients" : "numberOfWiredClients",
    "healthyClientsPercentage" : "healthyClientsPercentage",
    "distributionGoodCount" : "distributionGoodCount",
    "distributionTotalCount" : "distributionTotalCount",
    "wirelessGoodClients" : "wirelessGoodClients",
    "routerTotalCount" : "routerTotalCount",
    "networkHealthWireless" : "networkHealthWireless",
    "networkHealthAverage" : "networkHealthAverage",
    "accessTotalCount" : "accessTotalCount",
    "numberOfWirelessClients" : "numberOfWirelessClients",
    "siteId" : "siteId",
    "networkHealthRouter" : "networkHealthRouter",
    "overallGoodDevices" : "overallGoodDevices",
    "healthyNetworkDevicePercentage" : "healthyNetworkDevicePercentage",
    "clientHealthWired" : "clientHealthWired",
    "networkNumberOfIssues" : "networkNumberOfIssues"
  } ]
}}]
     - parameter timestamp: (query) Timestamp  
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<SiteHierarchyResponse> 
     */
    open class func getDnaIntentSiteHierarchyWithRequestBuilder(timestamp: String, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<SiteHierarchyResponse> {
        let path = "/dna/intent/api/v1/site-hierarchy"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "timestamp": timestamp
        ])
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<SiteHierarchyResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Post Application
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postDnaIntentCreateApplication(runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        postDnaIntentCreateApplicationWithRequestBuilder(runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Post Application
     - POST /dna/intent/api/v1/create-application
     - Invoke the API to create a custom application

     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func postDnaIntentCreateApplicationWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/create-application"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Post Application Policy Intent
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postDnaIntentCreateApplicationPolicy(runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        postDnaIntentCreateApplicationPolicyWithRequestBuilder(runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Post Application Policy Intent
     - POST /dna/intent/api/v1/create-application-policy
     - Invoke the API to create, modify or delete an application-policy

     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func postDnaIntentCreateApplicationPolicyWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/create-application-policy"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Post Application Set
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postDnaIntentCreateApplicationSet(runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        postDnaIntentCreateApplicationSetWithRequestBuilder(runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Post Application Set
     - POST /dna/intent/api/v1/create-application-set
     - Invoke the API to create a custom application set

     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func postDnaIntentCreateApplicationSetWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/create-application-set"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Create SSID
     - parameter request: (body) request 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postDnaIntentCreateSsid(request: CreateSSIDRequest, runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ data: CreateSSIDResponse?, _ error: ErrorResponse?) -> Void)) {
        postDnaIntentCreateSsidWithRequestBuilder(request: request, runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Create SSID
     - POST /dna/intent/api/v1/create-ssid
     - Creates non fabric enterprise SSID, dynamic interface, Wireless Network Profile and provisions WLC and AP

     - examples: [{contentType=application/json, example={
  "isError" : true,
  "failureReason" : "failureReason",
  "successMessage" : "successMessage"
}}]
     - parameter request: (body) request 
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<CreateSSIDResponse> 
     */
    open class func postDnaIntentCreateSsidWithRequestBuilder(request: CreateSSIDRequest, runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<CreateSSIDResponse> {
        let path = "/dna/intent/api/v1/create-ssid"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<CreateSSIDResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Edit Application
     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putDnaIntentUpdateApplication(runsync: Bool? = nil, timeout: Double? = nil, completion: @escaping ((_ error: ErrorResponse?) -> Void)) {
        putDnaIntentUpdateApplicationWithRequestBuilder(runsync: runsync, timeout: timeout).execute { (response, error) -> Void in
            completion(error)
        }
    }


    /**
     Edit Application
     - PUT /dna/intent/api/v1/update-application
     - Invoke the API to create a custom application

     - parameter runsync: (header) Enable this parameter to execute the API and return a response synchronously (optional, default to false)
     - parameter timeout: (header) During synchronous execution, this defines the maximum time to wait for a response, before the API execution is terminated (optional, default to 10)
     - returns: RequestBuilder<Void> 
     */
    open class func putDnaIntentUpdateApplicationWithRequestBuilder(runsync: Bool? = nil, timeout: Double? = nil) -> RequestBuilder<Void> {
        let path = "/dna/intent/api/v1/update-application"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "__runsync": runsync,
            "__timeout": timeout
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}
