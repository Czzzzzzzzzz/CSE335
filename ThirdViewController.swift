//
//  ThirdViewController.swift
//  finalProject
//
//  Created by 陈泽 on 2018/10/14.
//  Copyright © 2018 ASU. All rights reserved.
//

import UIKit
import MapKit

class ThirdViewController: UIViewController {
    var la:String?
    var lo:String?
    var setOne:NSArray?
    var i = 0
    @IBOutlet weak var e6: UILabel!
    @IBOutlet weak var e5: UILabel!
    @IBOutlet weak var e4: UILabel!
    @IBOutlet weak var e3: UILabel!
    @IBOutlet weak var e2: UILabel!
    @IBOutlet weak var e1: UILabel!
    @IBOutlet weak var earthquake: UILabel!
    @IBOutlet weak var localsearch: UITextField!
    
    @IBOutlet weak var area: UITextField!
    
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func maptype(_ sender: Any) {
        switch(mapType.selectedSegmentIndex)
        {
        case 0:
            map.mapType = MKMapType.standard
            
        case 1:
            map.mapType = MKMapType.satellite
            
        case 2:
            map.mapType = MKMapType.hybrid
            
        default:
            map.mapType = MKMapType.standard
        }
    }
    @IBAction func setlocation(_ sender: Any) {
        let geoCoder = CLGeocoder();
        //let addressString = "699, S. Mill Ave, Tempe, AZ, 85281"
        var addressString:String?
        addressString = String(self.area.text!)
        if addressString != nil{
            CLGeocoder().geocodeAddressString(addressString!, completionHandler:
                {(placemarks, error) in
                    
                    if error != nil {
                        print("Geocode failed: \(error!.localizedDescription)")
                    } else if placemarks!.count > 0 {
                        let placemark = placemarks![0]
                        let location = placemark.location
                        let la = location!.coordinate.latitude
                        let lo = location!.coordinate.longitude
                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                        self.map.setRegion(region, animated: true)
                        let ani = MKPointAnnotation()
                        ani.coordinate = placemark.location!.coordinate
                        ani.title = placemark.locality
                        ani.subtitle = placemark.subLocality
                        self.map.addAnnotation(ani)
                    }
            })
            
        }
    }
    
    @IBAction func search(_ sender: Any) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        request.region = map.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            print( response.mapItems )
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            for i in 1...matchingItems.count - 1
            {
                let place = matchingItems[i].placemark
                let annotation = MKPointAnnotation()
                annotation.coordinate = place.location!.coordinate
                annotation.title = place.name
                self.map.addAnnotation(annotation)
                
            }
            
        }
    }
    
    @IBAction func earthquake(_ sender: Any) {
        let geoCoder = CLGeocoder();
        
        //let addressString = "699, S. Mill Ave, Tempe, AZ, 85281"
        let addressString = area.text
        CLGeocoder().geocodeAddressString(addressString!, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    self.la = String(location!.coordinate.latitude)
                    self.lo = String(location!.coordinate.longitude)
                    let n = Double(self.la!)!+10
                    let s = Double(self.la!)!-10
                    let e = Double(self.lo!)!-10
                    let w = Double(self.lo!)!+10
                    let ns = String(format:"%.2f",n)
                    let ss = String(format:"%.2f",s)
                    let es = String(format:"%.2f",e)
                    let ws = String(format:"%.2f",w)
                    let urlAsString = "http://api.geonames.org/earthquakesJSON?north=" + ns + "&south=" + ss + "&east="+es+"&west="+ws+"&username=jbasu"
                    print(urlAsString)
                    let url = URL(string: urlAsString)!
                    let urlSession = URLSession.shared
                    let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
                        if (error != nil) {
                            print(error!.localizedDescription)
                        }
                        var err: NSError?
                        var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                        if (err != nil) {
                            print("JSON Error \(err!.localizedDescription)")
                        }
                        self.setOne = jsonResult["earthquakes"] as! NSArray
                        print(self.setOne)
                        let earth = self.setOne![self.i] as? [String:AnyObject]
                        DispatchQueue.main.async {
                            self.earthquake.text = earth!["datetime"] as! String
                            self.e1.text = String((earth!["depth"] as! NSNumber).doubleValue)
                            self.e2.text = String((earth!["lng"] as! NSNumber).doubleValue)
                            self.e3.text = earth!["src"] as! String
                            self.e4.text = earth!["eqid"] as! String
                            self.e5.text = String((earth!["magnitude"] as! NSNumber).doubleValue)
                            self.e6.text = String((earth!["lat"] as! NSNumber).doubleValue)
                        }
                    })
                    
                    jsonQuery.resume()
                }
        })
    }
    
    @IBAction func next(_ sender: Any) {
        if setOne != nil{
            if i < setOne!.count-1 {
                i = i+1
                let earth = self.setOne![self.i] as? [String:AnyObject]
                DispatchQueue.main.async {
                    self.earthquake.text = earth!["datetime"] as! String
                    self.e1.text = String((earth!["depth"] as! NSNumber).doubleValue)
                    self.e2.text = String((earth!["lng"] as! NSNumber).doubleValue)
                    self.e3.text = earth!["src"] as! String
                    self.e4.text = earth!["eqid"] as! String
                    self.e5.text = String((earth!["magnitude"] as! NSNumber).doubleValue)
                    self.e6.text = String((earth!["lat"] as! NSNumber).doubleValue)
                }
            }else{
                print("It is the last record")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
