//
// OnboardingAPI.swift
//

//

import Foundation
import Alamofire


open class OnboardingAPI: APIBase {
    /**
     Delete Device
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteOnboardingPnpDeviceById(id: String, completion: @escaping ((_ data: DeleteDeviceResponse?, _ error: ErrorResponse?) -> Void)) {
        deleteOnboardingPnpDeviceByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Delete Device
     - DELETE /api/v1/onboarding/pnp-device/${id}
     - This API is used to delete the specified device from the database.

     - examples: [{contentType=application/json, example={ }}]
     - parameter id: (path) id 
     - returns: RequestBuilder<DeleteDeviceResponse> 
     */
    open class func deleteOnboardingPnpDeviceByIdWithRequestBuilder(id: String) -> RequestBuilder<DeleteDeviceResponse> {
        var path = "/api/v1/onboarding/pnp-device/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeleteDeviceResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Deregister Virtual Account
     - parameter domain: (query) Smart Account Domain 
     - parameter name: (query) Virtual Account Name 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteOnboardingPnpSettingsVacct(domain: String, name: String, completion: @escaping ((_ data: DeregisterVirtualAccountResponse?, _ error: ErrorResponse?) -> Void)) {
        deleteOnboardingPnpSettingsVacctWithRequestBuilder(domain: domain, name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Deregister Virtual Account
     - DELETE /api/v1/onboarding/pnp-settings/vacct
     - This API is used to deregister the specified smart account & virtual account info and the associated device information from the PnP System & database. The devices associated with the deregistered virtual account are removed from the PnP database as well. The deregistered smart & virtual account info is returned in the response.

     - examples: [{contentType=application/json, example={ }}]
     - parameter domain: (query) Smart Account Domain 
     - parameter name: (query) Virtual Account Name 
     - returns: RequestBuilder<DeregisterVirtualAccountResponse> 
     */
    open class func deleteOnboardingPnpSettingsVacctWithRequestBuilder(domain: String, name: String) -> RequestBuilder<DeregisterVirtualAccountResponse> {
        let path = "/api/v1/onboarding/pnp-settings/vacct"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "domain": domain, 
            "name": name
        ])

        let requestBuilder: RequestBuilder<DeregisterVirtualAccountResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Delete Workflow
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteOnboardingPnpWorkflowById(id: String, completion: @escaping ((_ data: DeleteWorkflowResponse?, _ error: ErrorResponse?) -> Void)) {
        deleteOnboardingPnpWorkflowByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Delete Workflow
     - DELETE /api/v1/onboarding/pnp-workflow/${id}
     - Delete a workflow given its id

     - examples: [{contentType=application/json, example={ }}]
     - parameter id: (path) id 
     - returns: RequestBuilder<DeleteWorkflowResponse> 
     */
    open class func deleteOnboardingPnpWorkflowByIdWithRequestBuilder(id: String) -> RequestBuilder<DeleteWorkflowResponse> {
        var path = "/api/v1/onboarding/pnp-workflow/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<DeleteWorkflowResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     List devices
     - parameter limit: (query) Limits number of results (optional)
     - parameter offset: (query) Index of first result (optional)
     - parameter sort: (query) Comma seperated list of fields to sort on (optional)
     - parameter sortOrder: (query) Sort Order Ascending (asc) or Descending (des) (optional)
     - parameter serialNumber: (query) Device Serial Number (optional)
     - parameter state: (query) Device State (optional)
     - parameter onbState: (query) Device Onboarding State (optional)
     - parameter cmState: (query) Device Connection Manager State (optional)
     - parameter name: (query) Device Name (optional)
     - parameter pid: (query) Device ProductId (optional)
     - parameter source: (query) Device Source (optional)
     - parameter projectId: (query) Device Project Id (optional)
     - parameter workflowId: (query) Device Workflow Id (optional)
     - parameter projectName: (query) Device Project Name (optional)
     - parameter workflowName: (query) Device Workflow Name (optional)
     - parameter smartAccountId: (query) Device Smart Account (optional)
     - parameter virtualAccountId: (query) Device Virtual Account (optional)
     - parameter lastContact: (query) Device Has Contacted lastContact &gt; 0 (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpDevice(limit: Int32? = nil, offset: Int32? = nil, sort: [String]? = nil, sortOrder: String? = nil, serialNumber: [String]? = nil, state: [String]? = nil, onbState: [String]? = nil, cmState: [String]? = nil, name: [String]? = nil, pid: [String]? = nil, source: [String]? = nil, projectId: [String]? = nil, workflowId: [String]? = nil, projectName: [String]? = nil, workflowName: [String]? = nil, smartAccountId: [String]? = nil, virtualAccountId: [String]? = nil, lastContact: Bool? = nil, completion: @escaping ((_ data: ListDevicesResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpDeviceWithRequestBuilder(limit: limit, offset: offset, sort: sort, sortOrder: sortOrder, serialNumber: serialNumber, state: state, onbState: onbState, cmState: cmState, name: name, pid: pid, source: source, projectId: projectId, workflowId: workflowId, projectName: projectName, workflowName: workflowName, smartAccountId: smartAccountId, virtualAccountId: virtualAccountId, lastContact: lastContact).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     List devices
     - GET /api/v1/onboarding/pnp-device
     - This API is used to get the list of devices that match the provided filter. Pagination and sorting are also supported. If a limit is not specified, it will default to return 50 devices.

     - examples: [{contentType=application/json, example={ }}]
     - parameter limit: (query) Limits number of results (optional)
     - parameter offset: (query) Index of first result (optional)
     - parameter sort: (query) Comma seperated list of fields to sort on (optional)
     - parameter sortOrder: (query) Sort Order Ascending (asc) or Descending (des) (optional)
     - parameter serialNumber: (query) Device Serial Number (optional)
     - parameter state: (query) Device State (optional)
     - parameter onbState: (query) Device Onboarding State (optional)
     - parameter cmState: (query) Device Connection Manager State (optional)
     - parameter name: (query) Device Name (optional)
     - parameter pid: (query) Device ProductId (optional)
     - parameter source: (query) Device Source (optional)
     - parameter projectId: (query) Device Project Id (optional)
     - parameter workflowId: (query) Device Workflow Id (optional)
     - parameter projectName: (query) Device Project Name (optional)
     - parameter workflowName: (query) Device Workflow Name (optional)
     - parameter smartAccountId: (query) Device Smart Account (optional)
     - parameter virtualAccountId: (query) Device Virtual Account (optional)
     - parameter lastContact: (query) Device Has Contacted lastContact &gt; 0 (optional)
     - returns: RequestBuilder<ListDevicesResponse> 
     */
    open class func getOnboardingPnpDeviceWithRequestBuilder(limit: Int32? = nil, offset: Int32? = nil, sort: [String]? = nil, sortOrder: String? = nil, serialNumber: [String]? = nil, state: [String]? = nil, onbState: [String]? = nil, cmState: [String]? = nil, name: [String]? = nil, pid: [String]? = nil, source: [String]? = nil, projectId: [String]? = nil, workflowId: [String]? = nil, projectName: [String]? = nil, workflowName: [String]? = nil, smartAccountId: [String]? = nil, virtualAccountId: [String]? = nil, lastContact: Bool? = nil) -> RequestBuilder<ListDevicesResponse> {
        let path = "/api/v1/onboarding/pnp-device"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "limit": limit?.encodeToJSON(), 
            "offset": offset?.encodeToJSON(), 
            "sort": sort, 
            "sortOrder": sortOrder, 
            "serialNumber": serialNumber, 
            "state": state, 
            "onbState": onbState, 
            "cmState": cmState, 
            "name": name, 
            "pid": pid, 
            "source": source, 
            "projectId": projectId, 
            "workflowId": workflowId, 
            "projectName": projectName, 
            "workflowName": workflowName, 
            "smartAccountId": smartAccountId, 
            "virtualAccountId": virtualAccountId, 
            "lastContact": lastContact
        ])

        let requestBuilder: RequestBuilder<ListDevicesResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Device by ID
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpDeviceById(id: String, completion: @escaping ((_ data: GetDeviceByIDResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpDeviceByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Device by ID
     - GET /api/v1/onboarding/pnp-device/${id}
     - Get device details of the device with input device id

     - examples: [{contentType=application/json, example={ }}]
     - parameter id: (path) id 
     - returns: RequestBuilder<GetDeviceByIDResponse> 
     */
    open class func getOnboardingPnpDeviceByIdWithRequestBuilder(id: String) -> RequestBuilder<GetDeviceByIDResponse> {
        var path = "/api/v1/onboarding/pnp-device/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetDeviceByIDResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Device Count
     - parameter serialNumber: (query) Device Serial Number (optional)
     - parameter state: (query) Device State (optional)
     - parameter onbState: (query) Device Onboarding State (optional)
     - parameter cmState: (query) Device Connection Manager State (optional)
     - parameter name: (query) Device Name (optional)
     - parameter pid: (query) Device ProductId (optional)
     - parameter source: (query) Device Source (optional)
     - parameter projectId: (query) Device Project Id (optional)
     - parameter workflowId: (query) Device Workflow Id (optional)
     - parameter projectName: (query) Device Project Name (optional)
     - parameter workflowName: (query) Device Workflow Name (optional)
     - parameter smartAccountId: (query) Device Smart Account (optional)
     - parameter virtualAccountId: (query) Device Virtual Account (optional)
     - parameter lastContact: (query) Device Has Contacted lastContact &gt; 0 (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpDeviceCcount(serialNumber: [String]? = nil, state: [String]? = nil, onbState: [String]? = nil, cmState: [String]? = nil, name: [String]? = nil, pid: [String]? = nil, source: [String]? = nil, projectId: [String]? = nil, workflowId: [String]? = nil, projectName: [String]? = nil, workflowName: [String]? = nil, smartAccountId: [String]? = nil, virtualAccountId: [String]? = nil, lastContact: Bool? = nil, completion: @escaping ((_ data: GetDeviceCountResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpDeviceCcountWithRequestBuilder(serialNumber: serialNumber, state: state, onbState: onbState, cmState: cmState, name: name, pid: pid, source: source, projectId: projectId, workflowId: workflowId, projectName: projectName, workflowName: workflowName, smartAccountId: smartAccountId, virtualAccountId: virtualAccountId, lastContact: lastContact).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Device Count
     - GET /api/v1/onboarding/pnp-device/count
     - This API is used to get the number of the devices matching provided filters. This is useful for pageination.

     - examples: [{contentType=application/json, example={ }}]
     - parameter serialNumber: (query) Device Serial Number (optional)
     - parameter state: (query) Device State (optional)
     - parameter onbState: (query) Device Onboarding State (optional)
     - parameter cmState: (query) Device Connection Manager State (optional)
     - parameter name: (query) Device Name (optional)
     - parameter pid: (query) Device ProductId (optional)
     - parameter source: (query) Device Source (optional)
     - parameter projectId: (query) Device Project Id (optional)
     - parameter workflowId: (query) Device Workflow Id (optional)
     - parameter projectName: (query) Device Project Name (optional)
     - parameter workflowName: (query) Device Workflow Name (optional)
     - parameter smartAccountId: (query) Device Smart Account (optional)
     - parameter virtualAccountId: (query) Device Virtual Account (optional)
     - parameter lastContact: (query) Device Has Contacted lastContact &gt; 0 (optional)
     - returns: RequestBuilder<GetDeviceCountResponse> 
     */
    open class func getOnboardingPnpDeviceCcountWithRequestBuilder(serialNumber: [String]? = nil, state: [String]? = nil, onbState: [String]? = nil, cmState: [String]? = nil, name: [String]? = nil, pid: [String]? = nil, source: [String]? = nil, projectId: [String]? = nil, workflowId: [String]? = nil, projectName: [String]? = nil, workflowName: [String]? = nil, smartAccountId: [String]? = nil, virtualAccountId: [String]? = nil, lastContact: Bool? = nil) -> RequestBuilder<GetDeviceCountResponse> {
        let path = "/api/v1/onboarding/pnp-device/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "serialNumber": serialNumber, 
            "state": state, 
            "onbState": onbState, 
            "cmState": cmState, 
            "name": name, 
            "pid": pid, 
            "source": source, 
            "projectId": projectId, 
            "workflowId": workflowId, 
            "projectName": projectName, 
            "workflowName": workflowName, 
            "smartAccountId": smartAccountId, 
            "virtualAccountId": virtualAccountId, 
            "lastContact": lastContact
        ])

        let requestBuilder: RequestBuilder<GetDeviceCountResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Categorized Device Count
     - parameter category: (query) Valid Values: state, errorState, onbState or source 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpDeviceDashboardCount(category: String, completion: @escaping ((_ data: GetCategorizedDeviceCountResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpDeviceDashboardCountWithRequestBuilder(category: category).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Categorized Device Count
     - GET /api/v1/onboarding/pnp-device/dashboard/count
     - Get Categorized Device Count

     - examples: [{contentType=application/json, example={ }}]
     - parameter category: (query) Valid Values: state, errorState, onbState or source 
     - returns: RequestBuilder<GetCategorizedDeviceCountResponse> 
     */
    open class func getOnboardingPnpDeviceDashboardCountWithRequestBuilder(category: String) -> RequestBuilder<GetCategorizedDeviceCountResponse> {
        let path = "/api/v1/onboarding/pnp-device/dashboard/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "category": category
        ])

        let requestBuilder: RequestBuilder<GetCategorizedDeviceCountResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Device History
     - parameter serialNumber: (query) Device Serial Number 
     - parameter sort: (query) Comma seperated list of fields to sort on (optional)
     - parameter sortOrder: (query) Sort Order Ascending (asc) or Descending (des) (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpDeviceHistory(serialNumber: String, sort: [String]? = nil, sortOrder: String? = nil, completion: @escaping ((_ data: GetDeviceHistoryResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpDeviceHistoryWithRequestBuilder(serialNumber: serialNumber, sort: sort, sortOrder: sortOrder).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Device History
     - GET /api/v1/onboarding/pnp-device/history
     - Retrieves history for a specific device. Serial Number is a required parameter

     - examples: [{contentType=application/json, example={ }}]
     - parameter serialNumber: (query) Device Serial Number 
     - parameter sort: (query) Comma seperated list of fields to sort on (optional)
     - parameter sortOrder: (query) Sort Order Ascending (asc) or Descending (des) (optional)
     - returns: RequestBuilder<GetDeviceHistoryResponse> 
     */
    open class func getOnboardingPnpDeviceHistoryWithRequestBuilder(serialNumber: String, sort: [String]? = nil, sortOrder: String? = nil) -> RequestBuilder<GetDeviceHistoryResponse> {
        let path = "/api/v1/onboarding/pnp-device/history"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "serialNumber": serialNumber, 
            "sort": sort, 
            "sortOrder": sortOrder
        ])

        let requestBuilder: RequestBuilder<GetDeviceHistoryResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Sync Result for Virtual Account
     - parameter domain: (path) Smart Account Domain 
     - parameter name: (path) Virtual Account Name 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpDeviceSacctVacctSyncResultByDomainAndName(domain: String, name: String, completion: @escaping ((_ data: GetSyncResultForVirtualAccountResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpDeviceSacctVacctSyncResultByDomainAndNameWithRequestBuilder(domain: domain, name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Sync Result for Virtual Account
     - GET /api/v1/onboarding/pnp-device/sacct/${domain}/vacct/${name}/sync-result
     - This API is used to get the device sync info from the given smart account & virtual account with the PnP database. The SAVAMapping object which has the list of devices synced since the last sync is returned in the response.

     - examples: [{contentType=application/json, example={ }}]
     - parameter domain: (path) Smart Account Domain 
     - parameter name: (path) Virtual Account Name 
     - returns: RequestBuilder<GetSyncResultForVirtualAccountResponse> 
     */
    open class func getOnboardingPnpDeviceSacctVacctSyncResultByDomainAndNameWithRequestBuilder(domain: String, name: String) -> RequestBuilder<GetSyncResultForVirtualAccountResponse> {
        var path = "/api/v1/onboarding/pnp-device/sacct/${domain}/vacct/${name}/sync-result"
        let domainPreEscape = "\(domain)"
        let domainPostEscape = domainPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{domain}", with: domainPostEscape, options: .literal, range: nil)
        let namePreEscape = "\(name)"
        let namePostEscape = namePreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{name}", with: namePostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSyncResultForVirtualAccountResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     View Settings
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpSettings(completion: @escaping ((_ data: ViewSettingsResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpSettingsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     View Settings
     - GET /api/v1/onboarding/pnp-settings
     - Get this user's list of global PnP settings

     - examples: [{contentType=application/json, example={ }}]
     - returns: RequestBuilder<ViewSettingsResponse> 
     */
    open class func getOnboardingPnpSettingsWithRequestBuilder() -> RequestBuilder<ViewSettingsResponse> {
        let path = "/api/v1/onboarding/pnp-settings"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ViewSettingsResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Smart Account List
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpSettingsSacct(completion: @escaping ((_ data: GetSmartAccountListResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpSettingsSacctWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Smart Account List
     - GET /api/v1/onboarding/pnp-settings/sacct
     - This API is used to get list of Smart Accounts. The list of smart account domains is returned in the response.

     - examples: [{contentType=application/json, example={ }}]
     - returns: RequestBuilder<GetSmartAccountListResponse> 
     */
    open class func getOnboardingPnpSettingsSacctWithRequestBuilder() -> RequestBuilder<GetSmartAccountListResponse> {
        let path = "/api/v1/onboarding/pnp-settings/sacct"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSmartAccountListResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Virtual Account List
     - parameter domain: (path) Smart Account Domain 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpSettingsSacctVacctByDomain(domain: String, completion: @escaping ((_ data: GetVirtualAccountListResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpSettingsSacctVacctByDomainWithRequestBuilder(domain: domain).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Virtual Account List
     - GET /api/v1/onboarding/pnp-settings/sacct/${domain}/vacct
     - This API is used to get list of Virtual Accounts associated with the specified Smart Account. The list of virtual account names is returned in the response.

     - examples: [{contentType=application/json, example={ }}]
     - parameter domain: (path) Smart Account Domain 
     - returns: RequestBuilder<GetVirtualAccountListResponse> 
     */
    open class func getOnboardingPnpSettingsSacctVacctByDomainWithRequestBuilder(domain: String) -> RequestBuilder<GetVirtualAccountListResponse> {
        var path = "/api/v1/onboarding/pnp-settings/sacct/${domain}/vacct"
        let domainPreEscape = "\(domain)"
        let domainPostEscape = domainPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{domain}", with: domainPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetVirtualAccountListResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     List Workflows
     - parameter limit: (query) Limits number of results (optional)
     - parameter offset: (query) Index of first result (optional)
     - parameter sort: (query) Comma seperated lost of fields to sort on (optional)
     - parameter sortOrder: (query) Sort Order Ascending (asc) or Descending (des) (optional)
     - parameter type: (query) Workflow Type (optional)
     - parameter name: (query) Workflow Name (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpWorkflow(limit: Int32? = nil, offset: Int32? = nil, sort: [String]? = nil, sortOrder: String? = nil, type: [String]? = nil, name: [String]? = nil, completion: @escaping ((_ data: ListWorkflowsResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpWorkflowWithRequestBuilder(limit: limit, offset: offset, sort: sort, sortOrder: sortOrder, type: type, name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     List Workflows
     - GET /api/v1/onboarding/pnp-workflow
     - This API is used to get the list of workflows that match the provided filter. Pagination and sorting are also supported. If a limit is not specified, it will default to return 50 workflows.

     - examples: [{contentType=application/json, example={ }}]
     - parameter limit: (query) Limits number of results (optional)
     - parameter offset: (query) Index of first result (optional)
     - parameter sort: (query) Comma seperated lost of fields to sort on (optional)
     - parameter sortOrder: (query) Sort Order Ascending (asc) or Descending (des) (optional)
     - parameter type: (query) Workflow Type (optional)
     - parameter name: (query) Workflow Name (optional)
     - returns: RequestBuilder<ListWorkflowsResponse> 
     */
    open class func getOnboardingPnpWorkflowWithRequestBuilder(limit: Int32? = nil, offset: Int32? = nil, sort: [String]? = nil, sortOrder: String? = nil, type: [String]? = nil, name: [String]? = nil) -> RequestBuilder<ListWorkflowsResponse> {
        let path = "/api/v1/onboarding/pnp-workflow"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "limit": limit?.encodeToJSON(), 
            "offset": offset?.encodeToJSON(), 
            "sort": sort, 
            "sortOrder": sortOrder, 
            "type": type, 
            "name": name
        ])

        let requestBuilder: RequestBuilder<ListWorkflowsResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Workflow
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpWorkflowById(id: String, completion: @escaping ((_ data: GetWorkflowResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpWorkflowByIdWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Workflow
     - GET /api/v1/onboarding/pnp-workflow/${id}
     - Get a workflow given its id

     - examples: [{contentType=application/json, example={ }}]
     - parameter id: (path) id 
     - returns: RequestBuilder<GetWorkflowResponse> 
     */
    open class func getOnboardingPnpWorkflowByIdWithRequestBuilder(id: String) -> RequestBuilder<GetWorkflowResponse> {
        var path = "/api/v1/onboarding/pnp-workflow/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetWorkflowResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get Workflow Count
     - parameter name: (query) Workflow Name (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getOnboardingPnpWorkflowCount(name: [String]? = nil, completion: @escaping ((_ data: GetWorkflowCountResponse?, _ error: ErrorResponse?) -> Void)) {
        getOnboardingPnpWorkflowCountWithRequestBuilder(name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get Workflow Count
     - GET /api/v1/onboarding/pnp-workflow/count
     - This API is used to get the number of the workflows.

     - examples: [{contentType=application/json, example={ }}]
     - parameter name: (query) Workflow Name (optional)
     - returns: RequestBuilder<GetWorkflowCountResponse> 
     */
    open class func getOnboardingPnpWorkflowCountWithRequestBuilder(name: [String]? = nil) -> RequestBuilder<GetWorkflowCountResponse> {
        let path = "/api/v1/onboarding/pnp-workflow/count"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "name": name
        ])

        let requestBuilder: RequestBuilder<GetWorkflowCountResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Create Device
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpDevice(request: Device, completion: @escaping ((_ data: CreateDeviceResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpDeviceWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Create Device
     - POST /api/v1/onboarding/pnp-device
     - This API is used to add a Planned device to the PnP database. A Planned device is a device that the customer has bought and/or is planning to manage.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<CreateDeviceResponse> 
     */
    open class func postOnboardingPnpDeviceWithRequestBuilder(request: Device) -> RequestBuilder<CreateDeviceResponse> {
        let path = "/api/v1/onboarding/pnp-device"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CreateDeviceResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Claim Device(s)
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpDeviceClaim(request: ClaimDeviceRequest, completion: @escaping ((_ data: ClaimDevicesResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpDeviceClaimWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Claim Device(s)
     - POST /api/v1/onboarding/pnp-device/claim
     - This API is used to assign a project & workflow (i.e. claim) one of more devices.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<ClaimDevicesResponse> 
     */
    open class func postOnboardingPnpDeviceClaimWithRequestBuilder(request: ClaimDeviceRequest) -> RequestBuilder<ClaimDevicesResponse> {
        let path = "/api/v1/onboarding/pnp-device/claim"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ClaimDevicesResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Import Many Devices
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpDeviceImport(request: Device, completion: @escaping ((_ data: ImportManyDevicesResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpDeviceImportWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Import Many Devices
     - POST /api/v1/onboarding/pnp-device/import
     - This API is used to import a list of Planned devices to the PnP database. A Planned device is a device that the customer has bought and/or is planning to manage.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<ImportManyDevicesResponse> 
     */
    open class func postOnboardingPnpDeviceImportWithRequestBuilder(request: Device) -> RequestBuilder<ImportManyDevicesResponse> {
        let path = "/api/v1/onboarding/pnp-device/import"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ImportManyDevicesResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Provision Device
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpDeviceProvision(request: PushProvisionRequest, completion: @escaping ((_ data: ProvisionDeviceResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpDeviceProvisionWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Provision Device
     - POST /api/v1/onboarding/pnp-device/provision
     - This API is used push one or more devices to Provisoned state and add them to inventory.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<ProvisionDeviceResponse> 
     */
    open class func postOnboardingPnpDeviceProvisionWithRequestBuilder(request: PushProvisionRequest) -> RequestBuilder<ProvisionDeviceResponse> {
        let path = "/api/v1/onboarding/pnp-device/provision"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ProvisionDeviceResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Reset Device
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpDeviceReset(request: ResetRequest, completion: @escaping ((_ data: ResetDeviceResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpDeviceResetWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Reset Device
     - POST /api/v1/onboarding/pnp-device/reset
     - This API is used to recover a device from a Workflow Execution Error state.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<ResetDeviceResponse> 
     */
    open class func postOnboardingPnpDeviceResetWithRequestBuilder(request: ResetRequest) -> RequestBuilder<ResetDeviceResponse> {
        let path = "/api/v1/onboarding/pnp-device/reset"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ResetDeviceResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Un-Claim Device
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpDeviceUnclaim(request: UnclaimRequest, completion: @escaping ((_ data: UnClaimDeviceResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpDeviceUnclaimWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Un-Claim Device
     - POST /api/v1/onboarding/pnp-device/unclaim
     - This API is used to unassign the project and workflow from one or more device.A device can only be unclaimed if it has not begun provisioning.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<UnClaimDeviceResponse> 
     */
    open class func postOnboardingPnpDeviceUnclaimWithRequestBuilder(request: UnclaimRequest) -> RequestBuilder<UnClaimDeviceResponse> {
        let path = "/api/v1/onboarding/pnp-device/unclaim"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UnClaimDeviceResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Sync Virtual Account Devices
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpDeviceVacctSync(request: SAVAMapping, completion: @escaping ((_ data: SyncVirtualAccountDevicesResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpDeviceVacctSyncWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Sync Virtual Account Devices
     - POST /api/v1/onboarding/pnp-device/vacct-sync
     - This API is used to sync the device info from the given smart account & virtual account with the PnP database. The list of synced devices is returned in the response.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<SyncVirtualAccountDevicesResponse> 
     */
    open class func postOnboardingPnpDeviceVacctSyncWithRequestBuilder(request: SAVAMapping) -> RequestBuilder<SyncVirtualAccountDevicesResponse> {
        let path = "/api/v1/onboarding/pnp-device/vacct-sync"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SyncVirtualAccountDevicesResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Add Virtual Account
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpSettingsSavacct(request: SAVAMapping, completion: @escaping ((_ data: AddVirtualAccountResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpSettingsSavacctWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Add Virtual Account
     - POST /api/v1/onboarding/pnp-settings/savacct
     - This API is used to register a Smart Account, Virtual Account and the relevant server profile info with the PnP System & database. The devices present in the registered virtual account are synced with the PnP database as well. The new profile is returned in the response.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<AddVirtualAccountResponse> 
     */
    open class func postOnboardingPnpSettingsSavacctWithRequestBuilder(request: SAVAMapping) -> RequestBuilder<AddVirtualAccountResponse> {
        let path = "/api/v1/onboarding/pnp-settings/savacct"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<AddVirtualAccountResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Create Workflow
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postOnboardingPnpWorkflow(request: Workflow, completion: @escaping ((_ data: CreateWorkflowResponse?, _ error: ErrorResponse?) -> Void)) {
        postOnboardingPnpWorkflowWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Create Workflow
     - POST /api/v1/onboarding/pnp-workflow
     - This API is used to add a PnP Workflow along with the relevant tasks in the workflow into the PnP database.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<CreateWorkflowResponse> 
     */
    open class func postOnboardingPnpWorkflowWithRequestBuilder(request: Workflow) -> RequestBuilder<CreateWorkflowResponse> {
        let path = "/api/v1/onboarding/pnp-workflow"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CreateWorkflowResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update Device
     - parameter request: (body) request 
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putOnboardingPnpDeviceById(request: Device, id: String, completion: @escaping ((_ data: UpdateDeviceResponse?, _ error: ErrorResponse?) -> Void)) {
        putOnboardingPnpDeviceByIdWithRequestBuilder(request: request, id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Update Device
     - PUT /api/v1/onboarding/pnp-device/${id}
     - This API is used to update device details of a device that exists in the PnP database.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - parameter id: (path) id 
     - returns: RequestBuilder<UpdateDeviceResponse> 
     */
    open class func putOnboardingPnpDeviceByIdWithRequestBuilder(request: Device, id: String) -> RequestBuilder<UpdateDeviceResponse> {
        var path = "/api/v1/onboarding/pnp-device/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UpdateDeviceResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update Settings
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putOnboardingPnpSettings(request: Settings, completion: @escaping ((_ data: UpdateSettingsResponse?, _ error: ErrorResponse?) -> Void)) {
        putOnboardingPnpSettingsWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Update Settings
     - PUT /api/v1/onboarding/pnp-settings
     - Change this user's list of global PnP settings

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<UpdateSettingsResponse> 
     */
    open class func putOnboardingPnpSettingsWithRequestBuilder(request: Settings) -> RequestBuilder<UpdateSettingsResponse> {
        let path = "/api/v1/onboarding/pnp-settings"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UpdateSettingsResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Edit PnP Server Profile
     - parameter request: (body) request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putOnboardingPnpSettingsSavacct(request: SAVAMapping, completion: @escaping ((_ data: EditPnPServerProfileResponse?, _ error: ErrorResponse?) -> Void)) {
        putOnboardingPnpSettingsSavacctWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Edit PnP Server Profile
     - PUT /api/v1/onboarding/pnp-settings/savacct
     - This API is used to edit the PnP Server profile in a registered Virtual Account in the PnP database.The edited smart & virtual account info is returned in the response.

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - returns: RequestBuilder<EditPnPServerProfileResponse> 
     */
    open class func putOnboardingPnpSettingsSavacctWithRequestBuilder(request: SAVAMapping) -> RequestBuilder<EditPnPServerProfileResponse> {
        let path = "/api/v1/onboarding/pnp-settings/savacct"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<EditPnPServerProfileResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update Workflow
     - parameter request: (body) request 
     - parameter id: (path) id 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putOnboardingPnpWorkflowById(request: Workflow, id: String, completion: @escaping ((_ data: UpdateWorkflowResponse?, _ error: ErrorResponse?) -> Void)) {
        putOnboardingPnpWorkflowByIdWithRequestBuilder(request: request, id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Update Workflow
     - PUT /api/v1/onboarding/pnp-workflow/${id}
     - Update an existing workflow

     - examples: [{contentType=application/json, example={ }}]
     - parameter request: (body) request 
     - parameter id: (path) id 
     - returns: RequestBuilder<UpdateWorkflowResponse> 
     */
    open class func putOnboardingPnpWorkflowByIdWithRequestBuilder(request: Workflow, id: String) -> RequestBuilder<UpdateWorkflowResponse> {
        var path = "/api/v1/onboarding/pnp-workflow/${id}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = request.encodeToJSON()

        let url = NSURLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UpdateWorkflowResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
