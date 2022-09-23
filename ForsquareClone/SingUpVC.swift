//
//  ViewController.swift
//  ForsquareClone
//
//  Created by Zeynep Özdemir Açıkgöz on 25.07.2022.
//

import UIKit
import Parse

class SingUpVC: UIViewController {
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordTExt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        
        
      /*  let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Graph"
        parseObject["calories"] = "80"
        parseObject["colors"] = "purple"

        parseObject.saveInBackground { success, error in
            if error != nil{
                
                print(error?.localizedDescription)
            }else{
                print("uploaded")
            }
        }*/
        
        
       /* let query = PFQuery(className: "Fruits")
        query.findObjectsInBackground { objects, error in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print(objects)
            }
        } */
        
        let query = PFQuery(className: "Fruits")
         query.whereKey("name", equalTo: "Apple")
        
        //query.whereKey("calories", greaterThan: 90)

         query.findObjectsInBackground{ objects, error in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print(objects)
            }
        }
        
    
    }
    @IBAction func singInClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordTExt.text != "" {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordTExt.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput:error?.localizedDescription ?? "Error")
                }else{
                    //SEGUE
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
            
        }
        
    }
    
    @IBAction func sıngUpClicked(_ sender: Any) {
    
        if usernameText.text != "" && passwordTExt.text != ""{
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordTExt.text!
           
            user.signUpInBackground { succes, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Erroe!!")
                }else{
                  //SEGUE
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                }
            }
            
        }else{
            makeAlert(titleInput: "error", messageInput: "USername/Password")
            
        }
    
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}

