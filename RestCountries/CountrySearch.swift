//
//  CountrySearch.swift
//  RestCountries
//
//  Created by Admin on 8/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
struct CountrySearch {
    
    enum selectedScope: Int {
        case name = 0
        case code = 1
        case callingCode = 2
    }
    
    func filterCountries (countries:[Country], scopeIndex: Int, for text: String) -> [Country]?
    {
        switch scopeIndex {
        case selectedScope.name.rawValue:
            return countries.filter({(item) -> Bool in
                return item.name.lowercased().contains(text.lowercased())
            })
        case selectedScope.code.rawValue:
            return countries.filter{checkAlphaCode(item: $0, searchText: text)}
            
        case selectedScope.callingCode.rawValue:
            return countries.filter{checkCallingCodes(item: $0, searchText: text)}
            
        default:
            return nil
        }
        
    }
    
    private func checkCallingCodes(item: Country, searchText: String) -> Bool
    {
        if let callingCodes = item.callingCodes {
            for code in callingCodes
            {
                if code.contains(searchText)
                {
                    return true
                }
            }
        }
        return false
    }
    
    private func checkAlphaCode(item: Country, searchText: String) -> Bool
    {
        if let alpha2Code = item.alpha2Code  {
            if alpha2Code.contains(searchText.uppercased()) {
                return true
            }
        }
        if let alpha3Code = item.alpha3Code {
            if alpha3Code.contains(searchText.uppercased()) {
                return true
            }
        }
        return false
    }

}
