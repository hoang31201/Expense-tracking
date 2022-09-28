//
//  ViewController.swift
//
//  @Copyright 2022 - iOS-ET created by iOS Group
//

import UIKit

var users:[User]?;

class ViewController: UIViewController {
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var feedBackTF: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide nav bar
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    func fetchUser() {
        // retrieve the data from core data
        do {
            users = try context.fetch(User.fetchRequest());
        } catch {
            print("unable to fetch data")
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        // check if the textfield is empty or not
        if ((validateTF(userNameTF.text ?? "")) == false && (validateTF(pwdTF.text ?? "")) == false) {
            feedBackTF.textColor = UIColor.systemYellow;
            feedBackTF.text = "Enter username and password";
        } else if validateLogin(username: userNameTF.text!, pwd: pwdTF.text!) == false {
            feedBackTF.textColor = UIColor.systemYellow;
            feedBackTF.text = "incorrect username or password";
        } else {
            // after validations are complete; perform segue programmatically
            // move to the dashboard when "sign in" button is clicked
            self.performSegue(withIdentifier: "loginToDashboard", sender: nil);
        }
    }
    
    // validate func to check whether textfield are empty
    func validateTF(_ textfield: String) -> Bool {
        if textfield.isEmpty {
            return false;
        }
        return true;
    }
    
    // validate func to check login details
    func validateLogin(username: String, pwd: String) -> Bool {
        let user = User(context: self.context);
        
        if user.validateUser(userNameTF.text!, pwdTF.text!) == true {
            return true;
        }
        return false;
    }
    
    // function to pass data to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check whether it is the right segue
        if (segue.identifier == "loginToDashboard") {
            // find the destination dashboardViewController and pass relevant data over
            if let destinationVC = segue.destination as?
                dashboardViewController {
                destinationVC.username = userNameTF.text ?? "hello";
            }
        }
    }
}
