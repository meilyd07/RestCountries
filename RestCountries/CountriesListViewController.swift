//
//  CountriesListViewController.swift
//  RestCountries
//
//  Created by Admin on 8/20/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CountriesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - Model
    
    private var countries = [Country]()
    {
        didSet {
            currentCountries = countries
        }
    }
    private var currentCountries = [Country]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var search = CountrySearch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.backgroundView = spinner
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Helper.getCountriesDatafromJSON { (countriesData) in
            if let countriesData = countriesData {
                self.countries = countriesData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    let ac = UIAlertController(title: "Unable to complete", message: "An error occured during loading countries.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryFlagCell", for: indexPath)
        
        let country = currentCountries[indexPath.row]
        if let countryCell = cell as? CountryFlagTableViewCell {
            countryCell.country = country
        }
        
        return cell
    }
    
    // MARK: - Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            if searchText.isEmpty {
                currentCountries = countries
            }
            else {
                if let results = search.filterCountries(countries: countries, scopeIndex: searchBar.selectedScopeButtonIndex, for: searchText)
                {
                    currentCountries = results
                }
            }
            tableView.reloadData()
        }
        
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Country detail":
                if let cell = sender as? CountryFlagTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let seguedToMVC =
                    (segue.destination.contents as? DetailTableViewController)
                {
                    seguedToMVC.country = currentCountries[indexPath.row]
                }
            default: break
            }
        }
    }

}
