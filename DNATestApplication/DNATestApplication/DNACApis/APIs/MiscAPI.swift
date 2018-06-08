//
// MiscAPI.swift
//

//

import Foundation
import Alamofire


open class MiscAPI: APIBase {
    /**
     Retrieves SNMP properties
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSnmpProperty(completion: @escaping ((_ data: SystemPropertyListResult?, _ error: ErrorResponse?) -> Void)) {
        getSnmpPropertyWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves SNMP properties
     - GET /api/v1/snmp-property
     - This method is used to get SNMP properties

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "instanceTenantId" : "instanceTenantId",
    "intValue" : 0,
    "instanceUuid" : "instanceUuid",
    "id" : "id",
    "systemPropertyName" : "systemPropertyName"
  }, {
    "instanceTenantId" : "instanceTenantId",
    "intValue" : 0,
    "instanceUuid" : "instanceUuid",
    "id" : "id",
    "systemPropertyName" : "systemPropertyName"
  } ],
  "version" : "version"
}}]
     - returns: RequestBuilder<SystemPropertyListResult> 
     */
    open class func getSnmpPropertyWithRequestBuilder() -> RequestBuilder<SystemPropertyListResult> {
        let path = "/api/v1/snmp-property"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SystemPropertyListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Generate Token
     - parameter request: (body) request 
     - parameter authorization: (header) &lt;username:password&gt; of 64 based encoded string 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postAuthToken(request: GenerateTokenRequest, authorization: String, completion: @escaping ((_ data: GenerateTokenResponse?, _ error: ErrorResponse?) -> Void)) {
        postAuthTokenWithRequestBuilder(request: request, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Generate Token
     - POST /api/system/v1/auth/token
     - This method is used to generate token.

     - examples: [{contentType=application/json, example={
  "Token" : "Token"
}}]
     - parameter request: (body) request 
     - parameter authorization: (header) &lt;username:password&gt; of 64 based encoded string 
     - returns: RequestBuilder<GenerateTokenResponse> 
     */
    open class func postAuthTokenWithRequestBuilder(request: GenerateTokenRequest, authorization: String) -> RequestBuilder<GenerateTokenResponse> {
        let path = "/api/system/v1/auth/token"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<GenerateTokenResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Initiates a new flow analysis
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postFlowAnalysis(request: FlowAnalysisRequest, completion: @escaping ((_ data: FlowAnalysisRequestResultOutput?, _ error: ErrorResponse?) -> Void)) {
        postFlowAnalysisWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Initiates a new flow analysis
     - POST /api/v1/flow-analysis
     - Initiates a new flow analysis with periodic refresh and stat collection options. Returns a request id and a task id to get results and follow progress.

     - examples: [{contentType=application/json, example={
  "response" : {
    "flowAnalysisId" : "flowAnalysisId",
    "taskId" : "taskId",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<FlowAnalysisRequestResultOutput> 
     */
    open class func postFlowAnalysisWithRequestBuilder(request: FlowAnalysisRequest) -> RequestBuilder<FlowAnalysisRequestResultOutput> {
        let path = "/api/v1/flow-analysis"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FlowAnalysisRequestResultOutput>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Creates or updates SNMP properties
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postSnmpProperty(request: SystemPropertyNameAndIntValueDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postSnmpPropertyWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates or updates SNMP properties
     - POST /api/v1/snmp-property
     - This method is used to add SNMP properties

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
    open class func postSnmpPropertyWithRequestBuilder(request: SystemPropertyNameAndIntValueDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/snmp-property"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
