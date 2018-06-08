//
// CreateSSIDRequest.swift
//

//

import Foundation


open class CreateSSIDRequest: JSONEncodable {

    public enum AuthenticationType: String { 
        case wpa2Enterprise = "wpa2_enterprise"
        case wpa2Personal = "wpa2_personal"
        case open = "open"
    }
    public enum TrafficType: String { 
        case voicedata = "voicedata"
        case data = "data"
    }
    public enum RadioPolicy: String { 
        case _0 = "0"
        case _1 = "1"
    }
    public enum FastTransition: String { 
        case adaptive = "ADAPTIVE"
        case enable = "ENABLE"
        case disable = "DISABLE"
    }
    public enum RfProfile: String { 
        case low = "LOW"
        case typical = "TYPICAL"
        case high = "HIGH"
    }
    public var interfaceName: String?
    public var vlanId: Double?
    public var ssidName: String?
    public var wlanType: String?
    public var authenticationType: AuthenticationType?
    public var authenticationServer: String?
    public var passpharse: String?
    public var trafficType: TrafficType?
    public var radioPolicy: RadioPolicy?
    public var fastTransition: FastTransition?
    public var enableFastlane: Bool?
    public var enableMACFilering: Bool?
    public var enableBroadcastSSID: Bool?
    public var enableWLANBandSelection: Bool?
    public var wirelessNetworkProfileName: String?
    public var sitesNameHierarchyToMapTheProfile: String?
    public var deviceName: String?
    public var siteNameHierarchyToMapDevicePhysicalLocation: String?
    public var managedAPLocations: String?
    public var interfaceIPAddress: String?
    public var interfaceNetMaskInCIDRFormat: String?
    public var interfaceGatewayIPAddress: String?
    public var interfaceLAGPortNumber: Double?
    public var siteNameHierarchyToMapAPPhysicalLocation: String?
    public var apNames: String?
    public var rfProfile: RfProfile?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["interfaceName"] = self.interfaceName
        nillableDictionary["vlanId"] = self.vlanId
        nillableDictionary["ssidName"] = self.ssidName
        nillableDictionary["wlanType"] = self.wlanType
        nillableDictionary["authenticationType"] = self.authenticationType?.rawValue
        nillableDictionary["authenticationServer"] = self.authenticationServer
        nillableDictionary["passpharse"] = self.passpharse
        nillableDictionary["trafficType"] = self.trafficType?.rawValue
        nillableDictionary["radioPolicy"] = self.radioPolicy?.rawValue
        nillableDictionary["fastTransition"] = self.fastTransition?.rawValue
        nillableDictionary["enableFastlane"] = self.enableFastlane
        nillableDictionary["enableMACFilering"] = self.enableMACFilering
        nillableDictionary["enableBroadcastSSID"] = self.enableBroadcastSSID
        nillableDictionary["enableWLANBandSelection"] = self.enableWLANBandSelection
        nillableDictionary["wirelessNetworkProfileName"] = self.wirelessNetworkProfileName
        nillableDictionary["sitesNameHierarchyToMapTheProfile"] = self.sitesNameHierarchyToMapTheProfile
        nillableDictionary["deviceName"] = self.deviceName
        nillableDictionary["siteNameHierarchyToMapDevicePhysicalLocation"] = self.siteNameHierarchyToMapDevicePhysicalLocation
        nillableDictionary["managedAPLocations"] = self.managedAPLocations
        nillableDictionary["interfaceIPAddress"] = self.interfaceIPAddress
        nillableDictionary["interfaceNetMaskInCIDRFormat"] = self.interfaceNetMaskInCIDRFormat
        nillableDictionary["interfaceGatewayIPAddress"] = self.interfaceGatewayIPAddress
        nillableDictionary["interfaceLAGPortNumber"] = self.interfaceLAGPortNumber
        nillableDictionary["siteNameHierarchyToMapAPPhysicalLocation"] = self.siteNameHierarchyToMapAPPhysicalLocation
        nillableDictionary["apNames"] = self.apNames
        nillableDictionary["rfProfile"] = self.rfProfile?.rawValue

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}

