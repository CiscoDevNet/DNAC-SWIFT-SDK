//
//  DeviceDetailCell.swift
//  DNATestApplication
//
//  Copyright (c) 2018 Cisco.
//
// This software is licensed to you under the terms of the Cisco Sample
// Code License, Version 1.0 (the "License"). You may obtain a copy of the
// License at
//
// https://developer.cisco.com/docs/licenses
//
// All use of the material herein must be in accordance with the terms of
// the License. All rights not expressly granted by the License are
// reserved. Unless required by applicable law or agreed to separately in
// writing, software distributed under the License is distributed on an "AS
// IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
// or implied.
//
// All rights reserved.
//

import UIKit

class DeviceDetailCell: UITableViewCell {

    @IBOutlet weak var labelHostname: UILabel!
    @IBOutlet weak var labelSerialNo: UILabel!
    @IBOutlet weak var labelPlatformID: UILabel!
    @IBOutlet weak var labelSeries: UILabel!
    @IBOutlet weak var labelType: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /* ** Seting Cell Data ** */
    func setData(device:DeviceModalItem){
        labelHostname.text = device.hostname
        labelPlatformID.text = device.platformId
        labelSerialNo.text = device.serialNumber
        labelSeries.text = device.series
        labelType.text = device.type
    }
}
