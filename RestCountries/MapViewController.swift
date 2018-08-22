//
//  MapViewController.swift
//  RestCountries
//
//  Created by Admin on 8/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let regionRadius: CLLocationDistance = 5000000
    var points = [[CLLocationCoordinate2D]]()
    private var country: Country?
    
    private var polygonCountry: Polygon?
    {
        didSet {
            points.removeAll()
            if let doublesArray = polygonCountry?.features[0].geometry.coordinates2D {
                points[0] = doublesArray.map{CLLocationCoordinate2DMake($0[1], $0[0])}
            } else if let doublesArray = polygonCountry?.features[0].geometry.coordinates3D {
                for element in doublesArray {
                    points.append(element.map{CLLocationCoordinate2DMake($0[1], $0[0])})
                }
            } else if let doublesArray = polygonCountry?.features[0].geometry.coordinates4D {
                for elements in doublesArray {
                    for item in elements {
                        points.append(item.map{CLLocationCoordinate2DMake($0[1], $0[0])})
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.showCountryPolygon()
                let initialLocation = CLLocation(latitude: self.points[0][0].latitude, longitude: self.points[0][0].longitude)
                self.centerMapOnLocation(location: initialLocation)
                
                
                if self.country != nil {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                    self.performSegue(withIdentifier: "Country data", sender: nil)
                    }}
            }
            
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showCountryPolygon()
    {
        mapView.removeOverlays(mapView.overlays)
        //let polygon = MKPolygon(coordinates: &points, count: points.count)
        //mapView.add(polygon)
        for pointArray in points
        {
            var array = pointArray
            
            let polygon = MKPolygon(coordinates: &array, count: array.count)
            mapView.add(polygon)
            
            //let polyline = MKPolyline(coordinates: &array, count: array.count)
            //mapView.add(polyline)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    {
        didSet {
            let longTap = UITapGestureRecognizer(target: self, action: #selector(tapMapView(gestureRecognizer:)))
            mapView.addGestureRecognizer(longTap)
        }
    }
    
    @objc func tapMapView(gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)){(placemarks, error) -> Void in
                if error != nil {
                    print(String(describing: error))
                    return
                }
                
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        if let code = placemarks[0].isoCountryCode {
                            let urlCountryFullInfo = URL(string: CountriesConsts.urlTextCountries + code)
                            Helper.downloadCountryData(url: urlCountryFullInfo, completed: { countryInfo in
                                self.country = countryInfo
                                
                                if let country = self.country {
                                    
                                    if let alpha3code = country.alpha3Code {
                                        self.getPolygonData(url: URL(string: CountriesConsts.urlTextPolygon + alpha3code.lowercased() + CountriesConsts.urlTextEnd))
                                    }
                                    
                                    
                                }
                                else {
                                    print("Loading country error")
                                    DispatchQueue.main.async {
                                        let ac = UIAlertController(title: "Unable to complete", message: "An error occured during loading country.", preferredStyle: .alert)
                                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                                        self.present(ac, animated:  true)
                                    }
                                }
                                
                            })
                            
                            
                        }
                    }
                    else
                    {
                        print("no data")
                    }
                }
            }
        }
        
    }
    
    
    func getPolygonData(url:URL?)
    {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) {data, urlResponse, error in
            
            guard let data = data, error == nil, urlResponse != nil else {
                print("Loading country boarders error")
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Unable to complete", message: "An error occured during loading borders.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.polygonCountry = try decoder.decode(Polygon.self, from: data)
                
            } catch {
                
                print("Decoding polygon JSON error: \(error)")
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Unable to complete", message: "Unable to decode polygon.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
            
            }.resume()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .darkGray
            polylineRenderer.lineWidth = 5
            return polylineRenderer
            
        } else if overlay is MKPolygon {
            
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = UIColor.red
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "Country data":
                if let seguedToMVC = (segue.destination.contents as? DetailTableViewController) {
                    seguedToMVC.country = country
                }
            default: break
            }
        }
    }
    

}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }
        else
        {
            return self
        }
    }
}

