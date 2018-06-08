//
// FlowAnalysisAPI.swift
//

import Foundation
import Alamofire


open class FlowAnalysisAPI: APIBase {
    /**
     Deletes a flow analysis request
     - parameter flowAnalysisId: (path) Flow analysis request id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteFlowAnalysisByFlowAnalysisId(flowAnalysisId: String, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteFlowAnalysisByFlowAnalysisIdWithRequestBuilder(flowAnalysisId: flowAnalysisId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deletes a flow analysis request
     - DELETE /api/v1/flow-analysis/${flowAnalysisId}
     - Deletes a flow analysis request by its id

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter flowAnalysisId: (path) Flow analysis request id 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteFlowAnalysisByFlowAnalysisIdWithRequestBuilder(flowAnalysisId: String) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/flow-analysis/${flowAnalysisId}"
        let flowAnalysisIdPreEscape = "\(flowAnalysisId)"
        let flowAnalysisIdPostEscape = flowAnalysisIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{flowAnalysisId}", with: flowAnalysisIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves a summary of all flow analyses stored
     - parameter periodicRefresh: (query) Is analysis periodically refreshed? (optional)
     - parameter sourceIP: (query) Source IP address (optional)
     - parameter destIP: (query) Destination IP adress (optional)
     - parameter sourcePort: (query) Source port (optional)
     - parameter destPort: (query) Destination port (optional)
     - parameter gtCreateTime: (query) Analyses requested after this time (optional)
     - parameter ltCreateTime: (query) Analyses requested before this time (optional)
     - parameter _protocol: (query) Protocol (optional)
     - parameter status: (query) Status (optional)
     - parameter taskId: (query) Task ID (optional)
     - parameter lastUpdateTime: (query) Last update time (optional)
     - parameter limit: (query) Number of resources returned (optional)
     - parameter offset: (query) Start index of resources returned (1-based) (optional)
     - parameter order: (query) Order by this field (optional)
     - parameter sortBy: (query) Sort by this field (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getFlowAnalysis(periodicRefresh: Bool? = nil, sourceIP: String? = nil, destIP: String? = nil, sourcePort: String? = nil, destPort: String? = nil, gtCreateTime: String? = nil, ltCreateTime: String? = nil, _protocol: String? = nil, status: String? = nil, taskId: String? = nil, lastUpdateTime: String? = nil, limit: String? = nil, offset: String? = nil, order: String? = nil, sortBy: String? = nil, completion: @escaping ((_ data: FlowAnalysisListOutput?, _ error: ErrorResponse?) -> Void)) {
        getFlowAnalysisWithRequestBuilder(periodicRefresh: periodicRefresh, sourceIP: sourceIP, destIP: destIP, sourcePort: sourcePort, destPort: destPort, gtCreateTime: gtCreateTime, ltCreateTime: ltCreateTime, _protocol: _protocol, status: status, taskId: taskId, lastUpdateTime: lastUpdateTime, limit: limit, offset: offset, order: order, sortBy: sortBy).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves a summary of all flow analyses stored
     - GET /api/v1/flow-analysis
     - Retrieves a summary of all flow analyses stored. Filters the results by given parameters.

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "destIP" : "destIP",
    "sourcePort" : "sourcePort",
    "controlPath" : true,
    "protocol" : "protocol",
    "destPort" : "destPort",
    "sourceIP" : "sourceIP",
    "createTime" : 0,
    "failureReason" : "failureReason",
    "id" : "id",
    "inclusions" : [ "inclusions", "inclusions" ],
    "lastUpdateTime" : 6,
    "periodicRefresh" : true,
    "status" : "status"
  }, {
    "destIP" : "destIP",
    "sourcePort" : "sourcePort",
    "controlPath" : true,
    "protocol" : "protocol",
    "destPort" : "destPort",
    "sourceIP" : "sourceIP",
    "createTime" : 0,
    "failureReason" : "failureReason",
    "id" : "id",
    "inclusions" : [ "inclusions", "inclusions" ],
    "lastUpdateTime" : 6,
    "periodicRefresh" : true,
    "status" : "status"
  } ],
  "version" : "version"
}}]
     - parameter periodicRefresh: (query) Is analysis periodically refreshed? (optional)
     - parameter sourceIP: (query) Source IP address (optional)
     - parameter destIP: (query) Destination IP adress (optional)
     - parameter sourcePort: (query) Source port (optional)
     - parameter destPort: (query) Destination port (optional)
     - parameter gtCreateTime: (query) Analyses requested after this time (optional)
     - parameter ltCreateTime: (query) Analyses requested before this time (optional)
     - parameter _protocol: (query) Protocol (optional)
     - parameter status: (query) Status (optional)
     - parameter taskId: (query) Task ID (optional)
     - parameter lastUpdateTime: (query) Last update time (optional)
     - parameter limit: (query) Number of resources returned (optional)
     - parameter offset: (query) Start index of resources returned (1-based) (optional)
     - parameter order: (query) Order by this field (optional)
     - parameter sortBy: (query) Sort by this field (optional)
     - returns: RequestBuilder<FlowAnalysisListOutput> 
     */
    open class func getFlowAnalysisWithRequestBuilder(periodicRefresh: Bool? = nil, sourceIP: String? = nil, destIP: String? = nil, sourcePort: String? = nil, destPort: String? = nil, gtCreateTime: String? = nil, ltCreateTime: String? = nil, _protocol: String? = nil, status: String? = nil, taskId: String? = nil, lastUpdateTime: String? = nil, limit: String? = nil, offset: String? = nil, order: String? = nil, sortBy: String? = nil) -> RequestBuilder<FlowAnalysisListOutput> {
        let path = "/api/v1/flow-analysis"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "periodicRefresh": periodicRefresh, 
            "sourceIP": sourceIP, 
            "destIP": destIP, 
            "sourcePort": sourcePort, 
            "destPort": destPort, 
            "gtCreateTime": gtCreateTime, 
            "ltCreateTime": ltCreateTime, 
            "protocol": _protocol, 
            "status": status, 
            "taskId": taskId, 
            "lastUpdateTime": lastUpdateTime, 
            "limit": limit, 
            "offset": offset, 
            "order": order, 
            "sortBy": sortBy
        ])

        let requestBuilder: RequestBuilder<FlowAnalysisListOutput>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves result of a previously requested flow analysis
     - parameter flowAnalysisId: (path) Flow analysis request id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getFlowAnalysisByFlowAnalysisId(flowAnalysisId: String, completion: @escaping ((_ data: PathResponseResult?, _ error: ErrorResponse?) -> Void)) {
        getFlowAnalysisByFlowAnalysisIdWithRequestBuilder(flowAnalysisId: flowAnalysisId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves result of a previously requested flow analysis
     - GET /api/v1/flow-analysis/${flowAnalysisId}
     - Retrieves result of a previously requested flow analysis by its Flow Analysis id

     - examples: [{contentType=application/json, example={
  "response" : {
    "request" : {
      "destIP" : "destIP",
      "sourcePort" : "sourcePort",
      "controlPath" : true,
      "protocol" : "protocol",
      "destPort" : "destPort",
      "sourceIP" : "sourceIP",
      "createTime" : 0,
      "failureReason" : "failureReason",
      "id" : "id",
      "inclusions" : [ "inclusions", "inclusions" ],
      "lastUpdateTime" : 6,
      "periodicRefresh" : true,
      "status" : "status"
    },
    "detailedStatus" : {
      "aclTraceCalculationFailureReason" : "aclTraceCalculationFailureReason",
      "aclTraceCalculation" : "aclTraceCalculation"
    },
    "lastUpdate" : "lastUpdate",
    "networkElements" : [ {
      "linkInformationSource" : "linkInformationSource",
      "role" : "role",
      "flexConnect" : {
        "egressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "ingressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "dataSwitching" : "LOCAL",
        "wirelessLanControllerName" : "wirelessLanControllerName",
        "wirelessLanControllerId" : "wirelessLanControllerId",
        "authentication" : "LOCAL"
      },
      "deviceStatsCollection" : "deviceStatsCollection",
      "ip" : "ip",
      "perfMonCollectionFailureReason" : "perfMonCollectionFailureReason",
      "perfMonCollection" : "perfMonCollection",
      "type" : "type",
      "ssid" : "ssid",
      "wlanId" : "wlanId",
      "egressVirtualInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      },
      "tunnels" : [ "tunnels", "tunnels" ],
      "deviceStatsCollectionFailureReason" : "deviceStatsCollectionFailureReason",
      "perfMonStatistics" : [ {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      }, {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      } ],
      "detailedStatus" : {
        "aclTraceCalculationFailureReason" : "aclTraceCalculationFailureReason",
        "aclTraceCalculation" : "aclTraceCalculation"
      },
      "ingressVirtualInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      },
      "name" : "name",
      "deviceStatistics" : {
        "cpuStatistics" : {
          "fiveSecsUsageInPercentage" : 1.46581298050294517310021547018550336360931396484375,
          "refreshedAt" : 5,
          "fiveMinUsageInPercentage" : 6.02745618307040320615897144307382404804229736328125,
          "oneMinUsageInPercentage" : 5.962133916683182377482808078639209270477294921875
        },
        "memoryStatistics" : {
          "memoryUsage" : 2,
          "totalMemory" : 9,
          "refreshedAt" : 7
        }
      },
      "ingressPhysicalInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      },
      "accuracyList" : [ {
        "reason" : "reason",
        "percent" : 0
      }, {
        "reason" : "reason",
        "percent" : 0
      } ],
      "id" : "id",
      "egressPhysicalInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      }
    }, {
      "linkInformationSource" : "linkInformationSource",
      "role" : "role",
      "flexConnect" : {
        "egressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "ingressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "dataSwitching" : "LOCAL",
        "wirelessLanControllerName" : "wirelessLanControllerName",
        "wirelessLanControllerId" : "wirelessLanControllerId",
        "authentication" : "LOCAL"
      },
      "deviceStatsCollection" : "deviceStatsCollection",
      "ip" : "ip",
      "perfMonCollectionFailureReason" : "perfMonCollectionFailureReason",
      "perfMonCollection" : "perfMonCollection",
      "type" : "type",
      "ssid" : "ssid",
      "wlanId" : "wlanId",
      "egressVirtualInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      },
      "tunnels" : [ "tunnels", "tunnels" ],
      "deviceStatsCollectionFailureReason" : "deviceStatsCollectionFailureReason",
      "perfMonStatistics" : [ {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      }, {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      } ],
      "detailedStatus" : {
        "aclTraceCalculationFailureReason" : "aclTraceCalculationFailureReason",
        "aclTraceCalculation" : "aclTraceCalculation"
      },
      "ingressVirtualInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      },
      "name" : "name",
      "deviceStatistics" : {
        "cpuStatistics" : {
          "fiveSecsUsageInPercentage" : 1.46581298050294517310021547018550336360931396484375,
          "refreshedAt" : 5,
          "fiveMinUsageInPercentage" : 6.02745618307040320615897144307382404804229736328125,
          "oneMinUsageInPercentage" : 5.962133916683182377482808078639209270477294921875
        },
        "memoryStatistics" : {
          "memoryUsage" : 2,
          "totalMemory" : 9,
          "refreshedAt" : 7
        }
      },
      "ingressPhysicalInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      },
      "accuracyList" : [ {
        "reason" : "reason",
        "percent" : 0
      }, {
        "reason" : "reason",
        "percent" : 0
      } ],
      "id" : "id",
      "egressPhysicalInterface" : {
        "aclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "pathOverlayInfo" : [ {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        }, {
          "destIp" : "destIp",
          "protocol" : "protocol",
          "sourcePort" : "sourcePort",
          "controlPlane" : "controlPlane",
          "destPort" : "destPort",
          "sourceIp" : "sourceIp",
          "vxlanInfo" : {
            "dscp" : "dscp",
            "vnid" : "vnid"
          },
          "dataPacketEncapsulation" : "dataPacketEncapsulation"
        } ],
        "qosStatsCollection" : "qosStatsCollection",
        "interfaceStatistics" : {
          "inputQueueMaxDepth" : 1,
          "operationalStatus" : "operationalStatus",
          "outputQueueCount" : 7,
          "outputPackets" : 6,
          "inputQueueFlushes" : 7,
          "inputQueueCount" : 2,
          "inputQueueDrops" : 4,
          "outputRatebps" : 4,
          "inputPackets" : 3,
          "inputRatebps" : 1,
          "outputQueueDepth" : 1,
          "adminStatus" : "adminStatus",
          "refreshedAt" : 5,
          "outputDrop" : 1
        },
        "name" : "name",
        "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
        "usedVlan" : "usedVlan",
        "id" : "id",
        "interfaceStatsCollection" : "interfaceStatsCollection",
        "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
        "qosStatistics" : [ {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        }, {
          "numBytes" : 9,
          "queueBandwidthbps" : "queueBandwidthbps",
          "queueNoBufferDrops" : 6,
          "classMapName" : "classMapName",
          "offeredRate" : 8,
          "numPackets" : 6,
          "dropRate" : 9,
          "queueDepth" : 9,
          "refreshedAt" : 6,
          "queueTotalDrops" : 3
        } ],
        "vrfName" : "vrfName"
      }
    } ],
    "networkElementsInfo" : [ {
      "linkInformationSource" : "linkInformationSource",
      "role" : "role",
      "flexConnect" : {
        "egressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "ingressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "dataSwitching" : "LOCAL",
        "wirelessLanControllerName" : "wirelessLanControllerName",
        "wirelessLanControllerId" : "wirelessLanControllerId",
        "authentication" : "LOCAL"
      },
      "deviceStatsCollection" : "deviceStatsCollection",
      "ip" : "ip",
      "perfMonCollectionFailureReason" : "perfMonCollectionFailureReason",
      "ingressInterface" : {
        "physicalInterface" : {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        },
        "virtualInterface" : [ {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        }, {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        } ]
      },
      "perfMonCollection" : "perfMonCollection",
      "type" : "type",
      "ssid" : "ssid",
      "wlanId" : "wlanId",
      "tunnels" : [ "tunnels", "tunnels" ],
      "deviceStatsCollectionFailureReason" : "deviceStatsCollectionFailureReason",
      "perfMonitorStatistics" : [ {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      }, {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      } ],
      "detailedStatus" : {
        "aclTraceCalculationFailureReason" : "aclTraceCalculationFailureReason",
        "aclTraceCalculation" : "aclTraceCalculation"
      },
      "name" : "name",
      "deviceStatistics" : {
        "cpuStatistics" : {
          "fiveSecsUsageInPercentage" : 1.46581298050294517310021547018550336360931396484375,
          "refreshedAt" : 5,
          "fiveMinUsageInPercentage" : 6.02745618307040320615897144307382404804229736328125,
          "oneMinUsageInPercentage" : 5.962133916683182377482808078639209270477294921875
        },
        "memoryStatistics" : {
          "memoryUsage" : 2,
          "totalMemory" : 9,
          "refreshedAt" : 7
        }
      },
      "egressInterface" : {
        "physicalInterface" : {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        },
        "virtualInterface" : [ {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        }, {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        } ]
      },
      "accuracyList" : [ {
        "reason" : "reason",
        "percent" : 0
      }, {
        "reason" : "reason",
        "percent" : 0
      } ],
      "id" : "id"
    }, {
      "linkInformationSource" : "linkInformationSource",
      "role" : "role",
      "flexConnect" : {
        "egressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "ingressAclAnalysis" : {
          "result" : "result",
          "aclName" : "aclName",
          "matchingAces" : [ {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          }, {
            "matchingPorts" : [ {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            }, {
              "protocol" : "protocol",
              "ports" : [ {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              }, {
                "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                "destPorts" : [ "destPorts", "destPorts" ]
              } ]
            } ],
            "result" : "result",
            "ace" : "ace"
          } ]
        },
        "dataSwitching" : "LOCAL",
        "wirelessLanControllerName" : "wirelessLanControllerName",
        "wirelessLanControllerId" : "wirelessLanControllerId",
        "authentication" : "LOCAL"
      },
      "deviceStatsCollection" : "deviceStatsCollection",
      "ip" : "ip",
      "perfMonCollectionFailureReason" : "perfMonCollectionFailureReason",
      "ingressInterface" : {
        "physicalInterface" : {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        },
        "virtualInterface" : [ {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        }, {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        } ]
      },
      "perfMonCollection" : "perfMonCollection",
      "type" : "type",
      "ssid" : "ssid",
      "wlanId" : "wlanId",
      "tunnels" : [ "tunnels", "tunnels" ],
      "deviceStatsCollectionFailureReason" : "deviceStatsCollectionFailureReason",
      "perfMonitorStatistics" : [ {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      }, {
        "rtpJitterMax" : 3,
        "sourcePort" : "sourcePort",
        "ipv4TTL" : 2,
        "byteRate" : 1,
        "packetCount" : 6,
        "sourceIpAddress" : "sourceIpAddress",
        "rtpJitterMean" : 7,
        "ipv4DSCP" : "ipv4DSCP",
        "protocol" : "protocol",
        "rtpJitterMin" : 0,
        "destPort" : "destPort",
        "destIpAddress" : "destIpAddress",
        "outputInterface" : "outputInterface",
        "packetLoss" : 5,
        "packetLossPercentage" : 6.70401929795003592715829654480330646038055419921875,
        "packetBytes" : 6,
        "refreshedAt" : 3,
        "inputInterface" : "inputInterface"
      } ],
      "detailedStatus" : {
        "aclTraceCalculationFailureReason" : "aclTraceCalculationFailureReason",
        "aclTraceCalculation" : "aclTraceCalculation"
      },
      "name" : "name",
      "deviceStatistics" : {
        "cpuStatistics" : {
          "fiveSecsUsageInPercentage" : 1.46581298050294517310021547018550336360931396484375,
          "refreshedAt" : 5,
          "fiveMinUsageInPercentage" : 6.02745618307040320615897144307382404804229736328125,
          "oneMinUsageInPercentage" : 5.962133916683182377482808078639209270477294921875
        },
        "memoryStatistics" : {
          "memoryUsage" : 2,
          "totalMemory" : 9,
          "refreshedAt" : 7
        }
      },
      "egressInterface" : {
        "physicalInterface" : {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        },
        "virtualInterface" : [ {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        }, {
          "aclAnalysis" : {
            "result" : "result",
            "aclName" : "aclName",
            "matchingAces" : [ {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            }, {
              "matchingPorts" : [ {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              }, {
                "protocol" : "protocol",
                "ports" : [ {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                }, {
                  "sourcePorts" : [ "sourcePorts", "sourcePorts" ],
                  "destPorts" : [ "destPorts", "destPorts" ]
                } ]
              } ],
              "result" : "result",
              "ace" : "ace"
            } ]
          },
          "pathOverlayInfo" : [ {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          }, {
            "destIp" : "destIp",
            "protocol" : "protocol",
            "sourcePort" : "sourcePort",
            "controlPlane" : "controlPlane",
            "destPort" : "destPort",
            "sourceIp" : "sourceIp",
            "vxlanInfo" : {
              "dscp" : "dscp",
              "vnid" : "vnid"
            },
            "dataPacketEncapsulation" : "dataPacketEncapsulation"
          } ],
          "qosStatsCollection" : "qosStatsCollection",
          "interfaceStatistics" : {
            "inputQueueMaxDepth" : 1,
            "operationalStatus" : "operationalStatus",
            "outputQueueCount" : 7,
            "outputPackets" : 6,
            "inputQueueFlushes" : 7,
            "inputQueueCount" : 2,
            "inputQueueDrops" : 4,
            "outputRatebps" : 4,
            "inputPackets" : 3,
            "inputRatebps" : 1,
            "outputQueueDepth" : 1,
            "adminStatus" : "adminStatus",
            "refreshedAt" : 5,
            "outputDrop" : 1
          },
          "name" : "name",
          "qosStatsCollectionFailureReason" : "qosStatsCollectionFailureReason",
          "usedVlan" : "usedVlan",
          "id" : "id",
          "interfaceStatsCollection" : "interfaceStatsCollection",
          "interfaceStatsCollectionFailureReason" : "interfaceStatsCollectionFailureReason",
          "qosStatistics" : [ {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          }, {
            "numBytes" : 9,
            "queueBandwidthbps" : "queueBandwidthbps",
            "queueNoBufferDrops" : 6,
            "classMapName" : "classMapName",
            "offeredRate" : 8,
            "numPackets" : 6,
            "dropRate" : 9,
            "queueDepth" : 9,
            "refreshedAt" : 6,
            "queueTotalDrops" : 3
          } ],
          "vrfName" : "vrfName"
        } ]
      },
      "accuracyList" : [ {
        "reason" : "reason",
        "percent" : 0
      }, {
        "reason" : "reason",
        "percent" : 0
      } ],
      "id" : "id"
    } ],
    "properties" : [ "properties", "properties" ]
  },
  "version" : "version"
}}]
     - parameter flowAnalysisId: (path) Flow analysis request id 
     - returns: RequestBuilder<PathResponseResult> 
     */
    open class func getFlowAnalysisByFlowAnalysisIdWithRequestBuilder(flowAnalysisId: String) -> RequestBuilder<PathResponseResult> {
        var path = "/api/v1/flow-analysis/${flowAnalysisId}"
        let flowAnalysisIdPreEscape = "\(flowAnalysisId)"
        let flowAnalysisIdPostEscape = flowAnalysisIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{flowAnalysisId}", with: flowAnalysisIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<PathResponseResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
