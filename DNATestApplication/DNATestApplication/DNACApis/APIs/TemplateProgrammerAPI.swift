//
// TemplateProgrammerAPI.swift
//

//

import Foundation
import Alamofire


open class TemplateProgrammerAPI: APIBase {
    /**
     Deletes the project
     - parameter projectId: (path) projectId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteTemplateProgrammerProjectByProjectId(projectId: String, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteTemplateProgrammerProjectByProjectIdWithRequestBuilder(projectId: projectId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deletes the project
     - DELETE /api/v1/template-programmer/project/${projectId}
     - Deletes the project

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter projectId: (path) projectId 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteTemplateProgrammerProjectByProjectIdWithRequestBuilder(projectId: String) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/template-programmer/project/${projectId}"
        let projectIdPreEscape = "\(projectId)"
        let projectIdPostEscape = projectIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{projectId}", with: projectIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Deletes the template
     - parameter templateId: (path) templateId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteTemplateProgrammerTemplateByTemplateId(templateId: String, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        deleteTemplateProgrammerTemplateByTemplateIdWithRequestBuilder(templateId: templateId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deletes the template
     - DELETE /api/v1/template-programmer/template/${templateId}
     - Deletes the template

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter templateId: (path) templateId 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func deleteTemplateProgrammerTemplateByTemplateIdWithRequestBuilder(templateId: String) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/template-programmer/template/${templateId}"
        let templateIdPreEscape = "\(templateId)"
        let templateIdPostEscape = templateIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{templateId}", with: templateIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Gets a list of projects
     - parameter name: (query) Name of project to be searched (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTemplateProgrammerProject(name: String? = nil, completion: @escaping ((_ data: CollectionProjectDTO?, _ error: ErrorResponse?) -> Void)) {
        getTemplateProgrammerProjectWithRequestBuilder(name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gets a list of projects
     - GET /api/v1/template-programmer/project
     - List the projects

     - examples: [{contentType=application/json, example={ }}]
     - parameter name: (query) Name of project to be searched (optional)
     - returns: RequestBuilder<CollectionProjectDTO> 
     */
    open class func getTemplateProgrammerProjectWithRequestBuilder(name: String? = nil) -> RequestBuilder<CollectionProjectDTO> {
        let path = "/api/v1/template-programmer/project"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "name": name
        ])

        let requestBuilder: RequestBuilder<CollectionProjectDTO>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Gets the templates available depending on the criteria
     - parameter projectId: (query) projectId (optional)
     - parameter softwareType: (query) softwareType (optional)
     - parameter softwareVersion: (query) softwareVersion (optional)
     - parameter productFamily: (query) productFamily (optional)
     - parameter productSeries: (query) productSeries (optional)
     - parameter productType: (query) productType (optional)
     - parameter includeHead: (query) includeHead (optional)
     - parameter filterConflictingTemplates: (query) filterConflictingTemplates (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTemplateProgrammerTemplate(projectId: String? = nil, softwareType: String? = nil, softwareVersion: String? = nil, productFamily: String? = nil, productSeries: String? = nil, productType: String? = nil, includeHead: Bool? = nil, filterConflictingTemplates: Bool? = nil, completion: @escaping ((_ data: CollectionTemplateInfo?, _ error: ErrorResponse?) -> Void)) {
        getTemplateProgrammerTemplateWithRequestBuilder(projectId: projectId, softwareType: softwareType, softwareVersion: softwareVersion, productFamily: productFamily, productSeries: productSeries, productType: productType, includeHead: includeHead, filterConflictingTemplates: filterConflictingTemplates).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gets the templates available depending on the criteria
     - GET /api/v1/template-programmer/template
     - Gets the templates available depending on the criteria

     - examples: [{contentType=application/json, example={ }}]
     - parameter projectId: (query) projectId (optional)
     - parameter softwareType: (query) softwareType (optional)
     - parameter softwareVersion: (query) softwareVersion (optional)
     - parameter productFamily: (query) productFamily (optional)
     - parameter productSeries: (query) productSeries (optional)
     - parameter productType: (query) productType (optional)
     - parameter includeHead: (query) includeHead (optional)
     - parameter filterConflictingTemplates: (query) filterConflictingTemplates (optional)
     - returns: RequestBuilder<CollectionTemplateInfo> 
     */
    open class func getTemplateProgrammerTemplateWithRequestBuilder(projectId: String? = nil, softwareType: String? = nil, softwareVersion: String? = nil, productFamily: String? = nil, productSeries: String? = nil, productType: String? = nil, includeHead: Bool? = nil, filterConflictingTemplates: Bool? = nil) -> RequestBuilder<CollectionTemplateInfo> {
        let path = "/api/v1/template-programmer/template"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "projectId": projectId, 
            "softwareType": softwareType, 
            "softwareVersion": softwareVersion, 
            "productFamily": productFamily, 
            "productSeries": productSeries, 
            "productType": productType, 
            "includeHead": includeHead, 
            "filterConflictingTemplates": filterConflictingTemplates
        ])

        let requestBuilder: RequestBuilder<CollectionTemplateInfo>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Status of template deployment
     - parameter deploymentId: (path) deploymentId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTemplateProgrammerTemplateDeployStatusByDeploymentId(deploymentId: String, completion: @escaping ((_ data: TemplateDeploymentStatusDTO?, _ error: ErrorResponse?) -> Void)) {
        getTemplateProgrammerTemplateDeployStatusByDeploymentIdWithRequestBuilder(deploymentId: deploymentId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Status of template deployment
     - GET /api/v1/template-programmer/template/deploy/status/${deploymentId}
     - API to retrieve the status of template deployment.

     - examples: [{contentType=application/json, example={
  "duration" : "duration",
  "devices" : [ {
    "duration" : "duration",
    "ipAddress" : "ipAddress",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "deviceId" : "deviceId",
    "status" : "status"
  }, {
    "duration" : "duration",
    "ipAddress" : "ipAddress",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "deviceId" : "deviceId",
    "status" : "status"
  } ],
  "templateName" : "templateName",
  "deploymentId" : "deploymentId",
  "deploymentName" : "deploymentName",
  "startTime" : "startTime",
  "templateVersion" : "templateVersion",
  "endTime" : "endTime",
  "projectName" : "projectName",
  "status" : "status"
}}]
     - parameter deploymentId: (path) deploymentId 
     - returns: RequestBuilder<TemplateDeploymentStatusDTO> 
     */
    open class func getTemplateProgrammerTemplateDeployStatusByDeploymentIdWithRequestBuilder(deploymentId: String) -> RequestBuilder<TemplateDeploymentStatusDTO> {
        var path = "/api/v1/template-programmer/template/deploy/status/${deploymentId}"
        let deploymentIdPreEscape = "\(deploymentId)"
        let deploymentIdPostEscape = deploymentIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{deploymentId}", with: deploymentIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TemplateDeploymentStatusDTO>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Gets all the versions of a given template
     - parameter templateId: (path) templateId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTemplateProgrammerTemplateVersionByTempleteId(templateId: String, completion: @escaping ((_ data: CollectionTemplateInfo?, _ error: ErrorResponse?) -> Void)) {
        getTemplateProgrammerTemplateVersionByTempleteIdWithRequestBuilder(templateId: templateId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gets all the versions of a given template
     - GET /api/v1/template-programmer/template/version/${templateId}
     - Get all the versions of template

     - examples: [{contentType=application/json, example={ }}]
     - parameter templateId: (path) templateId 
     - returns: RequestBuilder<CollectionTemplateInfo> 
     */
    open class func getTemplateProgrammerTemplateVersionByTempleteIdWithRequestBuilder(templateId: String) -> RequestBuilder<CollectionTemplateInfo> {
        var path = "/api/v1/template-programmer/template/version/${templateId}"
        let templateIdPreEscape = "\(templateId)"
        let templateIdPostEscape = templateIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{templateId}", with: templateIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CollectionTemplateInfo>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Create Project
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postTemplateProgrammerProject(request: ProjectDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postTemplateProgrammerProjectWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Create Project
     - POST /api/v1/template-programmer/project
     - This API is used to create a new project.

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
    open class func postTemplateProgrammerProjectWithRequestBuilder(request: ProjectDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/template-programmer/project"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Create Template
     - parameter request: (body) request 
     - parameter projectId: (path) projectId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postTemplateProgrammerProjectTemplateByProjectId(request: TemplateDTO, projectId: String, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postTemplateProgrammerProjectTemplateByProjectIdWithRequestBuilder(request: request, projectId: projectId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Create Template
     - POST /api/v1/template-programmer/project/${projectId}/template
     - API to create a template.

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - parameter projectId: (path) projectId 
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func postTemplateProgrammerProjectTemplateByProjectIdWithRequestBuilder(request: TemplateDTO, projectId: String) -> RequestBuilder<TaskIdResult> {
        var path = "/api/v1/template-programmer/project/${projectId}/template"
        let projectIdPreEscape = "\(projectId)"
        let projectIdPostEscape = projectIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{projectId}", with: projectIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Deploy Template
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postTemplateProgrammerTemplateDeploy(request: TemplateDeploymentInfo, completion: @escaping ((_ data: TemplateDeploymentStatusDTO?, _ error: ErrorResponse?) -> Void)) {
        postTemplateProgrammerTemplateDeployWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deploy Template
     - POST /api/v1/template-programmer/template/deploy
     - API to deploy a template.

     - examples: [{contentType=application/json, example={
  "duration" : "duration",
  "devices" : [ {
    "duration" : "duration",
    "ipAddress" : "ipAddress",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "deviceId" : "deviceId",
    "status" : "status"
  }, {
    "duration" : "duration",
    "ipAddress" : "ipAddress",
    "name" : "name",
    "startTime" : "startTime",
    "endTime" : "endTime",
    "deviceId" : "deviceId",
    "status" : "status"
  } ],
  "templateName" : "templateName",
  "deploymentId" : "deploymentId",
  "deploymentName" : "deploymentName",
  "startTime" : "startTime",
  "templateVersion" : "templateVersion",
  "endTime" : "endTime",
  "projectName" : "projectName",
  "status" : "status"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<TemplateDeploymentStatusDTO> 
     */
    open class func postTemplateProgrammerTemplateDeployWithRequestBuilder(request: TemplateDeploymentInfo) -> RequestBuilder<TemplateDeploymentStatusDTO> {
        let path = "/api/v1/template-programmer/template/deploy"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TemplateDeploymentStatusDTO>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Version Template
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postTemplateProgrammerTemplateVersion(request: TemplateVersionRequestDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postTemplateProgrammerTemplateVersionWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Version Template
     - POST /api/v1/template-programmer/template/version
     - API to version the current contents of the template.

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
    open class func postTemplateProgrammerTemplateVersionWithRequestBuilder(request: TemplateVersionRequestDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/template-programmer/template/version"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update Project
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putTemplateProgrammerProject(request: ProjectDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putTemplateProgrammerProjectWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Update Project
     - PUT /api/v1/template-programmer/project
     - This API is used to update an existing project.

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
    open class func putTemplateProgrammerProjectWithRequestBuilder(request: ProjectDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/template-programmer/project"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update Template
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putTemplateProgrammerTemplate(request: TemplateDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        putTemplateProgrammerTemplateWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Update Template
     - PUT /api/v1/template-programmer/template
     - API to update a template.

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
    open class func putTemplateProgrammerTemplateWithRequestBuilder(request: TemplateDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/template-programmer/template"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Preview Template
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putTemplateProgrammerTemplatePreview(request: TemplatePreviewRequestDTO, completion: @escaping ((_ data: TemplatePreviewResponseDTO?, _ error: ErrorResponse?) -> Void)) {
        putTemplateProgrammerTemplatePreviewWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Preview Template
     - PUT /api/v1/template-programmer/template/preview
     - API to preview a template.

     - examples: [{contentType=application/json, example={
  "cliPreview" : "cliPreview",
  "templateId" : "templateId"
}}]
     - parameter request: (body) request 
     - returns: RequestBuilder<TemplatePreviewResponseDTO> 
     */
    open class func putTemplateProgrammerTemplatePreviewWithRequestBuilder(request: TemplatePreviewRequestDTO) -> RequestBuilder<TemplatePreviewResponseDTO> {
        let path = "/api/v1/template-programmer/template/preview"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TemplatePreviewResponseDTO>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Gets details of a given template
     - parameter templateId: (path) templateId 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func templateProgrammerTemplateByTemplateId(templateId: String, completion: @escaping ((_ data: TemplateDTO?, _ error: ErrorResponse?) -> Void)) {
        templateProgrammerTemplateByTemplateIdWithRequestBuilder(templateId: templateId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Gets details of a given template
     - GET /api/v1/template-programmer/template/${templateId}
     - Details of the template

     - examples: [{contentType=application/json, example={
  "softwareType" : "softwareType",
  "author" : "author",
  "description" : "description",
  "softwareVariant" : "softwareVariant",
  "version" : "version",
  "tags" : [ "tags", "tags" ],
  "deviceTypes" : [ {
    "productFamily" : "productFamily",
    "productSeries" : "productSeries",
    "productType" : "productType"
  }, {
    "productFamily" : "productFamily",
    "productSeries" : "productSeries",
    "productType" : "productType"
  } ],
  "parentTemplateId" : "parentTemplateId",
  "createTime" : 0,
  "name" : "name",
  "rollbackTemplateContent" : "rollbackTemplateContent",
  "templateContent" : "templateContent",
  "templateParams" : [ {
    "instructionText" : "instructionText",
    "defaultValue" : "defaultValue",
    "displayName" : "displayName",
    "dataType" : "STRING",
    "description" : "description",
    "range" : [ {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    }, {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    } ],
    "parameterName" : "parameterName",
    "required" : true,
    "selection" : "{}",
    "provider" : "provider",
    "id" : "id",
    "key" : "key",
    "group" : "group",
    "order" : 1
  }, {
    "instructionText" : "instructionText",
    "defaultValue" : "defaultValue",
    "displayName" : "displayName",
    "dataType" : "STRING",
    "description" : "description",
    "range" : [ {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    }, {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    } ],
    "parameterName" : "parameterName",
    "required" : true,
    "selection" : "{}",
    "provider" : "provider",
    "id" : "id",
    "key" : "key",
    "group" : "group",
    "order" : 1
  } ],
  "id" : "id",
  "projectName" : "projectName",
  "projectId" : "projectId",
  "softwareVersion" : "softwareVersion",
  "lastUpdateTime" : 6,
  "rollbackTemplateParams" : [ {
    "instructionText" : "instructionText",
    "defaultValue" : "defaultValue",
    "displayName" : "displayName",
    "dataType" : "STRING",
    "description" : "description",
    "range" : [ {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    }, {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    } ],
    "parameterName" : "parameterName",
    "required" : true,
    "selection" : "{}",
    "provider" : "provider",
    "id" : "id",
    "key" : "key",
    "group" : "group",
    "order" : 1
  }, {
    "instructionText" : "instructionText",
    "defaultValue" : "defaultValue",
    "displayName" : "displayName",
    "dataType" : "STRING",
    "description" : "description",
    "range" : [ {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    }, {
      "minValue" : 5,
      "maxValue" : 5,
      "id" : "id"
    } ],
    "parameterName" : "parameterName",
    "required" : true,
    "selection" : "{}",
    "provider" : "provider",
    "id" : "id",
    "key" : "key",
    "group" : "group",
    "order" : 1
  } ]
}}]
     - parameter templateId: (path) templateId 
     - returns: RequestBuilder<TemplateDTO> 
     */
    open class func templateProgrammerTemplateByTemplateIdWithRequestBuilder(templateId: String) -> RequestBuilder<TemplateDTO> {
        var path = "/api/v1/template-programmer/template/${templateId}"
        let templateIdPreEscape = "\(templateId)"
        let templateIdPostEscape = templateIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{templateId}", with: templateIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TemplateDTO>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
