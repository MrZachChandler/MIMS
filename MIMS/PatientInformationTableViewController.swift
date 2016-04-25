//
//  PatientInformationTableViewController.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/24/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class PatientInformationTableViewController: UITableViewController {

    let tableData = ["Name", "Address", "Phone", "Martial Status", "Allergies", "Medication", "Required Test", "Perscribed Medication"]
    
    let detailData = ["Name", "Address", "Phone", "Martial Status", "Allergies", "Medication", "Required Test", "Perscribed Medication"]
    
    let actionData = ["Delete Patient Record", "Charge Patient", "Manage Patient Insurence", "Admit Patient", "Discharge Patient" , "Manage Patient Information", "Request Patient Test", "Complete Patient Test", "Diagnose Symptoms","Issue Treatent", "Prescribe Medication", "Check Patient Status", "Transfer Patient"]
    
    let technicalActionData = ["Complete Patient Test", "Diagnose Symptoms", "Check Patient Status", "Manage Patient Info"]
    let adminData = [ "Discharge Patient", "Manage Patient Info", "Delete Patient Record", "Charge Patient", "Manage Patient Insurence"]
    let operationalData = ["Request Patient Test", "Complete Patient Test", "Diagnose Symptom", "Issue Treatment", "Prescribe Medication","Check Patient Status", "Transfer Patient"]
    
    var flag  = "1"
    //flag 0 = admin, 1 = operational, 2 = technical

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userType = MIMSUser.currentUser()!.userType else {
            flag = ""
            return
        }
        
        flag = userType

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return tableData.count
        }

        else if flag == UserTypes.AdminUser.rawValue
        {
            return adminData.count
        }
        else if flag == UserTypes.TechnicalUser.rawValue
        {
            return technicalActionData.count

        }
        //else operational user
        else
        {
            return operationalData.count

        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Information", forIndexPath: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = tableData[indexPath.row]
            cell.detailTextLabel?.text = detailData[indexPath.row]
        }
        else
        {
            cell.textLabel?.text = actionData[indexPath.row]
            cell.detailTextLabel?.text = " "
        }
        
        
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Information"
            
        }
        else{
            return "Actions"
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch flag {
        case UserTypes.AdminUser.rawValue:
            if indexPath.section == 1 {
                
            }
        case UserTypes.TechnicalUser.rawValue:
            print(indexPath.row)
            
        case UserTypes.OperationalUser.rawValue:
            print(indexPath.row)
            
        default:
            print(indexPath.row)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
