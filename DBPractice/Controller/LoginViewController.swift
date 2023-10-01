//
//  LoginViewController.swift
//  DBPractice
//
//  Created by Marcos on 11/9/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "background")
        backgroundImage.image = image
    }
    
   
    
    @IBAction func onPressLogin(_ sender: UIButton) {
        
       let model = NetworkModel()
        model.login(
            user: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ){
            [weak self ] result in
            switch result {
                //Removed the token from succes because we get it form localStorage
            case .success(_):
                model.getHeroes {
                    result in
                    switch result {
                    case let .success(characters):
                        // Push the second view controller onto the navigation stack
                              DispatchQueue.main.async {
                            let listViewViewController = ListViewViewController(characters: characters, title: "Personajes")
                                  self?.navigationController?.setViewControllers([listViewViewController], animated: true)
                        }
                                  
                    case let .failure(error):
//                        Tryiting to show a toast to show a login error
//                        let alertController = UIAlertController(title: nil,   message: "Error", preferredStyle: .alert)
                        
//                        alertController.show(, sender: nil)
                        
                        print("Error getting heroes \(error)")
                    }
                    
                }
            case let .failure(error):
                print("Error login: \(error)")
            }
        }
        
//       model.login(user: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: {
//           token, error in
//          print( "LOGIN  Token: \(String(describing: token)) Error: \(String(describing: error))")
//       }
//        )
//       model.getHeroes(completion: {heroes, error in
//            print("GET HEROES Token: \(heroes)  Error: \(String(describing: error))")
//        })
        

        
    }
    
    
    
}
