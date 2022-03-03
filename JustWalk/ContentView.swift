//
//  ContentView.swift
//  JustWalk
//
//  Created by M100-M1MacMini on 2022/3/3.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    @State private var steps: [Step] = []
    
    var body: some View {
        NavigationView {
            
            List(steps, id: \.id) { step in
                HStack {
                    Image(systemName: "figure.walk")
                        .imageScale(.large)
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Steps: \(step.count)")
                        Text(step.date, style: .date)
                            .opacity(0.6)
                    }
                }
            }
            .navigationTitle("Walk Activaity")
        }
        .onAppear {
            HealthDataManager.shared.requestAuthorization { success in
                print("HealthKit Auth: \(success)")
                if success {
                    HealthDataManager.shared.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            updateUIFromStatistics(statisticsCollection)
                        }
                    }
                }
            }
        }
    }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -120, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
