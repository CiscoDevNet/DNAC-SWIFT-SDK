// Models.swift
//

//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case HttpError(statusCode: Int, data: Data?, error: Error)
    case DecodeError(response: Data?, decodsseError: DecodeError)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for case let (key, value) as (String, String) in rawHeader {
            header[key] = value
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

public enum Decoded<ValueType> {
    case success(ValueType)
    case failure(DecodeError)
}

public extension Decoded {
    var value: ValueType? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }
}

public enum DecodeError {
    case typeMismatch(expected: String, actual: String)
    case missingKey(key: String)
    case parseError(message: String)
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject, AnyObject?) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject, AnyObject?) -> Decoded<T>)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0, $1) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> Decoded<T> {
        let key = discriminator
        if let decoder = decoders[key], let value = decoder(source, nil) as? Decoded<T> {
            return value
        } else {
            return .failure(.typeMismatch(expected: String(describing: clazz), actual: String(describing: source)))
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> Decoded<[T]> {
        if let sourceArray = source as? [AnyObject] {
            var values = [T]()
            for sourceValue in sourceArray {
                switch Decoders.decode(clazz: T.self, source: sourceValue, instance: nil) {
                case let .success(value):
                    values.append(value)
                case let .failure(error):
                    return .failure(error)
                }
            }
            return .success(values)
        } else {
            return .failure(.typeMismatch(expected: String(describing: clazz), actual: String(describing: source)))
        }
    }

    static func decode<T>(clazz: T.Type, source: AnyObject) -> Decoded<T> {
        switch Decoders.decode(clazz: T.self, source: source, instance: nil) {
    	    case let .success(value):
                return .success(value)
            case let .failure(error):
                return .failure(error)
        }
    }

    static open func decode<T: RawRepresentable>(clazz: T.Type, source: AnyObject) -> Decoded<T> {
        if let value = source as? T.RawValue {
            if let enumValue = T.init(rawValue: value) {
                return .success(enumValue)
            } else {
                return .failure(.typeMismatch(expected: "A value from the enumeration \(T.self)", actual: "\(value)"))
            }
        } else {
            return .failure(.typeMismatch(expected: "\(T.RawValue.self) matching a case from the enumeration \(T.self)", actual: String(describing: type(of: source))))
        }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> Decoded<[Key:T]> {
        if let sourceDictionary = source as? [Key: AnyObject] {
            var dictionary = [Key:T]()
            for (key, value) in sourceDictionary {
                switch Decoders.decode(clazz: T.self, source: value, instance: nil) {
                case let .success(value):
                    dictionary[key] = value
                case let .failure(error):
                    return .failure(error)
                }
            }
            return .success(dictionary)
        } else {
            return .failure(.typeMismatch(expected: String(describing: clazz), actual: String(describing: source)))
        }
    }

    static func decodeOptional<T: RawRepresentable>(clazz: T.Type, source: AnyObject?) -> Decoded<T?> {
        guard !(source is NSNull), source != nil else { return .success(nil) }
        if let value = source as? T.RawValue {
            if let enumValue = T.init(rawValue: value) {
                return .success(enumValue)
            } else {
                return .failure(.typeMismatch(expected: "A value from the enumeration \(T.self)", actual: "\(value)"))
            }
        } else {
            return .failure(.typeMismatch(expected: "\(T.RawValue.self) matching a case from the enumeration \(T.self)", actual: String(describing: type(of: source))))
        }
    }

    static func decode<T>(clazz: T.Type, source: AnyObject, instance: AnyObject?) -> Decoded<T> {
        initialize()
        if let sourceNumber = source as? NSNumber, let value = sourceNumber.int32Value as? T, T.self is Int32.Type {
            return .success(value)
        }
        if let sourceNumber = source as? NSNumber, let value = sourceNumber.int32Value as? T, T.self is Int64.Type {
     	    return .success(value)
        }
        if let intermediate = source as? String, let value = UUID(uuidString: intermediate) as? T, source is String, T.self is UUID.Type {
            return .success(value)
        }
        if let value = source as? T {
            return .success(value)
        }
        if let intermediate = source as? String, let value = Data(base64Encoded: intermediate) as? T {
            return .success(value)
        }

        let key = "\(T.self)"
        if let decoder = decoders[key], let value = decoder(source, instance) as? Decoded<T> {
           return value
        } else {
            return .failure(.typeMismatch(expected: String(describing: clazz), actual: String(describing: source)))
        }
    }

    //Convert a Decoded so that its value is optional. DO WE STILL NEED THIS?
    static func toOptional<T>(decoded: Decoded<T>) -> Decoded<T?> {
        return .success(decoded.value)
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> Decoded<T?> {
        if let source = source, !(source is NSNull) {
            switch Decoders.decode(clazz: clazz, source: source, instance: nil) {
            case let .success(value): return .success(value)
            case let .failure(error): return .failure(error)
            }
        } else {
            return .success(nil)
        }
    }
    
    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> Decoded<[T]?> where T: RawRepresentable {
        if let source = source as? [AnyObject] {
            var values = [T]()
            for sourceValue in source {
                switch Decoders.decodeOptional(clazz: T.self, source: sourceValue) {
                case let .success(value): if let value = value { values.append(value) }
                case let .failure(error): return .failure(error)
                }
            }
            return .success(values)
        } else {
            return .success(nil)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> Decoded<[T]?> {
        if let source = source as? [AnyObject] {
            var values = [T]()
            for sourceValue in source {
                switch Decoders.decode(clazz: T.self, source: sourceValue, instance: nil) {
                case let .success(value): values.append(value)
                case let .failure(error): return .failure(error)
                }
            }
            return .success(values)
        } else {
            return .success(nil)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> Decoded<[Key:T]?> {
        if let sourceDictionary = source as? [Key: AnyObject] {
            var dictionary = [Key:T]()
            for (key, value) in sourceDictionary {
                switch Decoders.decode(clazz: T.self, source: value, instance: nil) {
                case let .success(value): dictionary[key] = value
                case let .failure(error): return .failure(error)
                }
            }
            return .success(dictionary)
        } else {
            return .success(nil)
        }
    }

    static func decodeOptional<T: RawRepresentable, U: AnyObject>(clazz: T, source: AnyObject) -> Decoded<T?> where T.RawValue == U {
        if let value = source as? U {
            if let enumValue = T.init(rawValue: value) {
                return .success(enumValue)
            } else {
                return .failure(.typeMismatch(expected: "A value from the enumeration \(T.self)", actual: "\(value)"))
            }
        } else {
            return .failure(.typeMismatch(expected: "String", actual: String(describing: type(of: source))))
        }
    }


    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<Date> in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return .success(date)
                    }
                }
            }
            if let sourceInt = source as? Int {
                // treat as a java date
                return .success(Date(timeIntervalSince1970: Double(sourceInt / 1000) ))
            }
            if source is String || source is Int {
                return .failure(.parseError(message: "Could not decode date"))
            } else {
                return .failure(.typeMismatch(expected: "String or Int", actual: "\(source)"))
            }
        }

        // Decoder for ISOFullDate
        Decoders.addDecoder(clazz: ISOFullDate.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ISOFullDate> in
            if let string = source as? String,
               let isoDate = ISOFullDate.from(string: string) {
                return .success(isoDate)
            } else {
            	return .failure(.typeMismatch(expected: "ISO date", actual: "\(source)"))
            }
        }

        // Decoder for [ActivateDTOInner]
        Decoders.addDecoder(clazz: [ActivateDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ActivateDTOInner]> in
            return Decoders.decode(clazz: [ActivateDTOInner].self, source: source)
        }

        // Decoder for ActivateDTOInner
        Decoders.addDecoder(clazz: ActivateDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ActivateDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ActivateDTOInner() : instance as! ActivateDTOInner
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["activateLowerImageVersion"] as AnyObject?) {
                
                case let .success(value): _result.activateLowerImageVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceUpgradeMode"] as AnyObject?) {
                
                case let .success(value): _result.deviceUpgradeMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceUuid"] as AnyObject?) {
                
                case let .success(value): _result.deviceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["distributeIfNeeded"] as AnyObject?) {
                
                case let .success(value): _result.distributeIfNeeded = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["imageUuidList"] as AnyObject?) {
                
                case let .success(value): _result.imageUuidList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["smuImageUuidList"] as AnyObject?) {
                
                case let .success(value): _result.smuImageUuidList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ActivateDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [AddVirtualAccountResponse]
        Decoders.addDecoder(clazz: [AddVirtualAccountResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[AddVirtualAccountResponse]> in
            return Decoders.decode(clazz: [AddVirtualAccountResponse].self, source: source)
        }

        // Decoder for AddVirtualAccountResponse
        Decoders.addDecoder(clazz: AddVirtualAccountResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<AddVirtualAccountResponse> in
            if let source = source as? AddVirtualAccountResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias AddVirtualAccountResponse", actual: "\(source)"))
            }
        }
        // Decoder for [CLICredentialDTOInner]
        Decoders.addDecoder(clazz: [CLICredentialDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CLICredentialDTOInner]> in
            return Decoders.decode(clazz: [CLICredentialDTOInner].self, source: source)
        }

        // Decoder for CLICredentialDTOInner
        Decoders.addDecoder(clazz: CLICredentialDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CLICredentialDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? CLICredentialDTOInner() : instance as! CLICredentialDTOInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: CLICredentialDTOInner.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["enablePassword"] as AnyObject?) {
                
                case let .success(value): _result.enablePassword = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?) {
                
                case let .success(value): _result.password = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?) {
                
                case let .success(value): _result.username = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "CLICredentialDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [ClaimDeviceRequest]
        Decoders.addDecoder(clazz: [ClaimDeviceRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClaimDeviceRequest]> in
            return Decoders.decode(clazz: [ClaimDeviceRequest].self, source: source)
        }

        // Decoder for ClaimDeviceRequest
        Decoders.addDecoder(clazz: ClaimDeviceRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClaimDeviceRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClaimDeviceRequest() : instance as! ClaimDeviceRequest
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["configFileUrl"] as AnyObject?) {
                
                case let .success(value): _result.configFileUrl = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["configId"] as AnyObject?) {
                
                case let .success(value): _result.configId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [ResetRequestDeviceResetList].self, source: sourceDictionary["deviceClaimList"] as AnyObject?) {
                
                case let .success(value): _result.deviceClaimList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["fileServiceId"] as AnyObject?) {
                
                case let .success(value): _result.fileServiceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageId"] as AnyObject?) {
                
                case let .success(value): _result.imageId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageUrl"] as AnyObject?) {
                
                case let .success(value): _result.imageUrl = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["projectId"] as AnyObject?) {
                
                case let .success(value): _result.projectId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["workflowId"] as AnyObject?) {
                
                case let .success(value): _result.workflowId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClaimDeviceRequest", actual: "\(source)"))
            }
        }
        // Decoder for [ClaimDevicesResponse]
        Decoders.addDecoder(clazz: [ClaimDevicesResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClaimDevicesResponse]> in
            return Decoders.decode(clazz: [ClaimDevicesResponse].self, source: source)
        }

        // Decoder for ClaimDevicesResponse
        Decoders.addDecoder(clazz: ClaimDevicesResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClaimDevicesResponse> in
            if let source = source as? ClaimDevicesResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias ClaimDevicesResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponse]
        Decoders.addDecoder(clazz: [ClientDetailResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponse]> in
            return Decoders.decode(clazz: [ClientDetailResponse].self, source: source)
        }

        // Decoder for ClientDetailResponse
        Decoders.addDecoder(clazz: ClientDetailResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponse() : instance as! ClientDetailResponse
                switch Decoders.decodeOptional(clazz: ClientDetailResponseResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponse]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponse]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponse].self, source: source)
        }

        // Decoder for ClientDetailResponseResponse
        Decoders.addDecoder(clazz: ClientDetailResponseResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponse() : instance as! ClientDetailResponseResponse
                switch Decoders.decodeOptional(clazz: ClientDetailResponseResponseDetail.self, source: sourceDictionary["detail"] as AnyObject?) {
                
                case let .success(value): _result.detail = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: ClientDetailResponseResponseConnectionInfo.self, source: sourceDictionary["connectionInfo"] as AnyObject?) {
                
                case let .success(value): _result.connectionInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: ClientDetailResponseResponseTopology.self, source: sourceDictionary["topology"] as AnyObject?) {
                
                case let .success(value): _result.topology = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponseConnectionInfo]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponseConnectionInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponseConnectionInfo]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponseConnectionInfo].self, source: source)
        }

        // Decoder for ClientDetailResponseResponseConnectionInfo
        Decoders.addDecoder(clazz: ClientDetailResponseResponseConnectionInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponseConnectionInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponseConnectionInfo() : instance as! ClientDetailResponseResponseConnectionInfo
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostType"] as AnyObject?) {
                
                case let .success(value): _result.hostType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nwDeviceName"] as AnyObject?) {
                
                case let .success(value): _result.nwDeviceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nwDeviceMac"] as AnyObject?) {
                
                case let .success(value): _result.nwDeviceMac = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocol"] as AnyObject?) {
                
                case let .success(value): _result._protocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["band"] as AnyObject?) {
                
                case let .success(value): _result.band = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["spatialStream"] as AnyObject?) {
                
                case let .success(value): _result.spatialStream = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["channel"] as AnyObject?) {
                
                case let .success(value): _result.channel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["channelWidth"] as AnyObject?) {
                
                case let .success(value): _result.channelWidth = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wmm"] as AnyObject?) {
                
                case let .success(value): _result.wmm = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["uapsd"] as AnyObject?) {
                
                case let .success(value): _result.uapsd = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["timestamp"] as AnyObject?) {
                
                case let .success(value): _result.timestamp = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponseConnectionInfo", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponseDetail]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponseDetail].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponseDetail]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponseDetail].self, source: source)
        }

        // Decoder for ClientDetailResponseResponseDetail
        Decoders.addDecoder(clazz: ClientDetailResponseResponseDetail.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponseDetail> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponseDetail() : instance as! ClientDetailResponseResponseDetail
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["connectionStatus"] as AnyObject?) {
                
                case let .success(value): _result.connectionStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostType"] as AnyObject?) {
                
                case let .success(value): _result.hostType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userId"] as AnyObject?) {
                
                case let .success(value): _result.userId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostName"] as AnyObject?) {
                
                case let .success(value): _result.hostName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostOs"] as AnyObject?) {
                
                case let .success(value): _result.hostOs = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostVersion"] as AnyObject?) {
                
                case let .success(value): _result.hostVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["subType"] as AnyObject?) {
                
                case let .success(value): _result.subType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdated"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdated = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [ClientDetailResponseResponseDetailHealthScore].self, source: sourceDictionary["healthScore"] as AnyObject?) {
                
                case let .success(value): _result.healthScore = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostMac"] as AnyObject?) {
                
                case let .success(value): _result.hostMac = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostIpV4"] as AnyObject?) {
                
                case let .success(value): _result.hostIpV4 = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["hostIpV6"] as AnyObject?) {
                
                case let .success(value): _result.hostIpV6 = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["authType"] as AnyObject?) {
                
                case let .success(value): _result.authType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vlanId"] as AnyObject?) {
                
                case let .success(value): _result.vlanId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ssid"] as AnyObject?) {
                
                case let .success(value): _result.ssid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["frequency"] as AnyObject?) {
                
                case let .success(value): _result.frequency = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["channel"] as AnyObject?) {
                
                case let .success(value): _result.channel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["apGroup"] as AnyObject?) {
                
                case let .success(value): _result.apGroup = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["location"] as AnyObject?) {
                
                case let .success(value): _result.location = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clientConnection"] as AnyObject?) {
                
                case let .success(value): _result.clientConnection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["connectedDevice"] as AnyObject?) {
                
                case let .success(value): _result.connectedDevice = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["issueCount"] as AnyObject?) {
                
                case let .success(value): _result.issueCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["rssi"] as AnyObject?) {
                
                case let .success(value): _result.rssi = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["avgRssi"] as AnyObject?) {
                
                case let .success(value): _result.avgRssi = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snr"] as AnyObject?) {
                
                case let .success(value): _result.snr = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["avgSnr"] as AnyObject?) {
                
                case let .success(value): _result.avgSnr = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dataRate"] as AnyObject?) {
                
                case let .success(value): _result.dataRate = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["txBytes"] as AnyObject?) {
                
                case let .success(value): _result.txBytes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["rxBytes"] as AnyObject?) {
                
                case let .success(value): _result.rxBytes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dnsSuccess"] as AnyObject?) {
                
                case let .success(value): _result.dnsSuccess = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dnsFailure"] as AnyObject?) {
                
                case let .success(value): _result.dnsFailure = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: ClientDetailResponseResponseDetailOnboarding.self, source: sourceDictionary["onboarding"] as AnyObject?) {
                
                case let .success(value): _result.onboarding = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["onboardingTime"] as AnyObject?) {
                
                case let .success(value): _result.onboardingTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["port"] as AnyObject?) {
                
                case let .success(value): _result.port = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponseDetail", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponseDetailHealthScore]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponseDetailHealthScore].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponseDetailHealthScore]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponseDetailHealthScore].self, source: source)
        }

        // Decoder for ClientDetailResponseResponseDetailHealthScore
        Decoders.addDecoder(clazz: ClientDetailResponseResponseDetailHealthScore.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponseDetailHealthScore> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponseDetailHealthScore() : instance as! ClientDetailResponseResponseDetailHealthScore
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["healthType"] as AnyObject?) {
                
                case let .success(value): _result.healthType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["reason"] as AnyObject?) {
                
                case let .success(value): _result.reason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["score"] as AnyObject?) {
                
                case let .success(value): _result.score = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponseDetailHealthScore", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponseDetailOnboarding]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponseDetailOnboarding].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponseDetailOnboarding]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponseDetailOnboarding].self, source: source)
        }

        // Decoder for ClientDetailResponseResponseDetailOnboarding
        Decoders.addDecoder(clazz: ClientDetailResponseResponseDetailOnboarding.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponseDetailOnboarding> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponseDetailOnboarding() : instance as! ClientDetailResponseResponseDetailOnboarding
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["averageRunDuration"] as AnyObject?) {
                
                case let .success(value): _result.averageRunDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["maxRunDuration"] as AnyObject?) {
                
                case let .success(value): _result.maxRunDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["averageAssocDuration"] as AnyObject?) {
                
                case let .success(value): _result.averageAssocDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["maxAssocDuration"] as AnyObject?) {
                
                case let .success(value): _result.maxAssocDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["averageAuthDuration"] as AnyObject?) {
                
                case let .success(value): _result.averageAuthDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["maxAuthDuration"] as AnyObject?) {
                
                case let .success(value): _result.maxAuthDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["averageDhcpDuration"] as AnyObject?) {
                
                case let .success(value): _result.averageDhcpDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["maxDhcpDuration"] as AnyObject?) {
                
                case let .success(value): _result.maxDhcpDuration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["aaaServerIp"] as AnyObject?) {
                
                case let .success(value): _result.aaaServerIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dhcpServerIp"] as AnyObject?) {
                
                case let .success(value): _result.dhcpServerIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["authDoneTime"] as AnyObject?) {
                
                case let .success(value): _result.authDoneTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["assocDoneTime"] as AnyObject?) {
                
                case let .success(value): _result.assocDoneTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dhcpDoneTime"] as AnyObject?) {
                
                case let .success(value): _result.dhcpDoneTime = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponseDetailOnboarding", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponseTopology]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponseTopology].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponseTopology]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponseTopology].self, source: source)
        }

        // Decoder for ClientDetailResponseResponseTopology
        Decoders.addDecoder(clazz: ClientDetailResponseResponseTopology.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponseTopology> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponseTopology() : instance as! ClientDetailResponseResponseTopology
                switch Decoders.decodeOptional(clazz: [ClientDetailResponseResponseTopologyNodes].self, source: sourceDictionary["nodes"] as AnyObject?) {
                
                case let .success(value): _result.nodes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [ClientDetailResponseResponseTopologyLinks].self, source: sourceDictionary["links"] as AnyObject?) {
                
                case let .success(value): _result.links = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponseTopology", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponseTopologyLinks]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponseTopologyLinks].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponseTopologyLinks]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponseTopologyLinks].self, source: source)
        }

        // Decoder for ClientDetailResponseResponseTopologyLinks
        Decoders.addDecoder(clazz: ClientDetailResponseResponseTopologyLinks.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponseTopologyLinks> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponseTopologyLinks() : instance as! ClientDetailResponseResponseTopologyLinks
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["source"] as AnyObject?) {
                
                case let .success(value): _result.source = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["linkStatus"] as AnyObject?) {
                
                case let .success(value): _result.linkStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["label"] as AnyObject?) {
                
                case let .success(value): _result.label = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["target"] as AnyObject?) {
                
                case let .success(value): _result.target = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["portUtilization"] as AnyObject?) {
                
                case let .success(value): _result.portUtilization = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponseTopologyLinks", actual: "\(source)"))
            }
        }
        // Decoder for [ClientDetailResponseResponseTopologyNodes]
        Decoders.addDecoder(clazz: [ClientDetailResponseResponseTopologyNodes].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientDetailResponseResponseTopologyNodes]> in
            return Decoders.decode(clazz: [ClientDetailResponseResponseTopologyNodes].self, source: source)
        }

        // Decoder for ClientDetailResponseResponseTopologyNodes
        Decoders.addDecoder(clazz: ClientDetailResponseResponseTopologyNodes.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientDetailResponseResponseTopologyNodes> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientDetailResponseResponseTopologyNodes() : instance as! ClientDetailResponseResponseTopologyNodes
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceType"] as AnyObject?) {
                
                case let .success(value): _result.deviceType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["platformId"] as AnyObject?) {
                
                case let .success(value): _result.platformId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["family"] as AnyObject?) {
                
                case let .success(value): _result.family = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ip"] as AnyObject?) {
                
                case let .success(value): _result.ip = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.softwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userId"] as AnyObject?) {
                
                case let .success(value): _result.userId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nodeType"] as AnyObject?) {
                
                case let .success(value): _result.nodeType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["radioFrequency"] as AnyObject?) {
                
                case let .success(value): _result.radioFrequency = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clients"] as AnyObject?) {
                
                case let .success(value): _result.clients = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["count"] as AnyObject?) {
                
                case let .success(value): _result.count = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["healthScore"] as AnyObject?) {
                
                case let .success(value): _result.healthScore = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["level"] as AnyObject?) {
                
                case let .success(value): _result.level = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["fabricGroup"] as AnyObject?) {
                
                case let .success(value): _result.fabricGroup = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["connectedDevice"] as AnyObject?) {
                
                case let .success(value): _result.connectedDevice = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientDetailResponseResponseTopologyNodes", actual: "\(source)"))
            }
        }
        // Decoder for [ClientHealthResponse]
        Decoders.addDecoder(clazz: [ClientHealthResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientHealthResponse]> in
            return Decoders.decode(clazz: [ClientHealthResponse].self, source: source)
        }

        // Decoder for ClientHealthResponse
        Decoders.addDecoder(clazz: ClientHealthResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientHealthResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientHealthResponse() : instance as! ClientHealthResponse
                switch Decoders.decodeOptional(clazz: [ClientHealthResponseResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientHealthResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ClientHealthResponseResponse]
        Decoders.addDecoder(clazz: [ClientHealthResponseResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientHealthResponseResponse]> in
            return Decoders.decode(clazz: [ClientHealthResponseResponse].self, source: source)
        }

        // Decoder for ClientHealthResponseResponse
        Decoders.addDecoder(clazz: ClientHealthResponseResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientHealthResponseResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientHealthResponseResponse() : instance as! ClientHealthResponseResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["siteId"] as AnyObject?) {
                
                case let .success(value): _result.siteId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [ClientHealthResponseScoreDetail].self, source: sourceDictionary["scoreDetail"] as AnyObject?) {
                
                case let .success(value): _result.scoreDetail = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientHealthResponseResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ClientHealthResponseScoreCategory]
        Decoders.addDecoder(clazz: [ClientHealthResponseScoreCategory].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientHealthResponseScoreCategory]> in
            return Decoders.decode(clazz: [ClientHealthResponseScoreCategory].self, source: source)
        }

        // Decoder for ClientHealthResponseScoreCategory
        Decoders.addDecoder(clazz: ClientHealthResponseScoreCategory.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientHealthResponseScoreCategory> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientHealthResponseScoreCategory() : instance as! ClientHealthResponseScoreCategory
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["scoreCategory"] as AnyObject?) {
                
                case let .success(value): _result.scoreCategory = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["value"] as AnyObject?) {
                
                case let .success(value): _result.value = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientHealthResponseScoreCategory", actual: "\(source)"))
            }
        }
        // Decoder for [ClientHealthResponseScoreDetail]
        Decoders.addDecoder(clazz: [ClientHealthResponseScoreDetail].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ClientHealthResponseScoreDetail]> in
            return Decoders.decode(clazz: [ClientHealthResponseScoreDetail].self, source: source)
        }

        // Decoder for ClientHealthResponseScoreDetail
        Decoders.addDecoder(clazz: ClientHealthResponseScoreDetail.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ClientHealthResponseScoreDetail> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ClientHealthResponseScoreDetail() : instance as! ClientHealthResponseScoreDetail
                switch Decoders.decodeOptional(clazz: ClientHealthResponseScoreCategory.self, source: sourceDictionary["scoreCategory"] as AnyObject?) {
                
                case let .success(value): _result.scoreCategory = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["scoreValue"] as AnyObject?) {
                
                case let .success(value): _result.scoreValue = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clientCount"] as AnyObject?) {
                
                case let .success(value): _result.clientCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clientUniqueCount"] as AnyObject?) {
                
                case let .success(value): _result.clientUniqueCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["starttime"] as AnyObject?) {
                
                case let .success(value): _result.starttime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endtime"] as AnyObject?) {
                
                case let .success(value): _result.endtime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["scoreList"] as AnyObject?) {
                
                case let .success(value): _result.scoreList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ClientHealthResponseScoreDetail", actual: "\(source)"))
            }
        }
        // Decoder for [CollectionProjectDTO]
        Decoders.addDecoder(clazz: [CollectionProjectDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CollectionProjectDTO]> in
            return Decoders.decode(clazz: [CollectionProjectDTO].self, source: source)
        }

        // Decoder for CollectionProjectDTO
        Decoders.addDecoder(clazz: CollectionProjectDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CollectionProjectDTO> in
            if let source = source as? CollectionProjectDTO {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias CollectionProjectDTO", actual: "\(source)"))
            }
        }
        // Decoder for [CollectionTemplateInfo]
        Decoders.addDecoder(clazz: [CollectionTemplateInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CollectionTemplateInfo]> in
            return Decoders.decode(clazz: [CollectionTemplateInfo].self, source: source)
        }

        // Decoder for CollectionTemplateInfo
        Decoders.addDecoder(clazz: CollectionTemplateInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CollectionTemplateInfo> in
            if let source = source as? CollectionTemplateInfo {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias CollectionTemplateInfo", actual: "\(source)"))
            }
        }
        // Decoder for [CommandRunnerDTO]
        Decoders.addDecoder(clazz: [CommandRunnerDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CommandRunnerDTO]> in
            return Decoders.decode(clazz: [CommandRunnerDTO].self, source: source)
        }

        // Decoder for CommandRunnerDTO
        Decoders.addDecoder(clazz: CommandRunnerDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CommandRunnerDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? CommandRunnerDTO() : instance as! CommandRunnerDTO
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["commands"] as AnyObject?) {
                
                case let .success(value): _result.commands = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["deviceUuids"] as AnyObject?) {
                
                case let .success(value): _result.deviceUuids = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timeout"] as AnyObject?) {
                
                case let .success(value): _result.timeout = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "CommandRunnerDTO", actual: "\(source)"))
            }
        }
        // Decoder for [CountResult]
        Decoders.addDecoder(clazz: [CountResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CountResult]> in
            return Decoders.decode(clazz: [CountResult].self, source: source)
        }

        // Decoder for CountResult
        Decoders.addDecoder(clazz: CountResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CountResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? CountResult() : instance as! CountResult
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "CountResult", actual: "\(source)"))
            }
        }
        // Decoder for [CreateDeviceResponse]
        Decoders.addDecoder(clazz: [CreateDeviceResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CreateDeviceResponse]> in
            return Decoders.decode(clazz: [CreateDeviceResponse].self, source: source)
        }

        // Decoder for CreateDeviceResponse
        Decoders.addDecoder(clazz: CreateDeviceResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CreateDeviceResponse> in
            if let source = source as? CreateDeviceResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias CreateDeviceResponse", actual: "\(source)"))
            }
        }
        // Decoder for [CreateSSIDRequest]
        Decoders.addDecoder(clazz: [CreateSSIDRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CreateSSIDRequest]> in
            return Decoders.decode(clazz: [CreateSSIDRequest].self, source: source)
        }

        // Decoder for CreateSSIDRequest
        Decoders.addDecoder(clazz: CreateSSIDRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CreateSSIDRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? CreateSSIDRequest() : instance as! CreateSSIDRequest
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceName"] as AnyObject?) {
                
                case let .success(value): _result.interfaceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["vlanId"] as AnyObject?) {
                
                case let .success(value): _result.vlanId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ssidName"] as AnyObject?) {
                
                case let .success(value): _result.ssidName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wlanType"] as AnyObject?) {
                
                case let .success(value): _result.wlanType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: CreateSSIDRequest.AuthenticationType.self, source: sourceDictionary["authenticationType"] as AnyObject?) {
                
                case let .success(value): _result.authenticationType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["authenticationServer"] as AnyObject?) {
                
                case let .success(value): _result.authenticationServer = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["passpharse"] as AnyObject?) {
                
                case let .success(value): _result.passpharse = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: CreateSSIDRequest.TrafficType.self, source: sourceDictionary["trafficType"] as AnyObject?) {
                
                case let .success(value): _result.trafficType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: CreateSSIDRequest.RadioPolicy.self, source: sourceDictionary["radioPolicy"] as AnyObject?) {
                
                case let .success(value): _result.radioPolicy = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: CreateSSIDRequest.FastTransition.self, source: sourceDictionary["fastTransition"] as AnyObject?) {
                
                case let .success(value): _result.fastTransition = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["enableFastlane"] as AnyObject?) {
                
                case let .success(value): _result.enableFastlane = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["enableMACFilering"] as AnyObject?) {
                
                case let .success(value): _result.enableMACFilering = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["enableBroadcastSSID"] as AnyObject?) {
                
                case let .success(value): _result.enableBroadcastSSID = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["enableWLANBandSelection"] as AnyObject?) {
                
                case let .success(value): _result.enableWLANBandSelection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wirelessNetworkProfileName"] as AnyObject?) {
                
                case let .success(value): _result.wirelessNetworkProfileName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sitesNameHierarchyToMapTheProfile"] as AnyObject?) {
                
                case let .success(value): _result.sitesNameHierarchyToMapTheProfile = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceName"] as AnyObject?) {
                
                case let .success(value): _result.deviceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["siteNameHierarchyToMapDevicePhysicalLocation"] as AnyObject?) {
                
                case let .success(value): _result.siteNameHierarchyToMapDevicePhysicalLocation = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["managedAPLocations"] as AnyObject?) {
                
                case let .success(value): _result.managedAPLocations = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceIPAddress"] as AnyObject?) {
                
                case let .success(value): _result.interfaceIPAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceNetMaskInCIDRFormat"] as AnyObject?) {
                
                case let .success(value): _result.interfaceNetMaskInCIDRFormat = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceGatewayIPAddress"] as AnyObject?) {
                
                case let .success(value): _result.interfaceGatewayIPAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["interfaceLAGPortNumber"] as AnyObject?) {
                
                case let .success(value): _result.interfaceLAGPortNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["siteNameHierarchyToMapAPPhysicalLocation"] as AnyObject?) {
                
                case let .success(value): _result.siteNameHierarchyToMapAPPhysicalLocation = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["apNames"] as AnyObject?) {
                
                case let .success(value): _result.apNames = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: CreateSSIDRequest.RfProfile.self, source: sourceDictionary["rfProfile"] as AnyObject?) {
                
                case let .success(value): _result.rfProfile = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "CreateSSIDRequest", actual: "\(source)"))
            }
        }
        // Decoder for [CreateSSIDResponse]
        Decoders.addDecoder(clazz: [CreateSSIDResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CreateSSIDResponse]> in
            return Decoders.decode(clazz: [CreateSSIDResponse].self, source: source)
        }

        // Decoder for CreateSSIDResponse
        Decoders.addDecoder(clazz: CreateSSIDResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CreateSSIDResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? CreateSSIDResponse() : instance as! CreateSSIDResponse
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isError"] as AnyObject?) {
                
                case let .success(value): _result.isError = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["failureReason"] as AnyObject?) {
                
                case let .success(value): _result.failureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["successMessage"] as AnyObject?) {
                
                case let .success(value): _result.successMessage = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "CreateSSIDResponse", actual: "\(source)"))
            }
        }
        // Decoder for [CreateWorkflowResponse]
        Decoders.addDecoder(clazz: [CreateWorkflowResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[CreateWorkflowResponse]> in
            return Decoders.decode(clazz: [CreateWorkflowResponse].self, source: source)
        }

        // Decoder for CreateWorkflowResponse
        Decoders.addDecoder(clazz: CreateWorkflowResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<CreateWorkflowResponse> in
            if let source = source as? CreateWorkflowResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias CreateWorkflowResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DeleteDeviceResponse]
        Decoders.addDecoder(clazz: [DeleteDeviceResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeleteDeviceResponse]> in
            return Decoders.decode(clazz: [DeleteDeviceResponse].self, source: source)
        }

        // Decoder for DeleteDeviceResponse
        Decoders.addDecoder(clazz: DeleteDeviceResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeleteDeviceResponse> in
            if let source = source as? DeleteDeviceResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias DeleteDeviceResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DeleteSSIDResponse]
        Decoders.addDecoder(clazz: [DeleteSSIDResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeleteSSIDResponse]> in
            return Decoders.decode(clazz: [DeleteSSIDResponse].self, source: source)
        }

        // Decoder for DeleteSSIDResponse
        Decoders.addDecoder(clazz: DeleteSSIDResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeleteSSIDResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeleteSSIDResponse() : instance as! DeleteSSIDResponse
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isError"] as AnyObject?) {
                
                case let .success(value): _result.isError = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["failureReason"] as AnyObject?) {
                
                case let .success(value): _result.failureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["successMessage"] as AnyObject?) {
                
                case let .success(value): _result.successMessage = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeleteSSIDResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DeleteWorkflowResponse]
        Decoders.addDecoder(clazz: [DeleteWorkflowResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeleteWorkflowResponse]> in
            return Decoders.decode(clazz: [DeleteWorkflowResponse].self, source: source)
        }

        // Decoder for DeleteWorkflowResponse
        Decoders.addDecoder(clazz: DeleteWorkflowResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeleteWorkflowResponse> in
            if let source = source as? DeleteWorkflowResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias DeleteWorkflowResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DeregisterVirtualAccountResponse]
        Decoders.addDecoder(clazz: [DeregisterVirtualAccountResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeregisterVirtualAccountResponse]> in
            return Decoders.decode(clazz: [DeregisterVirtualAccountResponse].self, source: source)
        }

        // Decoder for DeregisterVirtualAccountResponse
        Decoders.addDecoder(clazz: DeregisterVirtualAccountResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeregisterVirtualAccountResponse> in
            if let source = source as? DeregisterVirtualAccountResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias DeregisterVirtualAccountResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceIfListResult]
        Decoders.addDecoder(clazz: [DeviceIfListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceIfListResult]> in
            return Decoders.decode(clazz: [DeviceIfListResult].self, source: source)
        }

        // Decoder for DeviceIfListResult
        Decoders.addDecoder(clazz: DeviceIfListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceIfListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceIfListResult() : instance as! DeviceIfListResult
                switch Decoders.decodeOptional(clazz: [DeviceIfListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceIfListResult", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceIfListResultResponse]
        Decoders.addDecoder(clazz: [DeviceIfListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceIfListResultResponse]> in
            return Decoders.decode(clazz: [DeviceIfListResultResponse].self, source: source)
        }

        // Decoder for DeviceIfListResultResponse
        Decoders.addDecoder(clazz: DeviceIfListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceIfListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceIfListResultResponse() : instance as! DeviceIfListResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["adminStatus"] as AnyObject?) {
                
                case let .success(value): _result.adminStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["className"] as AnyObject?) {
                
                case let .success(value): _result.className = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceId"] as AnyObject?) {
                
                case let .success(value): _result.deviceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["duplex"] as AnyObject?) {
                
                case let .success(value): _result.duplex = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ifIndex"] as AnyObject?) {
                
                case let .success(value): _result.ifIndex = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceType"] as AnyObject?) {
                
                case let .success(value): _result.interfaceType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipv4Address"] as AnyObject?) {
                
                case let .success(value): _result.ipv4Address = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipv4Mask"] as AnyObject?) {
                
                case let .success(value): _result.ipv4Mask = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["isisSupport"] as AnyObject?) {
                
                case let .success(value): _result.isisSupport = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdated"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdated = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mappedPhysicalInterfaceId"] as AnyObject?) {
                
                case let .success(value): _result.mappedPhysicalInterfaceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mappedPhysicalInterfaceName"] as AnyObject?) {
                
                case let .success(value): _result.mappedPhysicalInterfaceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mediaType"] as AnyObject?) {
                
                case let .success(value): _result.mediaType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nativeVlanId"] as AnyObject?) {
                
                case let .success(value): _result.nativeVlanId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ospfSupport"] as AnyObject?) {
                
                case let .success(value): _result.ospfSupport = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["pid"] as AnyObject?) {
                
                case let .success(value): _result.pid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["portMode"] as AnyObject?) {
                
                case let .success(value): _result.portMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["portName"] as AnyObject?) {
                
                case let .success(value): _result.portName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["portType"] as AnyObject?) {
                
                case let .success(value): _result.portType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNo"] as AnyObject?) {
                
                case let .success(value): _result.serialNo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["series"] as AnyObject?) {
                
                case let .success(value): _result.series = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["speed"] as AnyObject?) {
                
                case let .success(value): _result.speed = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["status"] as AnyObject?) {
                
                case let .success(value): _result.status = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vlanId"] as AnyObject?) {
                
                case let .success(value): _result.vlanId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["voiceVlan"] as AnyObject?) {
                
                case let .success(value): _result.voiceVlan = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceIfListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceIfResult]
        Decoders.addDecoder(clazz: [DeviceIfResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceIfResult]> in
            return Decoders.decode(clazz: [DeviceIfResult].self, source: source)
        }

        // Decoder for DeviceIfResult
        Decoders.addDecoder(clazz: DeviceIfResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceIfResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceIfResult() : instance as! DeviceIfResult
                switch Decoders.decodeOptional(clazz: DeviceIfListResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceIfResult", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInner]
        Decoders.addDecoder(clazz: [DeviceInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInner]> in
            return Decoders.decode(clazz: [DeviceInner].self, source: source)
        }

        // Decoder for DeviceInner
        Decoders.addDecoder(clazz: DeviceInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInner() : instance as! DeviceInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["_id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfo.self, source: sourceDictionary["deviceInfo"] as AnyObject?) {
                
                case let .success(value): _result.deviceInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerRunSummaryList].self, source: sourceDictionary["runSummaryList"] as AnyObject?) {
                
                case let .success(value): _result.runSummaryList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerSystemResetWorkflow.self, source: sourceDictionary["systemResetWorkflow"] as AnyObject?) {
                
                case let .success(value): _result.systemResetWorkflow = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerSystemResetWorkflow.self, source: sourceDictionary["systemWorkflow"] as AnyObject?) {
                
                case let .success(value): _result.systemWorkflow = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tenantId"] as AnyObject?) {
                
                case let .success(value): _result.tenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerSystemResetWorkflow.self, source: sourceDictionary["workflow"] as AnyObject?) {
                
                case let .success(value): _result.workflow = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerWorkflowParameters.self, source: sourceDictionary["workflowParameters"] as AnyObject?) {
                
                case let .success(value): _result.workflowParameters = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInner", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfo]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfo]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfo].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfo
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfo() : instance as! DeviceInnerDeviceInfo
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfoAaaCredentials.self, source: sourceDictionary["aaaCredentials"] as AnyObject?) {
                
                case let .success(value): _result.aaaCredentials = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["addedOn"] as AnyObject?) {
                
                case let .success(value): _result.addedOn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["addnMacAddrs"] as AnyObject?) {
                
                case let .success(value): _result.addnMacAddrs = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfo.AgentType.self, source: sourceDictionary["agentType"] as AnyObject?) {
                
                case let .success(value): _result.agentType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["authStatus"] as AnyObject?) {
                
                case let .success(value): _result.authStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["authenticatedSudiSerialNo"] as AnyObject?) {
                
                case let .success(value): _result.authenticatedSudiSerialNo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["capabilitiesSupported"] as AnyObject?) {
                
                case let .success(value): _result.capabilitiesSupported = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfo.CmState.self, source: sourceDictionary["cmState"] as AnyObject?) {
                
                case let .success(value): _result.cmState = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["deviceSudiSerialNos"] as AnyObject?) {
                
                case let .success(value): _result.deviceSudiSerialNos = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceType"] as AnyObject?) {
                
                case let .success(value): _result.deviceType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["featuresSupported"] as AnyObject?) {
                
                case let .success(value): _result.featuresSupported = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerDeviceInfoFileSystemList].self, source: sourceDictionary["fileSystemList"] as AnyObject?) {
                
                case let .success(value): _result.fileSystemList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["firstContact"] as AnyObject?) {
                
                case let .success(value): _result.firstContact = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostname"] as AnyObject?) {
                
                case let .success(value): _result.hostname = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [ResetRequestConfigParameters].self, source: sourceDictionary["httpHeaders"] as AnyObject?) {
                
                case let .success(value): _result.httpHeaders = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageFile"] as AnyObject?) {
                
                case let .success(value): _result.imageFile = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageVersion"] as AnyObject?) {
                
                case let .success(value): _result.imageVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerDeviceInfoIpInterfaces].self, source: sourceDictionary["ipInterfaces"] as AnyObject?) {
                
                case let .success(value): _result.ipInterfaces = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastContact"] as AnyObject?) {
                
                case let .success(value): _result.lastContact = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastSyncTime"] as AnyObject?) {
                
                case let .success(value): _result.lastSyncTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastUpdateOn"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdateOn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfoLocation.self, source: sourceDictionary["location"] as AnyObject?) {
                
                case let .success(value): _result.location = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mode"] as AnyObject?) {
                
                case let .success(value): _result.mode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerDeviceInfoNeighborLinks].self, source: sourceDictionary["neighborLinks"] as AnyObject?) {
                
                case let .success(value): _result.neighborLinks = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfo.OnbState.self, source: sourceDictionary["onbState"] as AnyObject?) {
                
                case let .success(value): _result.onbState = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["pid"] as AnyObject?) {
                
                case let .success(value): _result.pid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerDeviceInfoPnpProfileList].self, source: sourceDictionary["pnpProfileList"] as AnyObject?) {
                
                case let .success(value): _result.pnpProfileList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerDeviceInfoPreWorkflowCliOuputs].self, source: sourceDictionary["preWorkflowCliOuputs"] as AnyObject?) {
                
                case let .success(value): _result.preWorkflowCliOuputs = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["projectId"] as AnyObject?) {
                
                case let .success(value): _result.projectId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["projectName"] as AnyObject?) {
                
                case let .success(value): _result.projectName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["reloadRequested"] as AnyObject?) {
                
                case let .success(value): _result.reloadRequested = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["smartAccountId"] as AnyObject?) {
                
                case let .success(value): _result.smartAccountId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["source"] as AnyObject?) {
                
                case let .success(value): _result.source = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["stack"] as AnyObject?) {
                
                case let .success(value): _result.stack = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfoStackInfo.self, source: sourceDictionary["stackInfo"] as AnyObject?) {
                
                case let .success(value): _result.stackInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfo.State.self, source: sourceDictionary["state"] as AnyObject?) {
                
                case let .success(value): _result.state = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["sudiRequired"] as AnyObject?) {
                
                case let .success(value): _result.sudiRequired = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["tags"] as AnyObject?) {
                
                case let .success(value): _result.tags = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["userSudiSerialNos"] as AnyObject?) {
                
                case let .success(value): _result.userSudiSerialNos = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["virtualAccountId"] as AnyObject?) {
                
                case let .success(value): _result.virtualAccountId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["workflowId"] as AnyObject?) {
                
                case let .success(value): _result.workflowId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["workflowName"] as AnyObject?) {
                
                case let .success(value): _result.workflowName = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfo", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoAaaCredentials]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoAaaCredentials].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoAaaCredentials]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoAaaCredentials].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoAaaCredentials
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoAaaCredentials.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoAaaCredentials> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoAaaCredentials() : instance as! DeviceInnerDeviceInfoAaaCredentials
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?) {
                
                case let .success(value): _result.password = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?) {
                
                case let .success(value): _result.username = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoAaaCredentials", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoFileSystemList]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoFileSystemList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoFileSystemList]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoFileSystemList].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoFileSystemList
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoFileSystemList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoFileSystemList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoFileSystemList() : instance as! DeviceInnerDeviceInfoFileSystemList
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["freespace"] as AnyObject?) {
                
                case let .success(value): _result.freespace = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["readable"] as AnyObject?) {
                
                case let .success(value): _result.readable = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["size"] as AnyObject?) {
                
                case let .success(value): _result.size = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["writeable"] as AnyObject?) {
                
                case let .success(value): _result.writeable = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoFileSystemList", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoIpInterfaces]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoIpInterfaces].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoIpInterfaces]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoIpInterfaces].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoIpInterfaces
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoIpInterfaces.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoIpInterfaces> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoIpInterfaces() : instance as! DeviceInnerDeviceInfoIpInterfaces
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["ipv4Address"] as AnyObject?) {
                
                case let .success(value): _result.ipv4Address = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [Any].self, source: sourceDictionary["ipv6AddressList"] as AnyObject?) {
                
                case let .success(value): _result.ipv6AddressList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["status"] as AnyObject?) {
                
                case let .success(value): _result.status = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoIpInterfaces", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoLocation]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoLocation].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoLocation]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoLocation].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoLocation
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoLocation.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoLocation> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoLocation() : instance as! DeviceInnerDeviceInfoLocation
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["address"] as AnyObject?) {
                
                case let .success(value): _result.address = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["altitude"] as AnyObject?) {
                
                case let .success(value): _result.altitude = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["latitude"] as AnyObject?) {
                
                case let .success(value): _result.latitude = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["longitude"] as AnyObject?) {
                
                case let .success(value): _result.longitude = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["siteId"] as AnyObject?) {
                
                case let .success(value): _result.siteId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoLocation", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoNeighborLinks]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoNeighborLinks].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoNeighborLinks]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoNeighborLinks].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoNeighborLinks
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoNeighborLinks.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoNeighborLinks> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoNeighborLinks() : instance as! DeviceInnerDeviceInfoNeighborLinks
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["localInterfaceName"] as AnyObject?) {
                
                case let .success(value): _result.localInterfaceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["localMacAddress"] as AnyObject?) {
                
                case let .success(value): _result.localMacAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["localShortInterfaceName"] as AnyObject?) {
                
                case let .success(value): _result.localShortInterfaceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["remoteDeviceName"] as AnyObject?) {
                
                case let .success(value): _result.remoteDeviceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["remoteInterfaceName"] as AnyObject?) {
                
                case let .success(value): _result.remoteInterfaceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["remoteMacAddress"] as AnyObject?) {
                
                case let .success(value): _result.remoteMacAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["remotePlatform"] as AnyObject?) {
                
                case let .success(value): _result.remotePlatform = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["remoteShortInterfaceName"] as AnyObject?) {
                
                case let .success(value): _result.remoteShortInterfaceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["remoteVersion"] as AnyObject?) {
                
                case let .success(value): _result.remoteVersion = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoNeighborLinks", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoPnpProfileList]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoPnpProfileList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoPnpProfileList]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoPnpProfileList].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoPnpProfileList
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoPnpProfileList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoPnpProfileList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoPnpProfileList() : instance as! DeviceInnerDeviceInfoPnpProfileList
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["createdBy"] as AnyObject?) {
                
                case let .success(value): _result.createdBy = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["discoveryCreated"] as AnyObject?) {
                
                case let .success(value): _result.discoveryCreated = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfoPrimaryEndpoint.self, source: sourceDictionary["primaryEndpoint"] as AnyObject?) {
                
                case let .success(value): _result.primaryEndpoint = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["profileName"] as AnyObject?) {
                
                case let .success(value): _result.profileName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfoPrimaryEndpoint.self, source: sourceDictionary["secondaryEndpoint"] as AnyObject?) {
                
                case let .success(value): _result.secondaryEndpoint = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoPnpProfileList", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoPreWorkflowCliOuputs]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoPreWorkflowCliOuputs].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoPreWorkflowCliOuputs]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoPreWorkflowCliOuputs].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoPreWorkflowCliOuputs
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoPreWorkflowCliOuputs.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoPreWorkflowCliOuputs> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoPreWorkflowCliOuputs() : instance as! DeviceInnerDeviceInfoPreWorkflowCliOuputs
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cli"] as AnyObject?) {
                
                case let .success(value): _result.cli = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cliOutput"] as AnyObject?) {
                
                case let .success(value): _result.cliOutput = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoPreWorkflowCliOuputs", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoPrimaryEndpoint]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoPrimaryEndpoint].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoPrimaryEndpoint]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoPrimaryEndpoint].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoPrimaryEndpoint
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoPrimaryEndpoint.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoPrimaryEndpoint> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoPrimaryEndpoint() : instance as! DeviceInnerDeviceInfoPrimaryEndpoint
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["certificate"] as AnyObject?) {
                
                case let .success(value): _result.certificate = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["fqdn"] as AnyObject?) {
                
                case let .success(value): _result.fqdn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["ipv4Address"] as AnyObject?) {
                
                case let .success(value): _result.ipv4Address = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["ipv6Address"] as AnyObject?) {
                
                case let .success(value): _result.ipv6Address = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["port"] as AnyObject?) {
                
                case let .success(value): _result.port = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocol"] as AnyObject?) {
                
                case let .success(value): _result._protocol = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoPrimaryEndpoint", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoStackInfo]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoStackInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoStackInfo]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoStackInfo].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoStackInfo
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoStackInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoStackInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoStackInfo() : instance as! DeviceInnerDeviceInfoStackInfo
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isFullRing"] as AnyObject?) {
                
                case let .success(value): _result.isFullRing = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerDeviceInfoStackInfoStackMemberList].self, source: sourceDictionary["stackMemberList"] as AnyObject?) {
                
                case let .success(value): _result.stackMemberList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["stackRingProtocol"] as AnyObject?) {
                
                case let .success(value): _result.stackRingProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["supportsStackWorkflows"] as AnyObject?) {
                
                case let .success(value): _result.supportsStackWorkflows = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["totalMemberCount"] as AnyObject?) {
                
                case let .success(value): _result.totalMemberCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["validLicenseLevels"] as AnyObject?) {
                
                case let .success(value): _result.validLicenseLevels = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoStackInfo", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerDeviceInfoStackInfoStackMemberList]
        Decoders.addDecoder(clazz: [DeviceInnerDeviceInfoStackInfoStackMemberList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerDeviceInfoStackInfoStackMemberList]> in
            return Decoders.decode(clazz: [DeviceInnerDeviceInfoStackInfoStackMemberList].self, source: source)
        }

        // Decoder for DeviceInnerDeviceInfoStackInfoStackMemberList
        Decoders.addDecoder(clazz: DeviceInnerDeviceInfoStackInfoStackMemberList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerDeviceInfoStackInfoStackMemberList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerDeviceInfoStackInfoStackMemberList() : instance as! DeviceInnerDeviceInfoStackInfoStackMemberList
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hardwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.hardwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["licenseLevel"] as AnyObject?) {
                
                case let .success(value): _result.licenseLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["licenseType"] as AnyObject?) {
                
                case let .success(value): _result.licenseType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["pid"] as AnyObject?) {
                
                case let .success(value): _result.pid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["priority"] as AnyObject?) {
                
                case let .success(value): _result.priority = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.softwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["stackNumber"] as AnyObject?) {
                
                case let .success(value): _result.stackNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["state"] as AnyObject?) {
                
                case let .success(value): _result.state = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sudiSerialNumber"] as AnyObject?) {
                
                case let .success(value): _result.sudiSerialNumber = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerDeviceInfoStackInfoStackMemberList", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerHistoryTaskInfo]
        Decoders.addDecoder(clazz: [DeviceInnerHistoryTaskInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerHistoryTaskInfo]> in
            return Decoders.decode(clazz: [DeviceInnerHistoryTaskInfo].self, source: source)
        }

        // Decoder for DeviceInnerHistoryTaskInfo
        Decoders.addDecoder(clazz: DeviceInnerHistoryTaskInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerHistoryTaskInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerHistoryTaskInfo() : instance as! DeviceInnerHistoryTaskInfo
                switch Decoders.decodeOptional(clazz: [ResetRequestConfigParameters].self, source: sourceDictionary["addnDetails"] as AnyObject?) {
                
                case let .success(value): _result.addnDetails = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timeTaken"] as AnyObject?) {
                
                case let .success(value): _result.timeTaken = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerHistoryTaskInfoWorkItemList].self, source: sourceDictionary["workItemList"] as AnyObject?) {
                
                case let .success(value): _result.workItemList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerHistoryTaskInfo", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerHistoryTaskInfoWorkItemList]
        Decoders.addDecoder(clazz: [DeviceInnerHistoryTaskInfoWorkItemList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerHistoryTaskInfoWorkItemList]> in
            return Decoders.decode(clazz: [DeviceInnerHistoryTaskInfoWorkItemList].self, source: source)
        }

        // Decoder for DeviceInnerHistoryTaskInfoWorkItemList
        Decoders.addDecoder(clazz: DeviceInnerHistoryTaskInfoWorkItemList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerHistoryTaskInfoWorkItemList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerHistoryTaskInfoWorkItemList() : instance as! DeviceInnerHistoryTaskInfoWorkItemList
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["command"] as AnyObject?) {
                
                case let .success(value): _result.command = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["outputStr"] as AnyObject?) {
                
                case let .success(value): _result.outputStr = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["state"] as AnyObject?) {
                
                case let .success(value): _result.state = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timeTaken"] as AnyObject?) {
                
                case let .success(value): _result.timeTaken = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerHistoryTaskInfoWorkItemList", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerRunSummaryList]
        Decoders.addDecoder(clazz: [DeviceInnerRunSummaryList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerRunSummaryList]> in
            return Decoders.decode(clazz: [DeviceInnerRunSummaryList].self, source: source)
        }

        // Decoder for DeviceInnerRunSummaryList
        Decoders.addDecoder(clazz: DeviceInnerRunSummaryList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerRunSummaryList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerRunSummaryList() : instance as! DeviceInnerRunSummaryList
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["details"] as AnyObject?) {
                
                case let .success(value): _result.details = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["errorFlag"] as AnyObject?) {
                
                case let .success(value): _result.errorFlag = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerHistoryTaskInfo.self, source: sourceDictionary["historyTaskInfo"] as AnyObject?) {
                
                case let .success(value): _result.historyTaskInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timestamp"] as AnyObject?) {
                
                case let .success(value): _result.timestamp = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerRunSummaryList", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerSystemResetWorkflow]
        Decoders.addDecoder(clazz: [DeviceInnerSystemResetWorkflow].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerSystemResetWorkflow]> in
            return Decoders.decode(clazz: [DeviceInnerSystemResetWorkflow].self, source: source)
        }

        // Decoder for DeviceInnerSystemResetWorkflow
        Decoders.addDecoder(clazz: DeviceInnerSystemResetWorkflow.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerSystemResetWorkflow> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerSystemResetWorkflow() : instance as! DeviceInnerSystemResetWorkflow
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["_id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["addToInventory"] as AnyObject?) {
                
                case let .success(value): _result.addToInventory = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["addedOn"] as AnyObject?) {
                
                case let .success(value): _result.addedOn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["configId"] as AnyObject?) {
                
                case let .success(value): _result.configId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["currTaskIdx"] as AnyObject?) {
                
                case let .success(value): _result.currTaskIdx = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["execTime"] as AnyObject?) {
                
                case let .success(value): _result.execTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageId"] as AnyObject?) {
                
                case let .success(value): _result.imageId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastupdateOn"] as AnyObject?) {
                
                case let .success(value): _result.lastupdateOn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["state"] as AnyObject?) {
                
                case let .success(value): _result.state = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerSystemResetWorkflowTasks].self, source: sourceDictionary["tasks"] as AnyObject?) {
                
                case let .success(value): _result.tasks = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tenantId"] as AnyObject?) {
                
                case let .success(value): _result.tenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["useState"] as AnyObject?) {
                
                case let .success(value): _result.useState = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerSystemResetWorkflow", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerSystemResetWorkflowTasks]
        Decoders.addDecoder(clazz: [DeviceInnerSystemResetWorkflowTasks].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerSystemResetWorkflowTasks]> in
            return Decoders.decode(clazz: [DeviceInnerSystemResetWorkflowTasks].self, source: source)
        }

        // Decoder for DeviceInnerSystemResetWorkflowTasks
        Decoders.addDecoder(clazz: DeviceInnerSystemResetWorkflowTasks.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerSystemResetWorkflowTasks> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerSystemResetWorkflowTasks() : instance as! DeviceInnerSystemResetWorkflowTasks
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["currWorkItemIdx"] as AnyObject?) {
                
                case let .success(value): _result.currWorkItemIdx = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["state"] as AnyObject?) {
                
                case let .success(value): _result.state = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["taskSeqNo"] as AnyObject?) {
                
                case let .success(value): _result.taskSeqNo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timeTaken"] as AnyObject?) {
                
                case let .success(value): _result.timeTaken = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerHistoryTaskInfoWorkItemList].self, source: sourceDictionary["workItemList"] as AnyObject?) {
                
                case let .success(value): _result.workItemList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerSystemResetWorkflowTasks", actual: "\(source)"))
            }
        }
        // Decoder for [DeviceInnerWorkflowParameters]
        Decoders.addDecoder(clazz: [DeviceInnerWorkflowParameters].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DeviceInnerWorkflowParameters]> in
            return Decoders.decode(clazz: [DeviceInnerWorkflowParameters].self, source: source)
        }

        // Decoder for DeviceInnerWorkflowParameters
        Decoders.addDecoder(clazz: DeviceInnerWorkflowParameters.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DeviceInnerWorkflowParameters> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DeviceInnerWorkflowParameters() : instance as! DeviceInnerWorkflowParameters
                switch Decoders.decodeOptional(clazz: [ResetRequestConfigList].self, source: sourceDictionary["configList"] as AnyObject?) {
                
                case let .success(value): _result.configList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["licenseLevel"] as AnyObject?) {
                
                case let .success(value): _result.licenseLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["licenseType"] as AnyObject?) {
                
                case let .success(value): _result.licenseType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topOfStackSerialNumber"] as AnyObject?) {
                
                case let .success(value): _result.topOfStackSerialNumber = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DeviceInnerWorkflowParameters", actual: "\(source)"))
            }
        }
        // Decoder for [DiscoveryJobNIOListResult]
        Decoders.addDecoder(clazz: [DiscoveryJobNIOListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DiscoveryJobNIOListResult]> in
            return Decoders.decode(clazz: [DiscoveryJobNIOListResult].self, source: source)
        }

        // Decoder for DiscoveryJobNIOListResult
        Decoders.addDecoder(clazz: DiscoveryJobNIOListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DiscoveryJobNIOListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DiscoveryJobNIOListResult() : instance as! DiscoveryJobNIOListResult
                switch Decoders.decodeOptional(clazz: [DiscoveryJobNIOListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DiscoveryJobNIOListResult", actual: "\(source)"))
            }
        }
        // Decoder for [DiscoveryJobNIOListResultResponse]
        Decoders.addDecoder(clazz: [DiscoveryJobNIOListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DiscoveryJobNIOListResultResponse]> in
            return Decoders.decode(clazz: [DiscoveryJobNIOListResultResponse].self, source: source)
        }

        // Decoder for DiscoveryJobNIOListResultResponse
        Decoders.addDecoder(clazz: DiscoveryJobNIOListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DiscoveryJobNIOListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DiscoveryJobNIOListResultResponse() : instance as! DiscoveryJobNIOListResultResponse
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cliStatus"] as AnyObject?) {
                
                case let .success(value): _result.cliStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryStatus"] as AnyObject?) {
                
                case let .success(value): _result.discoveryStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["httpStatus"] as AnyObject?) {
                
                case let .success(value): _result.httpStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["inventoryCollectionStatus"] as AnyObject?) {
                
                case let .success(value): _result.inventoryCollectionStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["inventoryReachabilityStatus"] as AnyObject?) {
                
                case let .success(value): _result.inventoryReachabilityStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipAddress"] as AnyObject?) {
                
                case let .success(value): _result.ipAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["jobStatus"] as AnyObject?) {
                
                case let .success(value): _result.jobStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["netconfStatus"] as AnyObject?) {
                
                case let .success(value): _result.netconfStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["pingStatus"] as AnyObject?) {
                
                case let .success(value): _result.pingStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpStatus"] as AnyObject?) {
                
                case let .success(value): _result.snmpStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["taskId"] as AnyObject?) {
                
                case let .success(value): _result.taskId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DiscoveryJobNIOListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DiscoveryNIO]
        Decoders.addDecoder(clazz: [DiscoveryNIO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DiscoveryNIO]> in
            return Decoders.decode(clazz: [DiscoveryNIO].self, source: source)
        }

        // Decoder for DiscoveryNIO
        Decoders.addDecoder(clazz: DiscoveryNIO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DiscoveryNIO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DiscoveryNIO() : instance as! DiscoveryNIO
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["cdpLevel"] as AnyObject?) {
                
                case let .success(value): _result.cdpLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceIds"] as AnyObject?) {
                
                case let .success(value): _result.deviceIds = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryCondition"] as AnyObject?) {
                
                case let .success(value): _result.discoveryCondition = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryStatus"] as AnyObject?) {
                
                case let .success(value): _result.discoveryStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryType"] as AnyObject?) {
                
                case let .success(value): _result.discoveryType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["enablePasswordList"] as AnyObject?) {
                
                case let .success(value): _result.enablePasswordList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["globalCredentialIdList"] as AnyObject?) {
                
                case let .success(value): _result.globalCredentialIdList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPReadCredentialDTOInner.self, source: sourceDictionary["httpReadCredential"] as AnyObject?) {
                
                case let .success(value): _result.httpReadCredential = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPReadCredentialDTOInner.self, source: sourceDictionary["httpWriteCredential"] as AnyObject?) {
                
                case let .success(value): _result.httpWriteCredential = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipAddressList"] as AnyObject?) {
                
                case let .success(value): _result.ipAddressList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipFilterList"] as AnyObject?) {
                
                case let .success(value): _result.ipFilterList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isAutoCdp"] as AnyObject?) {
                
                case let .success(value): _result.isAutoCdp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lldpLevel"] as AnyObject?) {
                
                case let .success(value): _result.lldpLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["netconfPort"] as AnyObject?) {
                
                case let .success(value): _result.netconfPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["numDevices"] as AnyObject?) {
                
                case let .success(value): _result.numDevices = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentDiscoveryId"] as AnyObject?) {
                
                case let .success(value): _result.parentDiscoveryId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["passwordList"] as AnyObject?) {
                
                case let .success(value): _result.passwordList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["preferredMgmtIPMethod"] as AnyObject?) {
                
                case let .success(value): _result.preferredMgmtIPMethod = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocolOrder"] as AnyObject?) {
                
                case let .success(value): _result.protocolOrder = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["retryCount"] as AnyObject?) {
                
                case let .success(value): _result.retryCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpMode"] as AnyObject?) {
                
                case let .success(value): _result.snmpMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRoCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpRoCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRoCommunityDesc"] as AnyObject?) {
                
                case let .success(value): _result.snmpRoCommunityDesc = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRwCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpRwCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRwCommunityDesc"] as AnyObject?) {
                
                case let .success(value): _result.snmpRwCommunityDesc = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpUserName"] as AnyObject?) {
                
                case let .success(value): _result.snmpUserName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timeOut"] as AnyObject?) {
                
                case let .success(value): _result.timeOut = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["updateMgmtIp"] as AnyObject?) {
                
                case let .success(value): _result.updateMgmtIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userNameList"] as AnyObject?) {
                
                case let .success(value): _result.userNameList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DiscoveryNIO", actual: "\(source)"))
            }
        }
        // Decoder for [DiscoveryNIOListResult]
        Decoders.addDecoder(clazz: [DiscoveryNIOListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DiscoveryNIOListResult]> in
            return Decoders.decode(clazz: [DiscoveryNIOListResult].self, source: source)
        }

        // Decoder for DiscoveryNIOListResult
        Decoders.addDecoder(clazz: DiscoveryNIOListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DiscoveryNIOListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DiscoveryNIOListResult() : instance as! DiscoveryNIOListResult
                switch Decoders.decodeOptional(clazz: [DiscoveryNIOResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DiscoveryNIOListResult", actual: "\(source)"))
            }
        }
        // Decoder for [DiscoveryNIOResult]
        Decoders.addDecoder(clazz: [DiscoveryNIOResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DiscoveryNIOResult]> in
            return Decoders.decode(clazz: [DiscoveryNIOResult].self, source: source)
        }

        // Decoder for DiscoveryNIOResult
        Decoders.addDecoder(clazz: DiscoveryNIOResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DiscoveryNIOResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DiscoveryNIOResult() : instance as! DiscoveryNIOResult
                switch Decoders.decodeOptional(clazz: DiscoveryNIOResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DiscoveryNIOResult", actual: "\(source)"))
            }
        }
        // Decoder for [DiscoveryNIOResultResponse]
        Decoders.addDecoder(clazz: [DiscoveryNIOResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DiscoveryNIOResultResponse]> in
            return Decoders.decode(clazz: [DiscoveryNIOResultResponse].self, source: source)
        }

        // Decoder for DiscoveryNIOResultResponse
        Decoders.addDecoder(clazz: DiscoveryNIOResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DiscoveryNIOResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DiscoveryNIOResultResponse() : instance as! DiscoveryNIOResultResponse
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["cdpLevel"] as AnyObject?) {
                
                case let .success(value): _result.cdpLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceIds"] as AnyObject?) {
                
                case let .success(value): _result.deviceIds = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryCondition"] as AnyObject?) {
                
                case let .success(value): _result.discoveryCondition = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryStatus"] as AnyObject?) {
                
                case let .success(value): _result.discoveryStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryType"] as AnyObject?) {
                
                case let .success(value): _result.discoveryType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["enablePasswordList"] as AnyObject?) {
                
                case let .success(value): _result.enablePasswordList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["globalCredentialIdList"] as AnyObject?) {
                
                case let .success(value): _result.globalCredentialIdList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPReadCredentialDTOInner.self, source: sourceDictionary["httpReadCredential"] as AnyObject?) {
                
                case let .success(value): _result.httpReadCredential = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPReadCredentialDTOInner.self, source: sourceDictionary["httpWriteCredential"] as AnyObject?) {
                
                case let .success(value): _result.httpWriteCredential = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipAddressList"] as AnyObject?) {
                
                case let .success(value): _result.ipAddressList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipFilterList"] as AnyObject?) {
                
                case let .success(value): _result.ipFilterList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isAutoCdp"] as AnyObject?) {
                
                case let .success(value): _result.isAutoCdp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lldpLevel"] as AnyObject?) {
                
                case let .success(value): _result.lldpLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["netconfPort"] as AnyObject?) {
                
                case let .success(value): _result.netconfPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["numDevices"] as AnyObject?) {
                
                case let .success(value): _result.numDevices = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentDiscoveryId"] as AnyObject?) {
                
                case let .success(value): _result.parentDiscoveryId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["passwordList"] as AnyObject?) {
                
                case let .success(value): _result.passwordList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["preferredMgmtIPMethod"] as AnyObject?) {
                
                case let .success(value): _result.preferredMgmtIPMethod = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocolOrder"] as AnyObject?) {
                
                case let .success(value): _result.protocolOrder = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["retryCount"] as AnyObject?) {
                
                case let .success(value): _result.retryCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpMode"] as AnyObject?) {
                
                case let .success(value): _result.snmpMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRoCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpRoCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRoCommunityDesc"] as AnyObject?) {
                
                case let .success(value): _result.snmpRoCommunityDesc = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRwCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpRwCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRwCommunityDesc"] as AnyObject?) {
                
                case let .success(value): _result.snmpRwCommunityDesc = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpUserName"] as AnyObject?) {
                
                case let .success(value): _result.snmpUserName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timeOut"] as AnyObject?) {
                
                case let .success(value): _result.timeOut = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["updateMgmtIp"] as AnyObject?) {
                
                case let .success(value): _result.updateMgmtIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userNameList"] as AnyObject?) {
                
                case let .success(value): _result.userNameList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DiscoveryNIOResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [DistributeDTOInner]
        Decoders.addDecoder(clazz: [DistributeDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DistributeDTOInner]> in
            return Decoders.decode(clazz: [DistributeDTOInner].self, source: source)
        }

        // Decoder for DistributeDTOInner
        Decoders.addDecoder(clazz: DistributeDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DistributeDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? DistributeDTOInner() : instance as! DistributeDTOInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceUuid"] as AnyObject?) {
                
                case let .success(value): _result.deviceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageUuid"] as AnyObject?) {
                
                case let .success(value): _result.imageUuid = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "DistributeDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [DownloadsAFileReferredByTheFileIdResponse]
        Decoders.addDecoder(clazz: [DownloadsAFileReferredByTheFileIdResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[DownloadsAFileReferredByTheFileIdResponse]> in
            return Decoders.decode(clazz: [DownloadsAFileReferredByTheFileIdResponse].self, source: source)
        }

        // Decoder for DownloadsAFileReferredByTheFileIdResponse
        Decoders.addDecoder(clazz: DownloadsAFileReferredByTheFileIdResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<DownloadsAFileReferredByTheFileIdResponse> in
            if let source = source as? DownloadsAFileReferredByTheFileIdResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias DownloadsAFileReferredByTheFileIdResponse", actual: "\(source)"))
            }
        }
        // Decoder for [EditPnPServerProfileResponse]
        Decoders.addDecoder(clazz: [EditPnPServerProfileResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[EditPnPServerProfileResponse]> in
            return Decoders.decode(clazz: [EditPnPServerProfileResponse].self, source: source)
        }

        // Decoder for EditPnPServerProfileResponse
        Decoders.addDecoder(clazz: EditPnPServerProfileResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<EditPnPServerProfileResponse> in
            if let source = source as? EditPnPServerProfileResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias EditPnPServerProfileResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ExportDeviceDTO]
        Decoders.addDecoder(clazz: [ExportDeviceDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ExportDeviceDTO]> in
            return Decoders.decode(clazz: [ExportDeviceDTO].self, source: source)
        }

        // Decoder for ExportDeviceDTO
        Decoders.addDecoder(clazz: ExportDeviceDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ExportDeviceDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ExportDeviceDTO() : instance as! ExportDeviceDTO
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["deviceUuids"] as AnyObject?) {
                
                case let .success(value): _result.deviceUuids = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: ExportDeviceDTO.OperationEnum.self, source: sourceDictionary["operationEnum"] as AnyObject?) {
                
                case let .success(value): _result.operationEnum = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["parameters"] as AnyObject?) {
                
                case let .success(value): _result.parameters = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?) {
                
                case let .success(value): _result.password = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ExportDeviceDTO", actual: "\(source)"))
            }
        }
        // Decoder for [FileObjectListResult]
        Decoders.addDecoder(clazz: [FileObjectListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FileObjectListResult]> in
            return Decoders.decode(clazz: [FileObjectListResult].self, source: source)
        }

        // Decoder for FileObjectListResult
        Decoders.addDecoder(clazz: FileObjectListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FileObjectListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FileObjectListResult() : instance as! FileObjectListResult
                switch Decoders.decodeOptional(clazz: [FileObjectListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FileObjectListResult", actual: "\(source)"))
            }
        }
        // Decoder for [FileObjectListResultResponse]
        Decoders.addDecoder(clazz: [FileObjectListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FileObjectListResultResponse]> in
            return Decoders.decode(clazz: [FileObjectListResultResponse].self, source: source)
        }

        // Decoder for FileObjectListResultResponse
        Decoders.addDecoder(clazz: FileObjectListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FileObjectListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FileObjectListResultResponse() : instance as! FileObjectListResultResponse
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["downloadPath"] as AnyObject?) {
                
                case let .success(value): _result.downloadPath = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["encrypted"] as AnyObject?) {
                
                case let .success(value): _result.encrypted = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["fileFormat"] as AnyObject?) {
                
                case let .success(value): _result.fileFormat = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["fileSize"] as AnyObject?) {
                
                case let .success(value): _result.fileSize = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["md5Checksum"] as AnyObject?) {
                
                case let .success(value): _result.md5Checksum = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nameSpace"] as AnyObject?) {
                
                case let .success(value): _result.nameSpace = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [Any].self, source: sourceDictionary["sftpServerList"] as AnyObject?) {
                
                case let .success(value): _result.sftpServerList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sha1Checksum"] as AnyObject?) {
                
                case let .success(value): _result.sha1Checksum = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["taskId"] as AnyObject?) {
                
                case let .success(value): _result.taskId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FileObjectListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [FlowAnalysisListOutput]
        Decoders.addDecoder(clazz: [FlowAnalysisListOutput].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FlowAnalysisListOutput]> in
            return Decoders.decode(clazz: [FlowAnalysisListOutput].self, source: source)
        }

        // Decoder for FlowAnalysisListOutput
        Decoders.addDecoder(clazz: FlowAnalysisListOutput.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FlowAnalysisListOutput> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FlowAnalysisListOutput() : instance as! FlowAnalysisListOutput
                switch Decoders.decodeOptional(clazz: [FlowAnalysisListOutputResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FlowAnalysisListOutput", actual: "\(source)"))
            }
        }
        // Decoder for [FlowAnalysisListOutputResponse]
        Decoders.addDecoder(clazz: [FlowAnalysisListOutputResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FlowAnalysisListOutputResponse]> in
            return Decoders.decode(clazz: [FlowAnalysisListOutputResponse].self, source: source)
        }

        // Decoder for FlowAnalysisListOutputResponse
        Decoders.addDecoder(clazz: FlowAnalysisListOutputResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FlowAnalysisListOutputResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FlowAnalysisListOutputResponse() : instance as! FlowAnalysisListOutputResponse
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["controlPath"] as AnyObject?) {
                
                case let .success(value): _result.controlPath = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["createTime"] as AnyObject?) {
                
                case let .success(value): _result.createTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destIP"] as AnyObject?) {
                
                case let .success(value): _result.destIP = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destPort"] as AnyObject?) {
                
                case let .success(value): _result.destPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["failureReason"] as AnyObject?) {
                
                case let .success(value): _result.failureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["inclusions"] as AnyObject?) {
                
                case let .success(value): _result.inclusions = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastUpdateTime"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdateTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["periodicRefresh"] as AnyObject?) {
                
                case let .success(value): _result.periodicRefresh = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocol"] as AnyObject?) {
                
                case let .success(value): _result._protocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourceIP"] as AnyObject?) {
                
                case let .success(value): _result.sourceIP = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourcePort"] as AnyObject?) {
                
                case let .success(value): _result.sourcePort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["status"] as AnyObject?) {
                
                case let .success(value): _result.status = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FlowAnalysisListOutputResponse", actual: "\(source)"))
            }
        }
        // Decoder for [FlowAnalysisRequest]
        Decoders.addDecoder(clazz: [FlowAnalysisRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FlowAnalysisRequest]> in
            return Decoders.decode(clazz: [FlowAnalysisRequest].self, source: source)
        }

        // Decoder for FlowAnalysisRequest
        Decoders.addDecoder(clazz: FlowAnalysisRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FlowAnalysisRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FlowAnalysisRequest() : instance as! FlowAnalysisRequest
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["controlPath"] as AnyObject?) {
                
                case let .success(value): _result.controlPath = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destIP"] as AnyObject?) {
                
                case let .success(value): _result.destIP = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destPort"] as AnyObject?) {
                
                case let .success(value): _result.destPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["inclusions"] as AnyObject?) {
                
                case let .success(value): _result.inclusions = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["periodicRefresh"] as AnyObject?) {
                
                case let .success(value): _result.periodicRefresh = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocol"] as AnyObject?) {
                
                case let .success(value): _result._protocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourceIP"] as AnyObject?) {
                
                case let .success(value): _result.sourceIP = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourcePort"] as AnyObject?) {
                
                case let .success(value): _result.sourcePort = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FlowAnalysisRequest", actual: "\(source)"))
            }
        }
        // Decoder for [FlowAnalysisRequestResultOutput]
        Decoders.addDecoder(clazz: [FlowAnalysisRequestResultOutput].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FlowAnalysisRequestResultOutput]> in
            return Decoders.decode(clazz: [FlowAnalysisRequestResultOutput].self, source: source)
        }

        // Decoder for FlowAnalysisRequestResultOutput
        Decoders.addDecoder(clazz: FlowAnalysisRequestResultOutput.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FlowAnalysisRequestResultOutput> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FlowAnalysisRequestResultOutput() : instance as! FlowAnalysisRequestResultOutput
                switch Decoders.decodeOptional(clazz: FlowAnalysisRequestResultOutputResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FlowAnalysisRequestResultOutput", actual: "\(source)"))
            }
        }
        // Decoder for [FlowAnalysisRequestResultOutputResponse]
        Decoders.addDecoder(clazz: [FlowAnalysisRequestResultOutputResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FlowAnalysisRequestResultOutputResponse]> in
            return Decoders.decode(clazz: [FlowAnalysisRequestResultOutputResponse].self, source: source)
        }

        // Decoder for FlowAnalysisRequestResultOutputResponse
        Decoders.addDecoder(clazz: FlowAnalysisRequestResultOutputResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FlowAnalysisRequestResultOutputResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FlowAnalysisRequestResultOutputResponse() : instance as! FlowAnalysisRequestResultOutputResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["flowAnalysisId"] as AnyObject?) {
                
                case let .success(value): _result.flowAnalysisId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["taskId"] as AnyObject?) {
                
                case let .success(value): _result.taskId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["url"] as AnyObject?) {
                
                case let .success(value): _result.url = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FlowAnalysisRequestResultOutputResponse", actual: "\(source)"))
            }
        }
        // Decoder for [FunctionalCapabilityListResult]
        Decoders.addDecoder(clazz: [FunctionalCapabilityListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FunctionalCapabilityListResult]> in
            return Decoders.decode(clazz: [FunctionalCapabilityListResult].self, source: source)
        }

        // Decoder for FunctionalCapabilityListResult
        Decoders.addDecoder(clazz: FunctionalCapabilityListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FunctionalCapabilityListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FunctionalCapabilityListResult() : instance as! FunctionalCapabilityListResult
                switch Decoders.decodeOptional(clazz: [FunctionalCapabilityListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FunctionalCapabilityListResult", actual: "\(source)"))
            }
        }
        // Decoder for [FunctionalCapabilityListResultFunctionDetails]
        Decoders.addDecoder(clazz: [FunctionalCapabilityListResultFunctionDetails].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FunctionalCapabilityListResultFunctionDetails]> in
            return Decoders.decode(clazz: [FunctionalCapabilityListResultFunctionDetails].self, source: source)
        }

        // Decoder for FunctionalCapabilityListResultFunctionDetails
        Decoders.addDecoder(clazz: FunctionalCapabilityListResultFunctionDetails.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FunctionalCapabilityListResultFunctionDetails> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FunctionalCapabilityListResultFunctionDetails() : instance as! FunctionalCapabilityListResultFunctionDetails
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["propertyName"] as AnyObject?) {
                
                case let .success(value): _result.propertyName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["stringValue"] as AnyObject?) {
                
                case let .success(value): _result.stringValue = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FunctionalCapabilityListResultFunctionDetails", actual: "\(source)"))
            }
        }
        // Decoder for [FunctionalCapabilityListResultFunctionalCapability]
        Decoders.addDecoder(clazz: [FunctionalCapabilityListResultFunctionalCapability].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FunctionalCapabilityListResultFunctionalCapability]> in
            return Decoders.decode(clazz: [FunctionalCapabilityListResultFunctionalCapability].self, source: source)
        }

        // Decoder for FunctionalCapabilityListResultFunctionalCapability
        Decoders.addDecoder(clazz: FunctionalCapabilityListResultFunctionalCapability.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FunctionalCapabilityListResultFunctionalCapability> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FunctionalCapabilityListResultFunctionalCapability() : instance as! FunctionalCapabilityListResultFunctionalCapability
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [FunctionalCapabilityListResultFunctionDetails].self, source: sourceDictionary["functionDetails"] as AnyObject?) {
                
                case let .success(value): _result.functionDetails = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["functionName"] as AnyObject?) {
                
                case let .success(value): _result.functionName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: FunctionalCapabilityListResultFunctionalCapability.FunctionOpState.self, source: sourceDictionary["functionOpState"] as AnyObject?) {
                
                case let .success(value): _result.functionOpState = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FunctionalCapabilityListResultFunctionalCapability", actual: "\(source)"))
            }
        }
        // Decoder for [FunctionalCapabilityListResultResponse]
        Decoders.addDecoder(clazz: [FunctionalCapabilityListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FunctionalCapabilityListResultResponse]> in
            return Decoders.decode(clazz: [FunctionalCapabilityListResultResponse].self, source: source)
        }

        // Decoder for FunctionalCapabilityListResultResponse
        Decoders.addDecoder(clazz: FunctionalCapabilityListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FunctionalCapabilityListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FunctionalCapabilityListResultResponse() : instance as! FunctionalCapabilityListResultResponse
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceId"] as AnyObject?) {
                
                case let .success(value): _result.deviceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [FunctionalCapabilityListResultFunctionalCapability].self, source: sourceDictionary["functionalCapability"] as AnyObject?) {
                
                case let .success(value): _result.functionalCapability = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FunctionalCapabilityListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [FunctionalCapabilityResult]
        Decoders.addDecoder(clazz: [FunctionalCapabilityResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[FunctionalCapabilityResult]> in
            return Decoders.decode(clazz: [FunctionalCapabilityResult].self, source: source)
        }

        // Decoder for FunctionalCapabilityResult
        Decoders.addDecoder(clazz: FunctionalCapabilityResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<FunctionalCapabilityResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? FunctionalCapabilityResult() : instance as! FunctionalCapabilityResult
                switch Decoders.decodeOptional(clazz: FunctionalCapabilityListResultFunctionalCapability.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "FunctionalCapabilityResult", actual: "\(source)"))
            }
        }
        // Decoder for [GenerateTokenRequest]
        Decoders.addDecoder(clazz: [GenerateTokenRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GenerateTokenRequest]> in
            return Decoders.decode(clazz: [GenerateTokenRequest].self, source: source)
        }

        // Decoder for GenerateTokenRequest
        Decoders.addDecoder(clazz: GenerateTokenRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GenerateTokenRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? GenerateTokenRequest() : instance as! GenerateTokenRequest
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["Token"] as AnyObject?) {
                
                case let .success(value): _result.token = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "GenerateTokenRequest", actual: "\(source)"))
            }
        }
        // Decoder for [GenerateTokenResponse]
        Decoders.addDecoder(clazz: [GenerateTokenResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GenerateTokenResponse]> in
            return Decoders.decode(clazz: [GenerateTokenResponse].self, source: source)
        }

        // Decoder for GenerateTokenResponse
        Decoders.addDecoder(clazz: GenerateTokenResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GenerateTokenResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? GenerateTokenResponse() : instance as! GenerateTokenResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["Token"] as AnyObject?) {
                
                case let .success(value): _result.token = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "GenerateTokenResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetCategorizedDeviceCountResponse]
        Decoders.addDecoder(clazz: [GetCategorizedDeviceCountResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetCategorizedDeviceCountResponse]> in
            return Decoders.decode(clazz: [GetCategorizedDeviceCountResponse].self, source: source)
        }

        // Decoder for GetCategorizedDeviceCountResponse
        Decoders.addDecoder(clazz: GetCategorizedDeviceCountResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetCategorizedDeviceCountResponse> in
            if let source = source as? GetCategorizedDeviceCountResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetCategorizedDeviceCountResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetDeviceByIDResponse]
        Decoders.addDecoder(clazz: [GetDeviceByIDResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetDeviceByIDResponse]> in
            return Decoders.decode(clazz: [GetDeviceByIDResponse].self, source: source)
        }

        // Decoder for GetDeviceByIDResponse
        Decoders.addDecoder(clazz: GetDeviceByIDResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetDeviceByIDResponse> in
            if let source = source as? GetDeviceByIDResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetDeviceByIDResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetDeviceCountResponse]
        Decoders.addDecoder(clazz: [GetDeviceCountResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetDeviceCountResponse]> in
            return Decoders.decode(clazz: [GetDeviceCountResponse].self, source: source)
        }

        // Decoder for GetDeviceCountResponse
        Decoders.addDecoder(clazz: GetDeviceCountResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetDeviceCountResponse> in
            if let source = source as? GetDeviceCountResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetDeviceCountResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetDeviceHistoryResponse]
        Decoders.addDecoder(clazz: [GetDeviceHistoryResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetDeviceHistoryResponse]> in
            return Decoders.decode(clazz: [GetDeviceHistoryResponse].self, source: source)
        }

        // Decoder for GetDeviceHistoryResponse
        Decoders.addDecoder(clazz: GetDeviceHistoryResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetDeviceHistoryResponse> in
            if let source = source as? GetDeviceHistoryResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetDeviceHistoryResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetSmartAccountListResponse]
        Decoders.addDecoder(clazz: [GetSmartAccountListResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetSmartAccountListResponse]> in
            return Decoders.decode(clazz: [GetSmartAccountListResponse].self, source: source)
        }

        // Decoder for GetSmartAccountListResponse
        Decoders.addDecoder(clazz: GetSmartAccountListResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetSmartAccountListResponse> in
            if let source = source as? GetSmartAccountListResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetSmartAccountListResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetSyncResultForVirtualAccountResponse]
        Decoders.addDecoder(clazz: [GetSyncResultForVirtualAccountResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetSyncResultForVirtualAccountResponse]> in
            return Decoders.decode(clazz: [GetSyncResultForVirtualAccountResponse].self, source: source)
        }

        // Decoder for GetSyncResultForVirtualAccountResponse
        Decoders.addDecoder(clazz: GetSyncResultForVirtualAccountResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetSyncResultForVirtualAccountResponse> in
            if let source = source as? GetSyncResultForVirtualAccountResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetSyncResultForVirtualAccountResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetVirtualAccountListResponse]
        Decoders.addDecoder(clazz: [GetVirtualAccountListResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetVirtualAccountListResponse]> in
            return Decoders.decode(clazz: [GetVirtualAccountListResponse].self, source: source)
        }

        // Decoder for GetVirtualAccountListResponse
        Decoders.addDecoder(clazz: GetVirtualAccountListResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetVirtualAccountListResponse> in
            if let source = source as? GetVirtualAccountListResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetVirtualAccountListResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetWorkflowCountResponse]
        Decoders.addDecoder(clazz: [GetWorkflowCountResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetWorkflowCountResponse]> in
            return Decoders.decode(clazz: [GetWorkflowCountResponse].self, source: source)
        }

        // Decoder for GetWorkflowCountResponse
        Decoders.addDecoder(clazz: GetWorkflowCountResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetWorkflowCountResponse> in
            if let source = source as? GetWorkflowCountResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetWorkflowCountResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GetWorkflowResponse]
        Decoders.addDecoder(clazz: [GetWorkflowResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GetWorkflowResponse]> in
            return Decoders.decode(clazz: [GetWorkflowResponse].self, source: source)
        }

        // Decoder for GetWorkflowResponse
        Decoders.addDecoder(clazz: GetWorkflowResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GetWorkflowResponse> in
            if let source = source as? GetWorkflowResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias GetWorkflowResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GlobalCredentialListResult]
        Decoders.addDecoder(clazz: [GlobalCredentialListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GlobalCredentialListResult]> in
            return Decoders.decode(clazz: [GlobalCredentialListResult].self, source: source)
        }

        // Decoder for GlobalCredentialListResult
        Decoders.addDecoder(clazz: GlobalCredentialListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GlobalCredentialListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? GlobalCredentialListResult() : instance as! GlobalCredentialListResult
                switch Decoders.decodeOptional(clazz: [GlobalCredentialListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "GlobalCredentialListResult", actual: "\(source)"))
            }
        }
        // Decoder for [GlobalCredentialListResultResponse]
        Decoders.addDecoder(clazz: [GlobalCredentialListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GlobalCredentialListResultResponse]> in
            return Decoders.decode(clazz: [GlobalCredentialListResultResponse].self, source: source)
        }

        // Decoder for GlobalCredentialListResultResponse
        Decoders.addDecoder(clazz: GlobalCredentialListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GlobalCredentialListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? GlobalCredentialListResultResponse() : instance as! GlobalCredentialListResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: GlobalCredentialListResultResponse.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "GlobalCredentialListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [GlobalCredentialSubTypeResult]
        Decoders.addDecoder(clazz: [GlobalCredentialSubTypeResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[GlobalCredentialSubTypeResult]> in
            return Decoders.decode(clazz: [GlobalCredentialSubTypeResult].self, source: source)
        }

        // Decoder for GlobalCredentialSubTypeResult
        Decoders.addDecoder(clazz: GlobalCredentialSubTypeResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<GlobalCredentialSubTypeResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? GlobalCredentialSubTypeResult() : instance as! GlobalCredentialSubTypeResult
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "GlobalCredentialSubTypeResult", actual: "\(source)"))
            }
        }
        // Decoder for [HTTPReadCredentialDTOInner]
        Decoders.addDecoder(clazz: [HTTPReadCredentialDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[HTTPReadCredentialDTOInner]> in
            return Decoders.decode(clazz: [HTTPReadCredentialDTOInner].self, source: source)
        }

        // Decoder for HTTPReadCredentialDTOInner
        Decoders.addDecoder(clazz: HTTPReadCredentialDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<HTTPReadCredentialDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? HTTPReadCredentialDTOInner() : instance as! HTTPReadCredentialDTOInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPReadCredentialDTOInner.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?) {
                
                case let .success(value): _result.password = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["port"] as AnyObject?) {
                
                case let .success(value): _result.port = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["secure"] as AnyObject?) {
                
                case let .success(value): _result.secure = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?) {
                
                case let .success(value): _result.username = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "HTTPReadCredentialDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [HTTPWriteCredentialDTO]
        Decoders.addDecoder(clazz: [HTTPWriteCredentialDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[HTTPWriteCredentialDTO]> in
            return Decoders.decode(clazz: [HTTPWriteCredentialDTO].self, source: source)
        }

        // Decoder for HTTPWriteCredentialDTO
        Decoders.addDecoder(clazz: HTTPWriteCredentialDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<HTTPWriteCredentialDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? HTTPWriteCredentialDTO() : instance as! HTTPWriteCredentialDTO
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPWriteCredentialDTO.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?) {
                
                case let .success(value): _result.password = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["port"] as AnyObject?) {
                
                case let .success(value): _result.port = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["secure"] as AnyObject?) {
                
                case let .success(value): _result.secure = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?) {
                
                case let .success(value): _result.username = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "HTTPWriteCredentialDTO", actual: "\(source)"))
            }
        }
        // Decoder for [ImageImportFromUrlDTOInner]
        Decoders.addDecoder(clazz: [ImageImportFromUrlDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ImageImportFromUrlDTOInner]> in
            return Decoders.decode(clazz: [ImageImportFromUrlDTOInner].self, source: source)
        }

        // Decoder for ImageImportFromUrlDTOInner
        Decoders.addDecoder(clazz: ImageImportFromUrlDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ImageImportFromUrlDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ImageImportFromUrlDTOInner() : instance as! ImageImportFromUrlDTOInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["applicationType"] as AnyObject?) {
                
                case let .success(value): _result.applicationType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageFamily"] as AnyObject?) {
                
                case let .success(value): _result.imageFamily = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourceURL"] as AnyObject?) {
                
                case let .success(value): _result.sourceURL = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["thirdParty"] as AnyObject?) {
                
                case let .success(value): _result.thirdParty = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vendor"] as AnyObject?) {
                
                case let .success(value): _result.vendor = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ImageImportFromUrlDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [ImageInfoListResponse]
        Decoders.addDecoder(clazz: [ImageInfoListResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ImageInfoListResponse]> in
            return Decoders.decode(clazz: [ImageInfoListResponse].self, source: source)
        }

        // Decoder for ImageInfoListResponse
        Decoders.addDecoder(clazz: ImageInfoListResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ImageInfoListResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ImageInfoListResponse() : instance as! ImageInfoListResponse
                switch Decoders.decodeOptional(clazz: [ImageInfoListResponseResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ImageInfoListResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ImageInfoListResponseApplicableDevicesForImage]
        Decoders.addDecoder(clazz: [ImageInfoListResponseApplicableDevicesForImage].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ImageInfoListResponseApplicableDevicesForImage]> in
            return Decoders.decode(clazz: [ImageInfoListResponseApplicableDevicesForImage].self, source: source)
        }

        // Decoder for ImageInfoListResponseApplicableDevicesForImage
        Decoders.addDecoder(clazz: ImageInfoListResponseApplicableDevicesForImage.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ImageInfoListResponseApplicableDevicesForImage> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ImageInfoListResponseApplicableDevicesForImage() : instance as! ImageInfoListResponseApplicableDevicesForImage
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mdfId"] as AnyObject?) {
                
                case let .success(value): _result.mdfId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["productId"] as AnyObject?) {
                
                case let .success(value): _result.productId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["productName"] as AnyObject?) {
                
                case let .success(value): _result.productName = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ImageInfoListResponseApplicableDevicesForImage", actual: "\(source)"))
            }
        }
        // Decoder for [ImageInfoListResponseProfileInfo]
        Decoders.addDecoder(clazz: [ImageInfoListResponseProfileInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ImageInfoListResponseProfileInfo]> in
            return Decoders.decode(clazz: [ImageInfoListResponseProfileInfo].self, source: source)
        }

        // Decoder for ImageInfoListResponseProfileInfo
        Decoders.addDecoder(clazz: ImageInfoListResponseProfileInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ImageInfoListResponseProfileInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ImageInfoListResponseProfileInfo() : instance as! ImageInfoListResponseProfileInfo
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["extendedAttributes"] as AnyObject?) {
                
                case let .success(value): _result.extendedAttributes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["memory"] as AnyObject?) {
                
                case let .success(value): _result.memory = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["productType"] as AnyObject?) {
                
                case let .success(value): _result.productType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["profileName"] as AnyObject?) {
                
                case let .success(value): _result.profileName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["shares"] as AnyObject?) {
                
                case let .success(value): _result.shares = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["vCpu"] as AnyObject?) {
                
                case let .success(value): _result.vCpu = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ImageInfoListResponseProfileInfo", actual: "\(source)"))
            }
        }
        // Decoder for [ImageInfoListResponseResponse]
        Decoders.addDecoder(clazz: [ImageInfoListResponseResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ImageInfoListResponseResponse]> in
            return Decoders.decode(clazz: [ImageInfoListResponseResponse].self, source: source)
        }

        // Decoder for ImageInfoListResponseResponse
        Decoders.addDecoder(clazz: ImageInfoListResponseResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ImageInfoListResponseResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ImageInfoListResponseResponse() : instance as! ImageInfoListResponseResponse
                switch Decoders.decodeOptional(clazz: [ImageInfoListResponseApplicableDevicesForImage].self, source: sourceDictionary["applicableDevicesForImage"] as AnyObject?) {
                
                case let .success(value): _result.applicableDevicesForImage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["applicationType"] as AnyObject?) {
                
                case let .success(value): _result.applicationType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["createdTime"] as AnyObject?) {
                
                case let .success(value): _result.createdTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["extendedAttributes"] as AnyObject?) {
                
                case let .success(value): _result.extendedAttributes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["family"] as AnyObject?) {
                
                case let .success(value): _result.family = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["feature"] as AnyObject?) {
                
                case let .success(value): _result.feature = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["fileServiceId"] as AnyObject?) {
                
                case let .success(value): _result.fileServiceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["fileSize"] as AnyObject?) {
                
                case let .success(value): _result.fileSize = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageIntegrityStatus"] as AnyObject?) {
                
                case let .success(value): _result.imageIntegrityStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageName"] as AnyObject?) {
                
                case let .success(value): _result.imageName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["imageSeries"] as AnyObject?) {
                
                case let .success(value): _result.imageSeries = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageSource"] as AnyObject?) {
                
                case let .success(value): _result.imageSource = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageType"] as AnyObject?) {
                
                case let .success(value): _result.imageType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageUuid"] as AnyObject?) {
                
                case let .success(value): _result.imageUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: ImageInfoListResponseResponse.ImportSourceType.self, source: sourceDictionary["importSourceType"] as AnyObject?) {
                
                case let .success(value): _result.importSourceType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isTaggedGolden"] as AnyObject?) {
                
                case let .success(value): _result.isTaggedGolden = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["md5Checksum"] as AnyObject?) {
                
                case let .success(value): _result.md5Checksum = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [ImageInfoListResponseProfileInfo].self, source: sourceDictionary["profileInfo"] as AnyObject?) {
                
                case let .success(value): _result.profileInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["shaCheckSum"] as AnyObject?) {
                
                case let .success(value): _result.shaCheckSum = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vendor"] as AnyObject?) {
                
                case let .success(value): _result.vendor = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ImageInfoListResponseResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ImportManyDevicesResponse]
        Decoders.addDecoder(clazz: [ImportManyDevicesResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ImportManyDevicesResponse]> in
            return Decoders.decode(clazz: [ImportManyDevicesResponse].self, source: source)
        }

        // Decoder for ImportManyDevicesResponse
        Decoders.addDecoder(clazz: ImportManyDevicesResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ImportManyDevicesResponse> in
            if let source = source as? ImportManyDevicesResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias ImportManyDevicesResponse", actual: "\(source)"))
            }
        }
        // Decoder for [InventoryDeviceInfo]
        Decoders.addDecoder(clazz: [InventoryDeviceInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[InventoryDeviceInfo]> in
            return Decoders.decode(clazz: [InventoryDeviceInfo].self, source: source)
        }

        // Decoder for InventoryDeviceInfo
        Decoders.addDecoder(clazz: InventoryDeviceInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<InventoryDeviceInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? InventoryDeviceInfo() : instance as! InventoryDeviceInfo
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cliTransport"] as AnyObject?) {
                
                case let .success(value): _result.cliTransport = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["computeDevice"] as AnyObject?) {
                
                case let .success(value): _result.computeDevice = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["enablePassword"] as AnyObject?) {
                
                case let .success(value): _result.enablePassword = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["extendedDiscoveryInfo"] as AnyObject?) {
                
                case let .success(value): _result.extendedDiscoveryInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["httpPassword"] as AnyObject?) {
                
                case let .success(value): _result.httpPassword = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["httpPort"] as AnyObject?) {
                
                case let .success(value): _result.httpPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["httpSecure"] as AnyObject?) {
                
                case let .success(value): _result.httpSecure = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["httpUserName"] as AnyObject?) {
                
                case let .success(value): _result.httpUserName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["ipAddress"] as AnyObject?) {
                
                case let .success(value): _result.ipAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["merakiOrgId"] as AnyObject?) {
                
                case let .success(value): _result.merakiOrgId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["netconfPort"] as AnyObject?) {
                
                case let .success(value): _result.netconfPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?) {
                
                case let .success(value): _result.password = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpMode"] as AnyObject?) {
                
                case let .success(value): _result.snmpMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpROCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpROCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRWCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpRWCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["snmpRetry"] as AnyObject?) {
                
                case let .success(value): _result.snmpRetry = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["snmpTimeout"] as AnyObject?) {
                
                case let .success(value): _result.snmpTimeout = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpUserName"] as AnyObject?) {
                
                case let .success(value): _result.snmpUserName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpVersion"] as AnyObject?) {
                
                case let .success(value): _result.snmpVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: InventoryDeviceInfo.ModelType.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [InventoryDeviceInfoUpdateMgmtIPaddressList].self, source: sourceDictionary["updateMgmtIPaddressList"] as AnyObject?) {
                
                case let .success(value): _result.updateMgmtIPaddressList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userName"] as AnyObject?) {
                
                case let .success(value): _result.userName = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "InventoryDeviceInfo", actual: "\(source)"))
            }
        }
        // Decoder for [InventoryDeviceInfoUpdateMgmtIPaddressList]
        Decoders.addDecoder(clazz: [InventoryDeviceInfoUpdateMgmtIPaddressList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[InventoryDeviceInfoUpdateMgmtIPaddressList]> in
            return Decoders.decode(clazz: [InventoryDeviceInfoUpdateMgmtIPaddressList].self, source: source)
        }

        // Decoder for InventoryDeviceInfoUpdateMgmtIPaddressList
        Decoders.addDecoder(clazz: InventoryDeviceInfoUpdateMgmtIPaddressList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<InventoryDeviceInfoUpdateMgmtIPaddressList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? InventoryDeviceInfoUpdateMgmtIPaddressList() : instance as! InventoryDeviceInfoUpdateMgmtIPaddressList
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["existMgmtIpAddress"] as AnyObject?) {
                
                case let .success(value): _result.existMgmtIpAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["newMgmtIpAddress"] as AnyObject?) {
                
                case let .success(value): _result.newMgmtIpAddress = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "InventoryDeviceInfoUpdateMgmtIPaddressList", actual: "\(source)"))
            }
        }
        // Decoder for [InventoryRequest]
        Decoders.addDecoder(clazz: [InventoryRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[InventoryRequest]> in
            return Decoders.decode(clazz: [InventoryRequest].self, source: source)
        }

        // Decoder for InventoryRequest
        Decoders.addDecoder(clazz: InventoryRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<InventoryRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? InventoryRequest() : instance as! InventoryRequest
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["cdpLevel"] as AnyObject?) {
                
                case let .success(value): _result.cdpLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["discoveryType"] as AnyObject?) {
                
                case let .success(value): _result.discoveryType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["enablePasswordList"] as AnyObject?) {
                
                case let .success(value): _result.enablePasswordList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["globalCredentialIdList"] as AnyObject?) {
                
                case let .success(value): _result.globalCredentialIdList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPReadCredentialDTOInner.self, source: sourceDictionary["httpReadCredential"] as AnyObject?) {
                
                case let .success(value): _result.httpReadCredential = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: HTTPReadCredentialDTOInner.self, source: sourceDictionary["httpWriteCredential"] as AnyObject?) {
                
                case let .success(value): _result.httpWriteCredential = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipAddressList"] as AnyObject?) {
                
                case let .success(value): _result.ipAddressList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["ipFilterList"] as AnyObject?) {
                
                case let .success(value): _result.ipFilterList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lldpLevel"] as AnyObject?) {
                
                case let .success(value): _result.lldpLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["netconfPort"] as AnyObject?) {
                
                case let .success(value): _result.netconfPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["noAddNewDevice"] as AnyObject?) {
                
                case let .success(value): _result.noAddNewDevice = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentDiscoveryId"] as AnyObject?) {
                
                case let .success(value): _result.parentDiscoveryId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["passwordList"] as AnyObject?) {
                
                case let .success(value): _result.passwordList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["preferredMgmtIPMethod"] as AnyObject?) {
                
                case let .success(value): _result.preferredMgmtIPMethod = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocolOrder"] as AnyObject?) {
                
                case let .success(value): _result.protocolOrder = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["reDiscovery"] as AnyObject?) {
                
                case let .success(value): _result.reDiscovery = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["retry"] as AnyObject?) {
                
                case let .success(value): _result.retry = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpAuthProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpAuthProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpMode"] as AnyObject?) {
                
                case let .success(value): _result.snmpMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivPassphrase"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivPassphrase = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpPrivProtocol"] as AnyObject?) {
                
                case let .success(value): _result.snmpPrivProtocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpROCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpROCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpROCommunityDesc"] as AnyObject?) {
                
                case let .success(value): _result.snmpROCommunityDesc = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRWCommunity"] as AnyObject?) {
                
                case let .success(value): _result.snmpRWCommunity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpRWCommunityDesc"] as AnyObject?) {
                
                case let .success(value): _result.snmpRWCommunityDesc = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpUserName"] as AnyObject?) {
                
                case let .success(value): _result.snmpUserName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpVersion"] as AnyObject?) {
                
                case let .success(value): _result.snmpVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["timeout"] as AnyObject?) {
                
                case let .success(value): _result.timeout = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["updateMgmtIp"] as AnyObject?) {
                
                case let .success(value): _result.updateMgmtIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["userNameList"] as AnyObject?) {
                
                case let .success(value): _result.userNameList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "InventoryRequest", actual: "\(source)"))
            }
        }
        // Decoder for [LegitCliKeyResult]
        Decoders.addDecoder(clazz: [LegitCliKeyResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[LegitCliKeyResult]> in
            return Decoders.decode(clazz: [LegitCliKeyResult].self, source: source)
        }

        // Decoder for LegitCliKeyResult
        Decoders.addDecoder(clazz: LegitCliKeyResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<LegitCliKeyResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? LegitCliKeyResult() : instance as! LegitCliKeyResult
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "LegitCliKeyResult", actual: "\(source)"))
            }
        }
        // Decoder for [ListDevicesResponse]
        Decoders.addDecoder(clazz: [ListDevicesResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ListDevicesResponse]> in
            return Decoders.decode(clazz: [ListDevicesResponse].self, source: source)
        }

        // Decoder for ListDevicesResponse
        Decoders.addDecoder(clazz: ListDevicesResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ListDevicesResponse> in
            if let source = source as? ListDevicesResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias ListDevicesResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ListWorkflowsResponse]
        Decoders.addDecoder(clazz: [ListWorkflowsResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ListWorkflowsResponse]> in
            return Decoders.decode(clazz: [ListWorkflowsResponse].self, source: source)
        }

        // Decoder for ListWorkflowsResponse
        Decoders.addDecoder(clazz: ListWorkflowsResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ListWorkflowsResponse> in
            if let source = source as? ListWorkflowsResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias ListWorkflowsResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ModuleListResult]
        Decoders.addDecoder(clazz: [ModuleListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ModuleListResult]> in
            return Decoders.decode(clazz: [ModuleListResult].self, source: source)
        }

        // Decoder for ModuleListResult
        Decoders.addDecoder(clazz: ModuleListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ModuleListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ModuleListResult() : instance as! ModuleListResult
                switch Decoders.decodeOptional(clazz: [ModuleResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ModuleListResult", actual: "\(source)"))
            }
        }
        // Decoder for [ModuleResult]
        Decoders.addDecoder(clazz: [ModuleResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ModuleResult]> in
            return Decoders.decode(clazz: [ModuleResult].self, source: source)
        }

        // Decoder for ModuleResult
        Decoders.addDecoder(clazz: ModuleResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ModuleResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ModuleResult() : instance as! ModuleResult
                switch Decoders.decodeOptional(clazz: ModuleResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ModuleResult", actual: "\(source)"))
            }
        }
        // Decoder for [ModuleResultResponse]
        Decoders.addDecoder(clazz: [ModuleResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ModuleResultResponse]> in
            return Decoders.decode(clazz: [ModuleResultResponse].self, source: source)
        }

        // Decoder for ModuleResultResponse
        Decoders.addDecoder(clazz: ModuleResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ModuleResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ModuleResultResponse() : instance as! ModuleResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["assemblyNumber"] as AnyObject?) {
                
                case let .success(value): _result.assemblyNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["assemblyRevision"] as AnyObject?) {
                
                case let .success(value): _result.assemblyRevision = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["containmentEntity"] as AnyObject?) {
                
                case let .success(value): _result.containmentEntity = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["entityPhysicalIndex"] as AnyObject?) {
                
                case let .success(value): _result.entityPhysicalIndex = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: ModuleResultResponse.IsFieldReplaceable.self, source: sourceDictionary["isFieldReplaceable"] as AnyObject?) {
                
                case let .success(value): _result.isFieldReplaceable = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: ModuleResultResponse.IsReportingAlarmsAllowed.self, source: sourceDictionary["isReportingAlarmsAllowed"] as AnyObject?) {
                
                case let .success(value): _result.isReportingAlarmsAllowed = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["manufacturer"] as AnyObject?) {
                
                case let .success(value): _result.manufacturer = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["moduleIndex"] as AnyObject?) {
                
                case let .success(value): _result.moduleIndex = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["operationalStateCode"] as AnyObject?) {
                
                case let .success(value): _result.operationalStateCode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["partNumber"] as AnyObject?) {
                
                case let .success(value): _result.partNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vendorEquipmentType"] as AnyObject?) {
                
                case let .success(value): _result.vendorEquipmentType = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ModuleResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [NameSpaceListResult]
        Decoders.addDecoder(clazz: [NameSpaceListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NameSpaceListResult]> in
            return Decoders.decode(clazz: [NameSpaceListResult].self, source: source)
        }

        // Decoder for NameSpaceListResult
        Decoders.addDecoder(clazz: NameSpaceListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NameSpaceListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NameSpaceListResult() : instance as! NameSpaceListResult
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NameSpaceListResult", actual: "\(source)"))
            }
        }
        // Decoder for [NetconfCredentialDTOInner]
        Decoders.addDecoder(clazz: [NetconfCredentialDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetconfCredentialDTOInner]> in
            return Decoders.decode(clazz: [NetconfCredentialDTOInner].self, source: source)
        }

        // Decoder for NetconfCredentialDTOInner
        Decoders.addDecoder(clazz: NetconfCredentialDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetconfCredentialDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetconfCredentialDTOInner() : instance as! NetconfCredentialDTOInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: NetconfCredentialDTOInner.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["netconfPort"] as AnyObject?) {
                
                case let .success(value): _result.netconfPort = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetconfCredentialDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceBriefNIO]
        Decoders.addDecoder(clazz: [NetworkDeviceBriefNIO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceBriefNIO]> in
            return Decoders.decode(clazz: [NetworkDeviceBriefNIO].self, source: source)
        }

        // Decoder for NetworkDeviceBriefNIO
        Decoders.addDecoder(clazz: NetworkDeviceBriefNIO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceBriefNIO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceBriefNIO() : instance as! NetworkDeviceBriefNIO
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["roleSource"] as AnyObject?) {
                
                case let .success(value): _result.roleSource = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceBriefNIO", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceBriefNIOResult]
        Decoders.addDecoder(clazz: [NetworkDeviceBriefNIOResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceBriefNIOResult]> in
            return Decoders.decode(clazz: [NetworkDeviceBriefNIOResult].self, source: source)
        }

        // Decoder for NetworkDeviceBriefNIOResult
        Decoders.addDecoder(clazz: NetworkDeviceBriefNIOResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceBriefNIOResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceBriefNIOResult() : instance as! NetworkDeviceBriefNIOResult
                switch Decoders.decodeOptional(clazz: NetworkDeviceBriefNIOResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceBriefNIOResult", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceBriefNIOResultResponse]
        Decoders.addDecoder(clazz: [NetworkDeviceBriefNIOResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceBriefNIOResultResponse]> in
            return Decoders.decode(clazz: [NetworkDeviceBriefNIOResultResponse].self, source: source)
        }

        // Decoder for NetworkDeviceBriefNIOResultResponse
        Decoders.addDecoder(clazz: NetworkDeviceBriefNIOResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceBriefNIOResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceBriefNIOResultResponse() : instance as! NetworkDeviceBriefNIOResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["roleSource"] as AnyObject?) {
                
                case let .success(value): _result.roleSource = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceBriefNIOResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceDetailResponse]
        Decoders.addDecoder(clazz: [NetworkDeviceDetailResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceDetailResponse]> in
            return Decoders.decode(clazz: [NetworkDeviceDetailResponse].self, source: source)
        }

        // Decoder for NetworkDeviceDetailResponse
        Decoders.addDecoder(clazz: NetworkDeviceDetailResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceDetailResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceDetailResponse() : instance as! NetworkDeviceDetailResponse
                switch Decoders.decodeOptional(clazz: NetworkDeviceDetailResponseResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceDetailResponse", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceDetailResponseResponse]
        Decoders.addDecoder(clazz: [NetworkDeviceDetailResponseResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceDetailResponseResponse]> in
            return Decoders.decode(clazz: [NetworkDeviceDetailResponseResponse].self, source: source)
        }

        // Decoder for NetworkDeviceDetailResponseResponse
        Decoders.addDecoder(clazz: NetworkDeviceDetailResponseResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceDetailResponseResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceDetailResponseResponse() : instance as! NetworkDeviceDetailResponseResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["managementIpAddr"] as AnyObject?) {
                
                case let .success(value): _result.managementIpAddr = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nwDeviceName"] as AnyObject?) {
                
                case let .success(value): _result.nwDeviceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["opState"] as AnyObject?) {
                
                case let .success(value): _result.opState = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["platformId"] as AnyObject?) {
                
                case let .success(value): _result.platformId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nwDeviceId"] as AnyObject?) {
                
                case let .success(value): _result.nwDeviceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sysUptime"] as AnyObject?) {
                
                case let .success(value): _result.sysUptime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mode"] as AnyObject?) {
                
                case let .success(value): _result.mode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["resetReason"] as AnyObject?) {
                
                case let .success(value): _result.resetReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nwDeviceRole"] as AnyObject?) {
                
                case let .success(value): _result.nwDeviceRole = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["upTime"] as AnyObject?) {
                
                case let .success(value): _result.upTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nwDeviceFamily"] as AnyObject?) {
                
                case let .success(value): _result.nwDeviceFamily = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["connectedTime"] as AnyObject?) {
                
                case let .success(value): _result.connectedTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.softwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["subMode"] as AnyObject?) {
                
                case let .success(value): _result.subMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nwDeviceType"] as AnyObject?) {
                
                case let .success(value): _result.nwDeviceType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["overallHealth"] as AnyObject?) {
                
                case let .success(value): _result.overallHealth = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["memoryScore"] as AnyObject?) {
                
                case let .success(value): _result.memoryScore = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cpuScore"] as AnyObject?) {
                
                case let .success(value): _result.cpuScore = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceDetailResponseResponse", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceListResult]
        Decoders.addDecoder(clazz: [NetworkDeviceListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceListResult]> in
            return Decoders.decode(clazz: [NetworkDeviceListResult].self, source: source)
        }

        // Decoder for NetworkDeviceListResult
        Decoders.addDecoder(clazz: NetworkDeviceListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceListResult() : instance as! NetworkDeviceListResult
                switch Decoders.decodeOptional(clazz: [NetworkDeviceListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceListResult", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceListResultResponse]
        Decoders.addDecoder(clazz: [NetworkDeviceListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceListResultResponse]> in
            return Decoders.decode(clazz: [NetworkDeviceListResultResponse].self, source: source)
        }

        // Decoder for NetworkDeviceListResultResponse
        Decoders.addDecoder(clazz: NetworkDeviceListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceListResultResponse() : instance as! NetworkDeviceListResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["apManagerInterfaceIp"] as AnyObject?) {
                
                case let .success(value): _result.apManagerInterfaceIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["associatedWlcIp"] as AnyObject?) {
                
                case let .success(value): _result.associatedWlcIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bootDateTime"] as AnyObject?) {
                
                case let .success(value): _result.bootDateTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["collectionInterval"] as AnyObject?) {
                
                case let .success(value): _result.collectionInterval = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["collectionStatus"] as AnyObject?) {
                
                case let .success(value): _result.collectionStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["errorCode"] as AnyObject?) {
                
                case let .success(value): _result.errorCode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["errorDescription"] as AnyObject?) {
                
                case let .success(value): _result.errorDescription = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["family"] as AnyObject?) {
                
                case let .success(value): _result.family = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostname"] as AnyObject?) {
                
                case let .success(value): _result.hostname = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceCount"] as AnyObject?) {
                
                case let .success(value): _result.interfaceCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["inventoryStatusDetail"] as AnyObject?) {
                
                case let .success(value): _result.inventoryStatusDetail = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdateTime"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdateTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdated"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdated = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lineCardCount"] as AnyObject?) {
                
                case let .success(value): _result.lineCardCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lineCardId"] as AnyObject?) {
                
                case let .success(value): _result.lineCardId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["location"] as AnyObject?) {
                
                case let .success(value): _result.location = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["locationName"] as AnyObject?) {
                
                case let .success(value): _result.locationName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["managementIpAddress"] as AnyObject?) {
                
                case let .success(value): _result.managementIpAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["memorySize"] as AnyObject?) {
                
                case let .success(value): _result.memorySize = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["platformId"] as AnyObject?) {
                
                case let .success(value): _result.platformId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["reachabilityFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.reachabilityFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["reachabilityStatus"] as AnyObject?) {
                
                case let .success(value): _result.reachabilityStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["roleSource"] as AnyObject?) {
                
                case let .success(value): _result.roleSource = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["series"] as AnyObject?) {
                
                case let .success(value): _result.series = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpContact"] as AnyObject?) {
                
                case let .success(value): _result.snmpContact = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpLocation"] as AnyObject?) {
                
                case let .success(value): _result.snmpLocation = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareType"] as AnyObject?) {
                
                case let .success(value): _result.softwareType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.softwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tagCount"] as AnyObject?) {
                
                case let .success(value): _result.tagCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tunnelUdpPort"] as AnyObject?) {
                
                case let .success(value): _result.tunnelUdpPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["upTime"] as AnyObject?) {
                
                case let .success(value): _result.upTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["waasDeviceMode"] as AnyObject?) {
                
                case let .success(value): _result.waasDeviceMode = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceNIOListResult]
        Decoders.addDecoder(clazz: [NetworkDeviceNIOListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceNIOListResult]> in
            return Decoders.decode(clazz: [NetworkDeviceNIOListResult].self, source: source)
        }

        // Decoder for NetworkDeviceNIOListResult
        Decoders.addDecoder(clazz: NetworkDeviceNIOListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceNIOListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceNIOListResult() : instance as! NetworkDeviceNIOListResult
                switch Decoders.decodeOptional(clazz: [NetworkDeviceNIOListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceNIOListResult", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceNIOListResultResponse]
        Decoders.addDecoder(clazz: [NetworkDeviceNIOListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceNIOListResultResponse]> in
            return Decoders.decode(clazz: [NetworkDeviceNIOListResultResponse].self, source: source)
        }

        // Decoder for NetworkDeviceNIOListResultResponse
        Decoders.addDecoder(clazz: NetworkDeviceNIOListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceNIOListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceNIOListResultResponse() : instance as! NetworkDeviceNIOListResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["anchorWlcForAp"] as AnyObject?) {
                
                case let .success(value): _result.anchorWlcForAp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["authModelId"] as AnyObject?) {
                
                case let .success(value): _result.authModelId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["avgUpdateFrequency"] as AnyObject?) {
                
                case let .success(value): _result.avgUpdateFrequency = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bootDateTime"] as AnyObject?) {
                
                case let .success(value): _result.bootDateTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cliStatus"] as AnyObject?) {
                
                case let .success(value): _result.cliStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["duplicateDeviceId"] as AnyObject?) {
                
                case let .success(value): _result.duplicateDeviceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["errorCode"] as AnyObject?) {
                
                case let .success(value): _result.errorCode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["errorDescription"] as AnyObject?) {
                
                case let .success(value): _result.errorDescription = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["family"] as AnyObject?) {
                
                case let .success(value): _result.family = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostname"] as AnyObject?) {
                
                case let .success(value): _result.hostname = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["httpStatus"] as AnyObject?) {
                
                case let .success(value): _result.httpStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageName"] as AnyObject?) {
                
                case let .success(value): _result.imageName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ingressQueueConfig"] as AnyObject?) {
                
                case let .success(value): _result.ingressQueueConfig = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceCount"] as AnyObject?) {
                
                case let .success(value): _result.interfaceCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["inventoryCollectionStatus"] as AnyObject?) {
                
                case let .success(value): _result.inventoryCollectionStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["inventoryReachabilityStatus"] as AnyObject?) {
                
                case let .success(value): _result.inventoryReachabilityStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdated"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdated = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lineCardCount"] as AnyObject?) {
                
                case let .success(value): _result.lineCardCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lineCardId"] as AnyObject?) {
                
                case let .success(value): _result.lineCardId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["location"] as AnyObject?) {
                
                case let .success(value): _result.location = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["locationName"] as AnyObject?) {
                
                case let .success(value): _result.locationName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["managementIpAddress"] as AnyObject?) {
                
                case let .success(value): _result.managementIpAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["memorySize"] as AnyObject?) {
                
                case let .success(value): _result.memorySize = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["netconfStatus"] as AnyObject?) {
                
                case let .success(value): _result.netconfStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["numUpdates"] as AnyObject?) {
                
                case let .success(value): _result.numUpdates = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["pingStatus"] as AnyObject?) {
                
                case let .success(value): _result.pingStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["platformId"] as AnyObject?) {
                
                case let .success(value): _result.platformId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["portRange"] as AnyObject?) {
                
                case let .success(value): _result.portRange = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["qosStatus"] as AnyObject?) {
                
                case let .success(value): _result.qosStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["reachabilityFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.reachabilityFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["reachabilityStatus"] as AnyObject?) {
                
                case let .success(value): _result.reachabilityStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["roleSource"] as AnyObject?) {
                
                case let .success(value): _result.roleSource = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpContact"] as AnyObject?) {
                
                case let .success(value): _result.snmpContact = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpLocation"] as AnyObject?) {
                
                case let .success(value): _result.snmpLocation = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmpStatus"] as AnyObject?) {
                
                case let .success(value): _result.snmpStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.softwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tag"] as AnyObject?) {
                
                case let .success(value): _result.tag = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["tagCount"] as AnyObject?) {
                
                case let .success(value): _result.tagCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["upTime"] as AnyObject?) {
                
                case let .success(value): _result.upTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vendor"] as AnyObject?) {
                
                case let .success(value): _result.vendor = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wlcApDeviceStatus"] as AnyObject?) {
                
                case let .success(value): _result.wlcApDeviceStatus = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceNIOListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [NetworkDeviceResult]
        Decoders.addDecoder(clazz: [NetworkDeviceResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[NetworkDeviceResult]> in
            return Decoders.decode(clazz: [NetworkDeviceResult].self, source: source)
        }

        // Decoder for NetworkDeviceResult
        Decoders.addDecoder(clazz: NetworkDeviceResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<NetworkDeviceResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? NetworkDeviceResult() : instance as! NetworkDeviceResult
                switch Decoders.decodeOptional(clazz: NetworkDeviceListResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "NetworkDeviceResult", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResult]
        Decoders.addDecoder(clazz: [PathResponseResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResult]> in
            return Decoders.decode(clazz: [PathResponseResult].self, source: source)
        }

        // Decoder for PathResponseResult
        Decoders.addDecoder(clazz: PathResponseResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResult() : instance as! PathResponseResult
                switch Decoders.decodeOptional(clazz: PathResponseResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResult", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponse]
        Decoders.addDecoder(clazz: [PathResponseResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponse]> in
            return Decoders.decode(clazz: [PathResponseResultResponse].self, source: source)
        }

        // Decoder for PathResponseResultResponse
        Decoders.addDecoder(clazz: PathResponseResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponse() : instance as! PathResponseResultResponse
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseDetailedStatus.self, source: sourceDictionary["detailedStatus"] as AnyObject?) {
                
                case let .success(value): _result.detailedStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdate"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdate = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseNetworkElements].self, source: sourceDictionary["networkElements"] as AnyObject?) {
                
                case let .success(value): _result.networkElements = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseNetworkElementsInfo].self, source: sourceDictionary["networkElementsInfo"] as AnyObject?) {
                
                case let .success(value): _result.networkElementsInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["properties"] as AnyObject?) {
                
                case let .success(value): _result.properties = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: FlowAnalysisListOutputResponse.self, source: sourceDictionary["request"] as AnyObject?) {
                
                case let .success(value): _result.request = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseAccuracyList]
        Decoders.addDecoder(clazz: [PathResponseResultResponseAccuracyList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseAccuracyList]> in
            return Decoders.decode(clazz: [PathResponseResultResponseAccuracyList].self, source: source)
        }

        // Decoder for PathResponseResultResponseAccuracyList
        Decoders.addDecoder(clazz: PathResponseResultResponseAccuracyList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseAccuracyList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseAccuracyList() : instance as! PathResponseResultResponseAccuracyList
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["percent"] as AnyObject?) {
                
                case let .success(value): _result.percent = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["reason"] as AnyObject?) {
                
                case let .success(value): _result.reason = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseAccuracyList", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseDetailedStatus]
        Decoders.addDecoder(clazz: [PathResponseResultResponseDetailedStatus].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseDetailedStatus]> in
            return Decoders.decode(clazz: [PathResponseResultResponseDetailedStatus].self, source: source)
        }

        // Decoder for PathResponseResultResponseDetailedStatus
        Decoders.addDecoder(clazz: PathResponseResultResponseDetailedStatus.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseDetailedStatus> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseDetailedStatus() : instance as! PathResponseResultResponseDetailedStatus
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["aclTraceCalculation"] as AnyObject?) {
                
                case let .success(value): _result.aclTraceCalculation = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["aclTraceCalculationFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.aclTraceCalculationFailureReason = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseDetailedStatus", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseDeviceStatistics]
        Decoders.addDecoder(clazz: [PathResponseResultResponseDeviceStatistics].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseDeviceStatistics]> in
            return Decoders.decode(clazz: [PathResponseResultResponseDeviceStatistics].self, source: source)
        }

        // Decoder for PathResponseResultResponseDeviceStatistics
        Decoders.addDecoder(clazz: PathResponseResultResponseDeviceStatistics.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseDeviceStatistics> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseDeviceStatistics() : instance as! PathResponseResultResponseDeviceStatistics
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseDeviceStatisticsCpuStatistics.self, source: sourceDictionary["cpuStatistics"] as AnyObject?) {
                
                case let .success(value): _result.cpuStatistics = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseDeviceStatisticsMemoryStatistics.self, source: sourceDictionary["memoryStatistics"] as AnyObject?) {
                
                case let .success(value): _result.memoryStatistics = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseDeviceStatistics", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseDeviceStatisticsCpuStatistics]
        Decoders.addDecoder(clazz: [PathResponseResultResponseDeviceStatisticsCpuStatistics].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseDeviceStatisticsCpuStatistics]> in
            return Decoders.decode(clazz: [PathResponseResultResponseDeviceStatisticsCpuStatistics].self, source: source)
        }

        // Decoder for PathResponseResultResponseDeviceStatisticsCpuStatistics
        Decoders.addDecoder(clazz: PathResponseResultResponseDeviceStatisticsCpuStatistics.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseDeviceStatisticsCpuStatistics> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseDeviceStatisticsCpuStatistics() : instance as! PathResponseResultResponseDeviceStatisticsCpuStatistics
                switch Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["fiveMinUsageInPercentage"] as AnyObject?) {
                
                case let .success(value): _result.fiveMinUsageInPercentage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["fiveSecsUsageInPercentage"] as AnyObject?) {
                
                case let .success(value): _result.fiveSecsUsageInPercentage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["oneMinUsageInPercentage"] as AnyObject?) {
                
                case let .success(value): _result.oneMinUsageInPercentage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["refreshedAt"] as AnyObject?) {
                
                case let .success(value): _result.refreshedAt = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseDeviceStatisticsCpuStatistics", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseDeviceStatisticsMemoryStatistics]
        Decoders.addDecoder(clazz: [PathResponseResultResponseDeviceStatisticsMemoryStatistics].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseDeviceStatisticsMemoryStatistics]> in
            return Decoders.decode(clazz: [PathResponseResultResponseDeviceStatisticsMemoryStatistics].self, source: source)
        }

        // Decoder for PathResponseResultResponseDeviceStatisticsMemoryStatistics
        Decoders.addDecoder(clazz: PathResponseResultResponseDeviceStatisticsMemoryStatistics.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseDeviceStatisticsMemoryStatistics> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseDeviceStatisticsMemoryStatistics() : instance as! PathResponseResultResponseDeviceStatisticsMemoryStatistics
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["memoryUsage"] as AnyObject?) {
                
                case let .success(value): _result.memoryUsage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["refreshedAt"] as AnyObject?) {
                
                case let .success(value): _result.refreshedAt = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["totalMemory"] as AnyObject?) {
                
                case let .success(value): _result.totalMemory = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseDeviceStatisticsMemoryStatistics", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressInterface]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressInterface].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressInterface]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressInterface].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressInterface
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressInterface.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressInterface> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressInterface() : instance as! PathResponseResultResponseEgressInterface
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterface.self, source: sourceDictionary["physicalInterface"] as AnyObject?) {
                
                case let .success(value): _result.physicalInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseEgressPhysicalInterface].self, source: sourceDictionary["virtualInterface"] as AnyObject?) {
                
                case let .success(value): _result.virtualInterface = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressInterface", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterface]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterface].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterface]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterface].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterface
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterface.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterface> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterface() : instance as! PathResponseResultResponseEgressPhysicalInterface
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis.self, source: sourceDictionary["aclAnalysis"] as AnyObject?) {
                
                case let .success(value): _result.aclAnalysis = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics.self, source: sourceDictionary["interfaceStatistics"] as AnyObject?) {
                
                case let .success(value): _result.interfaceStatistics = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceStatsCollection"] as AnyObject?) {
                
                case let .success(value): _result.interfaceStatsCollection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceStatsCollectionFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.interfaceStatsCollectionFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo].self, source: sourceDictionary["pathOverlayInfo"] as AnyObject?) {
                
                case let .success(value): _result.pathOverlayInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseEgressPhysicalInterfaceQosStatistics].self, source: sourceDictionary["qosStatistics"] as AnyObject?) {
                
                case let .success(value): _result.qosStatistics = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["qosStatsCollection"] as AnyObject?) {
                
                case let .success(value): _result.qosStatsCollection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["qosStatsCollectionFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.qosStatsCollectionFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["usedVlan"] as AnyObject?) {
                
                case let .success(value): _result.usedVlan = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vrfName"] as AnyObject?) {
                
                case let .success(value): _result.vrfName = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterface", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis() : instance as! PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["aclName"] as AnyObject?) {
                
                case let .success(value): _result.aclName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces].self, source: sourceDictionary["matchingAces"] as AnyObject?) {
                
                case let .success(value): _result.matchingAces = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["result"] as AnyObject?) {
                
                case let .success(value): _result.result = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces() : instance as! PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ace"] as AnyObject?) {
                
                case let .success(value): _result.ace = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts].self, source: sourceDictionary["matchingPorts"] as AnyObject?) {
                
                case let .success(value): _result.matchingPorts = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["result"] as AnyObject?) {
                
                case let .success(value): _result.result = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingAces", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts() : instance as! PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts].self, source: sourceDictionary["ports"] as AnyObject?) {
                
                case let .success(value): _result.ports = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocol"] as AnyObject?) {
                
                case let .success(value): _result._protocol = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisMatchingPorts", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts() : instance as! PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["destPorts"] as AnyObject?) {
                
                case let .success(value): _result.destPorts = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["sourcePorts"] as AnyObject?) {
                
                case let .success(value): _result.sourcePorts = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfaceAclAnalysisPorts", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics() : instance as! PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["adminStatus"] as AnyObject?) {
                
                case let .success(value): _result.adminStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["inputPackets"] as AnyObject?) {
                
                case let .success(value): _result.inputPackets = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["inputQueueCount"] as AnyObject?) {
                
                case let .success(value): _result.inputQueueCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["inputQueueDrops"] as AnyObject?) {
                
                case let .success(value): _result.inputQueueDrops = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["inputQueueFlushes"] as AnyObject?) {
                
                case let .success(value): _result.inputQueueFlushes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["inputQueueMaxDepth"] as AnyObject?) {
                
                case let .success(value): _result.inputQueueMaxDepth = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["inputRatebps"] as AnyObject?) {
                
                case let .success(value): _result.inputRatebps = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["operationalStatus"] as AnyObject?) {
                
                case let .success(value): _result.operationalStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["outputDrop"] as AnyObject?) {
                
                case let .success(value): _result.outputDrop = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["outputPackets"] as AnyObject?) {
                
                case let .success(value): _result.outputPackets = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["outputQueueCount"] as AnyObject?) {
                
                case let .success(value): _result.outputQueueCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["outputQueueDepth"] as AnyObject?) {
                
                case let .success(value): _result.outputQueueDepth = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["outputRatebps"] as AnyObject?) {
                
                case let .success(value): _result.outputRatebps = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["refreshedAt"] as AnyObject?) {
                
                case let .success(value): _result.refreshedAt = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfaceInterfaceStatistics", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo() : instance as! PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["controlPlane"] as AnyObject?) {
                
                case let .success(value): _result.controlPlane = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dataPacketEncapsulation"] as AnyObject?) {
                
                case let .success(value): _result.dataPacketEncapsulation = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destIp"] as AnyObject?) {
                
                case let .success(value): _result.destIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destPort"] as AnyObject?) {
                
                case let .success(value): _result.destPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocol"] as AnyObject?) {
                
                case let .success(value): _result._protocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourceIp"] as AnyObject?) {
                
                case let .success(value): _result.sourceIp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourcePort"] as AnyObject?) {
                
                case let .success(value): _result.sourcePort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo.self, source: sourceDictionary["vxlanInfo"] as AnyObject?) {
                
                case let .success(value): _result.vxlanInfo = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfacePathOverlayInfo", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfaceQosStatistics]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfaceQosStatistics].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfaceQosStatistics]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfaceQosStatistics].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfaceQosStatistics
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfaceQosStatistics.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfaceQosStatistics> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfaceQosStatistics() : instance as! PathResponseResultResponseEgressPhysicalInterfaceQosStatistics
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["classMapName"] as AnyObject?) {
                
                case let .success(value): _result.classMapName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["dropRate"] as AnyObject?) {
                
                case let .success(value): _result.dropRate = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["numBytes"] as AnyObject?) {
                
                case let .success(value): _result.numBytes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["numPackets"] as AnyObject?) {
                
                case let .success(value): _result.numPackets = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["offeredRate"] as AnyObject?) {
                
                case let .success(value): _result.offeredRate = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["queueBandwidthbps"] as AnyObject?) {
                
                case let .success(value): _result.queueBandwidthbps = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["queueDepth"] as AnyObject?) {
                
                case let .success(value): _result.queueDepth = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["queueNoBufferDrops"] as AnyObject?) {
                
                case let .success(value): _result.queueNoBufferDrops = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["queueTotalDrops"] as AnyObject?) {
                
                case let .success(value): _result.queueTotalDrops = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["refreshedAt"] as AnyObject?) {
                
                case let .success(value): _result.refreshedAt = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfaceQosStatistics", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo]
        Decoders.addDecoder(clazz: [PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo]> in
            return Decoders.decode(clazz: [PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo].self, source: source)
        }

        // Decoder for PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo
        Decoders.addDecoder(clazz: PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo() : instance as! PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dscp"] as AnyObject?) {
                
                case let .success(value): _result.dscp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vnid"] as AnyObject?) {
                
                case let .success(value): _result.vnid = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseEgressPhysicalInterfaceVxlanInfo", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseFlexConnect]
        Decoders.addDecoder(clazz: [PathResponseResultResponseFlexConnect].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseFlexConnect]> in
            return Decoders.decode(clazz: [PathResponseResultResponseFlexConnect].self, source: source)
        }

        // Decoder for PathResponseResultResponseFlexConnect
        Decoders.addDecoder(clazz: PathResponseResultResponseFlexConnect.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseFlexConnect> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseFlexConnect() : instance as! PathResponseResultResponseFlexConnect
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseFlexConnect.Authentication.self, source: sourceDictionary["authentication"] as AnyObject?) {
                
                case let .success(value): _result.authentication = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseFlexConnect.DataSwitching.self, source: sourceDictionary["dataSwitching"] as AnyObject?) {
                
                case let .success(value): _result.dataSwitching = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis.self, source: sourceDictionary["egressAclAnalysis"] as AnyObject?) {
                
                case let .success(value): _result.egressAclAnalysis = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterfaceAclAnalysis.self, source: sourceDictionary["ingressAclAnalysis"] as AnyObject?) {
                
                case let .success(value): _result.ingressAclAnalysis = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wirelessLanControllerId"] as AnyObject?) {
                
                case let .success(value): _result.wirelessLanControllerId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wirelessLanControllerName"] as AnyObject?) {
                
                case let .success(value): _result.wirelessLanControllerName = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseFlexConnect", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseNetworkElements]
        Decoders.addDecoder(clazz: [PathResponseResultResponseNetworkElements].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseNetworkElements]> in
            return Decoders.decode(clazz: [PathResponseResultResponseNetworkElements].self, source: source)
        }

        // Decoder for PathResponseResultResponseNetworkElements
        Decoders.addDecoder(clazz: PathResponseResultResponseNetworkElements.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseNetworkElements> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseNetworkElements() : instance as! PathResponseResultResponseNetworkElements
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseAccuracyList].self, source: sourceDictionary["accuracyList"] as AnyObject?) {
                
                case let .success(value): _result.accuracyList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseDetailedStatus.self, source: sourceDictionary["detailedStatus"] as AnyObject?) {
                
                case let .success(value): _result.detailedStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseDeviceStatistics.self, source: sourceDictionary["deviceStatistics"] as AnyObject?) {
                
                case let .success(value): _result.deviceStatistics = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceStatsCollection"] as AnyObject?) {
                
                case let .success(value): _result.deviceStatsCollection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceStatsCollectionFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.deviceStatsCollectionFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterface.self, source: sourceDictionary["egressPhysicalInterface"] as AnyObject?) {
                
                case let .success(value): _result.egressPhysicalInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterface.self, source: sourceDictionary["egressVirtualInterface"] as AnyObject?) {
                
                case let .success(value): _result.egressVirtualInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseFlexConnect.self, source: sourceDictionary["flexConnect"] as AnyObject?) {
                
                case let .success(value): _result.flexConnect = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterface.self, source: sourceDictionary["ingressPhysicalInterface"] as AnyObject?) {
                
                case let .success(value): _result.ingressPhysicalInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressPhysicalInterface.self, source: sourceDictionary["ingressVirtualInterface"] as AnyObject?) {
                
                case let .success(value): _result.ingressVirtualInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ip"] as AnyObject?) {
                
                case let .success(value): _result.ip = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["linkInformationSource"] as AnyObject?) {
                
                case let .success(value): _result.linkInformationSource = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["perfMonCollection"] as AnyObject?) {
                
                case let .success(value): _result.perfMonCollection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["perfMonCollectionFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.perfMonCollectionFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponsePerfMonStatistics].self, source: sourceDictionary["perfMonStatistics"] as AnyObject?) {
                
                case let .success(value): _result.perfMonStatistics = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ssid"] as AnyObject?) {
                
                case let .success(value): _result.ssid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["tunnels"] as AnyObject?) {
                
                case let .success(value): _result.tunnels = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wlanId"] as AnyObject?) {
                
                case let .success(value): _result.wlanId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseNetworkElements", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponseNetworkElementsInfo]
        Decoders.addDecoder(clazz: [PathResponseResultResponseNetworkElementsInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponseNetworkElementsInfo]> in
            return Decoders.decode(clazz: [PathResponseResultResponseNetworkElementsInfo].self, source: source)
        }

        // Decoder for PathResponseResultResponseNetworkElementsInfo
        Decoders.addDecoder(clazz: PathResponseResultResponseNetworkElementsInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponseNetworkElementsInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponseNetworkElementsInfo() : instance as! PathResponseResultResponseNetworkElementsInfo
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponseAccuracyList].self, source: sourceDictionary["accuracyList"] as AnyObject?) {
                
                case let .success(value): _result.accuracyList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseDetailedStatus.self, source: sourceDictionary["detailedStatus"] as AnyObject?) {
                
                case let .success(value): _result.detailedStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseDeviceStatistics.self, source: sourceDictionary["deviceStatistics"] as AnyObject?) {
                
                case let .success(value): _result.deviceStatistics = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceStatsCollection"] as AnyObject?) {
                
                case let .success(value): _result.deviceStatsCollection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceStatsCollectionFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.deviceStatsCollectionFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressInterface.self, source: sourceDictionary["egressInterface"] as AnyObject?) {
                
                case let .success(value): _result.egressInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseFlexConnect.self, source: sourceDictionary["flexConnect"] as AnyObject?) {
                
                case let .success(value): _result.flexConnect = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: PathResponseResultResponseEgressInterface.self, source: sourceDictionary["ingressInterface"] as AnyObject?) {
                
                case let .success(value): _result.ingressInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ip"] as AnyObject?) {
                
                case let .success(value): _result.ip = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["linkInformationSource"] as AnyObject?) {
                
                case let .success(value): _result.linkInformationSource = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["perfMonCollection"] as AnyObject?) {
                
                case let .success(value): _result.perfMonCollection = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["perfMonCollectionFailureReason"] as AnyObject?) {
                
                case let .success(value): _result.perfMonCollectionFailureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [PathResponseResultResponsePerfMonStatistics].self, source: sourceDictionary["perfMonitorStatistics"] as AnyObject?) {
                
                case let .success(value): _result.perfMonitorStatistics = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ssid"] as AnyObject?) {
                
                case let .success(value): _result.ssid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["tunnels"] as AnyObject?) {
                
                case let .success(value): _result.tunnels = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wlanId"] as AnyObject?) {
                
                case let .success(value): _result.wlanId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponseNetworkElementsInfo", actual: "\(source)"))
            }
        }
        // Decoder for [PathResponseResultResponsePerfMonStatistics]
        Decoders.addDecoder(clazz: [PathResponseResultResponsePerfMonStatistics].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PathResponseResultResponsePerfMonStatistics]> in
            return Decoders.decode(clazz: [PathResponseResultResponsePerfMonStatistics].self, source: source)
        }

        // Decoder for PathResponseResultResponsePerfMonStatistics
        Decoders.addDecoder(clazz: PathResponseResultResponsePerfMonStatistics.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PathResponseResultResponsePerfMonStatistics> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PathResponseResultResponsePerfMonStatistics() : instance as! PathResponseResultResponsePerfMonStatistics
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["byteRate"] as AnyObject?) {
                
                case let .success(value): _result.byteRate = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destIpAddress"] as AnyObject?) {
                
                case let .success(value): _result.destIpAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["destPort"] as AnyObject?) {
                
                case let .success(value): _result.destPort = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["inputInterface"] as AnyObject?) {
                
                case let .success(value): _result.inputInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipv4DSCP"] as AnyObject?) {
                
                case let .success(value): _result.ipv4DSCP = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["ipv4TTL"] as AnyObject?) {
                
                case let .success(value): _result.ipv4TTL = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["outputInterface"] as AnyObject?) {
                
                case let .success(value): _result.outputInterface = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["packetBytes"] as AnyObject?) {
                
                case let .success(value): _result.packetBytes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["packetCount"] as AnyObject?) {
                
                case let .success(value): _result.packetCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["packetLoss"] as AnyObject?) {
                
                case let .success(value): _result.packetLoss = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["packetLossPercentage"] as AnyObject?) {
                
                case let .success(value): _result.packetLossPercentage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["protocol"] as AnyObject?) {
                
                case let .success(value): _result._protocol = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["refreshedAt"] as AnyObject?) {
                
                case let .success(value): _result.refreshedAt = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["rtpJitterMax"] as AnyObject?) {
                
                case let .success(value): _result.rtpJitterMax = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["rtpJitterMean"] as AnyObject?) {
                
                case let .success(value): _result.rtpJitterMean = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["rtpJitterMin"] as AnyObject?) {
                
                case let .success(value): _result.rtpJitterMin = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourceIpAddress"] as AnyObject?) {
                
                case let .success(value): _result.sourceIpAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sourcePort"] as AnyObject?) {
                
                case let .success(value): _result.sourcePort = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PathResponseResultResponsePerfMonStatistics", actual: "\(source)"))
            }
        }
        // Decoder for [ProjectDTO]
        Decoders.addDecoder(clazz: [ProjectDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ProjectDTO]> in
            return Decoders.decode(clazz: [ProjectDTO].self, source: source)
        }

        // Decoder for ProjectDTO
        Decoders.addDecoder(clazz: ProjectDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ProjectDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ProjectDTO() : instance as! ProjectDTO
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["createTime"] as AnyObject?) {
                
                case let .success(value): _result.createTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastUpdateTime"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdateTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["tags"] as AnyObject?) {
                
                case let .success(value): _result.tags = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["templates"] as AnyObject?) {
                
                case let .success(value): _result.templates = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ProjectDTO", actual: "\(source)"))
            }
        }
        // Decoder for [ProvisionDeviceResponse]
        Decoders.addDecoder(clazz: [ProvisionDeviceResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ProvisionDeviceResponse]> in
            return Decoders.decode(clazz: [ProvisionDeviceResponse].self, source: source)
        }

        // Decoder for ProvisionDeviceResponse
        Decoders.addDecoder(clazz: ProvisionDeviceResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ProvisionDeviceResponse> in
            if let source = source as? ProvisionDeviceResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias ProvisionDeviceResponse", actual: "\(source)"))
            }
        }
        // Decoder for [PushProvisionRequest]
        Decoders.addDecoder(clazz: [PushProvisionRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[PushProvisionRequest]> in
            return Decoders.decode(clazz: [PushProvisionRequest].self, source: source)
        }

        // Decoder for PushProvisionRequest
        Decoders.addDecoder(clazz: PushProvisionRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<PushProvisionRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? PushProvisionRequest() : instance as! PushProvisionRequest
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["deviceIdList"] as AnyObject?) {
                
                case let .success(value): _result.deviceIdList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "PushProvisionRequest", actual: "\(source)"))
            }
        }
        // Decoder for [RawCliInfoNIOListResult]
        Decoders.addDecoder(clazz: [RawCliInfoNIOListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[RawCliInfoNIOListResult]> in
            return Decoders.decode(clazz: [RawCliInfoNIOListResult].self, source: source)
        }

        // Decoder for RawCliInfoNIOListResult
        Decoders.addDecoder(clazz: RawCliInfoNIOListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<RawCliInfoNIOListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? RawCliInfoNIOListResult() : instance as! RawCliInfoNIOListResult
                switch Decoders.decodeOptional(clazz: [RawCliInfoNIOListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "RawCliInfoNIOListResult", actual: "\(source)"))
            }
        }
        // Decoder for [RawCliInfoNIOListResultResponse]
        Decoders.addDecoder(clazz: [RawCliInfoNIOListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[RawCliInfoNIOListResultResponse]> in
            return Decoders.decode(clazz: [RawCliInfoNIOListResultResponse].self, source: source)
        }

        // Decoder for RawCliInfoNIOListResultResponse
        Decoders.addDecoder(clazz: RawCliInfoNIOListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<RawCliInfoNIOListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? RawCliInfoNIOListResultResponse() : instance as! RawCliInfoNIOListResultResponse
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["attributeInfo"] as AnyObject?) {
                
                case let .success(value): _result.attributeInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cdpNeighbors"] as AnyObject?) {
                
                case let .success(value): _result.cdpNeighbors = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["healthMonitor"] as AnyObject?) {
                
                case let .success(value): _result.healthMonitor = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["intfDescription"] as AnyObject?) {
                
                case let .success(value): _result.intfDescription = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["inventory"] as AnyObject?) {
                
                case let .success(value): _result.inventory = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipIntfBrief"] as AnyObject?) {
                
                case let .success(value): _result.ipIntfBrief = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddressTable"] as AnyObject?) {
                
                case let .success(value): _result.macAddressTable = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["runningConfig"] as AnyObject?) {
                
                case let .success(value): _result.runningConfig = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["snmp"] as AnyObject?) {
                
                case let .success(value): _result.snmp = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "RawCliInfoNIOListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [RegisterNetworkDeviceResult]
        Decoders.addDecoder(clazz: [RegisterNetworkDeviceResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[RegisterNetworkDeviceResult]> in
            return Decoders.decode(clazz: [RegisterNetworkDeviceResult].self, source: source)
        }

        // Decoder for RegisterNetworkDeviceResult
        Decoders.addDecoder(clazz: RegisterNetworkDeviceResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<RegisterNetworkDeviceResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? RegisterNetworkDeviceResult() : instance as! RegisterNetworkDeviceResult
                switch Decoders.decodeOptional(clazz: RegisterNetworkDeviceResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "RegisterNetworkDeviceResult", actual: "\(source)"))
            }
        }
        // Decoder for [RegisterNetworkDeviceResultResponse]
        Decoders.addDecoder(clazz: [RegisterNetworkDeviceResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[RegisterNetworkDeviceResultResponse]> in
            return Decoders.decode(clazz: [RegisterNetworkDeviceResultResponse].self, source: source)
        }

        // Decoder for RegisterNetworkDeviceResultResponse
        Decoders.addDecoder(clazz: RegisterNetworkDeviceResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<RegisterNetworkDeviceResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? RegisterNetworkDeviceResultResponse() : instance as! RegisterNetworkDeviceResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["macAddress"] as AnyObject?) {
                
                case let .success(value): _result.macAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["modelNumber"] as AnyObject?) {
                
                case let .success(value): _result.modelNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serialNumber"] as AnyObject?) {
                
                case let .success(value): _result.serialNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tenantId"] as AnyObject?) {
                
                case let .success(value): _result.tenantId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "RegisterNetworkDeviceResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ResetDeviceResponse]
        Decoders.addDecoder(clazz: [ResetDeviceResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ResetDeviceResponse]> in
            return Decoders.decode(clazz: [ResetDeviceResponse].self, source: source)
        }

        // Decoder for ResetDeviceResponse
        Decoders.addDecoder(clazz: ResetDeviceResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ResetDeviceResponse> in
            if let source = source as? ResetDeviceResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias ResetDeviceResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ResetRequest]
        Decoders.addDecoder(clazz: [ResetRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ResetRequest]> in
            return Decoders.decode(clazz: [ResetRequest].self, source: source)
        }

        // Decoder for ResetRequest
        Decoders.addDecoder(clazz: ResetRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ResetRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ResetRequest() : instance as! ResetRequest
                switch Decoders.decodeOptional(clazz: [ResetRequestDeviceResetList].self, source: sourceDictionary["deviceResetList"] as AnyObject?) {
                
                case let .success(value): _result.deviceResetList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["projectId"] as AnyObject?) {
                
                case let .success(value): _result.projectId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["workflowId"] as AnyObject?) {
                
                case let .success(value): _result.workflowId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ResetRequest", actual: "\(source)"))
            }
        }
        // Decoder for [ResetRequestConfigList]
        Decoders.addDecoder(clazz: [ResetRequestConfigList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ResetRequestConfigList]> in
            return Decoders.decode(clazz: [ResetRequestConfigList].self, source: source)
        }

        // Decoder for ResetRequestConfigList
        Decoders.addDecoder(clazz: ResetRequestConfigList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ResetRequestConfigList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ResetRequestConfigList() : instance as! ResetRequestConfigList
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["configId"] as AnyObject?) {
                
                case let .success(value): _result.configId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [ResetRequestConfigParameters].self, source: sourceDictionary["configParameters"] as AnyObject?) {
                
                case let .success(value): _result.configParameters = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ResetRequestConfigList", actual: "\(source)"))
            }
        }
        // Decoder for [ResetRequestConfigParameters]
        Decoders.addDecoder(clazz: [ResetRequestConfigParameters].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ResetRequestConfigParameters]> in
            return Decoders.decode(clazz: [ResetRequestConfigParameters].self, source: source)
        }

        // Decoder for ResetRequestConfigParameters
        Decoders.addDecoder(clazz: ResetRequestConfigParameters.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ResetRequestConfigParameters> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ResetRequestConfigParameters() : instance as! ResetRequestConfigParameters
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["key"] as AnyObject?) {
                
                case let .success(value): _result.key = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["value"] as AnyObject?) {
                
                case let .success(value): _result.value = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ResetRequestConfigParameters", actual: "\(source)"))
            }
        }
        // Decoder for [ResetRequestDeviceResetList]
        Decoders.addDecoder(clazz: [ResetRequestDeviceResetList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ResetRequestDeviceResetList]> in
            return Decoders.decode(clazz: [ResetRequestDeviceResetList].self, source: source)
        }

        // Decoder for ResetRequestDeviceResetList
        Decoders.addDecoder(clazz: ResetRequestDeviceResetList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ResetRequestDeviceResetList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? ResetRequestDeviceResetList() : instance as! ResetRequestDeviceResetList
                switch Decoders.decodeOptional(clazz: [ResetRequestConfigList].self, source: sourceDictionary["configList"] as AnyObject?) {
                
                case let .success(value): _result.configList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceId"] as AnyObject?) {
                
                case let .success(value): _result.deviceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["licenseLevel"] as AnyObject?) {
                
                case let .success(value): _result.licenseLevel = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["licenseType"] as AnyObject?) {
                
                case let .success(value): _result.licenseType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["topOfStackSerialNumber"] as AnyObject?) {
                
                case let .success(value): _result.topOfStackSerialNumber = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "ResetRequestDeviceResetList", actual: "\(source)"))
            }
        }
        // Decoder for [RetrievesAllNetworkDevicesResponse]
        Decoders.addDecoder(clazz: [RetrievesAllNetworkDevicesResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[RetrievesAllNetworkDevicesResponse]> in
            return Decoders.decode(clazz: [RetrievesAllNetworkDevicesResponse].self, source: source)
        }

        // Decoder for RetrievesAllNetworkDevicesResponse
        Decoders.addDecoder(clazz: RetrievesAllNetworkDevicesResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<RetrievesAllNetworkDevicesResponse> in
            if let source = source as? RetrievesAllNetworkDevicesResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias RetrievesAllNetworkDevicesResponse", actual: "\(source)"))
            }
        }
        // Decoder for [SAVAMapping]
        Decoders.addDecoder(clazz: [SAVAMapping].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SAVAMapping]> in
            return Decoders.decode(clazz: [SAVAMapping].self, source: source)
        }

        // Decoder for SAVAMapping
        Decoders.addDecoder(clazz: SAVAMapping.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SAVAMapping> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SAVAMapping() : instance as! SAVAMapping
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["autoSyncPeriod"] as AnyObject?) {
                
                case let .success(value): _result.autoSyncPeriod = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ccoUser"] as AnyObject?) {
                
                case let .success(value): _result.ccoUser = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["expiry"] as AnyObject?) {
                
                case let .success(value): _result.expiry = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastSync"] as AnyObject?) {
                
                case let .success(value): _result.lastSync = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SAVAMappingProfile.self, source: sourceDictionary["profile"] as AnyObject?) {
                
                case let .success(value): _result.profile = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["smartAccountId"] as AnyObject?) {
                
                case let .success(value): _result.smartAccountId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SAVAMappingSyncResult.self, source: sourceDictionary["syncResult"] as AnyObject?) {
                
                case let .success(value): _result.syncResult = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["syncResultStr"] as AnyObject?) {
                
                case let .success(value): _result.syncResultStr = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["syncStartTime"] as AnyObject?) {
                
                case let .success(value): _result.syncStartTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SAVAMapping.SyncStatus.self, source: sourceDictionary["syncStatus"] as AnyObject?) {
                
                case let .success(value): _result.syncStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tenantId"] as AnyObject?) {
                
                case let .success(value): _result.tenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["token"] as AnyObject?) {
                
                case let .success(value): _result.token = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["virtualAccountId"] as AnyObject?) {
                
                case let .success(value): _result.virtualAccountId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SAVAMapping", actual: "\(source)"))
            }
        }
        // Decoder for [SAVAMappingProfile]
        Decoders.addDecoder(clazz: [SAVAMappingProfile].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SAVAMappingProfile]> in
            return Decoders.decode(clazz: [SAVAMappingProfile].self, source: source)
        }

        // Decoder for SAVAMappingProfile
        Decoders.addDecoder(clazz: SAVAMappingProfile.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SAVAMappingProfile> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SAVAMappingProfile() : instance as! SAVAMappingProfile
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["addressFqdn"] as AnyObject?) {
                
                case let .success(value): _result.addressFqdn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["addressIpV4"] as AnyObject?) {
                
                case let .success(value): _result.addressIpV4 = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cert"] as AnyObject?) {
                
                case let .success(value): _result.cert = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["makeDefault"] as AnyObject?) {
                
                case let .success(value): _result.makeDefault = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["port"] as AnyObject?) {
                
                case let .success(value): _result.port = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["profileId"] as AnyObject?) {
                
                case let .success(value): _result.profileId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["proxy"] as AnyObject?) {
                
                case let .success(value): _result.proxy = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SAVAMappingProfile", actual: "\(source)"))
            }
        }
        // Decoder for [SAVAMappingSyncResult]
        Decoders.addDecoder(clazz: [SAVAMappingSyncResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SAVAMappingSyncResult]> in
            return Decoders.decode(clazz: [SAVAMappingSyncResult].self, source: source)
        }

        // Decoder for SAVAMappingSyncResult
        Decoders.addDecoder(clazz: SAVAMappingSyncResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SAVAMappingSyncResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SAVAMappingSyncResult() : instance as! SAVAMappingSyncResult
                switch Decoders.decodeOptional(clazz: [SAVAMappingSyncResultSyncList].self, source: sourceDictionary["syncList"] as AnyObject?) {
                
                case let .success(value): _result.syncList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["syncMsg"] as AnyObject?) {
                
                case let .success(value): _result.syncMsg = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SAVAMappingSyncResult", actual: "\(source)"))
            }
        }
        // Decoder for [SAVAMappingSyncResultSyncList]
        Decoders.addDecoder(clazz: [SAVAMappingSyncResultSyncList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SAVAMappingSyncResultSyncList]> in
            return Decoders.decode(clazz: [SAVAMappingSyncResultSyncList].self, source: source)
        }

        // Decoder for SAVAMappingSyncResultSyncList
        Decoders.addDecoder(clazz: SAVAMappingSyncResultSyncList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SAVAMappingSyncResultSyncList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SAVAMappingSyncResultSyncList() : instance as! SAVAMappingSyncResultSyncList
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["deviceSnList"] as AnyObject?) {
                
                case let .success(value): _result.deviceSnList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SAVAMappingSyncResultSyncList.SyncType.self, source: sourceDictionary["syncType"] as AnyObject?) {
                
                case let .success(value): _result.syncType = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SAVAMappingSyncResultSyncList", actual: "\(source)"))
            }
        }
        // Decoder for [SNMPvCredentialDTOInner]
        Decoders.addDecoder(clazz: [SNMPvCredentialDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SNMPvCredentialDTOInner]> in
            return Decoders.decode(clazz: [SNMPvCredentialDTOInner].self, source: source)
        }

        // Decoder for SNMPvCredentialDTOInner
        Decoders.addDecoder(clazz: SNMPvCredentialDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SNMPvCredentialDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SNMPvCredentialDTOInner() : instance as! SNMPvCredentialDTOInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["authPassword"] as AnyObject?) {
                
                case let .success(value): _result.authPassword = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SNMPvCredentialDTOInner.AuthType.self, source: sourceDictionary["authType"] as AnyObject?) {
                
                case let .success(value): _result.authType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SNMPvCredentialDTOInner.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["privacyPassword"] as AnyObject?) {
                
                case let .success(value): _result.privacyPassword = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SNMPvCredentialDTOInner.PrivacyType.self, source: sourceDictionary["privacyType"] as AnyObject?) {
                
                case let .success(value): _result.privacyType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SNMPvCredentialDTOInner.SnmpMode.self, source: sourceDictionary["snmpMode"] as AnyObject?) {
                
                case let .success(value): _result.snmpMode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?) {
                
                case let .success(value): _result.username = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SNMPvCredentialDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [SNMPvReadCommunityDTO]
        Decoders.addDecoder(clazz: [SNMPvReadCommunityDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SNMPvReadCommunityDTO]> in
            return Decoders.decode(clazz: [SNMPvReadCommunityDTO].self, source: source)
        }

        // Decoder for SNMPvReadCommunityDTO
        Decoders.addDecoder(clazz: SNMPvReadCommunityDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SNMPvReadCommunityDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SNMPvReadCommunityDTO() : instance as! SNMPvReadCommunityDTO
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SNMPvReadCommunityDTO.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["readCommunity"] as AnyObject?) {
                
                case let .success(value): _result.readCommunity = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SNMPvReadCommunityDTO", actual: "\(source)"))
            }
        }
        // Decoder for [SNMPvWriteCommunityDTOInner]
        Decoders.addDecoder(clazz: [SNMPvWriteCommunityDTOInner].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SNMPvWriteCommunityDTOInner]> in
            return Decoders.decode(clazz: [SNMPvWriteCommunityDTOInner].self, source: source)
        }

        // Decoder for SNMPvWriteCommunityDTOInner
        Decoders.addDecoder(clazz: SNMPvWriteCommunityDTOInner.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SNMPvWriteCommunityDTOInner> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SNMPvWriteCommunityDTOInner() : instance as! SNMPvWriteCommunityDTOInner
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SNMPvWriteCommunityDTOInner.CredentialType.self, source: sourceDictionary["credentialType"] as AnyObject?) {
                
                case let .success(value): _result.credentialType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["writeCommunity"] as AnyObject?) {
                
                case let .success(value): _result.writeCommunity = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SNMPvWriteCommunityDTOInner", actual: "\(source)"))
            }
        }
        // Decoder for [Settings]
        Decoders.addDecoder(clazz: [Settings].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[Settings]> in
            return Decoders.decode(clazz: [Settings].self, source: source)
        }

        // Decoder for Settings
        Decoders.addDecoder(clazz: Settings.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<Settings> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? Settings() : instance as! Settings
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["_id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: DeviceInnerDeviceInfoAaaCredentials.self, source: sourceDictionary["aaaCredentials"] as AnyObject?) {
                
                case let .success(value): _result.aaaCredentials = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["acceptEula"] as AnyObject?) {
                
                case let .success(value): _result.acceptEula = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SettingsDefaultProfile.self, source: sourceDictionary["defaultProfile"] as AnyObject?) {
                
                case let .success(value): _result.defaultProfile = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [SettingsSavaMappingList].self, source: sourceDictionary["savaMappingList"] as AnyObject?) {
                
                case let .success(value): _result.savaMappingList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SettingsTaskTimeOuts.self, source: sourceDictionary["taskTimeOuts"] as AnyObject?) {
                
                case let .success(value): _result.taskTimeOuts = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tenantId"] as AnyObject?) {
                
                case let .success(value): _result.tenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "Settings", actual: "\(source)"))
            }
        }
        // Decoder for [SettingsDefaultProfile]
        Decoders.addDecoder(clazz: [SettingsDefaultProfile].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SettingsDefaultProfile]> in
            return Decoders.decode(clazz: [SettingsDefaultProfile].self, source: source)
        }

        // Decoder for SettingsDefaultProfile
        Decoders.addDecoder(clazz: SettingsDefaultProfile.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SettingsDefaultProfile> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SettingsDefaultProfile() : instance as! SettingsDefaultProfile
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cert"] as AnyObject?) {
                
                case let .success(value): _result.cert = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["fqdnAddresses"] as AnyObject?) {
                
                case let .success(value): _result.fqdnAddresses = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["ipAddresses"] as AnyObject?) {
                
                case let .success(value): _result.ipAddresses = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["port"] as AnyObject?) {
                
                case let .success(value): _result.port = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["proxy"] as AnyObject?) {
                
                case let .success(value): _result.proxy = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SettingsDefaultProfile", actual: "\(source)"))
            }
        }
        // Decoder for [SettingsSavaMappingList]
        Decoders.addDecoder(clazz: [SettingsSavaMappingList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SettingsSavaMappingList]> in
            return Decoders.decode(clazz: [SettingsSavaMappingList].self, source: source)
        }

        // Decoder for SettingsSavaMappingList
        Decoders.addDecoder(clazz: SettingsSavaMappingList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SettingsSavaMappingList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SettingsSavaMappingList() : instance as! SettingsSavaMappingList
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["autoSyncPeriod"] as AnyObject?) {
                
                case let .success(value): _result.autoSyncPeriod = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ccoUser"] as AnyObject?) {
                
                case let .success(value): _result.ccoUser = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["expiry"] as AnyObject?) {
                
                case let .success(value): _result.expiry = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastSync"] as AnyObject?) {
                
                case let .success(value): _result.lastSync = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SAVAMappingProfile.self, source: sourceDictionary["profile"] as AnyObject?) {
                
                case let .success(value): _result.profile = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["smartAccountId"] as AnyObject?) {
                
                case let .success(value): _result.smartAccountId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SAVAMappingSyncResult.self, source: sourceDictionary["syncResult"] as AnyObject?) {
                
                case let .success(value): _result.syncResult = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["syncResultStr"] as AnyObject?) {
                
                case let .success(value): _result.syncResultStr = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["syncStartTime"] as AnyObject?) {
                
                case let .success(value): _result.syncStartTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: SettingsSavaMappingList.SyncStatus.self, source: sourceDictionary["syncStatus"] as AnyObject?) {
                
                case let .success(value): _result.syncStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tenantId"] as AnyObject?) {
                
                case let .success(value): _result.tenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["token"] as AnyObject?) {
                
                case let .success(value): _result.token = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["virtualAccountId"] as AnyObject?) {
                
                case let .success(value): _result.virtualAccountId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SettingsSavaMappingList", actual: "\(source)"))
            }
        }
        // Decoder for [SettingsTaskTimeOuts]
        Decoders.addDecoder(clazz: [SettingsTaskTimeOuts].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SettingsTaskTimeOuts]> in
            return Decoders.decode(clazz: [SettingsTaskTimeOuts].self, source: source)
        }

        // Decoder for SettingsTaskTimeOuts
        Decoders.addDecoder(clazz: SettingsTaskTimeOuts.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SettingsTaskTimeOuts> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SettingsTaskTimeOuts() : instance as! SettingsTaskTimeOuts
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["configTimeOut"] as AnyObject?) {
                
                case let .success(value): _result.configTimeOut = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["generalTimeOut"] as AnyObject?) {
                
                case let .success(value): _result.generalTimeOut = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["imageDownloadTimeOut"] as AnyObject?) {
                
                case let .success(value): _result.imageDownloadTimeOut = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SettingsTaskTimeOuts", actual: "\(source)"))
            }
        }
        // Decoder for [SiteHierarchyResponse]
        Decoders.addDecoder(clazz: [SiteHierarchyResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SiteHierarchyResponse]> in
            return Decoders.decode(clazz: [SiteHierarchyResponse].self, source: source)
        }

        // Decoder for SiteHierarchyResponse
        Decoders.addDecoder(clazz: SiteHierarchyResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SiteHierarchyResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SiteHierarchyResponse() : instance as! SiteHierarchyResponse
                switch Decoders.decodeOptional(clazz: [SiteHierarchyResponseResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SiteHierarchyResponse", actual: "\(source)"))
            }
        }
        // Decoder for [SiteHierarchyResponseResponse]
        Decoders.addDecoder(clazz: [SiteHierarchyResponseResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SiteHierarchyResponseResponse]> in
            return Decoders.decode(clazz: [SiteHierarchyResponseResponse].self, source: source)
        }

        // Decoder for SiteHierarchyResponseResponse
        Decoders.addDecoder(clazz: SiteHierarchyResponseResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SiteHierarchyResponseResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SiteHierarchyResponseResponse() : instance as! SiteHierarchyResponseResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["siteName"] as AnyObject?) {
                
                case let .success(value): _result.siteName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["siteId"] as AnyObject?) {
                
                case let .success(value): _result.siteId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentSiteId"] as AnyObject?) {
                
                case let .success(value): _result.parentSiteId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentSiteName"] as AnyObject?) {
                
                case let .success(value): _result.parentSiteName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["siteType"] as AnyObject?) {
                
                case let .success(value): _result.siteType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["healthyNetworkDevicePercentage"] as AnyObject?) {
                
                case let .success(value): _result.healthyNetworkDevicePercentage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["healthyClientsPercentage"] as AnyObject?) {
                
                case let .success(value): _result.healthyClientsPercentage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clientHealthWired"] as AnyObject?) {
                
                case let .success(value): _result.clientHealthWired = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clientHealthWireless"] as AnyObject?) {
                
                case let .success(value): _result.clientHealthWireless = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["numberOfClients"] as AnyObject?) {
                
                case let .success(value): _result.numberOfClients = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clientNumberOfIssues"] as AnyObject?) {
                
                case let .success(value): _result.clientNumberOfIssues = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkNumberOfIssues"] as AnyObject?) {
                
                case let .success(value): _result.networkNumberOfIssues = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["numberOfNetworkDevice"] as AnyObject?) {
                
                case let .success(value): _result.numberOfNetworkDevice = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkHealthAverage"] as AnyObject?) {
                
                case let .success(value): _result.networkHealthAverage = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkHealthAccess"] as AnyObject?) {
                
                case let .success(value): _result.networkHealthAccess = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkHealthCore"] as AnyObject?) {
                
                case let .success(value): _result.networkHealthCore = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkHealthDistribution"] as AnyObject?) {
                
                case let .success(value): _result.networkHealthDistribution = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkHealthRouter"] as AnyObject?) {
                
                case let .success(value): _result.networkHealthRouter = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkHealthWireless"] as AnyObject?) {
                
                case let .success(value): _result.networkHealthWireless = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkHealthOthers"] as AnyObject?) {
                
                case let .success(value): _result.networkHealthOthers = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["numberOfWiredClients"] as AnyObject?) {
                
                case let .success(value): _result.numberOfWiredClients = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["numberOfWirelessClients"] as AnyObject?) {
                
                case let .success(value): _result.numberOfWirelessClients = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wiredGoodClients"] as AnyObject?) {
                
                case let .success(value): _result.wiredGoodClients = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wirelessGoodClients"] as AnyObject?) {
                
                case let .success(value): _result.wirelessGoodClients = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["clientIssueCount"] as AnyObject?) {
                
                case let .success(value): _result.clientIssueCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["overallGoodDevices"] as AnyObject?) {
                
                case let .success(value): _result.overallGoodDevices = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["accessGoodCount"] as AnyObject?) {
                
                case let .success(value): _result.accessGoodCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["accessTotalCount"] as AnyObject?) {
                
                case let .success(value): _result.accessTotalCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["coreGoodCount"] as AnyObject?) {
                
                case let .success(value): _result.coreGoodCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["coreTotalCount"] as AnyObject?) {
                
                case let .success(value): _result.coreTotalCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["distributionGoodCount"] as AnyObject?) {
                
                case let .success(value): _result.distributionGoodCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["distributionTotalCount"] as AnyObject?) {
                
                case let .success(value): _result.distributionTotalCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["routerGoodCount"] as AnyObject?) {
                
                case let .success(value): _result.routerGoodCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["routerTotalCount"] as AnyObject?) {
                
                case let .success(value): _result.routerTotalCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wirelessDeviceGoodCount"] as AnyObject?) {
                
                case let .success(value): _result.wirelessDeviceGoodCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["wirelessDeviceTotalCount"] as AnyObject?) {
                
                case let .success(value): _result.wirelessDeviceTotalCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["applicationHealth"] as AnyObject?) {
                
                case let .success(value): _result.applicationHealth = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["applicationGoodCount"] as AnyObject?) {
                
                case let .success(value): _result.applicationGoodCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["applicationTotalCount"] as AnyObject?) {
                
                case let .success(value): _result.applicationTotalCount = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["applicationBytesTotalCount"] as AnyObject?) {
                
                case let .success(value): _result.applicationBytesTotalCount = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SiteHierarchyResponseResponse", actual: "\(source)"))
            }
        }
        // Decoder for [SiteResult]
        Decoders.addDecoder(clazz: [SiteResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SiteResult]> in
            return Decoders.decode(clazz: [SiteResult].self, source: source)
        }

        // Decoder for SiteResult
        Decoders.addDecoder(clazz: SiteResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SiteResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SiteResult() : instance as! SiteResult
                switch Decoders.decodeOptional(clazz: SiteResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SiteResult", actual: "\(source)"))
            }
        }
        // Decoder for [SiteResultResponse]
        Decoders.addDecoder(clazz: [SiteResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SiteResultResponse]> in
            return Decoders.decode(clazz: [SiteResultResponse].self, source: source)
        }

        // Decoder for SiteResultResponse
        Decoders.addDecoder(clazz: SiteResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SiteResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SiteResultResponse() : instance as! SiteResultResponse
                switch Decoders.decodeOptional(clazz: [SiteResultResponseSites].self, source: sourceDictionary["sites"] as AnyObject?) {
                
                case let .success(value): _result.sites = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SiteResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [SiteResultResponseSites]
        Decoders.addDecoder(clazz: [SiteResultResponseSites].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SiteResultResponseSites]> in
            return Decoders.decode(clazz: [SiteResultResponseSites].self, source: source)
        }

        // Decoder for SiteResultResponseSites
        Decoders.addDecoder(clazz: SiteResultResponseSites.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SiteResultResponseSites> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SiteResultResponseSites() : instance as! SiteResultResponseSites
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["displayName"] as AnyObject?) {
                
                case let .success(value): _result.displayName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["groupNameHierarchy"] as AnyObject?) {
                
                case let .success(value): _result.groupNameHierarchy = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["latitude"] as AnyObject?) {
                
                case let .success(value): _result.latitude = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["locationAddress"] as AnyObject?) {
                
                case let .success(value): _result.locationAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["locationCountry"] as AnyObject?) {
                
                case let .success(value): _result.locationCountry = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["locationType"] as AnyObject?) {
                
                case let .success(value): _result.locationType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["longitude"] as AnyObject?) {
                
                case let .success(value): _result.longitude = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentId"] as AnyObject?) {
                
                case let .success(value): _result.parentId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SiteResultResponseSites", actual: "\(source)"))
            }
        }
        // Decoder for [SitesInfoDTO]
        Decoders.addDecoder(clazz: [SitesInfoDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SitesInfoDTO]> in
            return Decoders.decode(clazz: [SitesInfoDTO].self, source: source)
        }

        // Decoder for SitesInfoDTO
        Decoders.addDecoder(clazz: SitesInfoDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SitesInfoDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SitesInfoDTO() : instance as! SitesInfoDTO
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["siteUuids"] as AnyObject?) {
                
                case let .success(value): _result.siteUuids = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SitesInfoDTO", actual: "\(source)"))
            }
        }
        // Decoder for [SuccessResult]
        Decoders.addDecoder(clazz: [SuccessResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SuccessResult]> in
            return Decoders.decode(clazz: [SuccessResult].self, source: source)
        }

        // Decoder for SuccessResult
        Decoders.addDecoder(clazz: SuccessResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SuccessResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SuccessResult() : instance as! SuccessResult
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SuccessResult", actual: "\(source)"))
            }
        }
        // Decoder for [SuccessResultList]
        Decoders.addDecoder(clazz: [SuccessResultList].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SuccessResultList]> in
            return Decoders.decode(clazz: [SuccessResultList].self, source: source)
        }

        // Decoder for SuccessResultList
        Decoders.addDecoder(clazz: SuccessResultList.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SuccessResultList> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SuccessResultList() : instance as! SuccessResultList
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SuccessResultList", actual: "\(source)"))
            }
        }
        // Decoder for [SyncVirtualAccountDevicesResponse]
        Decoders.addDecoder(clazz: [SyncVirtualAccountDevicesResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SyncVirtualAccountDevicesResponse]> in
            return Decoders.decode(clazz: [SyncVirtualAccountDevicesResponse].self, source: source)
        }

        // Decoder for SyncVirtualAccountDevicesResponse
        Decoders.addDecoder(clazz: SyncVirtualAccountDevicesResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SyncVirtualAccountDevicesResponse> in
            if let source = source as? SyncVirtualAccountDevicesResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias SyncVirtualAccountDevicesResponse", actual: "\(source)"))
            }
        }
        // Decoder for [SystemPropertyListResult]
        Decoders.addDecoder(clazz: [SystemPropertyListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SystemPropertyListResult]> in
            return Decoders.decode(clazz: [SystemPropertyListResult].self, source: source)
        }

        // Decoder for SystemPropertyListResult
        Decoders.addDecoder(clazz: SystemPropertyListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SystemPropertyListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SystemPropertyListResult() : instance as! SystemPropertyListResult
                switch Decoders.decodeOptional(clazz: [SystemPropertyListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SystemPropertyListResult", actual: "\(source)"))
            }
        }
        // Decoder for [SystemPropertyListResultResponse]
        Decoders.addDecoder(clazz: [SystemPropertyListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[SystemPropertyListResultResponse]> in
            return Decoders.decode(clazz: [SystemPropertyListResultResponse].self, source: source)
        }

        // Decoder for SystemPropertyListResultResponse
        Decoders.addDecoder(clazz: SystemPropertyListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<SystemPropertyListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? SystemPropertyListResultResponse() : instance as! SystemPropertyListResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["intValue"] as AnyObject?) {
                
                case let .success(value): _result.intValue = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["systemPropertyName"] as AnyObject?) {
                
                case let .success(value): _result.systemPropertyName = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "SystemPropertyListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [TaskDTOListResponse]
        Decoders.addDecoder(clazz: [TaskDTOListResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TaskDTOListResponse]> in
            return Decoders.decode(clazz: [TaskDTOListResponse].self, source: source)
        }

        // Decoder for TaskDTOListResponse
        Decoders.addDecoder(clazz: TaskDTOListResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TaskDTOListResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TaskDTOListResponse() : instance as! TaskDTOListResponse
                switch Decoders.decodeOptional(clazz: [TaskDTOResponseResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TaskDTOListResponse", actual: "\(source)"))
            }
        }
        // Decoder for [TaskDTOResponse]
        Decoders.addDecoder(clazz: [TaskDTOResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TaskDTOResponse]> in
            return Decoders.decode(clazz: [TaskDTOResponse].self, source: source)
        }

        // Decoder for TaskDTOResponse
        Decoders.addDecoder(clazz: TaskDTOResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TaskDTOResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TaskDTOResponse() : instance as! TaskDTOResponse
                switch Decoders.decodeOptional(clazz: TaskDTOResponseResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TaskDTOResponse", actual: "\(source)"))
            }
        }
        // Decoder for [TaskDTOResponseResponse]
        Decoders.addDecoder(clazz: [TaskDTOResponseResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TaskDTOResponseResponse]> in
            return Decoders.decode(clazz: [TaskDTOResponseResponse].self, source: source)
        }

        // Decoder for TaskDTOResponseResponse
        Decoders.addDecoder(clazz: TaskDTOResponseResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TaskDTOResponseResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TaskDTOResponseResponse() : instance as! TaskDTOResponseResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["additionalStatusURL"] as AnyObject?) {
                
                case let .success(value): _result.additionalStatusURL = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["data"] as AnyObject?) {
                
                case let .success(value): _result.data = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["errorCode"] as AnyObject?) {
                
                case let .success(value): _result.errorCode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["errorKey"] as AnyObject?) {
                
                case let .success(value): _result.errorKey = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["failureReason"] as AnyObject?) {
                
                case let .success(value): _result.failureReason = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isError"] as AnyObject?) {
                
                case let .success(value): _result.isError = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastUpdate"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdate = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["operationIdList"] as AnyObject?) {
                
                case let .success(value): _result.operationIdList = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentId"] as AnyObject?) {
                
                case let .success(value): _result.parentId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["progress"] as AnyObject?) {
                
                case let .success(value): _result.progress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["rootId"] as AnyObject?) {
                
                case let .success(value): _result.rootId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["serviceType"] as AnyObject?) {
                
                case let .success(value): _result.serviceType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?) {
                
                case let .success(value): _result.username = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TaskDTOResponseResponse", actual: "\(source)"))
            }
        }
        // Decoder for [TaskIdResult]
        Decoders.addDecoder(clazz: [TaskIdResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TaskIdResult]> in
            return Decoders.decode(clazz: [TaskIdResult].self, source: source)
        }

        // Decoder for TaskIdResult
        Decoders.addDecoder(clazz: TaskIdResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TaskIdResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TaskIdResult() : instance as! TaskIdResult
                switch Decoders.decodeOptional(clazz: TaskIdResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TaskIdResult", actual: "\(source)"))
            }
        }
        // Decoder for [TaskIdResultResponse]
        Decoders.addDecoder(clazz: [TaskIdResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TaskIdResultResponse]> in
            return Decoders.decode(clazz: [TaskIdResultResponse].self, source: source)
        }

        // Decoder for TaskIdResultResponse
        Decoders.addDecoder(clazz: TaskIdResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TaskIdResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TaskIdResultResponse() : instance as! TaskIdResultResponse
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["taskId"] as AnyObject?) {
                
                case let .success(value): _result.taskId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["url"] as AnyObject?) {
                
                case let .success(value): _result.url = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TaskIdResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDTO]
        Decoders.addDecoder(clazz: [TemplateDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDTO]> in
            return Decoders.decode(clazz: [TemplateDTO].self, source: source)
        }

        // Decoder for TemplateDTO
        Decoders.addDecoder(clazz: TemplateDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDTO() : instance as! TemplateDTO
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["author"] as AnyObject?) {
                
                case let .success(value): _result.author = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["createTime"] as AnyObject?) {
                
                case let .success(value): _result.createTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [TemplateDTODeviceTypes].self, source: sourceDictionary["deviceTypes"] as AnyObject?) {
                
                case let .success(value): _result.deviceTypes = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastUpdateTime"] as AnyObject?) {
                
                case let .success(value): _result.lastUpdateTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentTemplateId"] as AnyObject?) {
                
                case let .success(value): _result.parentTemplateId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["projectId"] as AnyObject?) {
                
                case let .success(value): _result.projectId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["projectName"] as AnyObject?) {
                
                case let .success(value): _result.projectName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["rollbackTemplateContent"] as AnyObject?) {
                
                case let .success(value): _result.rollbackTemplateContent = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [TemplateDTORollbackTemplateParams].self, source: sourceDictionary["rollbackTemplateParams"] as AnyObject?) {
                
                case let .success(value): _result.rollbackTemplateParams = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareType"] as AnyObject?) {
                
                case let .success(value): _result.softwareType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVariant"] as AnyObject?) {
                
                case let .success(value): _result.softwareVariant = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.softwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["tags"] as AnyObject?) {
                
                case let .success(value): _result.tags = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["templateContent"] as AnyObject?) {
                
                case let .success(value): _result.templateContent = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [TemplateDTORollbackTemplateParams].self, source: sourceDictionary["templateParams"] as AnyObject?) {
                
                case let .success(value): _result.templateParams = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDTO", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDTODeviceTypes]
        Decoders.addDecoder(clazz: [TemplateDTODeviceTypes].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDTODeviceTypes]> in
            return Decoders.decode(clazz: [TemplateDTODeviceTypes].self, source: source)
        }

        // Decoder for TemplateDTODeviceTypes
        Decoders.addDecoder(clazz: TemplateDTODeviceTypes.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDTODeviceTypes> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDTODeviceTypes() : instance as! TemplateDTODeviceTypes
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["productFamily"] as AnyObject?) {
                
                case let .success(value): _result.productFamily = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["productSeries"] as AnyObject?) {
                
                case let .success(value): _result.productSeries = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["productType"] as AnyObject?) {
                
                case let .success(value): _result.productType = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDTODeviceTypes", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDTORange]
        Decoders.addDecoder(clazz: [TemplateDTORange].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDTORange]> in
            return Decoders.decode(clazz: [TemplateDTORange].self, source: source)
        }

        // Decoder for TemplateDTORange
        Decoders.addDecoder(clazz: TemplateDTORange.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDTORange> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDTORange() : instance as! TemplateDTORange
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["maxValue"] as AnyObject?) {
                
                case let .success(value): _result.maxValue = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["minValue"] as AnyObject?) {
                
                case let .success(value): _result.minValue = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDTORange", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDTORollbackTemplateParams]
        Decoders.addDecoder(clazz: [TemplateDTORollbackTemplateParams].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDTORollbackTemplateParams]> in
            return Decoders.decode(clazz: [TemplateDTORollbackTemplateParams].self, source: source)
        }

        // Decoder for TemplateDTORollbackTemplateParams
        Decoders.addDecoder(clazz: TemplateDTORollbackTemplateParams.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDTORollbackTemplateParams> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDTORollbackTemplateParams() : instance as! TemplateDTORollbackTemplateParams
                switch Decoders.decodeOptional(clazz: TemplateDTORollbackTemplateParams.DataType.self, source: sourceDictionary["dataType"] as AnyObject?) {
                
                case let .success(value): _result.dataType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["defaultValue"] as AnyObject?) {
                
                case let .success(value): _result.defaultValue = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["displayName"] as AnyObject?) {
                
                case let .success(value): _result.displayName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["group"] as AnyObject?) {
                
                case let .success(value): _result.group = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instructionText"] as AnyObject?) {
                
                case let .success(value): _result.instructionText = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["key"] as AnyObject?) {
                
                case let .success(value): _result.key = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["order"] as AnyObject?) {
                
                case let .success(value): _result.order = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parameterName"] as AnyObject?) {
                
                case let .success(value): _result.parameterName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["provider"] as AnyObject?) {
                
                case let .success(value): _result.provider = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [TemplateDTORange].self, source: sourceDictionary["range"] as AnyObject?) {
                
                case let .success(value): _result.range = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["required"] as AnyObject?) {
                
                case let .success(value): _result._required = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["selection"] as AnyObject?) {
                
                case let .success(value): _result.selection = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDTORollbackTemplateParams", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDeploymentInfo]
        Decoders.addDecoder(clazz: [TemplateDeploymentInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDeploymentInfo]> in
            return Decoders.decode(clazz: [TemplateDeploymentInfo].self, source: source)
        }

        // Decoder for TemplateDeploymentInfo
        Decoders.addDecoder(clazz: TemplateDeploymentInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDeploymentInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDeploymentInfo() : instance as! TemplateDeploymentInfo
                switch Decoders.decodeOptional(clazz: [TemplateDeploymentInfoTargetInfo].self, source: sourceDictionary["targetInfo"] as AnyObject?) {
                
                case let .success(value): _result.targetInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["templateId"] as AnyObject?) {
                
                case let .success(value): _result.templateId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDeploymentInfo", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDeploymentInfoTargetInfo]
        Decoders.addDecoder(clazz: [TemplateDeploymentInfoTargetInfo].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDeploymentInfoTargetInfo]> in
            return Decoders.decode(clazz: [TemplateDeploymentInfoTargetInfo].self, source: source)
        }

        // Decoder for TemplateDeploymentInfoTargetInfo
        Decoders.addDecoder(clazz: TemplateDeploymentInfoTargetInfo.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDeploymentInfoTargetInfo> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDeploymentInfoTargetInfo() : instance as! TemplateDeploymentInfoTargetInfo
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["hostName"] as AnyObject?) {
                
                case let .success(value): _result.hostName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["params"] as AnyObject?) {
                
                case let .success(value): _result.params = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: TemplateDeploymentInfoTargetInfo.ModelType.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDeploymentInfoTargetInfo", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDeploymentStatusDTO]
        Decoders.addDecoder(clazz: [TemplateDeploymentStatusDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDeploymentStatusDTO]> in
            return Decoders.decode(clazz: [TemplateDeploymentStatusDTO].self, source: source)
        }

        // Decoder for TemplateDeploymentStatusDTO
        Decoders.addDecoder(clazz: TemplateDeploymentStatusDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDeploymentStatusDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDeploymentStatusDTO() : instance as! TemplateDeploymentStatusDTO
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deploymentId"] as AnyObject?) {
                
                case let .success(value): _result.deploymentId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deploymentName"] as AnyObject?) {
                
                case let .success(value): _result.deploymentName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [TemplateDeploymentStatusDTODevices].self, source: sourceDictionary["devices"] as AnyObject?) {
                
                case let .success(value): _result.devices = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["duration"] as AnyObject?) {
                
                case let .success(value): _result.duration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["projectName"] as AnyObject?) {
                
                case let .success(value): _result.projectName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["status"] as AnyObject?) {
                
                case let .success(value): _result.status = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["templateName"] as AnyObject?) {
                
                case let .success(value): _result.templateName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["templateVersion"] as AnyObject?) {
                
                case let .success(value): _result.templateVersion = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDeploymentStatusDTO", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateDeploymentStatusDTODevices]
        Decoders.addDecoder(clazz: [TemplateDeploymentStatusDTODevices].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateDeploymentStatusDTODevices]> in
            return Decoders.decode(clazz: [TemplateDeploymentStatusDTODevices].self, source: source)
        }

        // Decoder for TemplateDeploymentStatusDTODevices
        Decoders.addDecoder(clazz: TemplateDeploymentStatusDTODevices.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateDeploymentStatusDTODevices> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateDeploymentStatusDTODevices() : instance as! TemplateDeploymentStatusDTODevices
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceId"] as AnyObject?) {
                
                case let .success(value): _result.deviceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["duration"] as AnyObject?) {
                
                case let .success(value): _result.duration = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipAddress"] as AnyObject?) {
                
                case let .success(value): _result.ipAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["status"] as AnyObject?) {
                
                case let .success(value): _result.status = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateDeploymentStatusDTODevices", actual: "\(source)"))
            }
        }
        // Decoder for [TemplatePreviewRequestDTO]
        Decoders.addDecoder(clazz: [TemplatePreviewRequestDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplatePreviewRequestDTO]> in
            return Decoders.decode(clazz: [TemplatePreviewRequestDTO].self, source: source)
        }

        // Decoder for TemplatePreviewRequestDTO
        Decoders.addDecoder(clazz: TemplatePreviewRequestDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplatePreviewRequestDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplatePreviewRequestDTO() : instance as! TemplatePreviewRequestDTO
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["params"] as AnyObject?) {
                
                case let .success(value): _result.params = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["templateId"] as AnyObject?) {
                
                case let .success(value): _result.templateId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplatePreviewRequestDTO", actual: "\(source)"))
            }
        }
        // Decoder for [TemplatePreviewResponseDTO]
        Decoders.addDecoder(clazz: [TemplatePreviewResponseDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplatePreviewResponseDTO]> in
            return Decoders.decode(clazz: [TemplatePreviewResponseDTO].self, source: source)
        }

        // Decoder for TemplatePreviewResponseDTO
        Decoders.addDecoder(clazz: TemplatePreviewResponseDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplatePreviewResponseDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplatePreviewResponseDTO() : instance as! TemplatePreviewResponseDTO
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cliPreview"] as AnyObject?) {
                
                case let .success(value): _result.cliPreview = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["templateId"] as AnyObject?) {
                
                case let .success(value): _result.templateId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplatePreviewResponseDTO", actual: "\(source)"))
            }
        }
        // Decoder for [TemplateVersionRequestDTO]
        Decoders.addDecoder(clazz: [TemplateVersionRequestDTO].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TemplateVersionRequestDTO]> in
            return Decoders.decode(clazz: [TemplateVersionRequestDTO].self, source: source)
        }

        // Decoder for TemplateVersionRequestDTO
        Decoders.addDecoder(clazz: TemplateVersionRequestDTO.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TemplateVersionRequestDTO> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TemplateVersionRequestDTO() : instance as! TemplateVersionRequestDTO
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["comments"] as AnyObject?) {
                
                case let .success(value): _result.comments = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["templateId"] as AnyObject?) {
                
                case let .success(value): _result.templateId = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TemplateVersionRequestDTO", actual: "\(source)"))
            }
        }
        // Decoder for [TopologyResult]
        Decoders.addDecoder(clazz: [TopologyResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TopologyResult]> in
            return Decoders.decode(clazz: [TopologyResult].self, source: source)
        }

        // Decoder for TopologyResult
        Decoders.addDecoder(clazz: TopologyResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TopologyResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TopologyResult() : instance as! TopologyResult
                switch Decoders.decodeOptional(clazz: TopologyResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TopologyResult", actual: "\(source)"))
            }
        }
        // Decoder for [TopologyResultResponse]
        Decoders.addDecoder(clazz: [TopologyResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TopologyResultResponse]> in
            return Decoders.decode(clazz: [TopologyResultResponse].self, source: source)
        }

        // Decoder for TopologyResultResponse
        Decoders.addDecoder(clazz: TopologyResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TopologyResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TopologyResultResponse() : instance as! TopologyResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [TopologyResultResponseLinks].self, source: sourceDictionary["links"] as AnyObject?) {
                
                case let .success(value): _result.links = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [TopologyResultResponseNodes].self, source: sourceDictionary["nodes"] as AnyObject?) {
                
                case let .success(value): _result.nodes = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TopologyResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [TopologyResultResponseCustomParam]
        Decoders.addDecoder(clazz: [TopologyResultResponseCustomParam].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TopologyResultResponseCustomParam]> in
            return Decoders.decode(clazz: [TopologyResultResponseCustomParam].self, source: source)
        }

        // Decoder for TopologyResultResponseCustomParam
        Decoders.addDecoder(clazz: TopologyResultResponseCustomParam.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TopologyResultResponseCustomParam> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TopologyResultResponseCustomParam() : instance as! TopologyResultResponseCustomParam
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["label"] as AnyObject?) {
                
                case let .success(value): _result.label = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["parentNodeId"] as AnyObject?) {
                
                case let .success(value): _result.parentNodeId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["x"] as AnyObject?) {
                
                case let .success(value): _result.x = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["y"] as AnyObject?) {
                
                case let .success(value): _result.y = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TopologyResultResponseCustomParam", actual: "\(source)"))
            }
        }
        // Decoder for [TopologyResultResponseLinks]
        Decoders.addDecoder(clazz: [TopologyResultResponseLinks].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TopologyResultResponseLinks]> in
            return Decoders.decode(clazz: [TopologyResultResponseLinks].self, source: source)
        }

        // Decoder for TopologyResultResponseLinks
        Decoders.addDecoder(clazz: TopologyResultResponseLinks.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TopologyResultResponseLinks> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TopologyResultResponseLinks() : instance as! TopologyResultResponseLinks
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["additionalInfo"] as AnyObject?) {
                
                case let .success(value): _result.additionalInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endPortID"] as AnyObject?) {
                
                case let .success(value): _result.endPortID = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endPortIpv4Address"] as AnyObject?) {
                
                case let .success(value): _result.endPortIpv4Address = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endPortIpv4Mask"] as AnyObject?) {
                
                case let .success(value): _result.endPortIpv4Mask = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endPortName"] as AnyObject?) {
                
                case let .success(value): _result.endPortName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["endPortSpeed"] as AnyObject?) {
                
                case let .success(value): _result.endPortSpeed = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["greyOut"] as AnyObject?) {
                
                case let .success(value): _result.greyOut = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["linkStatus"] as AnyObject?) {
                
                case let .success(value): _result.linkStatus = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["source"] as AnyObject?) {
                
                case let .success(value): _result.source = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startPortID"] as AnyObject?) {
                
                case let .success(value): _result.startPortID = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startPortIpv4Address"] as AnyObject?) {
                
                case let .success(value): _result.startPortIpv4Address = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startPortIpv4Mask"] as AnyObject?) {
                
                case let .success(value): _result.startPortIpv4Mask = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startPortName"] as AnyObject?) {
                
                case let .success(value): _result.startPortName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["startPortSpeed"] as AnyObject?) {
                
                case let .success(value): _result.startPortSpeed = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tag"] as AnyObject?) {
                
                case let .success(value): _result.tag = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["target"] as AnyObject?) {
                
                case let .success(value): _result.target = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TopologyResultResponseLinks", actual: "\(source)"))
            }
        }
        // Decoder for [TopologyResultResponseNodes]
        Decoders.addDecoder(clazz: [TopologyResultResponseNodes].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[TopologyResultResponseNodes]> in
            return Decoders.decode(clazz: [TopologyResultResponseNodes].self, source: source)
        }

        // Decoder for TopologyResultResponseNodes
        Decoders.addDecoder(clazz: TopologyResultResponseNodes.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<TopologyResultResponseNodes> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? TopologyResultResponseNodes() : instance as! TopologyResultResponseNodes
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["aclApplied"] as AnyObject?) {
                
                case let .success(value): _result.aclApplied = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["additionalInfo"] as AnyObject?) {
                
                case let .success(value): _result.additionalInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: TopologyResultResponseCustomParam.self, source: sourceDictionary["customParam"] as AnyObject?) {
                
                case let .success(value): _result.customParam = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dataPathId"] as AnyObject?) {
                
                case let .success(value): _result.dataPathId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceType"] as AnyObject?) {
                
                case let .success(value): _result.deviceType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["family"] as AnyObject?) {
                
                case let .success(value): _result.family = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["fixed"] as AnyObject?) {
                
                case let .success(value): _result.fixed = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["greyOut"] as AnyObject?) {
                
                case let .success(value): _result.greyOut = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ip"] as AnyObject?) {
                
                case let .success(value): _result.ip = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["label"] as AnyObject?) {
                
                case let .success(value): _result.label = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkType"] as AnyObject?) {
                
                case let .success(value): _result.networkType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["nodeType"] as AnyObject?) {
                
                case let .success(value): _result.nodeType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["order"] as AnyObject?) {
                
                case let .success(value): _result.order = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["osType"] as AnyObject?) {
                
                case let .success(value): _result.osType = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["platformId"] as AnyObject?) {
                
                case let .success(value): _result.platformId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["role"] as AnyObject?) {
                
                case let .success(value): _result.role = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["roleSource"] as AnyObject?) {
                
                case let .success(value): _result.roleSource = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["softwareVersion"] as AnyObject?) {
                
                case let .success(value): _result.softwareVersion = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["tags"] as AnyObject?) {
                
                case let .success(value): _result.tags = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["upperNode"] as AnyObject?) {
                
                case let .success(value): _result.upperNode = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userId"] as AnyObject?) {
                
                case let .success(value): _result.userId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vlanId"] as AnyObject?) {
                
                case let .success(value): _result.vlanId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["x"] as AnyObject?) {
                
                case let .success(value): _result.x = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["y"] as AnyObject?) {
                
                case let .success(value): _result.y = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "TopologyResultResponseNodes", actual: "\(source)"))
            }
        }
        // Decoder for [UnClaimDeviceResponse]
        Decoders.addDecoder(clazz: [UnClaimDeviceResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[UnClaimDeviceResponse]> in
            return Decoders.decode(clazz: [UnClaimDeviceResponse].self, source: source)
        }

        // Decoder for UnClaimDeviceResponse
        Decoders.addDecoder(clazz: UnClaimDeviceResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<UnClaimDeviceResponse> in
            if let source = source as? UnClaimDeviceResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias UnClaimDeviceResponse", actual: "\(source)"))
            }
        }
        // Decoder for [UnclaimRequest]
        Decoders.addDecoder(clazz: [UnclaimRequest].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[UnclaimRequest]> in
            return Decoders.decode(clazz: [UnclaimRequest].self, source: source)
        }

        // Decoder for UnclaimRequest
        Decoders.addDecoder(clazz: UnclaimRequest.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<UnclaimRequest> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? UnclaimRequest() : instance as! UnclaimRequest
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["deviceIdList"] as AnyObject?) {
                
                case let .success(value): _result.deviceIdList = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "UnclaimRequest", actual: "\(source)"))
            }
        }
        // Decoder for [UpdateDeviceResponse]
        Decoders.addDecoder(clazz: [UpdateDeviceResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[UpdateDeviceResponse]> in
            return Decoders.decode(clazz: [UpdateDeviceResponse].self, source: source)
        }

        // Decoder for UpdateDeviceResponse
        Decoders.addDecoder(clazz: UpdateDeviceResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<UpdateDeviceResponse> in
            if let source = source as? UpdateDeviceResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias UpdateDeviceResponse", actual: "\(source)"))
            }
        }
        // Decoder for [UpdateSettingsResponse]
        Decoders.addDecoder(clazz: [UpdateSettingsResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[UpdateSettingsResponse]> in
            return Decoders.decode(clazz: [UpdateSettingsResponse].self, source: source)
        }

        // Decoder for UpdateSettingsResponse
        Decoders.addDecoder(clazz: UpdateSettingsResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<UpdateSettingsResponse> in
            if let source = source as? UpdateSettingsResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias UpdateSettingsResponse", actual: "\(source)"))
            }
        }
        // Decoder for [UpdateWorkflowResponse]
        Decoders.addDecoder(clazz: [UpdateWorkflowResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[UpdateWorkflowResponse]> in
            return Decoders.decode(clazz: [UpdateWorkflowResponse].self, source: source)
        }

        // Decoder for UpdateWorkflowResponse
        Decoders.addDecoder(clazz: UpdateWorkflowResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<UpdateWorkflowResponse> in
            if let source = source as? UpdateWorkflowResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias UpdateWorkflowResponse", actual: "\(source)"))
            }
        }
        // Decoder for [ViewSettingsResponse]
        Decoders.addDecoder(clazz: [ViewSettingsResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[ViewSettingsResponse]> in
            return Decoders.decode(clazz: [ViewSettingsResponse].self, source: source)
        }

        // Decoder for ViewSettingsResponse
        Decoders.addDecoder(clazz: ViewSettingsResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<ViewSettingsResponse> in
            if let source = source as? ViewSettingsResponse {
                return .success(source)
            } else {
                return .failure(.typeMismatch(expected: "Typealias ViewSettingsResponse", actual: "\(source)"))
            }
        }
        // Decoder for [VlanListResult]
        Decoders.addDecoder(clazz: [VlanListResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[VlanListResult]> in
            return Decoders.decode(clazz: [VlanListResult].self, source: source)
        }

        // Decoder for VlanListResult
        Decoders.addDecoder(clazz: VlanListResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<VlanListResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? VlanListResult() : instance as! VlanListResult
                switch Decoders.decodeOptional(clazz: [VlanListResultResponse].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "VlanListResult", actual: "\(source)"))
            }
        }
        // Decoder for [VlanListResultResponse]
        Decoders.addDecoder(clazz: [VlanListResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[VlanListResultResponse]> in
            return Decoders.decode(clazz: [VlanListResultResponse].self, source: source)
        }

        // Decoder for VlanListResultResponse
        Decoders.addDecoder(clazz: VlanListResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<VlanListResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? VlanListResultResponse() : instance as! VlanListResultResponse
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["interfaceName"] as AnyObject?) {
                
                case let .success(value): _result.interfaceName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ipAddress"] as AnyObject?) {
                
                case let .success(value): _result.ipAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["mask"] as AnyObject?) {
                
                case let .success(value): _result.mask = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["networkAddress"] as AnyObject?) {
                
                case let .success(value): _result.networkAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["numberOfIPs"] as AnyObject?) {
                
                case let .success(value): _result.numberOfIPs = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["prefix"] as AnyObject?) {
                
                case let .success(value): _result._prefix = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["vlanNumber"] as AnyObject?) {
                
                case let .success(value): _result.vlanNumber = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vlanType"] as AnyObject?) {
                
                case let .success(value): _result.vlanType = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "VlanListResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [VlanNamesResult]
        Decoders.addDecoder(clazz: [VlanNamesResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[VlanNamesResult]> in
            return Decoders.decode(clazz: [VlanNamesResult].self, source: source)
        }

        // Decoder for VlanNamesResult
        Decoders.addDecoder(clazz: VlanNamesResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<VlanNamesResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? VlanNamesResult() : instance as! VlanNamesResult
                switch Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "VlanNamesResult", actual: "\(source)"))
            }
        }
        // Decoder for [WirelessInfoResult]
        Decoders.addDecoder(clazz: [WirelessInfoResult].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[WirelessInfoResult]> in
            return Decoders.decode(clazz: [WirelessInfoResult].self, source: source)
        }

        // Decoder for WirelessInfoResult
        Decoders.addDecoder(clazz: WirelessInfoResult.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<WirelessInfoResult> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? WirelessInfoResult() : instance as! WirelessInfoResult
                switch Decoders.decodeOptional(clazz: WirelessInfoResultResponse.self, source: sourceDictionary["response"] as AnyObject?) {
                
                case let .success(value): _result.response = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "WirelessInfoResult", actual: "\(source)"))
            }
        }
        // Decoder for [WirelessInfoResultResponse]
        Decoders.addDecoder(clazz: [WirelessInfoResultResponse].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[WirelessInfoResultResponse]> in
            return Decoders.decode(clazz: [WirelessInfoResultResponse].self, source: source)
        }

        // Decoder for WirelessInfoResultResponse
        Decoders.addDecoder(clazz: WirelessInfoResultResponse.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<WirelessInfoResultResponse> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? WirelessInfoResultResponse() : instance as! WirelessInfoResultResponse
                switch Decoders.decodeOptional(clazz: [Int32].self, source: sourceDictionary["adminEnabledPorts"] as AnyObject?) {
                
                case let .success(value): _result.adminEnabledPorts = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["apGroupName"] as AnyObject?) {
                
                case let .success(value): _result.apGroupName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["deviceId"] as AnyObject?) {
                
                case let .success(value): _result.deviceId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ethMacAddress"] as AnyObject?) {
                
                case let .success(value): _result.ethMacAddress = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["flexGroupName"] as AnyObject?) {
                
                case let .success(value): _result.flexGroupName = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceTenantId"] as AnyObject?) {
                
                case let .success(value): _result.instanceTenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["instanceUuid"] as AnyObject?) {
                
                case let .success(value): _result.instanceUuid = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["lagModeEnabled"] as AnyObject?) {
                
                case let .success(value): _result.lagModeEnabled = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["netconfEnabled"] as AnyObject?) {
                
                case let .success(value): _result.netconfEnabled = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: WirelessInfoResultResponse.WirelessLicenseInfo.self, source: sourceDictionary["wirelessLicenseInfo"] as AnyObject?) {
                
                case let .success(value): _result.wirelessLicenseInfo = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["wirelessPackageInstalled"] as AnyObject?) {
                
                case let .success(value): _result.wirelessPackageInstalled = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "WirelessInfoResultResponse", actual: "\(source)"))
            }
        }
        // Decoder for [Workflow]
        Decoders.addDecoder(clazz: [Workflow].self) { (source: AnyObject, instance: AnyObject?) -> Decoded<[Workflow]> in
            return Decoders.decode(clazz: [Workflow].self, source: source)
        }

        // Decoder for Workflow
        Decoders.addDecoder(clazz: Workflow.self) { (source: AnyObject, instance: AnyObject?) -> Decoded<Workflow> in
            if let sourceDictionary = source as? [AnyHashable: Any] {
                let _result = instance == nil ? Workflow() : instance as! Workflow
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["_id"] as AnyObject?) {
                
                case let .success(value): _result.id = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["addToInventory"] as AnyObject?) {
                
                case let .success(value): _result.addToInventory = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["addedOn"] as AnyObject?) {
                
                case let .success(value): _result.addedOn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["configId"] as AnyObject?) {
                
                case let .success(value): _result.configId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["currTaskIdx"] as AnyObject?) {
                
                case let .success(value): _result.currTaskIdx = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?) {
                
                case let .success(value): _result.description = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["endTime"] as AnyObject?) {
                
                case let .success(value): _result.endTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["execTime"] as AnyObject?) {
                
                case let .success(value): _result.execTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["imageId"] as AnyObject?) {
                
                case let .success(value): _result.imageId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["lastupdateOn"] as AnyObject?) {
                
                case let .success(value): _result.lastupdateOn = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?) {
                
                case let .success(value): _result.name = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["startTime"] as AnyObject?) {
                
                case let .success(value): _result.startTime = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["state"] as AnyObject?) {
                
                case let .success(value): _result.state = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: [DeviceInnerSystemResetWorkflowTasks].self, source: sourceDictionary["tasks"] as AnyObject?) {
                
                case let .success(value): _result.tasks = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tenantId"] as AnyObject?) {
                
                case let .success(value): _result.tenantId = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?) {
                
                case let .success(value): _result.type = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["useState"] as AnyObject?) {
                
                case let .success(value): _result.useState = value
                case let .failure(error): break
                
                }
                switch Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["version"] as AnyObject?) {
                
                case let .success(value): _result.version = value
                case let .failure(error): break
                
                }
                return .success(_result)
            } else {
                return .failure(.typeMismatch(expected: "Workflow", actual: "\(source)"))
            }
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}
