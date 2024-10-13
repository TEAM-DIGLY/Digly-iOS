//
//  ContentView.swift
//  watchDigly Watch App
//
//  Created by 김 형석 on 10/9/24.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HeartRateMonitorViewModel()
    
    var body: some View {
        VStack {
            Text("Current Heart Rate")
                .font(.headline)
            
            Text("\(Int(viewModel.currentHeartRate)) BPM")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("ConnectionStatus")
            Text("\(viewModel.connectionStatus)")
                .fontWeight(.bold).padding(.bottom,4)
        }
    }
}
