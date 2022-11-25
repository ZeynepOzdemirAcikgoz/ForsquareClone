//
//  MapVC.swift
//  ForsquareClone
//
//  Created by Zeynep Özdemir Açıkgöz on 29.07.2022.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapKit: MKMapView!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        //print(PlaceModel.sharedInstance.placeName)
        
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // ne kadar doğru yer bulacağını söylüyoruz
        locationManager.requestWhenInUseAuthorization() // sadece kullanıdğım zaman göster
        locationManager.startUpdatingLocation() // kullanıcının bulunduğu yeri güncellemeye başla
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(choseLocation(gestureRecognizer:))) //uzun basıldığında harekete geçiyor
        recognizer.minimumPressDuration = 3
        mapKit.addGestureRecognizer(recognizer)
        
    }
    @objc func choseLocation(gestureRecognizer: UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
            let touches = gestureRecognizer.location(in: self.mapKit)
            let coordinates = self.mapKit.convert(touches, toCoordinateFrom: self.mapKit)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapKit.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLAtitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation() //harita eski yerine dönmesin diye kullanocak olursak. yani 1 kere lokasyın güncellenicektir. tekrar güncellenmeden kullanıcı harita üzerinde gezinebilecektir.
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35) // enlem deltası ve boylam deltasını ne kadar zoomlu gösterceğini ifade ediyor
        let region = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
    }
    
    @objc func saveButtonClicked(){
        // PARSE SAVE
        
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLAtitude
        object["longitude"] = placeModel.placeLongitude
        
        //görseli data ya çeviriyoruz..
        
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        object.saveInBackground { succes, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }else {
                
                self.performSegue(withIdentifier: "fromMapVCtoPlaceVC", sender: nil)
            }
        }
        
        
    }
    @objc func backButtonClicked(){
        
        //navigationController?.popViewController(animated: true) ===>> yeni bir navigationController eklediğimiz için geri gidecek bir vc olmadığından bunu çalıştıramayız. bunun yerine bu vc kapatıp diğerine dönmek için bunu kullanmalıyız.
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
