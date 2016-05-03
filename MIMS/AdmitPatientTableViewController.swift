//
//  AdmitPatientTableViewController.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/29/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class AdmitPatientTableViewController: UITableViewController {

    //titles
    let informationData = ["Name", "Birthday", "Phone", "S.S.N.", "Gender", "Marital Status"]
    let address = ["Street", "City", "State", "Zip Code"]
    let insuranceInformation = ["PaymentInformation", "Experation Date", "Mem ID", "Group ID", "Copay" ]
    let vitals = ["Height: ft","Height: in", "Weight: lb", "BP:Systolic", "BP:Diastolic"]
    let appointmentInformation = ["Date", "Time"]
    
    //patient
    var name = ""
    var phone = ""
    var ssn = ""
    var birthday = ""
    var birthdayDate: NSDate?
    var gender: Bool?
    var maritalStatus: Bool?
        //NSDate.getDateForAppointment(NSDate())
                                    //patient.birthday^
    var street = ""
    var city = ""
    var state = ""
    var zipCode = ""
    
    var paymentInfo = ""
    var expiration = ""
    var expirationDate: NSDate?
    var memid = ""
    var groupid = ""
    var copay = ""
    
    var heightft = ""
    var heightIn = ""
    var weight = ""
    var bpS = ""
    var bpD = ""
    
    var appointmentTime = ""
    var appointmentDay = ""
    var appointmentDate: NSDate?
    
    var patient: Patient?
    var patientRecord: PatientRecord?
    
    var editingIndex: NSIndexPath?
    
    //-1 for nothing, 0 for manage insurance, 1 for manage finance information
    var flag = -1
    var inputtedText = [NSIndexPath: String]()
    
    lazy var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.datePickerMode = .Date
        picker.minimumDate = NSDate.distantPast()
        picker.maximumDate = NSDate()
        return picker
    }()
    
    lazy var insuranceDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .Date
        picker.minimumDate = NSDate()
        picker.maximumDate = NSDate.distantFuture()
        return picker
    }()
    
    lazy var appointmentPicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor.blackColor() //UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor.lightGrayColor()// UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.darkGrayColor() //UIColor.yellowColor()
        return dp
    }()
    
    lazy var hourDatePicker: UIDatePicker = {
        let screenSize = UIScreen.mainScreen().bounds
        var hourPicker = UIDatePicker() //UIDatePicker(frame: CGRect(x: screenSize.minX, y: screenSize.maxY - 100, width: screenSize.width, height: 100))
        hourPicker.datePickerMode = UIDatePickerMode.Time
        let currentDate = self.appointmentDate
        hourPicker.minimumDate = self.appointmentDate
        hourPicker.minuteInterval = 10
        return hourPicker
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let save = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(SelectionListTableViewController.saveTapped(_:)))
        
        self.navigationItem.setRightBarButtonItem(save, animated: true)
        
        guard patient != nil && patientRecord != nil else {
            return
        }
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveNewPatient() {
        var alert: UIAlertController!

        do {
            let patientAddress = try Address(initWithAddressData: self.street, city: self.city, state: self.state, zip: self.zipCode)
            let finances = try FinancialInformation(initWithPaymentInfo: self.paymentInfo)
            let insurance = try InsuranceInfo(initWith: expirationDate!, memID: self.memid, grpID: self.groupid, amount: Int(self.copay)!)
            let vitals = try Measurement(initWithVitalData: Int(self.heightft)!, inches: Double(self.heightIn)!, weight: Double(self.weight)!, systolic: Int(self.bpS)!, diastolic: Int(self.bpD)!)
            let _ = ParseClient.admitPatient(withPatientInfo: patientAddress, insuranceInfo: insurance, financeInfo: finances, name: self.name, maritalStatus: self.maritalStatus!, gender: self.gender!, birthday: self.birthdayDate!, ssn: self.ssn, phone: self.phone, vitalInformation: vitals, completion: { (success, errorMessage, patientRecord) in
                if success && patientRecord != nil {
                    //TODO: PResent success image
                    patientRecord?.addAppointment(Appointment(initWithDoctor: patientRecord!.attendingPhysician, patient: patientRecord!.patient!, timeScheduled: self.appointmentDate!))
                    patientRecord?.saveInBackground()
                    self.navigationController?.popViewControllerAnimated(true)
                } else if errorMessage != "" {
                    alert = getDefaultAlert("Uh oh", message: errorMessage, actions: nil, useDefaultAction: true)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } catch MeasurementError.InvalidBloodPressure {
            alert = getDefaultAlert("Uh oh", message: "You entered an invalid blood pressure.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch MeasurementError.InvalidHeight {
            alert = getDefaultAlert("Uh oh", message: "You entered an invalid height", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch AddressError.InvalidAddress {
            alert = getDefaultAlert("Uh oh", message: "You entered invalid address information.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch FinanceError.InvalidPaymentInfo {
            alert = getDefaultAlert("Uh oh", message: "You entered invalid payment information.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch InsuranceError.InvalidExpirationDate {
            alert = getDefaultAlert("Uh oh", message: "You entered an invalid insurance expiration date.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch InsuranceError.InvalidInsuranceInformation {
            alert = getDefaultAlert("Uh oh", message: "You entered invalid insurance information.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch PatientError.InvalidBrthday {
            alert = getDefaultAlert("Uh oh", message: "You entered an invalid birthday.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch PatientError.InvalidName {
            alert = getDefaultAlert("Uh oh", message: "You entered an name.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch PatientError.InvalidPhoneNumber {
            alert = getDefaultAlert("Uh oh", message: "You entered an invalid phone number.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch PatientError.InvalidSSN {
            alert = getDefaultAlert("Uh oh", message: "You entered an invalid SSN.", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        } catch let error as NSError {
            alert = getDefaultAlert("Uh oh, we encountered an unknown error", message: error.localizedDescription, actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        var alert: UIAlertController
        guard checkFields() else {
            alert = getDefaultAlert("Uh oh", message: "You left some information blank!", actions: nil, useDefaultAction: true)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if self.patient == nil && self.patientRecord == nil {
            self.saveNewPatient()
        } else {
            self.patient!.name = self.name
            self.patient!.phoneNumber = self.phone
            self.patient!.ssn = self.ssn
            self.patient!.birthday = self.birthdayDate!
            self.patient!.gender = self.gender!
            self.patient!.married = self.maritalStatus!
            
            let address = self.patient!.address
            try! address.changeCity(self.city)
            try! address.changeZip(self.zipCode)
            try! address.changeState(self.state)
            try! address.changeStreet(self.street)
            self.patient!.address = address
            
            let vitals = self.patientRecord!.measurements!
            try! vitals.addHeight(Int(self.heightft)!, inches: Double(self.heightIn)!)
            try! vitals.addNewBloodPressure(Int(self.bpS)!, diastolic: Int(self.bpD)!)
            vitals.weight = Double(self.weight)
            self.patientRecord!.measurements = vitals
            
            let paymentInfo = self.patient!.financials
            let insurance = self.patient!.insurance
            
            paymentInfo.paymentInfo = self.paymentInfo
            insurance.expirationDate = self.expirationDate!
            insurance.memberID = self.memid
            insurance.groupID = self.groupid
            insurance.copay = Int(self.copay)
            self.patient!.financials = paymentInfo
            self.patient!.insurance = insurance
            
            self.patientRecord!.patient = self.patient!
            self.patientRecord!.saveInBackgroundWithBlock({ (success, error) in
                if success && error == nil {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    let alert = getDefaultAlert("Uh oh", message: "Unable to save new info", actions: nil, useDefaultAction: true)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
        
    }

    func loadData() {
        self.name = patient!.name
        self.phone = patient!.phoneNumber!
        self.ssn = patient!.ssn
        self.birthday = patient!.birthday.getDateForAppointment()
        self.gender = patient!.gender
        self.maritalStatus = patient!.married
        
        let address = self.patient!.address
        self.street = address.getStreet()
        self.city = address.getCity()
        self.state = address.getState()
        self.zipCode = address.getZip()
        
        let vitals = self.patientRecord!.measurements!
        self.weight = String(vitals.weight!)
        self.heightft = vitals.getFeet()
        self.heightIn = vitals.getInches()
        self.bpS = vitals.getSystolic()
        self.bpD = vitals.getDiastolic()
        
        let paymentInfo = self.patient!.financials
        let insurance = self.patient!.insurance
        self.paymentInfo = paymentInfo.paymentInfo!
        self.expiration = insurance.expirationDate!.getDateForAppointment()
        self.memid = insurance.memberID!
        self.groupid = insurance.groupID!
        self.copay = String(insurance.copay!)
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if patientRecord != nil {
            return 4
        }
        return 5
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
        cell.textFielf.inputView = UITextField().inputView
        
        if indexPath.section == 0 {
            cell.DataNamw.text = informationData[indexPath.row]
            if indexPath.row == 0 {
                cell.textFielf.text = self.name
            }
            else if indexPath.row == 1 {
                datePicker.addTarget(self, action: #selector(AdmitPatientTableViewController.updateLabel(_:)), forControlEvents: .ValueChanged)
                cell.textFielf!.inputView = datePicker
                print(self.birthday)
                cell.textFielf.text = self.birthdayDate?.getDateForAppointment()
            }
            else if indexPath.row == 2 {
                cell.textFielf.text = self.phone
                cell.textFielf.keyboardType = .PhonePad
            } else if indexPath.row == 3 {
                cell.textFielf.text = self.ssn
                cell.textFielf.keyboardType = .NumberPad
            } else if indexPath.row == 4 {
                print(self.gender)
                if gender == nil {
                    cell.textFielf.text = ""
                } else {
                    cell.textFielf.text = gender == true ? "Male" : "Female" ?? ""
                }
            } else {
                if maritalStatus == nil {
                    cell.textFielf.text = ""
                } else {
                    cell.textFielf.text = maritalStatus == true ? "Married" : "Single" ?? ""
                }
            }
        }
        if indexPath.section == 1 {
            cell.DataNamw.text = address[indexPath.row]
            if indexPath.row == 0 {
                cell.textFielf.text = self.street
            } else if indexPath.row == 1 {
                cell.textFielf.text = self.city
            } else if indexPath.row == 2 {
                cell.textFielf.text = self.state
            } else {
                cell.textFielf.text = self.zipCode
                cell.textFielf.keyboardType = .NumberPad
            }
        }
        if indexPath.section == 2 {
            cell.DataNamw.text = insuranceInformation[indexPath.row]
            if indexPath.row == 0 {
                cell.textFielf.text = self.paymentInfo
            }
            else if indexPath.row == 1 {
                insuranceDatePicker.addTarget(self, action: #selector(AdmitPatientTableViewController.updateLabel(_:)), forControlEvents: .ValueChanged)
                cell.textFielf.inputView = insuranceDatePicker
                cell.textFielf.text = self.expirationDate?.getDateForAppointment()
            } else if indexPath.row == 2 {
                cell.textFielf.text = self.memid
                cell.textFielf.keyboardType = .NumberPad
            } else if indexPath.row == 3 {
                cell.textFielf.text = self.groupid
                cell.textFielf.keyboardType = .NumberPad
            } else {
                cell.textFielf.text = self.copay
                cell.textFielf.keyboardType = .NumberPad
            }
        }
        if indexPath.section == 3 {
            cell.DataNamw.text = vitals[indexPath.row]
            if indexPath.row == 0 {
                cell.textFielf.text = self.heightft
                cell.textFielf.keyboardType = .NumberPad
            } else if indexPath.row == 1 {
                cell.textFielf.text = self.heightIn
                cell.textFielf.keyboardType = .DecimalPad
            } else if indexPath.row == 2 {
                cell.textFielf.text = self.weight
                cell.textFielf.keyboardType = .DecimalPad
            } else if indexPath.row == 3 {
                cell.textFielf.text = self.bpS
                cell.textFielf.keyboardType = .NumberPad
            } else if indexPath.row == 4 {
                cell.textFielf.text = self.bpD
                cell.textFielf.keyboardType = .NumberPad
            }
        }
        if indexPath.section == 4 {
            cell.DataNamw.text = appointmentInformation[indexPath.row]
            if indexPath.row == 0 {
                cell.textFielf.text = self.appointmentDay
                cell.textFielf.addTarget(self, action: #selector(AdmitPatientTableViewController.presentDate(_:)), forControlEvents: .EditingDidBegin)
            }
            if indexPath.row == 1 {
                cell.textFielf.text = self.appointmentTime
                hourDatePicker.addTarget(self, action: #selector(AdmitPatientTableViewController.updateLabel(_:)), forControlEvents: .ValueChanged)
                cell.textFielf.inputView = hourDatePicker
            }
        }
        
        cell.textFielf.sizeToFit()
        cell.selectionStyle = .None
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
    
    func checkFields() -> Bool {
        return self.birthdayDate != nil && self.name.characters.count > 0 && self.phone.characters.count > 0 && self.ssn.characters.count > 0 && self.gender != nil && self.maritalStatus != nil && self.street.characters.count > 0 && self.city.characters.count > 0 && self.state.characters.count > 0 && self.zipCode.characters.count > 0 && self.paymentInfo.characters.count > 0 && self.expirationDate != nil && self.memid.characters.count > 0 && self.groupid.characters.count > 0 && self.copay.characters.count > 0 && heightIn.characters.count > 0 && heightft.characters.count > 0 && weight.characters.count > 0 && bpD.characters.count > 0 && bpS.characters.count > 0 && self.appointmentDate != nil
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
    func beganEditingAtIndexPath(indexPath: NSIndexPath) {
        self.editingIndex = indexPath
    }
    func changedWithNewValue(newValue: String, forIndexPath: NSIndexPath) {
        inputtedText[forIndexPath] = newValue
        switch forIndexPath.section {
        case 0:
            if forIndexPath.row == 0 {
                name = newValue
                print("name \(name)")
            }
            if forIndexPath.row == 2 {
                phone = newValue
            }
            if forIndexPath.row == 3 {
                ssn = newValue
            }
            if forIndexPath.row == 4 {
                if newValue == "Female" {
                    self.gender = false
                } else {
                    self.gender = true
                }
            }
            if forIndexPath.row == 5 {
                if newValue == "Single" {
                    self.maritalStatus = false
                } else {
                    self.maritalStatus = true
                }
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
                bpD = newValue
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
    
    func updateLabel(sender: UIDatePicker) {
        guard let index = editingIndex else {
            return
        }
        
        switch index.section {
        case 0:
            switch index.row {
            case 1:
                self.birthdayDate = sender.date
                self.birthday = sender.date.getDateForAppointment()
                print(self.birthday)
                let cell = self.tableView.cellForRowAtIndexPath(index) as! AddTableViewCell
                cell.textFielf.text = self.birthday
                //self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Automatic)
                break
            default:
                break
            }
        case 2:
            switch index.row {
            case 1:
                self.expirationDate = sender.date
                self.expiration = sender.date.getDateForAppointment()
                let cell = self.tableView.cellForRowAtIndexPath(index) as! AddTableViewCell
                cell.textFielf.text = self.expiration
                break
            case 3:
                break
            default:
                break
            }
        case 4:
            switch index.row {
            case 1:
                let components = NSCalendar.currentCalendar().components(
                    [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday, NSCalendarUnit.WeekdayOrdinal, NSCalendarUnit.WeekOfYear],
                    fromDate: sender.date)
                
                if components.hour < 7 {
                    components.hour = 7
                    components.minute = 0
                    sender.setDate(NSCalendar.currentCalendar().dateFromComponents(components)!, animated: true)
                }
                else if components.hour > 20 {
                    components.hour = 20
                    components.minute = 0
                    sender.setDate(NSCalendar.currentCalendar().dateFromComponents(components)!, animated: true)
                }
                else {
                }
                let cell = self.tableView.cellForRowAtIndexPath(index) as! AddTableViewCell
                self.appointmentTime = sender.date.getTimeForAppointment()
                self.appointmentDate = sender.date
                cell.textFielf.text = self.appointmentTime
            default: break
            }
        default:
            break
        }
    }
}

extension AdmitPatientTableViewController: THDatePickerDelegate {
    
    func presentDate(sender: AnyObject) {
        self.appointmentPicker.date = NSDate()
        self.appointmentPicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        })
        self.presentSemiViewController(self.appointmentPicker, withOptions: [
            self.convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
            self.convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
            self.convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
            ])
    }
    /* https://vandadnp.wordpress.com/2014/07/07/swift-convert-unmanaged-to-string/ */
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        self.appointmentDate = datePicker.date.dateByAddingTimeInterval(NSTimeInterval(25200))
        self.appointmentDay = appointmentDate!.getDateForAppointment()
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 4)], withRowAnimation: .Automatic)
        dismissSemiModalView()
    }
}