//
//  PatientInformationTableViewController.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/24/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class PatientInformationTableViewController: UITableViewController {
    
    var patient: Patient!
    var patientRecord: PatientRecord!

    let tableData = ["Name", "Address", "Phone", "Martial Status", "Allergies", "Medication", "Required Test", "Perscribed Medication"]
    
    let detailData = ["Name", "Address", "Phone", "Martial Status", "Allergies", "Medication", "Required Test", "Perscribed Medication"]
    
    let actionData = ["Delete Patient Record", "Charge Patient", "Manage Patient Insurence", "Admit Patient", "Discharge Patient" , "Manage Patient Information", "Request Patient Test", "Complete Patient Test", "Diagnose Symptoms","Issue Treatent", "Prescribe Medication", "Check Patient Status", "Transfer Patient"]
    
    let vitalsData = ["Height", "Weight", "Blood Pressure", "Time Taken"]
    
    let technicalActionData = ["Complete Patient Test", "Diagnose Symptoms", "Check Patient Status", "Manage Patient Info"]
    let adminData = [ "Discharge Patient", "Manage Patient Info", "Delete Patient Record", "Charge Patient", "Manage Patient Insurence"]
    let operationalData = ["Request Patient Test", "Complete Patient Test", "Diagnose Symptom", "Issue Treatment", "Prescribe Medication","Check Patient Status", "Transfer Patient"]
    
    var flag  = "1"
    //flag 0 = admin, 1 = operational, 2 = technical
    
    var selectionFlag = 0
    //0 = symptoms, 1 = test, 2 = treatment, 3 = medication
    
    var patientRecord: PatientRecord!
    var patient : Patient!

    
    
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
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return tableData.count
        }
        
        if section == 1 {
            return vitalsData.count
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
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = patient.name
                cell.accessoryType = .None
                cell.userInteractionEnabled = false
                break
            case 1:
                cell.detailTextLabel?.text = patient.address.description
                cell.accessoryType = .None
                cell.userInteractionEnabled = false
                break
            case 2:
                cell.detailTextLabel?.text = patient.phoneNumber
                cell.accessoryType = .None
                cell.userInteractionEnabled = false
                break
            case 3:
                if patient.married {
                    cell.detailTextLabel?.text = "Married"
                } else {
                    cell.detailTextLabel?.text = "Single"
                }
                cell.accessoryType = .None
                cell.userInteractionEnabled = false
                break
            default:
                cell.detailTextLabel?.text = ""
            }
        } else if indexPath.section == 1 {
            cell.textLabel?.text = vitalsData[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = patientRecord.measurements?.height
                cell.accessoryType = .None
                break
            case 1:
                cell.detailTextLabel?.text = String(patientRecord.measurements?.weight)
                cell.accessoryType = .None
                break
            case 2:
                cell.detailTextLabel?.text = patientRecord.measurements?.bloodPressure
                cell.accessoryType = .None
                break
            case 3:
                cell.detailTextLabel?.text = patientRecord.measurements?.updatedAt?.getDateForAppointment()
                cell.accessoryType = .None
                break
            default:
                break
            }
        }
        else
        {
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .DisclosureIndicator
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
        } else if section == 1 {
            return "Vitals"
        }
        return "Actions"
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
        switch flag {
        case UserTypes.AdminUser.rawValue:
         
        
            if indexPath.section == 2 {
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


            if indexPath.section == 2 {
                //request patient test
                if indexPath.row == 0 {
                    selectionFlag = 0
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                //complete patient test
                if indexPath.row == 1 {
                    selectionFlag = 1
                    self.performSegueWithIdentifier("List", sender: self)
                }
                //diagnose symptoms
                if indexPath.row == 2 {
                    selectionFlag = 2
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                //issue treatment
                if indexPath.row == 3 {
                    selectionFlag = 3
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                //persrcibe medication
                if indexPath.row == 4 {
                    selectionFlag = 4
                    self.performSegueWithIdentifier("List", sender: tableView)
                }
                if indexPath.row == 5 {
                    //check patient statius
                }
                if indexPath.row == 6 {
                    let alert = UIAlertController(title: "Transfer patient", message: "Please enter the name of a doctor to transfer the patient to.", preferredStyle: .Alert)
                    alert.addTextFieldWithConfigurationHandler({ (textField) in
                        textField.placeholder = "Doctor's name"
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
                    alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) in
                        let doctorName = alert.textFields?.first?.text
                        ParseClient.transferPatient(toNewDoctorWithName: doctorName!, withPatientRecord: self.patientRecord, completion: { (success, error) in
                            if !success || error != nil {
                                //TODO: Present error
                                var errorMessage: String = ""
                                if error != nil {
                                    errorMessage = error!.localizedDescription
                                }
                                let alert = getDefaultAlert("Couldn't transfer patient", message: errorMessage, actions: nil, useDefaultAction: true)
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        })
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
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
