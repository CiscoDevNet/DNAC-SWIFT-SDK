//
// ImageAPI.swift
//

//

import Foundation
import Alamofire


open class ImageAPI: APIBase {
    /**
     Get image details with filter
     - parameter imageUuid: (query) imageUuid (optional)
     - parameter name: (query) name (optional)
     - parameter family: (query) family (optional)
     - parameter applicationType: (query) applicationType (optional)
     - parameter imageIntegrityStatus: (query) imageIntegrityStatus - FAILURE, UNKNOWN, VERIFIED (optional)
     - parameter version: (query) software Image Version (optional)
     - parameter imageSeries: (query) image Series (optional)
     - parameter imageName: (query) image Name (optional)
     - parameter isTaggedGolden: (query) is Tagged Golden (optional)
     - parameter isCCORecommended: (query) is recommended from cisco.com (optional)
     - parameter isCCOLatest: (query) is latest from cisco.com (optional)
     - parameter createdTime: (query) time in milliseconds (epoch format) (optional)
     - parameter imageSizeGreaterThan: (query) size in bytes (optional)
     - parameter imageSizeLesserThan: (query) size in bytes (optional)
     - parameter sortBy: (query) sort results by this field (optional)
     - parameter sortOrder: (query) sort order - &#39;asc&#39; or &#39;des&#39;. Default is asc (optional)
     - parameter limit: (query) limit (optional)
     - parameter offset: (query) offset (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getImageImportation(imageUuid: String? = nil, name: String? = nil, family: String? = nil, applicationType: String? = nil, imageIntegrityStatus: String? = nil, version: String? = nil, imageSeries: String? = nil, imageName: String? = nil, isTaggedGolden: Bool? = nil, isCCORecommended: Bool? = nil, isCCOLatest: Bool? = nil, createdTime: Int32? = nil, imageSizeGreaterThan: Int32? = nil, imageSizeLesserThan: Int32? = nil, sortBy: String? = nil, sortOrder: String? = nil, limit: Int32? = nil, offset: Int32? = nil, completion: @escaping ((_ data: ImageInfoListResponse?, _ error: ErrorResponse?) -> Void)) {
        getImageImportationWithRequestBuilder(imageUuid: imageUuid, name: name, family: family, applicationType: applicationType, imageIntegrityStatus: imageIntegrityStatus, version: version, imageSeries: imageSeries, imageName: imageName, isTaggedGolden: isTaggedGolden, isCCORecommended: isCCORecommended, isCCOLatest: isCCOLatest, createdTime: createdTime, imageSizeGreaterThan: imageSizeGreaterThan, imageSizeLesserThan: imageSizeLesserThan, sortBy: sortBy, sortOrder: sortOrder, limit: limit, offset: offset).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get image details with filter
     - GET /api/v1/image/importation
     - Get image details based on filter criteria, use % for like operations. Example: filterByName = cat3k%

     - examples: [{contentType=application/json, example={
  "response" : [ {
    "applicationType" : "applicationType",
    "imageName" : "imageName",
    "profileInfo" : [ {
      "profileName" : "profileName",
      "shares" : 6,
      "memory" : 0,
      "vCpu" : 1,
      "description" : "description",
      "extendedAttributes" : "{}",
      "productType" : "productType"
    }, {
      "profileName" : "profileName",
      "shares" : 6,
      "memory" : 0,
      "vCpu" : 1,
      "description" : "description",
      "extendedAttributes" : "{}",
      "productType" : "productType"
    } ],
    "imageIntegrityStatus" : "imageIntegrityStatus",
    "imageSeries" : [ "imageSeries", "imageSeries" ],
    "isTaggedGolden" : true,
    "version" : "version",
    "extendedAttributes" : "{}",
    "md5Checksum" : "md5Checksum",
    "fileServiceId" : "fileServiceId",
    "imageSource" : "imageSource",
    "applicableDevicesForImage" : [ {
      "mdfId" : "mdfId",
      "productId" : [ "productId", "productId" ],
      "productName" : "productName"
    }, {
      "mdfId" : "mdfId",
      "productId" : [ "productId", "productId" ],
      "productName" : "productName"
    } ],
    "feature" : "feature",
    "fileSize" : "fileSize",
    "vendor" : "vendor",
    "name" : "name",
    "createdTime" : "createdTime",
    "shaCheckSum" : "shaCheckSum",
    "family" : "family",
    "imageType" : "imageType",
    "importSourceType" : "DEVICE",
    "imageUuid" : "imageUuid"
  }, {
    "applicationType" : "applicationType",
    "imageName" : "imageName",
    "profileInfo" : [ {
      "profileName" : "profileName",
      "shares" : 6,
      "memory" : 0,
      "vCpu" : 1,
      "description" : "description",
      "extendedAttributes" : "{}",
      "productType" : "productType"
    }, {
      "profileName" : "profileName",
      "shares" : 6,
      "memory" : 0,
      "vCpu" : 1,
      "description" : "description",
      "extendedAttributes" : "{}",
      "productType" : "productType"
    } ],
    "imageIntegrityStatus" : "imageIntegrityStatus",
    "imageSeries" : [ "imageSeries", "imageSeries" ],
    "isTaggedGolden" : true,
    "version" : "version",
    "extendedAttributes" : "{}",
    "md5Checksum" : "md5Checksum",
    "fileServiceId" : "fileServiceId",
    "imageSource" : "imageSource",
    "applicableDevicesForImage" : [ {
      "mdfId" : "mdfId",
      "productId" : [ "productId", "productId" ],
      "productName" : "productName"
    }, {
      "mdfId" : "mdfId",
      "productId" : [ "productId", "productId" ],
      "productName" : "productName"
    } ],
    "feature" : "feature",
    "fileSize" : "fileSize",
    "vendor" : "vendor",
    "name" : "name",
    "createdTime" : "createdTime",
    "shaCheckSum" : "shaCheckSum",
    "family" : "family",
    "imageType" : "imageType",
    "importSourceType" : "DEVICE",
    "imageUuid" : "imageUuid"
  } ],
  "version" : "version"
}}]
     - parameter imageUuid: (query) imageUuid (optional)
     - parameter name: (query) name (optional)
     - parameter family: (query) family (optional)
     - parameter applicationType: (query) applicationType (optional)
     - parameter imageIntegrityStatus: (query) imageIntegrityStatus - FAILURE, UNKNOWN, VERIFIED (optional)
     - parameter version: (query) software Image Version (optional)
     - parameter imageSeries: (query) image Series (optional)
     - parameter imageName: (query) image Name (optional)
     - parameter isTaggedGolden: (query) is Tagged Golden (optional)
     - parameter isCCORecommended: (query) is recommended from cisco.com (optional)
     - parameter isCCOLatest: (query) is latest from cisco.com (optional)
     - parameter createdTime: (query) time in milliseconds (epoch format) (optional)
     - parameter imageSizeGreaterThan: (query) size in bytes (optional)
     - parameter imageSizeLesserThan: (query) size in bytes (optional)
     - parameter sortBy: (query) sort results by this field (optional)
     - parameter sortOrder: (query) sort order - &#39;asc&#39; or &#39;des&#39;. Default is asc (optional)
     - parameter limit: (query) limit (optional)
     - parameter offset: (query) offset (optional)
     - returns: RequestBuilder<ImageInfoListResponse> 
     */
    open class func getImageImportationWithRequestBuilder(imageUuid: String? = nil, name: String? = nil, family: String? = nil, applicationType: String? = nil, imageIntegrityStatus: String? = nil, version: String? = nil, imageSeries: String? = nil, imageName: String? = nil, isTaggedGolden: Bool? = nil, isCCORecommended: Bool? = nil, isCCOLatest: Bool? = nil, createdTime: Int32? = nil, imageSizeGreaterThan: Int32? = nil, imageSizeLesserThan: Int32? = nil, sortBy: String? = nil, sortOrder: String? = nil, limit: Int32? = nil, offset: Int32? = nil) -> RequestBuilder<ImageInfoListResponse> {
        let path = "/api/v1/image/importation"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "imageUuid": imageUuid, 
            "name": name, 
            "family": family, 
            "applicationType": applicationType, 
            "imageIntegrityStatus": imageIntegrityStatus, 
            "version": version, 
            "imageSeries": imageSeries, 
            "imageName": imageName, 
            "isTaggedGolden": isTaggedGolden, 
            "isCCORecommended": isCCORecommended, 
            "isCCOLatest": isCCOLatest, 
            "createdTime": createdTime?.encodeToJSON(), 
            "imageSizeGreaterThan": imageSizeGreaterThan?.encodeToJSON(), 
            "imageSizeLesserThan": imageSizeLesserThan?.encodeToJSON(), 
            "sortBy": sortBy, 
            "sortOrder": sortOrder, 
            "limit": limit?.encodeToJSON(), 
            "offset": offset?.encodeToJSON()
        ])

        let requestBuilder: RequestBuilder<ImageInfoListResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Trigger activation on a device
     - parameter request: (body) request 
     - parameter clientType: (header) Client-type (Optional) (optional)
     - parameter clientUrl: (header) Client-url (Optional) (optional)
     - parameter scheduleValidate: (query) scheduleValidate, validates data before schedule (Optional) (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postImageActivationDevice(request: ActivateDTO, clientType: String? = nil, clientUrl: String? = nil, scheduleValidate: Bool? = nil, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postImageActivationDeviceWithRequestBuilder(request: request, clientType: clientType, clientUrl: clientUrl, scheduleValidate: scheduleValidate).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Trigger activation on a device
     - POST /api/v1/image/activation/device
     - Performs activation of an image on a given device.

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - parameter clientType: (header) Client-type (Optional) (optional)
     - parameter clientUrl: (header) Client-url (Optional) (optional)
     - parameter scheduleValidate: (query) scheduleValidate, validates data before schedule (Optional) (optional)
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func postImageActivationDeviceWithRequestBuilder(request: ActivateDTO, clientType: String? = nil, clientUrl: String? = nil, scheduleValidate: Bool? = nil) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/image/activation/device"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "scheduleValidate": scheduleValidate
        ])
        let nillableHeaders: [String: Any?] = [
            "Client-Type": clientType,
            "Client-Url": clientUrl
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true, headers: headerParameters)
    }

    /**
     Trigger distribution of an image
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postImageDistribution(request: DistributeDTO, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postImageDistributionWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Trigger distribution of an image
     - POST /api/v1/image/distribution
     - Performs distribution of an image to a given device.

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
    open class func postImageDistributionWithRequestBuilder(request: DistributeDTO) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/image/distribution"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Import an image from local file system
     - parameter isThirdParty: (query) Third party Image check (optional)
     - parameter thirdPartyVendor: (query) Third Party Vendor (optional)
     - parameter thirdPartyImageFamily: (query) Third Party image family (optional)
     - parameter thirdPartyApplicationType: (query) Third Party Application Type (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postImageImportationSourceFile(isThirdParty: Bool? = nil, thirdPartyVendor: String? = nil, thirdPartyImageFamily: String? = nil, thirdPartyApplicationType: String? = nil, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postImageImportationSourceFileWithRequestBuilder(isThirdParty: isThirdParty, thirdPartyVendor: thirdPartyVendor, thirdPartyImageFamily: thirdPartyImageFamily, thirdPartyApplicationType: thirdPartyApplicationType).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Import an image from local file system
     - POST /api/v1/image/importation/source/file
     - Imports an image to SWIM image repository from local file system. The image files with extensions bin, img, tar, smu, pie, aes, iso, ova, tar_gz and qcow2 are supported. Set siteUuid as -1 to tag as golden image.

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter isThirdParty: (query) Third party Image check (optional)
     - parameter thirdPartyVendor: (query) Third Party Vendor (optional)
     - parameter thirdPartyImageFamily: (query) Third Party image family (optional)
     - parameter thirdPartyApplicationType: (query) Third Party Application Type (optional)
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func postImageImportationSourceFileWithRequestBuilder(isThirdParty: Bool? = nil, thirdPartyVendor: String? = nil, thirdPartyImageFamily: String? = nil, thirdPartyApplicationType: String? = nil) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/image/importation/source/file"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "isThirdParty": isThirdParty, 
            "thirdPartyVendor": thirdPartyVendor, 
            "thirdPartyImageFamily": thirdPartyImageFamily, 
            "thirdPartyApplicationType": thirdPartyApplicationType
        ])

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Trigger now or schedule import of an image from a URL
     - parameter request: (body) request 
     - parameter scheduleAt: (query) Epoch Time (The number of milli-seconds since January 1 1970 UTC) at which the distribution should be scheduled (Optional)  (optional)
     - parameter scheduleDesc: (query) Custom Description (Optional) (optional)
     - parameter scheduleOrigin: (query) Originator of this call (Optional) (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postImageImportationSourceUrl(request: ImageImportFromUrlDTO, scheduleAt: String? = nil, scheduleDesc: String? = nil, scheduleOrigin: String? = nil, completion: @escaping ((_ data: TaskIdResult?, _ error: ErrorResponse?) -> Void)) {
        postImageImportationSourceUrlWithRequestBuilder(request: request, scheduleAt: scheduleAt, scheduleDesc: scheduleDesc, scheduleOrigin: scheduleOrigin).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Trigger now or schedule import of an image from a URL
     - POST /api/v1/image/importation/source/url
     - Imports an image to SWIM image repository, source is any ftp or http URL. The image files with extensions bin, img, tar, smu, pie, aes, iso, ova, tar_gz and qcow2 are supported. Set siteUuid as -1 to tag as golden image.

     - examples: [{contentType=application/json, example={
  "response" : {
    "taskId" : "{}",
    "url" : "url"
  },
  "version" : "version"
}}]
     - parameter request: (body) request 
     - parameter scheduleAt: (query) Epoch Time (The number of milli-seconds since January 1 1970 UTC) at which the distribution should be scheduled (Optional)  (optional)
     - parameter scheduleDesc: (query) Custom Description (Optional) (optional)
     - parameter scheduleOrigin: (query) Originator of this call (Optional) (optional)
     - returns: RequestBuilder<TaskIdResult> 
     */
    open class func postImageImportationSourceUrlWithRequestBuilder(request: ImageImportFromUrlDTO, scheduleAt: String? = nil, scheduleDesc: String? = nil, scheduleOrigin: String? = nil) -> RequestBuilder<TaskIdResult> {
        let path = "/api/v1/image/importation/source/url"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "scheduleAt": scheduleAt, 
            "scheduleDesc": scheduleDesc, 
            "scheduleOrigin": scheduleOrigin
        ])

        let requestBuilder: RequestBuilder<TaskIdResult>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
