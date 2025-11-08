//
//  OnboardingContainerView.swift
//  Conectar
//
//  Created by ChatGPT on 8/11/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.stage {
                case 1:
                    OnboardingStage1(viewModel: viewModel)
                case 2:
                    OnboardingStage2(viewModel: viewModel)
                case 3:
                    OnboardingStage3(viewModel: viewModel)
                default:
                    ContentView()
                }
            }
            .animation(.easeInOut, value: viewModel.stage)
        }
    }
}

#Preview {
    OnboardingContainerView()
}
