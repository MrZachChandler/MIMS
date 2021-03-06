//
//  Conditions.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/25/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation
import Parse

/**
 *  <#Description#>
 */
struct Disease {
    enum Disease: String {
        case Diabetes = "diabetes"
        case Alzeheimers = "alzheimers"
        case Arthritis = "arthritis"
        case Asthma = "asthma"
        case Cancer = "cancer"
        case Stroke = "stroke"
        case HIV = "hiv"
        case COPD = "copd"
    }
    
    var disease: Disease
    var description: String {
        return disease.rawValue
    }
    
    init(withDiseaseName name: String) throws {
        guard let newDisease = Disease(rawValue: name.lowercaseString) else {
            throw ConditionError.InvalidDisease
        }
        self.disease = newDisease
    }
    
}

struct Allergy {
    enum Allergies: String {
        case Insulin = "insulin"
        case Pollen = "pollen"
        case DustMites = "dust mites"
        case Mold = "mold"
        case AnimalHair = "animal hair"
        case InsectSting = "insect sting"
        case Latex = "latex"
        case Food = "food"
        case Drug = "drug"
    }
    
    var allergy: Allergies
    
    var description: String {
        return allergy.rawValue
    }
    
    init(withAllergyName name: String) throws {
        guard let newAllergy = Allergies(rawValue: name.lowercaseString) else {
            throw ConditionError.InvalidAllergy
        }
        self.allergy = newAllergy
    }
}

struct Disorder {
    
    enum Disorders: String {
        case ExampleDisorder = "example"
        case Bipolar = "bipolar"
        case CysticFibrosis = "cystic fibrosis"
        case HuntingtonsDisease = "huntington's disease"
        case DownSyndrome = "down syndrome"
        case MuscularDystrophy = "muscular dystrophy"
        case SickleCellAnemia = "cickle cell anemia"
        case CeliacDiseases = "celiac disease"
        case MultiplePersonalityDisorder = "multiple personality disorder"
    }
    
    var disorder: Disorders
    var description: String {
        return disorder.rawValue
    }
    
    init(withDisorderName name: String) throws {
        guard let newDisorder = Disorders(rawValue: name.lowercaseString) else {
            throw ConditionError.InvalidDisorder
        }
        self.disorder = newDisorder
    }
}

struct CauseOfDeath {
    enum Cause: String {
        case HeartAttack = "heart attack"
        case HeartDisease = "heart disease"
        case Cancer = "cancer"
        case RespiratoryDisease = "resipratory disease"
        case Accident = "accident"
        case Alzheimers = "alzheimer's diease"
        case Diabetes = "diabetes"
        case Influenza = "influenza"
        case Pneumonia = "pneumonia"
        case KidneyDisease = "kidney disease"
        case Suicide = "suicide"
    }
    
    var causeOfDeath: Cause
    var description: String {
        return causeOfDeath.rawValue
    }
    
    init(withCauseOfDeath cod: String) throws {
        guard let newCOD = Cause(rawValue: cod) else {
            throw ConditionError.InvalidCOD
        }
        self.causeOfDeath = newCOD
    }
    
}

enum ConditionError: ErrorType {
    case InvalidDisease
    case InvalidAllergy
    case InvalidCOD
    case InvalidDisorder
}

//MARK: Condition Class
/**
 A class that will contain all of the patient's conditions, including
 diseases, allergies, disorders, and, if applicable, the cause of death.
 *
 *  timeAdded: The time the /first/ condition of the patient was added
 *  timeUpdated: The time the condition's file was most recently updated
 *  disease: [String] -- any diseases the patient has been diagnosed with
 */
class Condition: PFObject, PFSubclassing {
    
    var timeAdded: NSDate? {
        return self.createdAt
    }
    
    var timeUpdated: NSDate? {
        return self.updatedAt
    }
    
    //The disease, allergies, and disorders arrays are all comprised of the rawValue description
    //of the corresponding struct (Disease, Disorder, Allergies, Cause of Death
    var disease: [String]? {
        get {
            return self["disease"] as? [String]
        }
        set {self["disease"] = newValue}
    }
    
    var allergies: [String]? {
        get {
            return self["allergies"] as? [String]
        }
        set {self["allergies"] = newValue}
    }
    
    var disorders: [String]? {
        get {
            return self["disorders"] as? [String]
        }
        set {self["disorders"] = newValue}
    }
    
    var causeOfDeath: String? {
        get {
            return self["causeOfDeath"] as? String
        }
        set {self["causeOfDeath"] = newValue}
    }
    
    convenience init(defaultInit: Bool) {
        self.init()
        self.disease = [String]()
        self.allergies = [String]()
        self.disorders = [String]()
        
    }

    /**
     Method to add a new disease to the patient record
     
     - parameter newDisease: The new disease name
     
     - throws: An error if the disease name is invalid
     */
    func addDisease(newDisease: String) throws {
        do {
            let disease = try Disease(withDiseaseName: newDisease)
            self.disease?.append(disease.description)
        } catch ConditionError.InvalidDisease {
            throw ConditionError.InvalidDisease
        }
    }
    
    /**
     Method to add a new allergy to the patient's record
     
     - parameter newAllergy: The new allergy
     
     - throws: An error if the allergy name is invalid
     */
    func addAllergy(newAllergy: String) throws {
        do {
            let allergy = try Allergy(withAllergyName: newAllergy)
            self.allergies?.append(allergy.description)
        } catch ConditionError.InvalidAllergy {
            throw ConditionError.InvalidAllergy
        }
    }
    
    /**
     Method to add a new disorder to the patient's record
     
     - parameter newDisorder: The new disorder
     
     - throws: An error if the disorder name in invalid
     */
    func addDisorder(newDisorder: String) throws {
        do {
            let disorder = try Disorder(withDisorderName: newDisorder)
            self.disorders?.append(disorder.description)
        } catch ConditionError.InvalidDisorder {
            throw ConditionError.InvalidDisorder
        }
    }
    
    /**
     Method to add a new cause of death to the patient's record
     
     - parameter cause: The new cause of death
     
     - throws: An error if the ause of death is invalid
     */
    func addCauseOfDeath(cause: String) throws {
        do {
            let causeOfDeath = try CauseOfDeath(withCauseOfDeath: cause)
            self.causeOfDeath = causeOfDeath.description
        } catch ConditionError.InvalidCOD {
            throw ConditionError.InvalidCOD
        }
    }
    
    class func parseClassName() -> String {
        return "Condition"
    }
}
