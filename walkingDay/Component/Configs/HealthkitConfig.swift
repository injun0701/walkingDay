//
//  HealthkitConfig.swift
//  walkingDay
//
//  Created by HongInJun on 2021/02/26.
//

extension UIViewController {
    
    //MARK: 헬스킷 구현
    //healthStore에서 오늘 걸음수 가져오기
    func getTodaySteps(healthStore: HKHealthStore, stepCountVelue: @escaping (Int) -> ()) {
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
        // Check for Authorization
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if (success) {
                // Authorization Successful
                self.getStepsFunc(healthStore: healthStore, date: Date()) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        stepCountVelue(stepCount)
                    }
                }
            } // end if
        } // end of checking authorization
    }
   
    //healthStore에서 어제부터 6일전 걸음수 가져오기
    func getSteps(healthStore: HKHealthStore,
                stepCountVelueDayBefore: @escaping (String) -> (),
                stepCountVelueTwoDaysAgo: @escaping (String) -> (),
                stepCountVelueThreeDaysAgo: @escaping (String) -> (),
                stepCountVelueFourDaysAgo: @escaping (String) -> (),
                stepCountVelueFiveDaysAgo: @escaping (String) -> (),
                stepCountVelueSixDaysAgo: @escaping (String) -> ()) {
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
        
        // Check for Authorization
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if (success) {
                // Authorization Successful
                self.getStepsFunc(healthStore: healthStore, date: Date().dayBefore) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        stepCountVelueDayBefore("\(stepCount)")
                    }
                }
                self.getStepsFunc(healthStore: healthStore, date: Date().twoDaysAgo) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        stepCountVelueTwoDaysAgo("\(stepCount)")
                      }
                }
                self.getStepsFunc(healthStore: healthStore, date: Date().threeDaysAgo) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        stepCountVelueThreeDaysAgo("\(stepCount)")
                    }
                }
                self.getStepsFunc(healthStore: healthStore, date: Date().fourDaysAgo) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        stepCountVelueFourDaysAgo("\(stepCount)")
                    }
                }
                self.getStepsFunc(healthStore: healthStore, date: Date().fiveDaysAgo) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        stepCountVelueFiveDaysAgo("\(stepCount)")
                    }
                }
                self.getStepsFunc(healthStore: healthStore, date: Date().sixDaysAgo) { (result) in
                    DispatchQueue.main.async {
                        let stepCount = Int(result)
                        stepCountVelueSixDaysAgo("\(stepCount)")
                    }
                }
            } // end if
        } // end of checking authorization
    }
    
    func getStepsFunc(healthStore: HKHealthStore, date: Date, completion: @escaping (Double) -> Void)  {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startOfDay = Calendar.current.startOfDay(for: date)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfDay,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { _, result, error in
            
            var resultCount = 0.0
            
            guard let result = result else {
                completion(resultCount)
                return
            }
            
            result.enumerateStatistics(from: startOfDay, to: date) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.count())
                }
                
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in
            
            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.count())
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        healthStore.execute(query)
    }
}
