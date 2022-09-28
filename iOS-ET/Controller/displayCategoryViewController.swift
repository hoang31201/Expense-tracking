//
//  detailExpenseDisplayViewController.swift
//
//  @Copyright 2022 - iOS-ET created by iOS Group
//

import Foundation
import UIKit
import CoreData

class displayCategoryViewController: UIViewController {
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var titleLable: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    var username: String = "hello"
    var categoryTitle: String = "Hello";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the nav bar
        self.navigationController?.isNavigationBarHidden = true;
        titleLable.text = categoryTitle;
        self.display();
    }
    
    // fetch data from the database and display to table view
    func display() {
        do {
            // called the fetchBalanceCategory() to filter data based on category and sort it based on "date" in descending order
            // load the filtered and sorted data into the table
            let fetchBalance = Balance(context: self.context);
            let request = fetchBalance.fetchBalanceCategory(self.username, categoryTitle)
            let sort = NSSortDescriptor(key: "date", ascending: false);
            request.sortDescriptors = [sort];
            balances = try context.fetch(request);
            
            // re-load the data to the table
            DispatchQueue.main.async {
                self.detailTable.reloadData();
            }
        } catch {
            print("unable to retrieve data")
        }
    }
}

extension displayCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    // return table rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balances?.count ?? 0;
    }
    
    // display data into tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayExpense", for: indexPath)
        let balance = balances![indexPath.row];
        
        // reformat the data for display uses
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/YYYY";
                
        // display data to corresponding cells
        cell.textLabel?.text = String(balance.amount);
        cell.detailTextLabel?.text = dateFormatter.string(from: balance.date!);
        
        // set background color based on income or expenses
        if balance.type == "income" {
            cell.contentView.backgroundColor = UIColor.systemTeal;
        } else {
            cell.contentView.backgroundColor = UIColor.systemRed;
        }
        
        // return cell
        return cell
    }
    
    // delete func
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // create the swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            // which data to delete
            let personToRemove = balances![indexPath.row];
            
            // remove the data
            self.context.delete(personToRemove);
            
            // save the data
            do {
                try self.context.save();
            } catch {
                print("unable to save data");
            }
            
            // re-fetch the data
            self.display();
        }

        // return the swipe action
        return UISwipeActionsConfiguration(actions: [action]);
    }
}
