//
//  User+CoreDataClass.swift
//
//  @Copyright 2022 - iOS-ET created by iOS Group
//

import Foundation
import CoreData
import UIKit

@objc(User)
public class User: NSManagedObject {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    // add function
    func addUser(firstName: String, lastName: String, userName: String, pwd: String, monthlyIncome: Double, spendingLimit: Double) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.userName = userName;
        self.pwd = pwd;
        self.monthIncome = monthlyIncome;
        self.spendingLimit = spendingLimit;
        
        // save data
        saveUser();
    }
    
    // save data into database func
    func saveUser() {
        do {
            try self.context.save();
        } catch {
            print("unable to add user to database");
        }
    }
    
    // update func
    func updateUser(username: String, data: String, type: String) {
        let predicateUser = NSPredicate(format: "userName CONTAINS '\(username)' ");
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User");
        fetchRequest.predicate = predicateUser;

        do {
            let fetchResult = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let value = fetchResult.first as? User {
                if type == "Income" {
                    value.monthIncome = Double(data) ?? 0;
                } else if type == "pwd" {
                    value.pwd = data;
                } else {
                    value.spendingLimit = Double(data) ?? 0;
                }
            }
            
            // save data
            saveUser();
        } catch {
            print("error in updating");
        }
    }
    
    // retrieve specific user from core data (database)
    func fetchUser(_ userName: String) -> NSFetchRequest<User> {
        let request = User.fetchRequest() as NSFetchRequest<User>
        
        // set the filtering and return the filtered data
        let predicateUser = NSPredicate(format: "userName CONTAINS '\(userName)' ")
        request.predicate = predicateUser;
        return request;
    }
    
    // validate user login details
    // return "true" if login details matches else return "false"
    func validateUser(_ username: String,_ pwd: String) -> Bool {
        do {
            let request = fetchUser(username);
            let result = try context.fetch(request);
            
            for data in result as [NSManagedObject] {
                if username == data.value(forKey: "userName") as! String && pwd == data.value(forKey: "pwd") as! String {
                    return true;
                }
                return false;
            }
        } catch {
            print("unable to validate")
        }
        
        return false;
    }
    
    // validate existing username in database
    // return "true" if there is existing name else return "false"
    func validateExisting(_ username: String) -> Bool {
        do {
            let request = fetchUser(username);
            let result = try context.fetch(request);
            
            for data in result as [NSManagedObject] {
                if username == data.value(forKey: "userName") as! String {
                    return true;
                }
                return false;
            }
        } catch {
            print("unable to validate")
        }
        
        return false;
    }
}
