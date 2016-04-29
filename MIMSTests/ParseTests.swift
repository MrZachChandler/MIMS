//
//  ParseTests.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/15/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import XCTest
import Parse
@testable import MIMS


class ParseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    let patientInsurance = try! InsuranceInfo(initWith: NSDate(), memID: "128374838", grpID: "13849301", amount: 25)
    let address = try! Address(initWithAddressData: "123 Test Street", city: "Auburn", state: "AL", zip: "36832")
    let finances = try! FinancialInformation(initWithAllInfo: "Some finance information", balance: 50)
    let vitals = try! Measurement(initWithVitalData: 5, inches: 11, weight: 170, systolic: 120, diastolic: 80)

    
    func testAddPatient() {
        var expectation = XCTestExpectation()
        expectation = expectationWithDescription("Testing add patient")
        ParseClient.admitPatient(withPatientInfo: address, insuranceInfo: patientInsurance, financeInfo: finances, name: "No Name", maritalStatus: false, gender: false, birthday: NSDate(), ssn: "373829192", phone: "7701117897", vitalInformation: self.vitals) { (success, errorMessage, patientRecord) in
            if success || errorMessage == "" {
                expectation.fulfill()
            } else {
                XCTAssert(false)
            }
        }
        waitForExpectationsWithTimeout(20) { (error) in
//            XCTAssert(error)
        }
    }

}






