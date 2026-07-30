//
//  HealthViewModel.swift
//  HealthTracker
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import Foundation // <-- Primitive types
import HealthKit // <-- Framework that gets the health data
import Combine // <-- MVVM PATTERN

class HealthViewModel: ObservableObject {
    
    @Published var steps: Int = 0
    @Published var distance: Double = 0.0
    @Published var activityStatus: String = "Not Active"
    @Published var authStatus: String = "Not Requested"
    @Published var isAuthorized: Bool = false
    
    // This is my service(this service gets the data)
    private let healthStore: HKHealthStore = HKHealthStore()
    
    // Runs every time there is a new VM
    init() {
        checkIfDataIsAvailable()
        
    }
    
    
    // Some devices don't have HealthKit (iPads, Simulator)
    private func checkIfDataIsAvailable() {
        // HKHealthStore.isDataAvailable -> returns a bool
        if HKHealthStore.isHealthDataAvailable() {
            print("Data Available")
        }else {
            print("Not Available")
            authStatus = "Not Available"
        }
    }
    
    
    
    // VM LOGIC
    private func updateActivityStatus() {
        
        if steps < 2000 {
            activityStatus = "Sedentary"
        }else if steps < 5000 {
            activityStatus = "Lightly Active"
        }else if steps < 7000 {
            activityStatus = "Moderately Active"
        }else if steps < 10000 {
            activityStatus = "Active"
        }else {
            activityStatus = "Very Active"
        }
    }
    
    
    func requestAuthorization() {
        
        // LETS WORK WITH THIS TYPES OF VALUES
        let typeToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
            
        healthStore.requestAuthorization(toShare: nil, read: typeToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.authStatus = "Authorized"
                    
                    // perform the fetch
                    // - Fetch the steps
                    self.fetchTodaySteps()
                    // - Fetch the distance
                    self.fetchTodayDistance()
                    
                    
                }else {
                    self.isAuthorized = false
                    self.authStatus = "Denied"
                    
                    if let error = error {
                        print("Error with healthKit: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    func fetchTodaySteps() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Error with step count type")
            return
        }
        
        // Set the time interval for our query
        let now = Date()
        let startOfTheDay = Calendar.current.startOfDay(for: now)
        
        // TIME INTERVAL - FROM START OF DAY UNTIL THE CURRENT TIME
        let predicate = HKQuery.predicateForSamples(withStart: startOfTheDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    self.steps = 0
                    self.updateActivityStatus()
                    return
                }
                
                if let result = result, let sum = result.sumQuantity() {
                    
                    let steps = Int(sum.doubleValue(for: .count()))
                    
                    self.steps = steps
                    self.updateActivityStatus()
                    
                }else {
                    self.steps = 0
                    self.updateActivityStatus()
                }
            }
        }
        
        healthStore.execute(query)
        
        
    }
    
    func fetchTodayDistance() {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        let now = Date()
        let startOfTheDay = Calendar.current.startOfDay(for: now)
        
        // TIME INTERVAL - FROM START OF DAY UNTIL THE CURRENT TIME
        let predicate = HKQuery.predicateForSamples(withStart: startOfTheDay, end: now, options: .strictStartDate)
        
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
            
            DispatchQueue.main.async {
                if let error = error {
                    self.distance = 0.0
                    return
                }
                
                if let result = result, let sum = result.sumQuantity() {
                    
                    let distanceInMeter = sum.doubleValue(for: .meter())
                    let distanceInKm = distanceInMeter / 1000.0
                    
                    self.distance = distanceInMeter
                    print("Distance in KM: \(distanceInKm)")
                    
                }else {
                    self.distance = 0.0
                }
            }
        }
        
        
        healthStore.execute(query)
    }
    
    func startObserving() {
        
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { query, completionHandler, error in
            
            if let error = error {
                return
            }
            
            self.fetchTodaySteps()
            self.fetchTodayDistance()
            
            completionHandler()
            
        }
        
        healthStore.execute(query)
        
    }
    
    
}
