//
//  HealthDataManager.swift
//  JustWalk
//
//  Created by M100-M1MacMini on 2022/3/3.
//

import Foundation
import HealthKit

final class HealthDataManager {
    
    static let shared = HealthDataManager()
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    
    private init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        guard let healthStore = healthStore else {
            return completion(false)
        }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            completion(success)
        }
    }
    
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {

        let startDate = Calendar.current.date(byAdding: .day, value: -120, to: Date())
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType,
                                            quantitySamplePredicate: predicate,
                                            options: .cumulativeSum,
                                            anchorDate: anchorDate,
                                            intervalComponents: daily)
        
        query?.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
}
