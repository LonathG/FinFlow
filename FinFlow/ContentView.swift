//
//  ContentView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var store = FinFlowStore()
    
    var body: some View {
        Group {
            if store.showSplashIntro {
                SplashView {
                    store.showSplashIntro = false
                }
            } else if !store.hasCompletedOnboarding {
                OnboardingView {
                    store.hasCompletedOnboarding = true
                }
            } else if !store.isAuthenticated {
                LoginView {
                    store.isAuthenticated = true
                }
            } else {
                // Main Spatial Computing Workspace
                ZStack {
                    // Soft Ambient Gradient Base
                    LinearGradient(
                        colors: [
                            FinFlowTheme.background,
                            FinFlowTheme.surface,
                            Color(hex: "F0F4FC")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Selected Tab Content View
                    Group {
                        switch store.selectedTab {
                        case .dashboard:
                            DashboardView()
                        case .scanner:
                            ReceiptScannerView()
                        case .analytics:
                            WeeklyAnalyticsView()
                        case .split:
                            SplitBillSheet()
                        case .garden3D:
                            Garden3DView()
                        case .settings:
                            ProfileSettingsView()
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                }
                .ornament(visibility: .visible, attachmentAnchor: .scene(.bottom), contentAlignment: .center) {
                    NavigationOrnamentView(
                        selectedTab: $store.selectedTab,
                        onQuickAdd: {
                            store.showAddExpenseModal = true
                        }
                    )
                    .padding(.bottom, 16)
                }
                .sheet(isPresented: $store.showAddExpenseModal) {
                    AddExpenseSheet()
                        .environment(store)
                }
                .sheet(isPresented: $store.showSplitBillModal) {
                    SplitBillSheet()
                        .environment(store)
                }
                .sheet(item: $store.editingTransaction) { tx in
                    EditTransactionSheet(transaction: tx)
                        .environment(store)
                }
            }
        }
        .environment(store)
        .glassBackgroundEffect()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
