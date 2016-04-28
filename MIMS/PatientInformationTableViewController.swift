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
    
    var selectionFlag = 0
    //0 = symptoms, 1 = test, 2 = treatment, 3 = medication
    
    
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
            switch flag  {
            case UserTypes.AdminUser.rawValue:
                cell.textLabel?.text = adminData[indexPath.row]
            case UserTypes.TechnicalUser.rawValue:
                cell.textLabel?.text = technicalActionData[indexPath.row]
            case UserTypes.OperationalUser.rawValue:
                cell.textLabel?.text = operationalData[indexPath.row]
            default:
                cell.textLabel?.text = operationalData[indexPath.row]
            }
            return cell
        }
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Information"
            
        }
        else {
            return "Actions"
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch flag {
        case UserTypes.AdminUser.rawValue:
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    
                }
                if indexPath.row == 1 {
                    
                }
                if indexPath.row == 2 {
                    
                }
                if indexPath.row == 3 {
                    
                }
                if indexPath.row == 4 {
                    
                }
                
            }
            
         
        
            if indexPath.section == 1 {
                //Discharge Patient
                if indexPath.row == 0 {
                    //ParseClient.dischargePatient(PatientRecord)
                }
                //manage patient information
                if indexPath.row == 1 {
                    
                }
                //delete patient record
                if indexPath.row == 2 {
                    let deleteAlert = UIAlertController(title: "Delete Patient Record", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    deleteAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action: UIAlertAction!) in
                        
                    }))
                    
                    deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    }))
                    
                    presentViewController(deleteAlert, animated: true, completion: nil)
                    
                }
                //charge Patient
                if indexPath.row == 3 {
                    let message = self.title
                    let chargeAlert = UIAlertController(title: "Charge Patient", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    chargeAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction!) in
                        
                    }))
                    
                    chargeAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    }))
                    
                    presentViewController(chargeAlert, animated: true, completion: nil)
                    
                }
                //manage patient insurence
                if indexPath.row == 4 {
                    
                }
            }
        case UserTypes.TechnicalUser.rawValue:
            if indexPath.section == 0 {
                
            }
            if indexPath.section == 1 {
                //complete patient test
                if indexPath.row == 0 {
                    
                }
                //diagnose symptoms
                if indexPath.row == 1 {
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                //chaeck patient status
                if indexPath.row == 2 {
                    
                }
                //manage patient info
                if indexPath.row == 3 {
                    
                }
                
            }
        case UserTypes.OperationalUser.rawValue:
            if indexPath.section == 0 {
                
            }

            if indexPath.section == 1 {
                //request patient test
                if indexPath.row == 0 {
                    selectionFlag = 1
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                //complete patient test
                if indexPath.row == 1 {
                    
                }
                //diagnose symptoms
                if indexPath.row == 2 {
                    selectionFlag = 0
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                //issue treatment
                if indexPath.row == 3 {
                    selectionFlag = 2
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                //persrcibe medication
                if indexPath.row == 4 {
                    selectionFlag = 3
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
            }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "List" {
            let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let detailVC:SelectionListTableViewController = segue.destinationViewController as! SelectionListTableViewController
            detailVC.flag = selectionFlag
            if flag == UserTypes.AdminUser.rawValue
            {
                detailVC.title = adminData[indexPath.row]
            }
            if flag == UserTypes.TechnicalUser.rawValue
            {
                detailVC.title = technicalActionData[indexPath.row]
            }
                //else operational user
            else
            {
                detailVC.title = operationalData[indexPath.row]
                
            }
            detailVC.navigationItem.backBarButtonItem?.title = "Back"
        }
    }
    

}
