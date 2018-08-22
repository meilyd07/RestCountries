//
//  DetailTableViewController.swift
//  RestCountries
//
//  Created by Admin on 8/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

private enum SectionType {
    case Flag
    case Name
    case Currencies
    case Code
    case Languages
    case Geography
}

private enum Item {
    case FlagImage
    case Name
    case NativeName
    case AlternativeSpellings
    case Demonym
    case Translations
    case Currencies
    case Alpha3Code
    case Alpha2Code
    case CallingCodes
    case NumericCode
    case TopLevelDomain
    case Languages
    case Capital
    case Region
    case Subregion
    case Area
    case Population
    case LatLng
    case Borders
}

private struct Section {
    var type: SectionType
    var items: [Item]
}


private var sections = [Section]()

class DetailTableViewController: UITableViewController {
    
    var country: Country? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }

    var currencyRateDict: [String: String] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sections = [
            Section(type: .Flag, items: [.FlagImage]),
            Section(type: .Name, items: [.Name, .NativeName, .AlternativeSpellings, .Demonym, .Translations]),
            Section(type: .Currencies, items: [.Currencies]),
            Section(type: .Code, items: [.Alpha3Code, .Alpha2Code, .CallingCodes, .NumericCode, .TopLevelDomain]),
            Section(type: .Languages, items: [.Languages]),
            Section(type: .Geography, items: [.Capital, .Region, .Subregion, .Area, .Population, .LatLng, .Borders])
        ]
        
        if country == nil {
            Helper.getCountryDataByIP(finished: {countryData in
                if let countryByIP = countryData {
                    self.country = countryByIP
                    self.retrieveCurrencyData()
                }
                else {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: "Unable to complete", message: "An error occured during loading country by Ip.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                }
            })
        }
        else {
            retrieveCurrencyData()
        }
    }
    
    private func retrieveCurrencyData() {
        if let countryInfo = country {
            if let currenciesArray = countryInfo.currencies {
                currenciesArray.forEach{item in
                    if let code = item.code {
                        
                        Helper.getCurrencyRate(currencyCode: code, finished: { currencyRate in
                            if let rate = currencyRate {
                                if let rates = rate.rates {
                                    if let value = rates[code] {
                                        self.currencyRateDict[code] = String(format: "%.6f", value)
                                    }
                                }
                            }
                        })
                        
                    }
            }
        }
    }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section].type {
        case .Flag:
            return "Flag"
        case .Name:
            return "Names"
        case .Currencies:
            return "Currencies"
        case .Code:
            return "Codes"
        case .Languages:
            return "Languages"
        case .Geography:
            return "Geography"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Country Detail Cell", for: indexPath)
        
        switch sections[indexPath.section].items[indexPath.row] {
        case .FlagImage:
            cell = tableView.dequeueReusableCell(withIdentifier: "Country Flag Cell", for: indexPath)
            if let cell = cell as? FlagTableViewCell {
                cell.url = country?.flag
                return cell
            }
            
        case .Name:
            cell.textLabel?.text = "Name:"
            cell.detailTextLabel?.text = country?.name
        case .NativeName:
            cell.textLabel?.text = "Native name:"
            cell.detailTextLabel?.text = country?.nativeName
        case .AlternativeSpellings:
            cell.textLabel?.text = "Alternative spelling:"
            cell.detailTextLabel?.text = country?.altSpellings?.joined(separator: ",\n")
        case .Demonym:
            cell.textLabel?.text = "Demonym:"
            cell.detailTextLabel?.text = country?.demonym
        case .Translations:
            cell.textLabel?.text = "Translations:"
            if let country = country, let dictTranslations = country.translations {
                var allText = ""
                for (key, value) in dictTranslations {
                    allText += key + ": " + (value ?? "") + "\n"
                }
                cell.detailTextLabel?.text = allText
            }
            else {
                cell.detailTextLabel?.text = "-"
            }
        case .Currencies:
            cell.textLabel?.text = "Currencies:"
            if let country = country, let currenciesArray = country.currencies {
                var lines = ""
                currenciesArray.forEach{item in
                    if let code = item.code {
                        lines += "Code: " + code + "\n"
                        lines += "Rate to USD: "
                        if let  currentRate = currencyRateDict[code] {
                            lines += "\(currentRate)\n"
                        }
                        else {
                            lines += "unknown\n"
                        }
                        lines += "\n"
                    }
                    if let name = item.name { lines += "Name: " + name + "\n" }
                    if let symbol = item.symbol { lines += "Symbol: " + symbol + ";\n\n" }
                }
                cell.detailTextLabel?.text = lines
            }
            else {
                cell.detailTextLabel?.text = "-"
            }
            
        case .Alpha3Code:
            cell.textLabel?.text = "ISO 3166 alpha-3:"
            cell.detailTextLabel?.text = country?.alpha3Code
        case .Alpha2Code:
            cell.textLabel?.text = "ISO 3166 alpha-2:"
            cell.detailTextLabel?.text = country?.alpha2Code
        case .CallingCodes:
            cell.textLabel?.text = "Calling codes:"
            cell.detailTextLabel?.text = country?.callingCodes?.joined(separator: ", ")
        case .NumericCode:
            cell.textLabel?.text = "ISO 3166 numeric:"
            cell.detailTextLabel?.text = country?.numericCode
        case .TopLevelDomain:
            cell.textLabel?.text = "Top level domain:"
            cell.detailTextLabel?.text = country?.topLevelDomain?.joined(separator: ", ")
        case .Languages:
            cell.textLabel?.text = "Languages:"
            if let country = country, let languagesArray = country.languages {
                var allLines = ""
                languagesArray.forEach{dictItem in
                    for (key, value) in dictItem {
                        allLines += key + ": " + (value ?? "") + "\n"
                    }
                }
                cell.detailTextLabel?.text = allLines
                
            }
            else {
                cell.detailTextLabel?.text = "-"
            }
        case .Capital:
            cell.textLabel?.text = "Capital:"
            cell.detailTextLabel?.text = country?.capital
        case .Region:
            cell.textLabel?.text = "Region:"
            cell.detailTextLabel?.text = country?.region
        case .Subregion:
            cell.textLabel?.text = "Subregion:"
            cell.detailTextLabel?.text = country?.subregion
        case .Area:
            cell.textLabel?.text = "Area:"
            if let country = country, let countryArea = country.area {
                cell.detailTextLabel?.text = String(format: "%.1f", countryArea)
            }
            else {
                cell.detailTextLabel?.text = "-"
            }
        case .Population:
            cell.textLabel?.text = "Population:"
            if let country = country, let countryPopulation = country.population {
                cell.detailTextLabel?.text = String(format: "%.0f", countryPopulation)
            }
            else {
                cell.detailTextLabel?.text = "-"
            }
        case .LatLng:
            cell.textLabel?.text = "Coordinates:"
            if let country = country, let coordinates = country.latlng {
                cell.detailTextLabel?.text = String(format: "[%.4f, %.4f]", coordinates[0], coordinates[1])
            }
            else {
                cell.detailTextLabel?.text = "-"
            }
        case .Borders:
            cell.textLabel?.text = "Borders:"
            cell.detailTextLabel?.text = country?.borders?.joined(separator: ",\n")
        }
        return cell
    }
}
