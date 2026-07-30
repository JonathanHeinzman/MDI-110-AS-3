//
//  HeaderSectionView.swift
//  HealthTracker
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import SwiftUI

struct HeaderSectionView: View {
    var body: some View {
        VStack{
            Image(systemName: "figure.walk")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Daily Activity Tracker")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Monitor Health Data")
                .font(.subheadline)
                .foregroundColor(.gray)
            
        }
        .padding()
        
    }
}
#Preview {
    HeaderSectionView()
}
