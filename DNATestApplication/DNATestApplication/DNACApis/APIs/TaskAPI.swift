//
// TaskAPI.swift
//

//

import Foundation
import Alamofire


open class TaskAPI: APIBase {
    /**
     Get filtered tasks
     - parameter startTime: (query) This is the epoch start time from which tasks need to be fetched (optional)
     - parameter endTime: (query) This is the epoch end time upto which audit records need to be fetched (optional)
     - parameter data: (query) Fetch tasks that contains this data (optional)
     - parameter errorCode: (query) Fetch tasks that have this error code (optional)
     - parameter serviceType: (query) Fetch tasks with this service type (optional)
     - parameter username: (query) Fetch tasks with this username (optional)
     - parameter progress: (query) Fetch tasks that contains this progress (optional)
     - parameter isError: (query) Fetch tasks ended as success or failure. Valid values: true, false (optional)
     - parameter failureReason: (query) Fetch tasks that contains this failure reason (optional)
     - parameter parentId: (query) Fetch tasks that have this parent Id (optional)
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - parameter sortBy: (query) Sort results by this field (optional)
     - parameter order: (query) Sort order - asc or dsc (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTask(startTime: String? = nil, endTime: String? = nil, data: String? = nil, errorCode: String? = nil, serviceType: String? = nil, username: String? = nil, progress: String? = nil, isError: String? = nil, failureReason: String? = nil, parentId: String? = nil, offset: String? = nil, limit: String? = nil, sortBy: String? = nil, order: String? = nil, completion: @escaping ((_ data: TaskDTOListResponse?, _ error: ErrorResponse?) -> Void)) {
        getTaskWithRequestBuilder(startTime: startTime, endTime: endTime, data: data, errorCode: errorCode, serviceType: serviceType, username: username, progress: progress, isError: isError, failureReason: failureReason, parentId: parentId, offset: offset, limit: limit, sortBy: sortBy, order: order).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get filtered tasks
     - GET /api/v1/task
     - This method is used to retrieve task(s) based on various filters

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "operationIdList" : "{}",
    "serviceType" : "serviceType",
    "errorKey" : "errorKey",
    "data" : "data",
    "additionalStatusURL" : "additionalStatusURL",
    "rootId" : "rootId",
    "errorCode" : "errorCode",
    "version" : 0,
    "parentId" : "parentId",
    "isError" : true,
    "instanceTenantId" : "instanceTenantId",
    "failureReason" : "failureReason",
    "lastUpdate" : "lastUpdate",
    "progress" : "progress",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "username" : "username"
  }, {
    "operationIdList" : "{}",
    "serviceType" : "serviceType",
    "errorKey" : "errorKey",
    "data" : "data",
    "additionalStatusURL" : "additionalStatusURL",
    "rootId" : "rootId",
    "errorCode" : "errorCode",
    "version" : 0,
    "parentId" : "parentId",
    "isError" : true,
    "instanceTenantId" : "instanceTenantId",
    "failureReason" : "failureReason",
    "lastUpdate" : "lastUpdate",
    "progress" : "progress",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "username" : "username"
  } ],
  "version" : "version"
}}]
     - parameter startTime: (query) This is the epoch start time from which tasks need to be fetched (optional)
     - parameter endTime: (query) This is the epoch end time upto which audit records need to be fetched (optional)
     - parameter data: (query) Fetch tasks that contains this data (optional)
     - parameter errorCode: (query) Fetch tasks that have this error code (optional)
     - parameter serviceType: (query) Fetch tasks with this service type (optional)
     - parameter username: (query) Fetch tasks with this username (optional)
     - parameter progress: (query) Fetch tasks that contains this progress (optional)
     - parameter isError: (query) Fetch tasks ended as success or failure. Valid values: true, false (optional)
     - parameter failureReason: (query) Fetch tasks that contains this failure reason (optional)
     - parameter parentId: (query) Fetch tasks that have this parent Id (optional)
     - parameter offset: (query) offset (optional)
     - parameter limit: (query) limit (optional)
     - parameter sortBy: (query) Sort results by this field (optional)
     - parameter order: (query) Sort order - asc or dsc (optional)
     - returns: RequestBuilder<TaskDTOListResponse> 
     */
    open class func getTaskWithRequestBuilder(startTime: String? = nil, endTime: String? = nil, data: String? = nil, errorCode: String? = nil, serviceType: String? = nil, username: String? = nil, progress: String? = nil, isError: String? = nil, failureReason: String? = nil, parentId: String? = nil, offset: String? = nil, limit: String? = nil, sortBy: String? = nil, order: String? = nil) -> RequestBuilder<TaskDTOListResponse> {
        let path = "/api/v1/task"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "startTime": startTime, 
            "endTime": endTime, 
            "data": data, 
            "errorCode": errorCode, 
            "serviceType": serviceType, 
            "username": username, 
            "progress": progress, 
            "isError": isError, 
            "failureReason": failureReason, 
            "parentId": parentId, 
            "offset": offset, 
            "limit": limit, 
            "sortBy": sortBy, 
            "order": order
        ])

        let requestBuilder: RequestBuilder<TaskDTOListResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     getTruststoreFileCount
     - parameter taskId: (path) UUID of the Task 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTaskByTaskId(taskId: String, completion: @escaping ((_ data: TaskDTOResponse?, _ error: ErrorResponse?) -> Void)) {
        getTaskByTaskIdWithRequestBuilder(taskId: taskId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     getTruststoreFileCount
     - GET /api/v1/task/${taskId}
     - This method is used to retrieve a task based on their id

     - examples: [{contentType=application/json, example={
  "response" : {
    "operationIdList" : "{}",
    "serviceType" : "serviceType",
    "errorKey" : "errorKey",
    "data" : "data",
    "additionalStatusURL" : "additionalStatusURL",
    "rootId" : "rootId",
    "errorCode" : "errorCode",
    "version" : 0,
    "parentId" : "parentId",
    "isError" : true,
    "instanceTenantId" : "instanceTenantId",
    "failureReason" : "failureReason",
    "lastUpdate" : "lastUpdate",
    "progress" : "progress",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "username" : "username"
  },
  "version" : "version"
}}]
     - parameter taskId: (path) UUID of the Task 
     - returns: RequestBuilder<TaskDTOResponse> 
     */
    open class func getTaskByTaskIdWithRequestBuilder(taskId: String) -> RequestBuilder<TaskDTOResponse> {
        var path = "/api/v1/task/${taskId}"
        let taskIdPreEscape = "\(taskId)"
        let taskIdPostEscape = taskIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{taskId}", with: taskIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskDTOResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get task count
     - parameter startTime: (query) This is the epoch start time from which tasks need to be fetched (optional)
     - parameter endTime: (query) This is the epoch end time upto which audit records need to be fetched (optional)
     - parameter data: (query) Fetch tasks that contains this data (optional)
     - parameter errorCode: (query) Fetch tasks that have this error code (optional)
     - parameter serviceType: (query) Fetch tasks with this service type (optional)
     - parameter username: (query) Fetch tasks with this username (optional)
     - parameter progress: (query) Fetch tasks that contains this progress (optional)
     - parameter isError: (query) Fetch tasks ended as success or failure. Valid values: true, false (optional)
     - parameter failureReason: (query) Fetch tasks that contains this failure reason (optional)
     - parameter parentId: (query) Fetch tasks that have this parent Id (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTaskCount(startTime: String? = nil, endTime: String? = nil, data: String? = nil, errorCode: String? = nil, serviceType: String? = nil, username: String? = nil, progress: String? = nil, isError: String? = nil, failureReason: String? = nil, parentId: String? = nil, completion: @escaping ((_ data: CountResult?, _ error: ErrorResponse?) -> Void)) {
        getTaskCountWithRequestBuilder(startTime: startTime, endTime: endTime, data: data, errorCode: errorCode, serviceType: serviceType, username: username, progress: progress, isError: isError, failureReason: failureReason, parentId: parentId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get task count
     - GET /api/v1/task/count
     - This method is used to retrieve task count

     - examples: [{contentType=application/json, example={
  "response" : 0,
  "version" : "version"
}}]
     - parameter startTime: (query) This is the epoch start time from which tasks need to be fetched (optional)
     - parameter endTime: (query) This is the epoch end time upto which audit records need to be fetched (optional)
     - parameter data: (query) Fetch tasks that contains this data (optional)
     - parameter errorCode: (query) Fetch tasks that have this error code (optional)
     - parameter serviceType: (query) Fetch tasks with this service type (optional)
     - parameter username: (query) Fetch tasks with this username (optional)
     - parameter progress: (query) Fetch tasks that contains this progress (optional)
     - parameter isError: (query) Fetch tasks ended as success or failure. Valid values: true, false (optional)
     - parameter failureReason: (query) Fetch tasks that contains this failure reason (optional)
     - parameter parentId: (query) Fetch tasks that have this parent Id (optional)
     - returns: RequestBuilder<CountResult> 
     */
    open class func getTaskCountWithRequestBuilder(startTime: String? = nil, endTime: String? = nil, data: String? = nil, errorCode: String? = nil, serviceType: String? = nil, username: String? = nil, progress: String? = nil, isError: String? = nil, failureReason: String? = nil, parentId: String? = nil) -> RequestBuilder<CountResult> {
        let path = "/api/v1/task/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "startTime": startTime, 
            "endTime": endTime, 
            "data": data, 
            "errorCode": errorCode, 
            "serviceType": serviceType, 
            "username": username, 
            "progress": progress, 
            "isError": isError, 
            "failureReason": failureReason, 
            "parentId": parentId
        ])

        let requestBuilder: RequestBuilder<CountResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     getTaskByOperationId
     - parameter operationId: (path) operationId 
     - parameter offset: (path) Index, minimum value is 0 
     - parameter limit: (path) The maximum value of {limit} supported is 500. &lt;br/&gt; Base 1 indexing for {limit}, minimum value is 1 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTaskOperationByOperationIdRange(operationId: String, offset: Int32, limit: Int32, completion: @escaping ((_ data: TaskDTOListResponse?, _ error: ErrorResponse?) -> Void)) {
        getTaskOperationByOperationIdRangeWithRequestBuilder(operationId: operationId, offset: offset, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     getTaskByOperationId
     - GET /api/v1/task/operation/${operationId}/${offset}/${limit}
     - This method is used to find root tasks assoicated to an operationid 

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "operationIdList" : "{}",
    "serviceType" : "serviceType",
    "errorKey" : "errorKey",
    "data" : "data",
    "additionalStatusURL" : "additionalStatusURL",
    "rootId" : "rootId",
    "errorCode" : "errorCode",
    "version" : 0,
    "parentId" : "parentId",
    "isError" : true,
    "instanceTenantId" : "instanceTenantId",
    "failureReason" : "failureReason",
    "lastUpdate" : "lastUpdate",
    "progress" : "progress",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "username" : "username"
  }, {
    "operationIdList" : "{}",
    "serviceType" : "serviceType",
    "errorKey" : "errorKey",
    "data" : "data",
    "additionalStatusURL" : "additionalStatusURL",
    "rootId" : "rootId",
    "errorCode" : "errorCode",
    "version" : 0,
    "parentId" : "parentId",
    "isError" : true,
    "instanceTenantId" : "instanceTenantId",
    "failureReason" : "failureReason",
    "lastUpdate" : "lastUpdate",
    "progress" : "progress",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "username" : "username"
  } ],
  "version" : "version"
}}]
     - parameter operationId: (path) operationId 
     - parameter offset: (path) Index, minimum value is 0 
     - parameter limit: (path) The maximum value of {limit} supported is 500. &lt;br/&gt; Base 1 indexing for {limit}, minimum value is 1 
     - returns: RequestBuilder<TaskDTOListResponse> 
     */
    open class func getTaskOperationByOperationIdRangeWithRequestBuilder(operationId: String, offset: Int32, limit: Int32) -> RequestBuilder<TaskDTOListResponse> {
        var path = "/api/v1/task/operation/${operationId}/${offset}/${limit}"
        let operationIdPreEscape = "\(operationId)"
        let operationIdPostEscape = operationIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{operationId}", with: operationIdPostEscape, options: .literal, range: nil)
        let offsetPreEscape = "\(offset)"
        let offsetPostEscape = offsetPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{offset}", with: offsetPostEscape, options: .literal, range: nil)
        let limitPreEscape = "\(limit)"
        let limitPostEscape = limitPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{limit}", with: limitPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskDTOListResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Task Tree
     - parameter taskId: (path) UUID of the Task 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTaskTreeByTaskId(taskId: String, completion: @escaping ((_ data: TaskDTOListResponse?, _ error: ErrorResponse?) -> Void)) {
        getTaskTreeByTaskIdWithRequestBuilder(taskId: taskId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Task Tree
     - GET /api/v1/task/${taskId}/tree
     - This method is used to retrieve a task with its children tasks based on their id

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "operationIdList" : "{}",
    "serviceType" : "serviceType",
    "errorKey" : "errorKey",
    "data" : "data",
    "additionalStatusURL" : "additionalStatusURL",
    "rootId" : "rootId",
    "errorCode" : "errorCode",
    "version" : 0,
    "parentId" : "parentId",
    "isError" : true,
    "instanceTenantId" : "instanceTenantId",
    "failureReason" : "failureReason",
    "lastUpdate" : "lastUpdate",
    "progress" : "progress",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "username" : "username"
  }, {
    "operationIdList" : "{}",
    "serviceType" : "serviceType",
    "errorKey" : "errorKey",
    "data" : "data",
    "additionalStatusURL" : "additionalStatusURL",
    "rootId" : "rootId",
    "errorCode" : "errorCode",
    "version" : 0,
    "parentId" : "parentId",
    "isError" : true,
    "instanceTenantId" : "instanceTenantId",
    "failureReason" : "failureReason",
    "lastUpdate" : "lastUpdate",
    "progress" : "progress",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "id" : "id",
    "username" : "username"
  } ],
  "version" : "version"
}}]
     - parameter taskId: (path) UUID of the Task 
     - returns: RequestBuilder<TaskDTOListResponse> 
     */
    open class func getTaskTreeByTaskIdWithRequestBuilder(taskId: String) -> RequestBuilder<TaskDTOListResponse> {
        var path = "/api/v1/task/${taskId}/tree"
        let taskIdPreEscape = "\(taskId)"
        let taskIdPostEscape = taskIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{taskId}", with: taskIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskDTOListResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
