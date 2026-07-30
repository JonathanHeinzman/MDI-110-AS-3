//
//  ContentView.swift
//  HealthTracker
//
//  Created by Jonathan Heinzman on 7/29/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel: HealthViewModel = HealthViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    HeaderSectionView()
                    StepCardView(steps: viewModel.steps).padding()
                    DistanceCardView(distance: viewModel.distance).padding()
                    ActivityStatusCardView(
                        activityStatus: viewModel.activityStatus,
                        authStatus: viewModel.authStatus,
                        isAuthorized: viewModel.isAuthorized).padding()
                    
                }
            }.onAppear {
                viewModel.requestAuthorization()
            }
            .refreshable {
                viewModel.fetchTodaySteps()
                viewModel.fetchTodayDistance()
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
