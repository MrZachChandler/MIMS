//
//  MIMSTableViewCell.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/22/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit
import Parse

class MIMSTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel1: UILabel!
    @IBOutlet weak var detailLabel2: UILabel!
    @IBOutlet weak var detailLabel3: UILabel!
    @IBOutlet weak var sideInformationLabel: UILabel!
    
    func bindAppointment(appointmentToBind appointment: Appointment) {
        let patient = appointment.associatedPatient
        let scheduledTime = appointment.timeScheduled
        let detail0 = scheduledTime?.getDateForAppointment()
        let detail1 = scheduledTime?.getTimeForAppointment()
        
        self.titleLabel.text = patient.name
        self.detailLabel1.text = detail0!
        self.detailLabel2.text = detail1!
        self.detailLabel3.text = ""
        self.sideInformationLabel.text = ""
    }
    
    func bindCompletedAppointment(appointmentToBind appointment: Appointment) {
        let patient = appointment.associatedPatient
        let scheduledTime = appointment.timeScheduled
        let detail0 = scheduledTime?.getDateForAppointment()
        let detail1 = scheduledTime?.getTimeForAppointment()
        
        self.titleLabel.text = patient.name
        self.detailLabel1.text = detail0!
        self.detailLabel2.text = detail1!
        self.detailLabel3.text = ""
        self.sideInformationLabel.text = ""
    }
    
    func bindPatientWithoutData(patient: Patient) {
        self.titleLabel.text = patient.name
        self.detailLabel1.text = patient.address.description
        self.detailLabel2.text = patient.birthday.getDateForAppointment()
        self.detailLabel3.text = patient.phoneNumber
        if patient.gender == true {
            self.sideInformationLabel.text = "Male"
        }
        else
        {
            self.sideInformationLabel.text = "Female"
            
        }

    }
    func bindPatient(patientToBind patient: Patient, completion: (patient: Patient) ->()){
        var updatedPatient: Patient!
        let query = PFQuery(className: "Patient")
        query.cachePolicy = .CacheThenNetwork
        query.whereKey("objectId", equalTo: patient.objectId!)
        query.includeKey("address")
        query.includeKey("insuranceInfo")
        query.includeKey("financialData")
        query.getFirstObjectInBackgroundWithBlock { (patient, error) in
            if error == nil && patient != nil {
                updatedPatient = patient as! Patient
                self.titleLabel.text = updatedPatient.name
                self.detailLabel1.text = updatedPatient.address.description
                self.detailLabel2.text = updatedPatient.birthday.getDateForAppointment()
                self.detailLabel3.text = updatedPatient.phoneNumber
                if updatedPatient.gender == true {
                    self.sideInformationLabel.text = "Male"
                }
                else
                {
                    self.sideInformationLabel.text = "Female"
                    
                }
                completion(patient: updatedPatient)
            }
        }
    }
}
