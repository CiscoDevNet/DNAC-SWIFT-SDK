//
// FileAPI.swift
//

//

import Foundation
import Alamofire


open class FileAPI: APIBase {
    /**
     Downloads a file referred by the fileId
     - parameter fileId: (path) File Identification number 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getFileByFileId(fileId: String, completion: @escaping ((_ data: DownloadsAFileReferredByTheFileIdResponse?, _ error: ErrorResponse?) -> Void)) {
        getFileByFileIdWithRequestBuilder(fileId: fileId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Downloads a file referred by the fileId
     - GET /api/v1/file/${fileId}
     - This method is used to download a file referred by the fileId

     - examples: [{contentType=application/json, example={ }}]
     - parameter fileId: (path) File Identification number 
     - returns: RequestBuilder<DownloadsAFileReferredByTheFileIdResponse> 
     */
    open class func getFileByFileIdWithRequestBuilder(fileId: String) -> RequestBuilder<DownloadsAFileReferredByTheFileIdResponse> {
        var path = "/api/v1/file/${fileId}"
        let fileIdPreEscape = "\(fileId)"
        let fileIdPostEscape = fileIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{fileId}", with: fileIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DownloadsAFileReferredByTheFileIdResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Returns list of available namespaces
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getFileNamespace(completion: @escaping ((_ data: NameSpaceListResult?, _ error: ErrorResponse?) -> Void)) {
        getFileNamespaceWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Returns list of available namespaces
     - GET /api/v1/file/namespace
     - This method is used to obtain a list of available namespaces

     - examples: [{contentType=application/json, example={
  "response" : [ "response", "response" ],
  "version" : "version"
}}]
     - returns: RequestBuilder<NameSpaceListResult> 
     */
    open class func getFileNamespaceWithRequestBuilder() -> RequestBuilder<NameSpaceListResult> {
        let path = "/api/v1/file/namespace"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<NameSpaceListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Returns list of files under a specific namespace
     - parameter nameSpace: (path) A listing of fileId&#39;s 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getFileNamespaceByNameSpace(nameSpace: String, completion: @escaping ((_ data: FileObjectListResult?, _ error: ErrorResponse?) -> Void)) {
        getFileNamespaceByNameSpaceWithRequestBuilder(nameSpace: nameSpace).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Returns list of files under a specific namespace
     - GET /api/v1/file/namespace/${nameSpace}
     - This method is used to obtain a list of files under a specific namespace

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "md5Checksum" : "md5Checksum",
    "sha1Checksum" : "sha1Checksum",
    "attributeInfo" : "{}",
    "downloadPath" : "downloadPath",
    "encrypted" : true,
    "fileSize" : "fileSize",
    "name" : "name",
    "id" : "id",
    "nameSpace" : "nameSpace",
    "sftpServerList" : [ "{}", "{}" ],
    "fileFormat" : "fileFormat",
    "taskId" : "{}"
  }, {
    "md5Checksum" : "md5Checksum",
    "sha1Checksum" : "sha1Checksum",
    "attributeInfo" : "{}",
    "downloadPath" : "downloadPath",
    "encrypted" : true,
    "fileSize" : "fileSize",
    "name" : "name",
    "id" : "id",
    "nameSpace" : "nameSpace",
    "sftpServerList" : [ "{}", "{}" ],
    "fileFormat" : "fileFormat",
    "taskId" : "{}"
  } ],
  "version" : "version"
}}]
     - parameter nameSpace: (path) A listing of fileId&#39;s 
     - returns: RequestBuilder<FileObjectListResult> 
     */
    open class func getFileNamespaceByNameSpaceWithRequestBuilder(nameSpace: String) -> RequestBuilder<FileObjectListResult> {
        var path = "/api/v1/file/namespace/${nameSpace}"
        let nameSpacePreEscape = "\(nameSpace)"
        let nameSpacePostEscape = nameSpacePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{nameSpace}", with: nameSpacePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<FileObjectListResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
