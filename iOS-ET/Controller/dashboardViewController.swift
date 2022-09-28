//
//  dashboardViewController.swift
//
//  @Copyright 2022 - iOS-ET created by iOS Group
//

import Foundation
import UIKit
import CoreData

var balances:[Balance]?

class dashboardViewController: UIViewController {
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    
    var username: String = "hello";
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide navbar
        self.navigationController?.isNavigationBarHidden = true;
        self.fetchBalance();
    }
    
    func fetchBalance() {
        do {
            let fetchBalance = Balance(context: self.context);
            let requestIncome = fetchBalance.fetchBalanceType(username, "Income");
            let requestExpense = fetchBalance.fetchBalanceType(username, "Expense");
            let incomeResult = try context.fetch(requestIncome);
            let expenseResult = try context.fetch(requestExpense);
            var totalIncome: Double = 0;
            var totalExpense: Double = 0;

            // perform calculation for income
            for data in incomeResult as [NSManagedObject] {
                let user = data.value(forKey: "userName") as? String;
                let type = data.value(forKey: "type") as? String;
                
                if user == self.username && type == "income" {
                    // convert the data for calculation
                    // then display the result onto screen
                    let toCalculateIncome = data.value(forKey: "amount") as! Double;
                    totalIncome += toCalculateIncome;
                    totalIncomeLabel.text = String(totalIncome);
                }
            }
            
            // perform calculation for expense
            for data in expenseResult as [NSManagedObject] {
                let user = data.value(forKey: "userName") as? String;
                let type = data.value(forKey: "type") as? String;
                
                if user == self.username && type == "expense" {
                    // convert the data for calculation
                    // then display the result onto screen
                    let toCalculateExpense = data.value(forKey: "amount") as! Double;
                    totalExpense += toCalculateExpense;
                    totalExpenseLabel.text = String(totalExpense);
                }
            }
            
            // perform calculation for balance = income - expense
            totalBalanceLabel.text = String(totalIncome - totalExpense);
        } catch {
            print("unable to retrieve data")
        }
    }
    
    @IBAction func createButton(_ sender: Any) {
        // create alert
        let alert = UIAlertController(title: "New Invoice", message: "Enter all required information", preferredStyle: .alert)
        alert.addTextField();
        alert.addTextField();
        alert.addTextField();
        
        // get the textfield
        let typeTF = alert.textFields![0];
        let amountTF = alert.textFields![1];
        let categoryTF = alert.textFields![2];
        
        typeTF.placeholder = "Income or Expense?";
        amountTF.placeholder = "Enter Amount";
        categoryTF.placeholder = "Which Category";
        
        let addButton = UIAlertAction(title: "Create", style: .default) { (action) in
            // create the invoice object
            let newInvoice = Balance(context: self.context);
            let amount = (amountTF.text! as NSString).floatValue;
            
            newInvoice.createInvoice(username: self.username, type: typeTF.text ?? "", amount: Double(amount), category: categoryTF.text ?? "");
            
            // re-fetch the data by reload the UI
            self.viewDidLoad();
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel);
        
        // add buttons
        alert.addAction(addButton);
        alert.addAction(cancelButton);
        
        // show alert
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func viewProfileButton(_ sender: Any) {
        // perform segue programmatically
        self.performSegue(withIdentifier: "goToProfile", sender: nil);
    }
    
    @IBAction func viewCategory(_ sender: Any) {
        // perform segue programmatically
        self.performSegue(withIdentifier: "goToCategory", sender: nil);
    }
    
    // function to pass data to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check whether it is the right segue
        if (segue.identifier == "goToProfile") {
            // find the destination profileViewController and pass relevant data over
            if let destinationVC = segue.destination as?
                profileViewController {
                destinationVC.username = username;
                destinationVC.currentIncome = totalIncomeLabel.text ?? "0";
                destinationVC.currentExpense = totalExpenseLabel.text ?? "0";
                destinationVC.currentBalance = totalBalanceLabel.text ?? "0";
            }
        } else if (segue.identifier == "goToCategory") {
            // find the destination selectCategoryViewController and pass relevant data over
            if let destinationVC = segue.destination as?
                selectCategoryViewController {
                destinationVC.username = username;
            }
        }
    }
}
