//
//  Helper.swift
//  RestCountries
//
//  Created by Admin on 8/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class Helper {
    static func getCountriesDatafromJSON(finished: @escaping ((_ countriesData: [Country]?)->Void))
    {
        let session = URLSession(configuration: .default)
        if let url = CountriesConsts.allCountriesList {
            let task = session.dataTask(with: url) {
                (data, urlResponse, error) in
                
                guard let data = data, error == nil, urlResponse != nil else {
                    print("Loading countries error")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let downloadedCountries = try decoder.decode([Country].self, from: data)
                    finished(downloadedCountries)
                    
                } catch {
                    print("Decoding countries JSON error: \(error)")
                }
                
            }
            task.resume()
        }
    }
    
    static func getCurrencyRate(currencyCode:String, finished: @escaping ((_ rate: CurrencyRate?)->Void))
    {
        let session = URLSession(configuration: .default)
        if let urlCountryFullInfo = URL(string: CountriesConsts.urlCurrencyExchange + currencyCode) {
            
            let task = session.dataTask(with: urlCountryFullInfo) {
                (data, urlResponse, error) in
                
                guard let data = data, error == nil, urlResponse != nil else {
                    print("Loading currency error")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let currencyRate = try decoder.decode(CurrencyRate.self, from: data)
                    finished(currencyRate)
                    
                } catch {
                    print("Decoding currency JSON error: \(error)")
                }
                
            }
            task.resume()
        }
    }
    
    
    static func downloadCountryData(url:URL?, completed: @escaping ((_ countryData: Country?) -> Void)) {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) {data, urlResponse, error in
            
            guard let data = data, error == nil, urlResponse != nil else {
                print("Loading country error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let downloadedCountry = try decoder.decode(Country.self, from: data)
                
                completed(downloadedCountry)
                
            } catch {
                print("Decoding country JSON error: \(error)")
            }
            
            }.resume()
    }
    
    static func getCountryDataByIP(finished: @escaping ((_ countryData: Country?)->Void)) {
        if let downloadURL = CountriesConsts.urlCodeByIp {
            URLSession.shared.dataTask(with: downloadURL) {data, URLResponse, error in
                guard let data = data, error == nil, URLResponse != nil else {
                    
                    print("Loading country by IP error")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let downloadedCountryCode = try decoder.decode([String:String].self, from: data)
                    
                    if let code = downloadedCountryCode["countryCode"] {
                        let urlCountryFullInfo = URL(string: CountriesConsts.urlTextCountries + code)
                        downloadCountryData(url: urlCountryFullInfo, completed: { countryInfo  in
                            finished(countryInfo)
                        })
                        
                    }
                    
                } catch {
                    print(error)
                }
                
                }.resume()
         
        }
    }
    
}
