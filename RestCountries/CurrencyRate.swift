//
//  CurrencyExchange.swift
//  RestCountries
//
//  Created by Admin on 8/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct CurrencyRate: Codable {
    let disclaimer: String?
    let license: String?
    let timestamp: Double?
    let base: String?
    let rates:[String:Double]?
}
