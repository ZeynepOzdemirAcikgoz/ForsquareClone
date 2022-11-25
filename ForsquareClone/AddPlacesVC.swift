//
//  AddPlacesVC.swift
//  ForsquareClone
//
//  Created by Zeynep Özdemir Açıkgöz on 29.07.2022.
//

import UIKit
import MapKit

//var globalName = ""
//var globalType = ""
//var globalAtmosphere = ""


class AddPlacesVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var placesNAmeText: UITextField!
    @IBOutlet weak var placesTypeText: UITextField!
    @IBOutlet weak var placesAtmosphere: UITextField!
    
    @IBOutlet weak var selectImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//pictutr tıklanabilir oldu
        selectImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        selectImage.addGestureRecognizer(gestureRecognizer)


    }
    
    
    @IBAction func nextClickes(_ sender: Any) {
        if placesNAmeText.text != "" && placesTypeText.text != "" && placesAtmosphere.text != "" {
            
            if let chosenImage = selectImage.image{
                PlaceModel.sharedInstance.placeName = placesNAmeText.text!
                PlaceModel.sharedInstance.placeType = placesTypeText.text!
                PlaceModel.sharedInstance.placeAtmosphere = placesAtmosphere.text!
                PlaceModel.sharedInstance.placeImage = chosenImage

                
            }
            self.performSegue(withIdentifier: "toMapVC", sender: nil)

        } else{
            
            let alert = UIAlertController(title: "Error!", message: "place name/Type/Atmosphere ??", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    @objc func choseImage(){
        //picker tanımlayıp galeriye gittik ve seçtik
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
}
