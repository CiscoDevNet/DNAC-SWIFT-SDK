//
// GlobalCredentialAPI.swift
//

//

import Foundation
import Alamofire


open class GlobalCredentialAPI: APIBase {
    /**
     Retrieves global credential by ID
     - parameter globalCredentialId: (path) ID of global-credential 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteGlobalCredentialByGlobalCredentialId(globalCredentialId: String, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteGlobalCredentialByGlobalCredentialIdWithRequestBuilder(globalCredentialId: globalCredentialId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves global credential by ID
     - DELETE /api/v1/global-credential/${globalCredentialId}
     - This method is used to delete global credential for the given ID

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter globalCredentialId: (path) ID of global-credential 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteGlobalCredentialByGlobalCredentialIdWithRequestBuilder(globalCredentialId: String) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/global-credential/${globalCredentialId}"
        let globalCredentialIdPreEscape = "\(globalCredentialId)"
        let globalCredentialIdPostEscape = globalCredentialIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{globalCredentialId}", with: globalCredentialIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves global credential for the given credential sub type
     - parameter credentialSubType: (query) Credential type as CLI / SNMPV2_READ_COMMUNITY / SNMPV2_WRITE_COMMUNITY / SNMPV3 / HTTP_WRITE / HTTP_READ / NETCONF (optional)
     - parameter sortBy: (query) sortBy (optional)
     - parameter order: (query) order (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getGlobalCredential(credentialSubType: String? = nil, sortBy: String? = nil, order: String? = nil, completion: @escaping ((_ data: GlobalCredentialListResult?, _ error: ErrorResponse?) -> Void)) {
        getGlobalCredentialWithRequestBuilder(credentialSubType: credentialSubType, sortBy: sortBy, order: order).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves global credential for the given credential sub type
     - GET /api/v1/global-credential
     - This method is used to get global credential for the given credential sub type

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "credentialType" : "GLOBAL",
    "comments" : "comments",
    "instanceTenantId" : "instanceTenantId",
    "instanceUuid" : "instanceUuid",
    "description" : "description",
    "id" : "id"
  }, {
    "credentialType" : "GLOBAL",
    "comments" : "comments",
    "instanceTenantId" : "instanceTenantId",
    "instanceUuid" : "instanceUuid",
    "description" : "description",
    "id" : "id"
  } ],
  "version" : "version"
}}]
     - parameter credentialSubType: (query) Credential type as CLI / SNMPV2_READ_COMMUNITY / SNMPV2_WRITE_COMMUNITY / SNMPV3 / HTTP_WRITE / HTTP_READ / NETCONF (optional)
     - parameter sortBy: (query) sortBy (optional)
     - parameter order: (query) order (optional)
     - returns: RequestBuilder<GlobalCredentialListResult> 
     */
    open class func getGlobalCredentialWithRequestBuilder(credentialSubType: String? = nil, sortBy: String? = nil, order: String? = nil) -> RequestBuilder<GlobalCredentialListResult> {
        let path = "/api/v1/global-credential"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "credentialSubType": credentialSubType, 
            "sortBy": sortBy, 
            "order": order
        ])

        let requestBuilder: RequestBuilder<GlobalCredentialListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Retrieves credential sub type for the given credential Id
     - parameter id: (path) Global Credential ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getGlobalCredentialById(id: String, completion: @escaping ((_ data: GlobalCredentialSubTypeResult?, _ error: ErrorResponse?) -> Void)) {
        getGlobalCredentialByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Retrieves credential sub type for the given credential Id
     - GET /api/v1/global-credential/${id}
     - This method is used to get credential sub type for the given Id

     - examples: [{contentType=application/json, example={
  "response" : "response",
  "version" : "version"
}}]
     - parameter id: (path) Global Credential ID 
     - returns: RequestBuilder<GlobalCredentialSubTypeResult> 
     */
    open class func getGlobalCredentialByIdWithRequestBuilder(id: String) -> RequestBuilder<GlobalCredentialSubTypeResult> {
        var path = "/api/v1/global-credential/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GlobalCredentialSubTypeResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Creates global CLI credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postGlobalCredentialCli(request: CLICredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postGlobalCredentialCliWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates global CLI credential
     - POST /api/v1/global-credential/cli
     - This method is used to add global CLI credential

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
    open class func postGlobalCredentialCliWithRequestBuilder(request: CLICredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/cli"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Creates global HTTP read credentials
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postGlobalCredentialHttpRead(request: HTTPReadCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postGlobalCredentialHttpReadWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates global HTTP read credentials
     - POST /api/v1/global-credential/http-read
     - This method is used to add HTTP read credentials

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
    open class func postGlobalCredentialHttpReadWithRequestBuilder(request: HTTPReadCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/http-read"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Creates global HTTP write credentials
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postGlobalCredentialHttpWrite(request: HTTPWriteCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postGlobalCredentialHttpWriteWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates global HTTP write credentials
     - POST /api/v1/global-credential/http-write
     - This method is used to add global HTTP write credentials

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
    open class func postGlobalCredentialHttpWriteWithRequestBuilder(request: HTTPWriteCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/http-write"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Creates global netconf credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postGlobalCredentialNetconf(request: NetconfCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postGlobalCredentialNetconfWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates global netconf credential
     - POST /api/v1/global-credential/netconf
     - This method is used to add global netconf credential

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
    open class func postGlobalCredentialNetconfWithRequestBuilder(request: NetconfCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/netconf"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Creates global SNMP read community
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postGlobalCredentialSnmpv2ReadCommunity(request: SNMPvReadCommunityDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postGlobalCredentialSnmpv2ReadCommunityWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates global SNMP read community
     - POST /api/v1/global-credential/snmpv2-read-community
     - This method is used to add global SNMP read community

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
    open class func postGlobalCredentialSnmpv2ReadCommunityWithRequestBuilder(request: SNMPvReadCommunityDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/snmpv2-read-community"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Creates global SNMP write community
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postGlobalCredentialSnmpv2WriteCommunity(request: SNMPvWriteCommunityDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postGlobalCredentialSnmpv2WriteCommunityWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates global SNMP write community
     - POST /api/v1/global-credential/snmpv2-write-community
     - This method is used to add global SNMP write community

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
    open class func postGlobalCredentialSnmpv2WriteCommunityWithRequestBuilder(request: SNMPvWriteCommunityDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/snmpv2-write-community"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Creates global SNMPv3 credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postGlobalCredentialSnmpv3(request: SNMPvCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postGlobalCredentialSnmpv3WithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Creates global SNMPv3 credential
     - POST /api/v1/global-credential/snmpv3
     - This method is used to add global SNMPv3 credential

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
    open class func postGlobalCredentialSnmpv3WithRequestBuilder(request: SNMPvCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/snmpv3"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update global credential for network devices in site(s)
     - parameter request: (body) request 
     - parameter globalCredentialId: (path) Global credential Uuid 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialByGlobalCredentialId(request: SitesInfoDTO, globalCredentialId: String, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialByGlobalCredentialIdWithRequestBuilder(request: request, globalCredentialId: globalCredentialId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Update global credential for network devices in site(s)
     - PUT /api/v1/global-credential/${globalCredentialId}
     - Update global credential for network devices in site(s)

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - parameter globalCredentialId: (path) Global credential Uuid 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func putGlobalCredentialByGlobalCredentialIdWithRequestBuilder(request: SitesInfoDTO, globalCredentialId: String) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/global-credential/${globalCredentialId}"
        let globalCredentialIdPreEscape = "\(globalCredentialId)"
        let globalCredentialIdPostEscape = globalCredentialIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{globalCredentialId}", with: globalCredentialIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates global CLI credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialCli(request: CLICredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialCliWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates global CLI credential
     - PUT /api/v1/global-credential/cli
     - This method is used to update global CLI credential

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
    open class func putGlobalCredentialCliWithRequestBuilder(request: CLICredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/cli"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates global HTTP Read credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialHttpRead(request: HTTPReadCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialHttpReadWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates global HTTP Read credential
     - PUT /api/v1/global-credential/http-read
     - This method is used to update global HTTP Read credential

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
    open class func putGlobalCredentialHttpReadWithRequestBuilder(request: HTTPReadCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/http-read"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates global HTTP Write credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialHttpWrite(request: HTTPWriteCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialHttpWriteWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates global HTTP Write credential
     - PUT /api/v1/global-credential/http-write
     - This method is used to update global HTTP Write credential

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
    open class func putGlobalCredentialHttpWriteWithRequestBuilder(request: HTTPWriteCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/http-write"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates global netconf credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialNetconf(request: NetconfCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialNetconfWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates global netconf credential
     - PUT /api/v1/global-credential/netconf
     - This method is used to update global netconf credential

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
    open class func putGlobalCredentialNetconfWithRequestBuilder(request: NetconfCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/netconf"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates global SNMP read community
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialSnmpv2ReadCommunity(request: SNMPvReadCommunityDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialSnmpv2ReadCommunityWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates global SNMP read community
     - PUT /api/v1/global-credential/snmpv2-read-community
     - This method is used to update global SNMP read community

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
    open class func putGlobalCredentialSnmpv2ReadCommunityWithRequestBuilder(request: SNMPvReadCommunityDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/snmpv2-read-community"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates global SNMP write community
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialSnmpv2WriteCommunity(request: SNMPvWriteCommunityDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialSnmpv2WriteCommunityWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates global SNMP write community
     - PUT /api/v1/global-credential/snmpv2-write-community
     - This method is used to update global SNMP write community

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
    open class func putGlobalCredentialSnmpv2WriteCommunityWithRequestBuilder(request: SNMPvWriteCommunityDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/snmpv2-write-community"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Updates global SNMPv3 credential
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putGlobalCredentialSnmpv3(request: SNMPvCredentialDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putGlobalCredentialSnmpv3WithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Updates global SNMPv3 credential
     - PUT /api/v1/global-credential/snmpv3
     - This method is used to update global SNMPv3 credential

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
    open class func putGlobalCredentialSnmpv3WithRequestBuilder(request: SNMPvCredentialDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/global-credential/snmpv3"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
