//
//  FlagTableViewCell.swift
//  RestCountries
//
//  Created by Admin on 8/21/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVGKit

class FlagTableViewCell: UITableViewCell {

    
    @IBOutlet weak var flagImageView: UIImageView!
    
    var url: String? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let flagStringURL = url, let flagURL = URL(string: flagStringURL) {
            URLSession.shared.dataTask(with: flagURL) { data, urlResponse, error in
                guard let data = data, error == nil, urlResponse != nil else {
                    return
                }
                let svgImgFlag = SVGKImage(data: data)
                DispatchQueue.main.async { [weak self] in
                    self?.flagImageView?.image = svgImgFlag?.uiImage
                }
                }.resume()
        }
    }
}
