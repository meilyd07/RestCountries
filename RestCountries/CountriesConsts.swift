//
//  CountriesURL.swift
//  RestCountries
//
//  Created by Admin on 8/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
struct CountriesConsts
{
    static let allCountriesList = URL(string: "https://restcountries.eu/rest/v2/all")
    static let urlCodeByIp = URL(string:"http://ip-api.com/json/?fields=countryCode")
    static let urlTextCountries = "https://restcountries.eu/rest/v2/alpha/"
    static let urlTextPolygon = "https://raw.githubusercontent.com/mledoze/countries/master/data/"
    static let urlTextEnd = ".geo.json"
    static let urlCurrencyExchange = "https://openexchangerates.org/api/latest.json?app_id=6e3dadb61abf41cba7c58f2eb8ea4de7&symbols="
}
