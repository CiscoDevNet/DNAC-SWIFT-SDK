//
// InterfaceAPI.swift
//

//

import Foundation
import Alamofire


open class InterfaceAPI: APIBase {
    /**
     Retrieves all interfaces
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterface(completion: @escaping ((_ data: DeviceIfListResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves all interfaces
     - GET /api/v1/interface
     - Gets all available interfaces with a maximum limit of 500

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  }, {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  } ],
  "version" : "version"
}}]
     - returns: RequestBuilder<DeviceIfListResult> 
     */
    open class func getInterfaceWithRequestBuilder() -> RequestBuilder<DeviceIfListResult> {
        let path = "/api/v1/interface"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeviceIfListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves interface by ID
     - parameter id: (path) Interface ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceById(id: String, completion: @escaping ((_ data: DeviceIfResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves interface by ID
     - GET /api/v1/interface/${id}
     - Gets the interface for the given interface ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  },
  "version" : "version"
}}]
     - parameter id: (path) Interface ID 
     - returns: RequestBuilder<DeviceIfResult> 
     */
    open class func getInterfaceByIdWithRequestBuilder(id: String) -> RequestBuilder<DeviceIfResult> {
        var path = "/api/v1/interface/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeviceIfResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves interface count
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceCount(completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceCountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves interface count
     - GET /api/v1/interface/count
     - Gets the count of interfaces for all devices

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - returns: RequestBuilder<CountResult> 
     */
    open class func getInterfaceCountWithRequestBuilder() -> RequestBuilder<CountResult> {
        let path = "/api/v1/interface/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves interfaces by IP address
     - parameter ipAddress: (path) IP address of the interface 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceIpAddressByIpAddress(ipAddress: String, completion: @escaping ((_ data: DeviceIfListResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceIpAddressByIpAddressWithRequestBuilder(ipAddress: ipAddress).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves interfaces by IP address
     - GET /api/v1/interface/ip-address/${ipAddress}
     - Gets list of interfaces with the given IP address

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  }, {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  } ],
  "version" : "version"
}}]
     - parameter ipAddress: (path) IP address of the interface 
     - returns: RequestBuilder<DeviceIfListResult> 
     */
    open class func getInterfaceIpAddressByIpAddressWithRequestBuilder(ipAddress: String) -> RequestBuilder<DeviceIfListResult> {
        var path = "/api/v1/interface/ip-address/${ipAddress}"
        let ipAddressPreEscape = "\(ipAddress)"
        let ipAddressPostEscape = ipAddressPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{ipAddress}", with: ipAddressPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeviceIfListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves ISIS interfaces
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceIsis(completion: @escaping ((_ data: DeviceIfListResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceIsisWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves ISIS interfaces
     - GET /api/v1/interface/isis
     - Gets the interfaces that has ISIS enabled

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  }, {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  } ],
  "version" : "version"
}}]
     - returns: RequestBuilder<DeviceIfListResult> 
     */
    open class func getInterfaceIsisWithRequestBuilder() -> RequestBuilder<DeviceIfListResult> {
        let path = "/api/v1/interface/isis"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeviceIfListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves device interfaces
     - parameter deviceId: (path) Device ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceNetworkDeviceByDeviceId(deviceId: String, completion: @escaping ((_ data: DeviceIfListResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceNetworkDeviceByDeviceIdWithRequestBuilder(deviceId: deviceId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves device interfaces
     - GET /api/v1/interface/network-device/${deviceId}
     - Gets list of interfaces for the given device

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  }, {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  } ],
  "version" : "version"
}}]
     - parameter deviceId: (path) Device ID 
     - returns: RequestBuilder<DeviceIfListResult> 
     */
    open class func getInterfaceNetworkDeviceByDeviceIdWithRequestBuilder(deviceId: String) -> RequestBuilder<DeviceIfListResult> {
        var path = "/api/v1/interface/network-device/${deviceId}"
        let deviceIdPreEscape = "\(deviceId)"
        let deviceIdPostEscape = deviceIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{deviceId}", with: deviceIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeviceIfListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves device interface count
     - parameter deviceId: (path) Device ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceNetworkDeviceCountByDeviceId(deviceId: String, completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceNetworkDeviceCountByDeviceIdWithRequestBuilder(deviceId: deviceId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves device interface count
     - GET /api/v1/interface/network-device/${deviceId}/count
     - Gets the interface count for the given device

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - parameter deviceId: (path) Device ID 
     - returns: RequestBuilder<CountResult> 
     */
    open class func getInterfaceNetworkDeviceCountByDeviceIdWithRequestBuilder(deviceId: String) -> RequestBuilder<CountResult> {
        var path = "/api/v1/interface/network-device/${deviceId}/count"
        let deviceIdPreEscape = "\(deviceId)"
        let deviceIdPostEscape = deviceIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{deviceId}", with: deviceIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves interface for the given device and interface name
     - parameter deviceId: (path) Device ID 
     - parameter name: (query) Interface name 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceNetworkDeviceInterfaceNameByDeviceId(deviceId: String, name: String, completion: @escaping ((_ data: DeviceIfResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceNetworkDeviceInterfaceNameByDeviceIdWithRequestBuilder(deviceId: deviceId, name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves interface for the given device and interface name
     - GET /api/v1/interface/network-device/${deviceId}/interface-name
     - Gets the interface for the given device ID and for the given interface name

     - examples: [{contentType=application/json, example={
  "response" : {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  },
  "version" : "version"
}}]
     - parameter deviceId: (path) Device ID 
     - parameter name: (query) Interface name 
     - returns: RequestBuilder<DeviceIfResult> 
     */
    open class func getInterfaceNetworkDeviceInterfaceNameByDeviceIdWithRequestBuilder(deviceId: String, name: String) -> RequestBuilder<DeviceIfResult> {
        var path = "/api/v1/interface/network-device/${deviceId}/interface-name"
        let deviceIdPreEscape = "\(deviceId)"
        let deviceIdPostEscape = deviceIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{deviceId}", with: deviceIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "name": name
        ])

        let requestBuilder: RequestBuilder<DeviceIfResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves OSPF interfaces
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getInterfaceOspf(completion: @escaping ((_ data: DeviceIfListResult?, _ error: ErrorResponse?) -> Void)) {
        getInterfaceOspfWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves OSPF interfaces
     - GET /api/v1/interface/ospf
     - Gets the interfaces that has OSPF enabled

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  }, {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  } ],
  "version" : "version"
}}]
     - returns: RequestBuilder<DeviceIfListResult> 
     */
    open class func getInterfaceOspfWithRequestBuilder() -> RequestBuilder<DeviceIfListResult> {
        let path = "/api/v1/interface/ospf"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeviceIfListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves device interfaces in the given range
     - parameter deviceId: (path) Device ID 
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getNetworkDeviceByDeviceIdRange(deviceId: String, startIndex: Int32, recordsToReturn: Int32, completion: @escaping ((_ data: DeviceIfListResult?, _ error: ErrorResponse?) -> Void)) {
        getNetworkDeviceByDeviceIdRangeWithRequestBuilder(deviceId: deviceId, startIndex: startIndex, recordsToReturn: recordsToReturn).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves device interfaces in the given range
     - GET /api/v1/interface/network-device/${deviceId}/${startIndex}/${recordsToReturn}
     - Gets the list of interfaces for the device for the specified range

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  }, {
    "ifIndex" : "ifIndex",
    "ipv4Mask" : "ipv4Mask",
    "nativeVlanId" : "nativeVlanId",
    "ipv4Address" : "ipv4Address",
    "description" : "description",
    "duplex" : "duplex",
    "className" : "className",
    "pid" : "pid",
    "portName" : "portName",
    "deviceId" : "deviceId",
    "speed" : "speed",
    "interfaceType" : "interfaceType",
    "lastUpdated" : "lastUpdated",
    "instanceTenantId" : "instanceTenantId",
    "adminStatus" : "adminStatus",
    "id" : "id",
    "portMode" : "portMode",
    "mappedPhysicalInterfaceName" : "mappedPhysicalInterfaceName",
    "vlanId" : "vlanId",
    "mediaType" : "mediaType",
    "ospfSupport" : "ospfSupport",
    "serialNo" : "serialNo",
    "portType" : "portType",
    "macAddress" : "macAddress",
    "isisSupport" : "isisSupport",
    "series" : "series",
    "voiceVlan" : "voiceVlan",
    "instanceUuid" : "instanceUuid",
    "mappedPhysicalInterfaceId" : "mappedPhysicalInterfaceId",
    "status" : "status"
  } ],
  "version" : "version"
}}]
     - parameter deviceId: (path) Device ID 
     - parameter startIndex: (path) Start index 
     - parameter recordsToReturn: (path) Number of records to return 
     - returns: RequestBuilder<DeviceIfListResult> 
     */
    open class func getNetworkDeviceByDeviceIdRangeWithRequestBuilder(deviceId: String, startIndex: Int32, recordsToReturn: Int32) -> RequestBuilder<DeviceIfListResult> {
        var path = "/api/v1/interface/network-device/${deviceId}/${startIndex}/${recordsToReturn}"
        let deviceIdPreEscape = "\(deviceId)"
        let deviceIdPostEscape = deviceIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{deviceId}", with: deviceIdPostEscape, options: .literal, range: nil)
        let startIndexPreEscape = "\(startIndex)"
        let startIndexPostEscape = startIndexPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{startIndex}", with: startIndexPostEscape, options: .literal, range: nil)
        let recordsToReturnPreEscape = "\(recordsToReturn)"
        let recordsToReturnPostEscape = recordsToReturnPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{recordsToReturn}", with: recordsToReturnPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeviceIfListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
