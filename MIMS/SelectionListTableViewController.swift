//
//  SelectionListTableViewController.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class SelectionListTableViewController: UITableViewController {

    var patient: Patient!
    var patientRecord: PatientRecord!
    
    var flag = 0;
    //0 = symptoms, 1 = test, 2 = treatment, 3 = medication
    var tableData = [String]()
    var sendingResults = [String]()
    var checked = [Bool]()
    
    let treatment = ["treatment1","treatment2","treatment3","treatment4","treatment5","treatment6","treatment7","treatment8","treatment9"]
    let medication = ["Medication1","Medication2","Medication3","Medication4","Medication5","Medication6","Medication7","Medication8","Medication9"]
    let test = ["test1","test2","test3","test4","test5","test6","test7","test8","test","test9","test10","test11","test12","test13","test14"]
    let symptoms = ["Symptoms1","Symptoms2","Symptoms3","Symptoms4","Symptoms5","Symptoms6","Symptoms7","Symptoms8","Symptoms9","Symptoms10","Symptoms11"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch flag {
        case 0:
            tableData = symptoms
        case 1:
            tableData = test
        case 2:
            tableData = treatment
        case 3:
            tableData = medication
        default:
            tableData = medication
        }
        let save = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(SelectionListTableViewController.saveTapped(_:)))
        
        self.navigationItem.setRightBarButtonItem(save, animated: true)

        let sizeArray = [Bool](count: tableData.count, repeatedValue: false)
        checked = sizeArray
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBAction func saveTapped(sender: AnyObject) {
        switch flag {
        case 0:
            //symptoms
            break
        case 1:
            ParseClient.addPatientTests(self.sendingResults, toPatientRecord: patientRecord)
        case 2:
             //treatment
            break
        case 3:
            tableData = medication
        default:
            tableData = medication
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        
        if !checked[indexPath.row] {
            cell.accessoryType = .None
        } else if checked[indexPath.row] {
            cell.accessoryType = .Checkmark
        }

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checked[indexPath.row] = false
                if let index = sendingResults.indexOf(tableData[indexPath.row]) {
                    self.sendingResults.removeAtIndex(index)
                }
            }
            else {
                cell.accessoryType = .Checkmark
                checked[indexPath.row] = true
                sendingResults.append(tableData[indexPath.row])
            }
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
