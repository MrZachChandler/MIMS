//
//  AdmitPatientTableViewController.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/29/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class AdmitPatientTableViewController: UITableViewController {

    //titles
    let informationData = ["Name", "Birthday", "Phone", "S.S.N."]
    let address = ["Street", "City", "State", "Zip Code"]
    let insuranceInformation = ["PaymentInformation", "Experation Date", "Mem ID", "Group ID", "Copay" ]
    let vitals = ["Height: ft","Height: in", "Weight: lb", "BP:Systolic", "BP:Diastolic"]
    let appointmentInformation = ["Time", "Date"]
    
    //patient
    var name = ""
    var phone = ""
    var ssn = ""
    var birthday = ""
        //NSDate.getDateForAppointment(NSDate())
                                    //patient.birthday^
    var street = ""
    var city = ""
    var state = ""
    var zipCode = ""
    
    var paymentInfo = ""
    var expiration = ""
    var memid = ""
    var groupid = ""
    var copay = ""
    
    var heightft = ""
    var heightIn = ""
    var weight = ""
    var bpS = ""
    var bpD = ""
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let save = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(SelectionListTableViewController.saveTapped(_:)))
        
        self.navigationItem.setRightBarButtonItem(save, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return informationData.count
        } else if section == 1 {
            return address.count
        }
        else if section == 2
        {
            return insuranceInformation.count
        }
        else if section == 3
        {
            return vitals.count
        }
        return appointmentInformation.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataEntry", forIndexPath: indexPath) as! AddTableViewCell
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.DataNamw.text = informationData[indexPath.row]
                
            }
            if indexPath.row == 1 {
                cell.DataNamw.text = informationData[indexPath.row]

                //TODO: date picker
            }
            if indexPath.row == 2 {
                cell.DataNamw.text = informationData[indexPath.row]

                
            }
            if indexPath.row == 3 {
                cell.DataNamw.text = informationData[indexPath.row]

                
            }
            
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.DataNamw.text = address[indexPath.row]
                
            }
            if indexPath.row == 1 {
                cell.DataNamw.text = address[indexPath.row]
                
            }
            if indexPath.row == 2 {
                cell.DataNamw.text = address[indexPath.row]
                
                
            }
            if indexPath.row == 3 {
                cell.DataNamw.text = address[indexPath.row]
                
                
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.DataNamw.text = insuranceInformation[indexPath.row]
                
            }
            if indexPath.row == 1 {
                cell.DataNamw.text = insuranceInformation[indexPath.row]
                
                //TODO: date picker
            }
            if indexPath.row == 2 {
                cell.DataNamw.text = insuranceInformation[indexPath.row]
                
                
            }
            if indexPath.row == 3 {
                cell.DataNamw.text = insuranceInformation[indexPath.row]
                
                
            }
            if indexPath.row == 4 {
                cell.DataNamw.text = insuranceInformation[indexPath.row]

            }
            
        }
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                cell.DataNamw.text = vitals[indexPath.row]
                
            }
            if indexPath.row == 1 {
                cell.DataNamw.text = vitals[indexPath.row]
                
                //TODO: date picker
            }
            if indexPath.row == 2 {
                cell.DataNamw.text = vitals[indexPath.row]
                
                
            }
            if indexPath.row == 3 {
                cell.DataNamw.text = vitals[indexPath.row]
                
                
            }
            if indexPath.row == 4 {
                cell.DataNamw.text = vitals[indexPath.row]
                
            }
            
            
        }
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                cell.DataNamw.text = vitals[indexPath.row]
                //TODO: time picker

            }
            if indexPath.row == 1 {
                cell.DataNamw.text = vitals[indexPath.row]
                
                //TODO: date picker
            }
        }
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Information"
        } else if section == 1 {
            return "Address"
        }
        else if section == 2
        {
            return "Finanace & Insurance Information"
        }
        else if section == 3
        {
            return "Measurements"
        }
        return "Appointment Time"
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            print("indexPath.row \(indexPath.row)")
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

extension AdmitPatientTableViewController: AddDataTableviewDelegate {
    func changedWithNewValue(newValue: String, forIndexPath: NSIndexPath) {
        switch forIndexPath.section {
        case 0:
            if forIndexPath.row == 0 {
                name = newValue
                print("name \(name)")
            }
            if forIndexPath.row == 1 {
                birthday = newValue
            }
            if forIndexPath.row == 2 {
                phone = newValue
            }
            if forIndexPath.row == 3 {
                ssn = newValue
            }
            
        case 1:
            if forIndexPath.row == 0 {
                street = newValue
            }
            if forIndexPath.row == 1 {
                city = newValue
            }
            if forIndexPath.row == 2 {
                state = newValue
            }
            if forIndexPath.row == 3 {
                zipCode = newValue
            }

        case 2:
            if forIndexPath.row == 0 {
                paymentInfo = newValue
            }
            if forIndexPath.row == 1 {
                expiration = newValue
            }
            if forIndexPath.row == 2 {
                memid = newValue
            }
            if forIndexPath.row == 3 {
                groupid = newValue
            }
            if forIndexPath.row == 4 {
                copay = newValue
            }
        case 3:

            if forIndexPath.row == 0 {
                heightft = newValue
            }
            if forIndexPath.row == 1 {
                heightIn = newValue
            }
            if forIndexPath.row == 2 {
                weight = newValue
            }
            if forIndexPath.row == 3 {
                bpS = newValue
            }
            if forIndexPath.row == 4 {
                bpS = newValue
            }
            
        case 4:
            if forIndexPath.row == 0 {
                
            }
            if forIndexPath.row == 1 {
                
            }
            
            
        default:
            print(forIndexPath)
        }
    }
}
