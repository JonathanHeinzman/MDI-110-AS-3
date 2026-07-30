//
//  StepCardView.swift
//  HealthTracker
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import SwiftUI

struct StepCardView: View {
    
    let goal: Int = 10_000
    let steps: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "figure.walk.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("Today's Steps").font(.headline)
                
                Spacer()
                
            }
            HStack(alignment: .firstTextBaseline) {
                Text("\(steps)")
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("steps")
                    .font(.title)
                    .foregroundColor(.secondary)
                    
            }
            ProgressView(
                value: Double(steps),
                total: Double(goal))
            .tint(.green)
            
            Text("Goal \(goal)").foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        
    }
}

#Preview {
    StepCardView(steps: 2_200)
}
