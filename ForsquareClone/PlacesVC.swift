//
//  PlacesVC.swift
//  ForsquareClone
//
//  Created by Zeynep Özdemir Açıkgöz on 29.07.2022.
//

import UIKit
import Parse
class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlacesId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil{
                
                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
            }else{
                if objects != nil {
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                       if let placeName = object.object(forKey: "name") as? String{
                           if let placeId = object.objectId {
                               self.placeNameArray.append(placeName)
                               self.placeIdArray.append(placeId)
                           }
                        }
                    }
                    self.tableView.reloadData()
                    
                }
                                }
            }
        }
        
    
    
    @objc func addButtonClicked(){
     //Segue
        self.performSegue(withIdentifier: "toAddPlacesVC", sender: nil)
    }
    @objc func logOutButtonClicked(){
        PFUser.logOutInBackground { error in
            if error != nil{
                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
            }else{
                self.performSegue(withIdentifier: "toSingUpVC", sender: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toDetailVC"{
            
            let destinationVC = segue.destination as! DetailVC
            destinationVC.choosenPlacedId = selectedPlacesId
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlacesId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
