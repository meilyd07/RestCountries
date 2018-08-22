//
//  CountryFlagTableViewCell.swift
//  RestCountries
//
//  Created by Admin on 8/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVGKit

class CountryFlagTableViewCell: FlagTableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var code: UILabel!
    
    var country: Country? {
        didSet {
            name?.text = country?.name
            code?.text = country?.alpha3Code
            url = country?.flag
            updateUI()
        }
    }

}
