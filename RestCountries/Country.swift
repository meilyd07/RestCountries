//
//  Country.swift
//  Countries
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct Language: Codable {
    let iso639_1: String?
    let iso639_2: String?
    let name: String?
    let nativeName: String?
}

struct RegionalBlock: Codable {
    let acronym: String?
    let name: String?
    let otherAcronyms: [String]?
    let otherNames: [String]?
}

struct Country: Codable {
    let name: String
    let alpha2Code: String?
    let alpha3Code: String?
    
    let flag: String
    let capital: String?
    let region: String?
    let subregion: String?
    let population: Double?
    let demonym: String?
    let area: Double?
    let gini: Double?
    let cioc: String?
    let callingCodes: [String]?
    let topLevelDomain: [String]?
    let altSpellings: [String]?
    let latlng: [Double]?
    let timezones: [String]?
    let borders: [String]?

    let currencies: [Currency]?
    let languages: [[String:String?]]?
    
    let nativeName: String?
    let numericCode: String?
    let regionalBlocs: [RegionalBlock]?
    
    let translations: [String:String?]?
}
