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
    
    var tempObject: AnyObject!
    var rawValueArray: [String]!
    
    var pendingArry = [Bool]()
    var listflag = 0
    // 0 display patient info , 1 assign patient info
    
    var flag = 0;
    //0 = symptoms, 1 = test, 2 = treatment, 3 = medication
    var tableData = [String]()
    var sendingResults = [String]()
    var checked = [Bool]()
    
    let test = ["Get Height","Get Weight Blood","Get Blood Pressure","Take Blood","Check Pulse","Check Breathing","General Examination","Check Vision","Ear Examiniation", "Strep Testing"]
    
    let medication = ["Acetaminophen","Adderall","Alprazolam","Amitriptyline","Amlodipine","Amoxicillin","Ativan","Atorvastatin","Azithromycin","Ciprofloxacin","Citalopram","Clindamycin","Clonazepam","Codeine","Cyclobenzaprine","Cymbalta","Doxycycline","Gabapentin","Hydrochlorothiazide","Ibuprofen","Lexapro","Lisinopril","Loratadine","Lorazepam","Losartan","Lyrica","Meloxicam","Metformin","Metoprolol","Naproxen","Omeprazole","Oxycodone","Pantoprazole","Prednisone","Tramadol","Trazodone","Viagra","Wellbutrin","Xanax","Zoloft"]
    let treatment = ["Knee Surgery","Heart Surgery","Eye Surgery","Chest Surgery","Open Heart Surgery","Cranial Surgery","Hand Surgery","Spinal Surgery","Toe Surgery","Mental Surgery"]
    let symptoms = ["Symptoms1","Symptoms2","Symptoms3","Symptoms4","Symptoms5","Symptoms6","Symptoms7","Symptoms8","Symptoms9","Symptoms10","Symptoms11"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if listflag == 0
        {
            
            
            switch flag {
            case 4:
                if patientRecord.conditions?.allergies == nil
                {
                    tableData = ["No Allergies on file."]
                }
                else
                {
                    tableData = (patientRecord.conditions?.allergies)!
                    
                }
            case 5:
                if patientRecord.testsTaken == nil
                {
                    tableData = ["No Test have been taken."]
                }
                else
                {
                    for item in patientRecord.testsTaken!
                    {
                        tableData.append(item.testDescription!)
                        if item.completedStatus == false {
                        }
                    }
                }
            case 6:
                if patientRecord.conditions == nil
                {
                    tableData = ["No Conditions options have been issued."]
                }
                else
                {
                    
                    for item in (patientRecord.conditions?.disease)!
                    {
                        tableData.append(item)
                    }
                    for item in (patientRecord.conditions?.disorders)!
                    {
                        tableData.append(item)
                    }
                }
            case 7:
                if patientRecord.treatments?.prescriptions == nil
                {
                    tableData = ["No Medication is on file."]
                    print(patientRecord.treatments?.prescriptions?.description)
                    
                }
                else
                {
                    for item in (patientRecord.treatments?.prescriptions)!
                    {
                        tableData.append(item.script!)
                    }
                }
            default:
                tableData = medication
                
            }
        }
        else
        {
            let save = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(SelectionListTableViewController.saveTapped(_:)))
            
            self.navigationItem.setRightBarButtonItem(save, animated: true)
            
            
            switch flag {
            case 0:
                tableData = test
            case 1:
                let nonCompletedTests = self.patientRecord.testsTaken!.filter({ (test) -> Bool in
                    return !test.completedStatus!
                })
                tableData = nonCompletedTests.map {$0.testDescription!}
            case 2:
                tableData = createSymptoms()
            case 3:
                tableData = treatment
            default:
                tableData = medication
            }
        }
        let sizeArray = [Bool](count: tableData.count, repeatedValue: false)
        checked = sizeArray
        pendingArry = sizeArray
        tableData = tableData.map {$0.localizedCapitalizedString}
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    

    
    func createSymptoms() -> [String] {
        var symptoms = [String]()
        
        for disease in iterateEnum(Disease.Disease.self) {
            symptoms.append(disease.rawValue.localizedUppercaseString)
        }
        
        for disorder in iterateEnum(Disorder.Disorders.self) {
            symptoms.append(disorder.rawValue.localizedUppercaseString)
        }
        
        for allergy in iterateEnum(Allergy.Allergies.self) {
            symptoms.append(allergy.rawValue.localizedUppercaseString)
        }
        
        return symptoms
    }
    
    
    @IBAction func saveTapped(sender: AnyObject) {
        if sendingResults.count != 0 {
            switch flag {
            case 0:
                //request patient test
                ParseClient.addPatientTests(self.sendingResults, toPatientRecord: patientRecord)
                self.navigationController?.popViewControllerAnimated(true)
                break
            case 1:
                //complete patient tests
                for testSelected in self.sendingResults {
                    for test in self.patientRecord.testsTaken! {
                        if test.testDescription! == testSelected {
                            test.changeCompletionStatus(true, timeCompleted: NSDate())
                            test.saveInBackground()
                        }
                    }
                }
                self.patientRecord.saveInBackgroundWithBlock({ (success, error) in
                    if success && error == nil {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            case 2:
                //symptoms
                var patientConditions: Condition!
                if self.patientRecord.conditions == nil {
                    patientConditions = Condition(defaultInit: true)
                    self.patientRecord.conditions = patientConditions
                } else {
                    patientConditions = self.patientRecord.conditions!
                }
                for var newSymptom in self.sendingResults {
                    newSymptom = newSymptom.lowercaseString
                    do {
                        if let allergy = try? Allergy(withAllergyName: newSymptom) {
                            try patientConditions.addAllergy(allergy.description)
                        } else if let disease = try? Disease(withDiseaseName: newSymptom) {
                            try patientConditions.addDisease(disease.description)
                        } else if let disorder = try? Disorder(withDisorderName: newSymptom) {
                            try patientConditions.addDisorder(disorder.description)
                        }

                    } catch let error as NSError {
                        //TODO: Present Error
                        let alert = getDefaultAlert("Uh oh", message: error.localizedDescription, actions: nil, useDefaultAction: true)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                patientRecord.saveInBackgroundWithBlock({ (success, error) in
                    if success && error == nil {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
                break
            case 3:
                //issue treatment
                var patientTreatmentRecord: Treatment!
                if self.patientRecord.treatments == nil {
                    let treatment = Treatment(defaultInit: true)
                    self.patientRecord.treatments = treatment
                } else {
                    patientTreatmentRecord = self.patientRecord.treatments!
                }
                for request in self.sendingResults {
                    patientTreatmentRecord.addSurgery(Surgery(withSurgeon: MIMSUser.currentUser()!, surgeryName: request))
                }
                patientTreatmentRecord.saveInBackgroundWithBlock({ (success, error) in
                    if success && error == nil {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            case 4:
                //prescribe medicine
                var patientTreatmentRecord: Treatment!
                if self.patientRecord.treatments == nil {
                    let treatment = Treatment(defaultInit: true)
                    self.patientRecord.treatments = treatment
                } else {
                    patientTreatmentRecord = self.patientRecord.treatments!
                }
                for medication in self.sendingResults {
                    patientTreatmentRecord.addNewScript(Prescription(withPharmacist: MIMSUser.currentUser()!, newScript: medication))
                }
                patientTreatmentRecord.saveInBackgroundWithBlock({ (success, error) in
                    if success && error == nil {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
                break
            default:
                break
            }
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
        if listflag == 0 {
            if flag == 5
            {
                if patientRecord.testsTaken![indexPath.row].completedStatus == true
                {
                
                    cell.textLabel?.text = tableData[indexPath.row]
                    cell.detailTextLabel?.text = "Completed"
                }
                else
                {
                    cell.detailTextLabel?.text = "Pending"
                }
                cell.textLabel?.text = tableData[indexPath.row]
                cell.accessoryType = .None
                cell.selectionStyle = .None
            }
        }
        else
        {
            cell.textLabel?.text = tableData[indexPath.row]
            cell.detailTextLabel?.text = ""

            if !checked[indexPath.row] {
                cell.accessoryType = .None
            } else if checked[indexPath.row] {
                cell.accessoryType = .Checkmark
            }
        }
        return cell

    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if listflag == 0 {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
        else
        {
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
