//
//  ActivityStatusCardView.swift
//  HealthTracker
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import SwiftUI

struct ActivityStatusCardView: View {
    
    let activityStatus: String
    let authStatus: String
    let isAuthorized: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                
                Text("Activity Status").font(.headline)
                
                Spacer()
            }
            
            HStack {
                Text("Status")
                Text(activityStatus).fontWeight(.bold) // make the color change based on the activity leavel : hint: use an enum
            }
            
            HStack {
                Text("Authorization Status")
                    .font(.body)
                    .foregroundColor(.gray)
                Text(authStatus)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(isAuthorized ? .green : .red)
            }
            
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

#Preview {
    ActivityStatusCardView(activityStatus: "Active", authStatus: "Authorized", isAuthorized: true)
        .padding(.vertical)
    ActivityStatusCardView(activityStatus: "Active", authStatus: "Authorized", isAuthorized: false)
}
