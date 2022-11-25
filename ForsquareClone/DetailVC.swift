//
//  DetailVC.swift
//  ForsquareClone
//
//  Created by Zeynep Özdemir Açıkgöz on 29.07.2022.
//

import UIKit
import MapKit
import Parse

class DetailVC: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailTypeLAbel: UILabel!
    @IBOutlet weak var detailAutmosphereLabel: UILabel!
    @IBOutlet weak var detailMapView: MKMapView!
    
    var choosenPlacedId = ""
    var choosenLatitude = Double()
     var choosenLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getDataFromParse()
        detailMapView.delegate = self
  
        }

func getDataFromParse(){
    let query = PFQuery(className: "Places")
    query.whereKey("objectId", equalTo: choosenPlacedId)
    query.findObjectsInBackground { objects, error in
        if error != nil{
            
            
        }else {
            if objects != nil{
                if objects!.count > 0 {
                    let choosenPlaceObject = objects![0]
                    if let placeName = choosenPlaceObject.object(forKey: "name") as? String{
                        self.detailNameLabel.text = placeName
                    }
                    
                    if let placeType = choosenPlaceObject.object(forKey: "type") as? String{
                        self.detailTypeLAbel.text = placeType
                    }
                    if let placeAtmosphere = choosenPlaceObject.object(forKey: "atmosphere") as? String{
                        self.detailAutmosphereLabel.text = placeAtmosphere
                    }
                    if let placeLatitude = choosenPlaceObject.object(forKey: "latitude") as? String{
                        if let placeLatitudeDouble = Double(placeLatitude){
                            self.choosenLatitude = placeLatitudeDouble
                        }
                    }
                    
                    if let placeLongitude = choosenPlaceObject.object(forKey: "longitude") as? String{
                        if let placeLongitudeDouble = Double(placeLongitude){
                            self.choosenLatitude = placeLongitudeDouble
                        }
                    }
                    if let imagedata = choosenPlaceObject.object(forKey: "image") as? PFFileObject{
                        imagedata.getDataInBackground { data, error in
                            if error == nil{
                                if data != nil{
                                    self.detailImageView.image = UIImage(data: data!)
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    
                    //MAPS
                    let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailMapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.detailNameLabel.text!
                    annotation.subtitle = self.detailTypeLAbel.text!
                    self.detailMapView.addAnnotation(annotation)
                    
                    
                }
            }
        }}

    

}
    
    //pin eklemek ve pin yanındaki detail disclosurebutton çıkması
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
            
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
                pinView?.canShowCallout = true
                let button = UIButton(type: .detailDisclosure)
                pinView?.rightCalloutAccessoryView = button
            } else{
                pinView?.annotation = annotation
            }
            return pinView
            

        }
    
    //detail butona tıklanınca bana yeri gösterip arabayla nasıl gideceğimi göstermesi için yazdık
        
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        
        if self.choosenLatitude != 0.0 && self.choosenLongitude != 0.0{
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                
                if let placemark = placemarks{
                    
                    if placemark.count > 0{
                        
                        let mkPlaceMArk = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMArk)
                        mapItem.name = self.detailNameLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
                
            }
            

        }
    }
       
    }
        
        
        
    

