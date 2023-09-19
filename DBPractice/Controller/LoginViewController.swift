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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    
    @IBAction func onPressLogin(_ sender: UIButton) {
        
       // let listViewController = ListViewViewController(nibName: "ListViewViewController", bundle: nil)

             // Push the second view controller onto the navigation stack
           //  self.navigationController?.pushViewController(listViewController, animated: true)
        
        
       let model = NetworkModel()

       model.login(user: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: {
           token, error in
          print( "LOGIN  Token: \(String(describing: token)) Error: \(String(describing: error))")
       }
        )
        model.getHeroes(completion: {heroes, error in
            print("GET HEROES Token: \(heroes)  Error: \(String(describing: error))")
        })
    }
    
}
