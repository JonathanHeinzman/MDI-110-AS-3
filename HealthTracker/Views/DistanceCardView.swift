//
//  DistanceCardView.swift
//  HealthTracker
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import SwiftUI

struct DistanceCardView: View {
    let distance: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "map.circle.fill")
                    .font(.system(size: 33))
                    .foregroundColor(.blue)
                
                Text("Distance").font(.headline)
                
                Spacer()
            }

            HStack(alignment: .firstTextBaseline) {
                Text(String(format: "%.2f", distance))
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("Km")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

#Preview {
    DistanceCardView(distance: 9900.00)
}
