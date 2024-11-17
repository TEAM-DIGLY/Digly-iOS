//
//  HomeViewModel.swift
//  digly
//
//  Created by Neoself on 11/3/24.
//
//
//  OnboardingViewModel.swift
//  digly
//
//  Created by Neoself on 11/2/24.
//

import Foundation
import Combine
import AuthenticationServices
import GoogleSignIn
import SwiftUI

class HomeViewModel: ObservableObject {
    @ObservedObject private var appState: AppState
    @Published var path = NavigationPath()
    var remainingDate:Int = 2
    
    
    init(appState: AppState = .shared) {
        self.appState = appState
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func submit(){}
}

