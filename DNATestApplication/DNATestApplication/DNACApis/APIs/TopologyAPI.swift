//
// TopologyAPI.swift
//

//

import Foundation
import Alamofire


open class TopologyAPI: APIBase {
    /**
     getL2Topology
     - parameter vlanID: (path) Vlan Name for e.g Vlan1, Vlan23 etc 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTopologyL2ByVlanId(vlanID: String, completion: @escaping ((_ data: TopologyResult?, _ error: ErrorResponse?) -> Void)) {
        getTopologyL2ByVlanIdWithRequestBuilder(vlanID: vlanID).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     getL2Topology
     - GET /api/v1/topology/l2/${vlanID}
     - This method is used to obtain the Layer 2 topology by Vlan ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "nodes" : [ {
      "role" : "role",
      "upperNode" : "upperNode",
      "additionalInfo" : "{}",
      "osType" : "osType",
      "dataPathId" : "dataPathId",
      "id" : "id",
      "roleSource" : "roleSource",
      "networkType" : "networkType",
      "greyOut" : true,
      "order" : 1,
      "deviceType" : "deviceType",
      "vlanId" : "vlanId",
      "ip" : "ip",
      "aclApplied" : true,
      "label" : "label",
      "platformId" : "platformId",
      "nodeType" : "nodeType",
      "customParam" : {
        "x" : 0,
        "y" : 6,
        "parentNodeId" : "parentNodeId",
        "id" : "id",
        "label" : "label"
      },
      "userId" : "userId",
      "tags" : [ "tags", "tags" ],
      "x" : 5,
      "y" : 5,
      "fixed" : true,
      "family" : "family",
      "softwareVersion" : "softwareVersion"
    }, {
      "role" : "role",
      "upperNode" : "upperNode",
      "additionalInfo" : "{}",
      "osType" : "osType",
      "dataPathId" : "dataPathId",
      "id" : "id",
      "roleSource" : "roleSource",
      "networkType" : "networkType",
      "greyOut" : true,
      "order" : 1,
      "deviceType" : "deviceType",
      "vlanId" : "vlanId",
      "ip" : "ip",
      "aclApplied" : true,
      "label" : "label",
      "platformId" : "platformId",
      "nodeType" : "nodeType",
      "customParam" : {
        "x" : 0,
        "y" : 6,
        "parentNodeId" : "parentNodeId",
        "id" : "id",
        "label" : "label"
      },
      "userId" : "userId",
      "tags" : [ "tags", "tags" ],
      "x" : 5,
      "y" : 5,
      "fixed" : true,
      "family" : "family",
      "softwareVersion" : "softwareVersion"
    } ],
    "links" : [ {
      "endPortName" : "endPortName",
      "startPortID" : "startPortID",
      "endPortSpeed" : "endPortSpeed",
      "startPortIpv4Mask" : "startPortIpv4Mask",
      "source" : "source",
      "target" : "target",
      "linkStatus" : "linkStatus",
      "endPortIpv4Mask" : "endPortIpv4Mask",
      "endPortID" : "endPortID",
      "startPortName" : "startPortName",
      "startPortSpeed" : "startPortSpeed",
      "additionalInfo" : "{}",
      "endPortIpv4Address" : "endPortIpv4Address",
      "id" : "id",
      "tag" : "tag",
      "startPortIpv4Address" : "startPortIpv4Address",
      "greyOut" : true
    }, {
      "endPortName" : "endPortName",
      "startPortID" : "startPortID",
      "endPortSpeed" : "endPortSpeed",
      "startPortIpv4Mask" : "startPortIpv4Mask",
      "source" : "source",
      "target" : "target",
      "linkStatus" : "linkStatus",
      "endPortIpv4Mask" : "endPortIpv4Mask",
      "endPortID" : "endPortID",
      "startPortName" : "startPortName",
      "startPortSpeed" : "startPortSpeed",
      "additionalInfo" : "{}",
      "endPortIpv4Address" : "endPortIpv4Address",
      "id" : "id",
      "tag" : "tag",
      "startPortIpv4Address" : "startPortIpv4Address",
      "greyOut" : true
    } ],
    "id" : "id"
  },
  "version" : "version"
}}]
     - parameter vlanID: (path) Vlan Name for e.g Vlan1, Vlan23 etc 
     - returns: RequestBuilder<TopologyResult> 
     */
    open class func getTopologyL2ByVlanIdWithRequestBuilder(vlanID: String) -> RequestBuilder<TopologyResult> {
        var path = "/api/v1/topology/l2/${vlanID}"
        let vlanIDPreEscape = "\(vlanID)"
        let vlanIDPostEscape = vlanIDPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{vlanID}", with: vlanIDPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TopologyResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     getL3Topology
     - parameter topologyType: (path) Type of topology(OSPF,ISIS,etc) 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTopologyL3ByTopologyType(topologyType: String, completion: @escaping ((_ data: TopologyResult?, _ error: ErrorResponse?) -> Void)) {
        getTopologyL3ByTopologyTypeWithRequestBuilder(topologyType: topologyType).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     getL3Topology
     - GET /api/v1/topology/l3/${topologyType}
     - This method is used to obtain Layer 3 device topology by routing protocol type

     - examples: [{contentType=application/json, example={
  "response" : {
    "nodes" : [ {
      "role" : "role",
      "upperNode" : "upperNode",
      "additionalInfo" : "{}",
      "osType" : "osType",
      "dataPathId" : "dataPathId",
      "id" : "id",
      "roleSource" : "roleSource",
      "networkType" : "networkType",
      "greyOut" : true,
      "order" : 1,
      "deviceType" : "deviceType",
      "vlanId" : "vlanId",
      "ip" : "ip",
      "aclApplied" : true,
      "label" : "label",
      "platformId" : "platformId",
      "nodeType" : "nodeType",
      "customParam" : {
        "x" : 0,
        "y" : 6,
        "parentNodeId" : "parentNodeId",
        "id" : "id",
        "label" : "label"
      },
      "userId" : "userId",
      "tags" : [ "tags", "tags" ],
      "x" : 5,
      "y" : 5,
      "fixed" : true,
      "family" : "family",
      "softwareVersion" : "softwareVersion"
    }, {
      "role" : "role",
      "upperNode" : "upperNode",
      "additionalInfo" : "{}",
      "osType" : "osType",
      "dataPathId" : "dataPathId",
      "id" : "id",
      "roleSource" : "roleSource",
      "networkType" : "networkType",
      "greyOut" : true,
      "order" : 1,
      "deviceType" : "deviceType",
      "vlanId" : "vlanId",
      "ip" : "ip",
      "aclApplied" : true,
      "label" : "label",
      "platformId" : "platformId",
      "nodeType" : "nodeType",
      "customParam" : {
        "x" : 0,
        "y" : 6,
        "parentNodeId" : "parentNodeId",
        "id" : "id",
        "label" : "label"
      },
      "userId" : "userId",
      "tags" : [ "tags", "tags" ],
      "x" : 5,
      "y" : 5,
      "fixed" : true,
      "family" : "family",
      "softwareVersion" : "softwareVersion"
    } ],
    "links" : [ {
      "endPortName" : "endPortName",
      "startPortID" : "startPortID",
      "endPortSpeed" : "endPortSpeed",
      "startPortIpv4Mask" : "startPortIpv4Mask",
      "source" : "source",
      "target" : "target",
      "linkStatus" : "linkStatus",
      "endPortIpv4Mask" : "endPortIpv4Mask",
      "endPortID" : "endPortID",
      "startPortName" : "startPortName",
      "startPortSpeed" : "startPortSpeed",
      "additionalInfo" : "{}",
      "endPortIpv4Address" : "endPortIpv4Address",
      "id" : "id",
      "tag" : "tag",
      "startPortIpv4Address" : "startPortIpv4Address",
      "greyOut" : true
    }, {
      "endPortName" : "endPortName",
      "startPortID" : "startPortID",
      "endPortSpeed" : "endPortSpeed",
      "startPortIpv4Mask" : "startPortIpv4Mask",
      "source" : "source",
      "target" : "target",
      "linkStatus" : "linkStatus",
      "endPortIpv4Mask" : "endPortIpv4Mask",
      "endPortID" : "endPortID",
      "startPortName" : "startPortName",
      "startPortSpeed" : "startPortSpeed",
      "additionalInfo" : "{}",
      "endPortIpv4Address" : "endPortIpv4Address",
      "id" : "id",
      "tag" : "tag",
      "startPortIpv4Address" : "startPortIpv4Address",
      "greyOut" : true
    } ],
    "id" : "id"
  },
  "version" : "version"
}}]
     - parameter topologyType: (path) Type of topology(OSPF,ISIS,etc) 
     - returns: RequestBuilder<TopologyResult> 
     */
    open class func getTopologyL3ByTopologyTypeWithRequestBuilder(topologyType: String) -> RequestBuilder<TopologyResult> {
        var path = "/api/v1/topology/l3/${topologyType}"
        let topologyTypePreEscape = "\(topologyType)"
        let topologyTypePostEscape = topologyTypePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{topologyType}", with: topologyTypePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TopologyResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     getPhysicalTopology
     - parameter nodeType: (query) nodeType (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTopologyPhysicalTopology(nodeType: String? = nil, completion: @escaping ((_ data: TopologyResult?, _ error: ErrorResponse?) -> Void)) {
        getTopologyPhysicalTopologyWithRequestBuilder(nodeType: nodeType).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     getPhysicalTopology
     - GET /api/v1/topology/physical-topology
     - This method is used to obtain the raw physical topology and filter based on nodeType

     - examples: [{contentType=application/json, example={
  "response" : {
    "nodes" : [ {
      "role" : "role",
      "upperNode" : "upperNode",
      "additionalInfo" : "{}",
      "osType" : "osType",
      "dataPathId" : "dataPathId",
      "id" : "id",
      "roleSource" : "roleSource",
      "networkType" : "networkType",
      "greyOut" : true,
      "order" : 1,
      "deviceType" : "deviceType",
      "vlanId" : "vlanId",
      "ip" : "ip",
      "aclApplied" : true,
      "label" : "label",
      "platformId" : "platformId",
      "nodeType" : "nodeType",
      "customParam" : {
        "x" : 0,
        "y" : 6,
        "parentNodeId" : "parentNodeId",
        "id" : "id",
        "label" : "label"
      },
      "userId" : "userId",
      "tags" : [ "tags", "tags" ],
      "x" : 5,
      "y" : 5,
      "fixed" : true,
      "family" : "family",
      "softwareVersion" : "softwareVersion"
    }, {
      "role" : "role",
      "upperNode" : "upperNode",
      "additionalInfo" : "{}",
      "osType" : "osType",
      "dataPathId" : "dataPathId",
      "id" : "id",
      "roleSource" : "roleSource",
      "networkType" : "networkType",
      "greyOut" : true,
      "order" : 1,
      "deviceType" : "deviceType",
      "vlanId" : "vlanId",
      "ip" : "ip",
      "aclApplied" : true,
      "label" : "label",
      "platformId" : "platformId",
      "nodeType" : "nodeType",
      "customParam" : {
        "x" : 0,
        "y" : 6,
        "parentNodeId" : "parentNodeId",
        "id" : "id",
        "label" : "label"
      },
      "userId" : "userId",
      "tags" : [ "tags", "tags" ],
      "x" : 5,
      "y" : 5,
      "fixed" : true,
      "family" : "family",
      "softwareVersion" : "softwareVersion"
    } ],
    "links" : [ {
      "endPortName" : "endPortName",
      "startPortID" : "startPortID",
      "endPortSpeed" : "endPortSpeed",
      "startPortIpv4Mask" : "startPortIpv4Mask",
      "source" : "source",
      "target" : "target",
      "linkStatus" : "linkStatus",
      "endPortIpv4Mask" : "endPortIpv4Mask",
      "endPortID" : "endPortID",
      "startPortName" : "startPortName",
      "startPortSpeed" : "startPortSpeed",
      "additionalInfo" : "{}",
      "endPortIpv4Address" : "endPortIpv4Address",
      "id" : "id",
      "tag" : "tag",
      "startPortIpv4Address" : "startPortIpv4Address",
      "greyOut" : true
    }, {
      "endPortName" : "endPortName",
      "startPortID" : "startPortID",
      "endPortSpeed" : "endPortSpeed",
      "startPortIpv4Mask" : "startPortIpv4Mask",
      "source" : "source",
      "target" : "target",
      "linkStatus" : "linkStatus",
      "endPortIpv4Mask" : "endPortIpv4Mask",
      "endPortID" : "endPortID",
      "startPortName" : "startPortName",
      "startPortSpeed" : "startPortSpeed",
      "additionalInfo" : "{}",
      "endPortIpv4Address" : "endPortIpv4Address",
      "id" : "id",
      "tag" : "tag",
      "startPortIpv4Address" : "startPortIpv4Address",
      "greyOut" : true
    } ],
    "id" : "id"
  },
  "version" : "version"
}}]
     - parameter nodeType: (query) nodeType (optional)
     - returns: RequestBuilder<TopologyResult> 
     */
    open class func getTopologyPhysicalTopologyWithRequestBuilder(nodeType: String? = nil) -> RequestBuilder<TopologyResult> {
        let path = "/api/v1/topology/physical-topology"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "nodeType": nodeType
        ])

        let requestBuilder: RequestBuilder<TopologyResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     getSiteTopology
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTopologySiteTopology(completion: @escaping ((_ data: SiteResult?, _ error: ErrorResponse?) -> Void)) {
        getTopologySiteTopologyWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     getSiteTopology
     - GET /api/v1/topology/site-topology
     - This method is used to obtain the site topology

     - examples: [{contentType=application/json, example={
  "response" : {
    "sites" : [ {
      "groupNameHierarchy" : "groupNameHierarchy",
      "locationCountry" : "locationCountry",
      "displayName" : "displayName",
      "latitude" : "latitude",
      "name" : "name",
      "locationType" : "locationType",
      "id" : "id",
      "locationAddress" : "locationAddress",
      "parentId" : "parentId",
      "longitude" : "longitude"
    }, {
      "groupNameHierarchy" : "groupNameHierarchy",
      "locationCountry" : "locationCountry",
      "displayName" : "displayName",
      "latitude" : "latitude",
      "name" : "name",
      "locationType" : "locationType",
      "id" : "id",
      "locationAddress" : "locationAddress",
      "parentId" : "parentId",
      "longitude" : "longitude"
    } ]
  },
  "version" : "version"
}}]
     - returns: RequestBuilder<SiteResult> 
     */
    open class func getTopologySiteTopologyWithRequestBuilder() -> RequestBuilder<SiteResult> {
        let path = "/api/v1/topology/site-topology"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SiteResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     getVlanNames
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTopologyVlanVlanNames(completion: @escaping ((_ data: VlanNamesResult?, _ error: ErrorResponse?) -> Void)) {
        getTopologyVlanVlanNamesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     getVlanNames
     - GET /api/v1/topology/vlan/vlan-names
     - This method is used to obtain the list of vlan names

     - examples: [{contentType=application/json, example={
  "response" : [ "response", "response" ],
  "version" : "version"
}}]
     - returns: RequestBuilder<VlanNamesResult> 
     */
    open class func getTopologyVlanVlanNamesWithRequestBuilder() -> RequestBuilder<VlanNamesResult> {
        let path = "/api/v1/topology/vlan/vlan-names"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<VlanNamesResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
