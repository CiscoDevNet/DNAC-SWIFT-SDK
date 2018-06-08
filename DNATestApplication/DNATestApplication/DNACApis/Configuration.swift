// Configuration.swift
//

//

import Foundation

open class Configuration {
	
	// This value is used to configure the date formatter that is used to serialize dates into JSON format. 
	// You must set it prior to encoding any dates, and it will only be read once. 
    open static var dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    
}