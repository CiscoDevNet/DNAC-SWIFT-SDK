//
// SiteHierarchyResponseResponse.swift
//

//

import Foundation


open class SiteHierarchyResponseResponse: JSONEncodable {

    public var siteName: String?
    public var siteId: String?
    public var parentSiteId: String?
    public var parentSiteName: String?
    public var siteType: String?
    public var healthyNetworkDevicePercentage: String?
    public var healthyClientsPercentage: String?
    public var clientHealthWired: String?
    public var clientHealthWireless: String?
    public var numberOfClients: String?
    public var clientNumberOfIssues: String?
    public var networkNumberOfIssues: String?
    public var numberOfNetworkDevice: String?
    public var networkHealthAverage: String?
    public var networkHealthAccess: String?
    public var networkHealthCore: String?
    public var networkHealthDistribution: String?
    public var networkHealthRouter: String?
    public var networkHealthWireless: String?
    public var networkHealthOthers: String?
    public var numberOfWiredClients: String?
    public var numberOfWirelessClients: String?
    public var wiredGoodClients: String?
    public var wirelessGoodClients: String?
    public var clientIssueCount: String?
    public var overallGoodDevices: String?
    public var accessGoodCount: String?
    public var accessTotalCount: String?
    public var coreGoodCount: String?
    public var coreTotalCount: String?
    public var distributionGoodCount: String?
    public var distributionTotalCount: String?
    public var routerGoodCount: String?
    public var routerTotalCount: String?
    public var wirelessDeviceGoodCount: String?
    public var wirelessDeviceTotalCount: String?
    public var applicationHealth: String?
    public var applicationGoodCount: String?
    public var applicationTotalCount: String?
    public var applicationBytesTotalCount: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["siteName"] = self.siteName
        nillableDictionary["siteId"] = self.siteId
        nillableDictionary["parentSiteId"] = self.parentSiteId
        nillableDictionary["parentSiteName"] = self.parentSiteName
        nillableDictionary["siteType"] = self.siteType
        nillableDictionary["healthyNetworkDevicePercentage"] = self.healthyNetworkDevicePercentage
        nillableDictionary["healthyClientsPercentage"] = self.healthyClientsPercentage
        nillableDictionary["clientHealthWired"] = self.clientHealthWired
        nillableDictionary["clientHealthWireless"] = self.clientHealthWireless
        nillableDictionary["numberOfClients"] = self.numberOfClients
        nillableDictionary["clientNumberOfIssues"] = self.clientNumberOfIssues
        nillableDictionary["networkNumberOfIssues"] = self.networkNumberOfIssues
        nillableDictionary["numberOfNetworkDevice"] = self.numberOfNetworkDevice
        nillableDictionary["networkHealthAverage"] = self.networkHealthAverage
        nillableDictionary["networkHealthAccess"] = self.networkHealthAccess
        nillableDictionary["networkHealthCore"] = self.networkHealthCore
        nillableDictionary["networkHealthDistribution"] = self.networkHealthDistribution
        nillableDictionary["networkHealthRouter"] = self.networkHealthRouter
        nillableDictionary["networkHealthWireless"] = self.networkHealthWireless
        nillableDictionary["networkHealthOthers"] = self.networkHealthOthers
        nillableDictionary["numberOfWiredClients"] = self.numberOfWiredClients
        nillableDictionary["numberOfWirelessClients"] = self.numberOfWirelessClients
        nillableDictionary["wiredGoodClients"] = self.wiredGoodClients
        nillableDictionary["wirelessGoodClients"] = self.wirelessGoodClients
        nillableDictionary["clientIssueCount"] = self.clientIssueCount
        nillableDictionary["overallGoodDevices"] = self.overallGoodDevices
        nillableDictionary["accessGoodCount"] = self.accessGoodCount
        nillableDictionary["accessTotalCount"] = self.accessTotalCount
        nillableDictionary["coreGoodCount"] = self.coreGoodCount
        nillableDictionary["coreTotalCount"] = self.coreTotalCount
        nillableDictionary["distributionGoodCount"] = self.distributionGoodCount
        nillableDictionary["distributionTotalCount"] = self.distributionTotalCount
        nillableDictionary["routerGoodCount"] = self.routerGoodCount
        nillableDictionary["routerTotalCount"] = self.routerTotalCount
        nillableDictionary["wirelessDeviceGoodCount"] = self.wirelessDeviceGoodCount
        nillableDictionary["wirelessDeviceTotalCount"] = self.wirelessDeviceTotalCount
        nillableDictionary["applicationHealth"] = self.applicationHealth
        nillableDictionary["applicationGoodCount"] = self.applicationGoodCount
        nillableDictionary["applicationTotalCount"] = self.applicationTotalCount
        nillableDictionary["applicationBytesTotalCount"] = self.applicationBytesTotalCount

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

