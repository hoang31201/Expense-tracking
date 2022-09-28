//
//  profileViewController.swift
//
//  @Copyright 2022 - iOS-ET created by iOS Group
//

import Foundation
import UIKit
import CoreData

class profileViewController: UIViewController {
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pwdLabel: UILabel!
    
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var monthlyIncome: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    var username: String = "hello";
    var currentIncome: String = "0";
    var currentExpense: String = "0";
    var currentBalance: String = "0";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide navbar and retieve and display data to screen
        self.navigationController?.isNavigationBarHidden = true;
        totalIncomeLabel.text = currentIncome;
        totalExpenseLabel.text = currentExpense;
        totalBalanceLabel.text = currentBalance;
        self.fetchUser();
    }
    
    func fetchUser() {
        do {
            let fetchUser = User(context: self.context);
            let request = fetchUser.fetchUser(username)
            let result = try context.fetch(request);
            
            // for-loop to display corresponding data to the UI
            for data in result as [NSManagedObject] {
                let montlyIncome = data.value(forKey: "monthIncome") as! NSNumber;
                let spendingLimit = data.value(forKey: "spendingLimit") as! NSNumber;
                
                firstNameLabel.text = data.value(forKey: "firstName") as? String;
                lastNameLabel.text = data.value(forKey: "lastName") as? String;
                monthlyIncome.text = montlyIncome.stringValue;
                limitLabel.text = spendingLimit.stringValue;
                userNameLabel.text = data.value(forKey: "userName") as? String;
                pwdLabel.text = data.value(forKey: "pwd") as? String;
            }
        } catch {
            print("unable to retrieve data")
        }
    }
    
    @IBAction func incomeButton(_ sender: Any) {
        let alert = UIAlertController(title: "Update Income", message: "New Monthly Income: ", preferredStyle: .alert)
        alert.addTextField();
        
        // get the textfield and pass in existing data
        let incomeTF = alert.textFields![0];
        incomeTF.text = monthlyIncome.text;
        
        // create button and call the update func then reload data display on screen
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            let updateUser = User(context: self.context);
            updateUser.updateUser(username: self.username, data: incomeTF.text ?? "", type: "Income")
            self.viewDidLoad();
        }
        
        // add button and show alert
        alert.addAction(saveButton);
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func limitButton(_ sender: Any) {
        // create alert
        let alert = UIAlertController(title: "Update Spending Limit", message: "New Spending Limit: ", preferredStyle: .alert)
        alert.addTextField();
        
        // get the textfield and pass in existing data
        let limitTF = alert.textFields![0];
        limitTF.text = limitLabel.text;
        
        // create button and call the update func then reload data display on screen
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            let updateUser = User(context: self.context);
            updateUser.updateUser(username: self.username, data: limitTF.text ?? "", type: "Spending")
            self.viewDidLoad();
        }
        
        // add button and show alert
        alert.addAction(saveButton);
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func pwdButton(_ sender: Any) {
        let alert = UIAlertController(title: "Update password", message: "New password: ", preferredStyle: .alert)
        alert.addTextField();
        
        // get the textfield and pass in existing data
        let pwdTF = alert.textFields![0];
        pwdTF.text = pwdLabel.text;
        
        // create button and call the update func then reload data display on screen
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            let updateUser = User(context: self.context);
            updateUser.updateUser(username: self.username, data: pwdTF.text ?? "", type: "pwd")
            self.viewDidLoad();
        }
        
        // add button and show alert
        alert.addAction(saveButton);
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func dashboardButton(_ sender: Any) {
        // perform segue programmatically
        self.performSegue(withIdentifier: "backToDash", sender: nil);
    }
    
    // function to pass data to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check whether it is the right segue
        if (segue.identifier == "backToDash") {
            // find the destination dashboardViewController and pass relevant data over
            if let destinationVC = segue.destination as?
                dashboardViewController {
                destinationVC.username = self.username;
            }
        }
    }
}
