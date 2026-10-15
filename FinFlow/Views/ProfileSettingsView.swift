//
//  ProfileSettingsView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct ProfileSettingsView: View {
    @Environment(FinFlowStore.self) private var store
    @State private var targetString: String = "1000.00"
    @State private var showSavedToast: Bool = false
    
    public init() {}
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 28) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Profile & Settings")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(FinFlowTheme.textPrimary)
                        
                        Text("Personal finance preferences & Stitch screen previewer")
                            .font(.system(size: 14))
                            .foregroundColor(FinFlowTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                
                // Profile Hero Card
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [FinFlowTheme.brand, FinFlowTheme.brandDark],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 72, height: 72)
                            .shadow(color: FinFlowTheme.glowBrand, radius: 12, x: 0, y: 4)
                        
                        Text("AM")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(store.userName)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(FinFlowTheme.textPrimary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 12))
                                Text("PRO")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .foregroundColor(FinFlowTheme.sproutGreenDark)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(FinFlowTheme.sproutGreenLight))
                        }
                        
                        Text(store.userEmail)
                            .font(.system(size: 14))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        Text("Member since October 2026 • 78% Savings Capacity")
                            .font(.system(size: 12))
                            .foregroundColor(FinFlowTheme.textTertiary)
                    }
                    
                    Spacer()
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 28)
                
                // Budget Preferences Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Budget Target Calibration")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Weekly Target Allowance ($)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(FinFlowTheme.textSecondary)
                            
                            TextField("1000.00", text: $targetString)
                                .font(.system(size: 16, weight: .bold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(FinFlowTheme.surfaceSecondary)
                                )
                        }
                        
                        Button {
                            if let val = Double(targetString), val > 0 {
                                store.weeklyTarget = val
                                withAnimation {
                                    showSavedToast = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showSavedToast = false
                                    }
                                }
                            }
                        } label: {
                            Text("Update Target")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(FinFlowTheme.brand)
                                )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.lift)
                        .padding(.top, 20)
                    }
                    
                    if showSavedToast {
                        Text("Target updated successfully! Sprout capacity recalculated.")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.sproutGreenDark)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 28)
                
                // Stitch Screen Demo Switcher
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Stitch MCP Screens Interactive Tester")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(FinFlowTheme.textPrimary)
                        
                        Text("Jump directly to any of the 6 Stitch screens for inspection")
                            .font(.system(size: 13))
                            .foregroundColor(FinFlowTheme.textSecondary)
                    }
                    
                    VStack(spacing: 10) {
                        ScreenTestRow(
                            title: "Screen 1: Splash — Brand Reveal",
                            subtitle: "Brand reveal intro with glowing sprout emblem",
                            icon: "sparkles",
                            color: FinFlowTheme.brand
                        ) {
                            withAnimation {
                                store.showSplashIntro = true
                            }
                        }
                        
                        ScreenTestRow(
                            title: "Screen 2: Onboarding — Feature Teaser",
                            subtitle: "Interactive 3-pillar feature carousel & tour",
                            icon: "hand.tap.fill",
                            color: FinFlowTheme.sproutGreen
                        ) {
                            withAnimation {
                                store.hasCompletedOnboarding = false
                            }
                        }
                        
                        ScreenTestRow(
                            title: "Screen 3: Login — Secure Access",
                            subtitle: "Optic ID biometric authentication and credentials form",
                            icon: "opticid",
                            color: Color(hex: "485466")
                        ) {
                            withAnimation {
                                store.isAuthenticated = false
                            }
                        }
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 28)
                .padding(.bottom, 60)
            }
        }
    }
}

// MARK: - Screen Test Row
struct ScreenTestRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(FinFlowTheme.textSecondary)
                }
                
                Spacer()
                
                Text("Preview")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(FinFlowTheme.brand)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(FinFlowTheme.surfaceContainerHighest))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(FinFlowTheme.surfaceSecondary.opacity(0.6))
            )
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
    }
}
