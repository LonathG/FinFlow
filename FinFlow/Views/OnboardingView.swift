//
//  OnboardingView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct OnboardingView: View {
    public var onComplete: () -> Void
    
    @State private var currentStep: Int = 0
    @State private var isLaserScanning: Bool = false
    @State private var laserYOffset: CGFloat = -40
    
    public init(onComplete: @escaping () -> Void = {}) {
        self.onComplete = onComplete
    }
    
    private let steps = [
        (
            title: "Adaptive Weekly Target",
            subtitle: "Set a clear weekly budget target ($1,000). Watch your dynamic remaining allowance calibrate in real-time as days progress.",
            icon: "dollarsign.circle.fill",
            color: FinFlowTheme.brand
        ),
        (
            title: "Living Sprout Garden",
            subtitle: "Your financial health is represented by a spatial living sprout. Keep spending within pace to nourish and bloom your garden.",
            icon: "leaf.fill",
            color: FinFlowTheme.sproutGreen
        ),
        (
            title: "Vision OCR Receipt Engine",
            subtitle: "Hover over paper or digital receipts. High-precision neural OCR parses merchant, line items, and totals instantly.",
            icon: "viewfinder",
            color: FinFlowTheme.brandGlow
        )
    ]
    
    public var body: some View {
        ZStack {
            FinFlowTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 36) {
                // Top Header Progress & Skip
                HStack {
                    HStack(spacing: 8) {
                        ForEach(0..<steps.count, id: \.self) { idx in
                            Capsule()
                                .fill(idx == currentStep ? FinFlowTheme.brand : FinFlowTheme.surfaceContainerHighest)
                                .frame(width: idx == currentStep ? 36 : 12, height: 6)
                                .animation(.spring(), value: currentStep)
                        }
                    }
                    
                    Spacer()
                    
                    Button("Skip to Dashboard") {
                        withAnimation {
                            onComplete()
                        }
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(FinFlowTheme.textSecondary)
                }
                .padding(.horizontal, 40)
                .padding(.top, 30)
                
                // Central Interactive Feature Card
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.white.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1.5)
                        )
                        .shadow(color: FinFlowTheme.floatingShadow, radius: 24, x: 0, y: 12)
                    
                    VStack(spacing: 24) {
                        // Visual Graphic depending on step
                        ZStack {
                            Circle()
                                .fill(steps[currentStep].color.opacity(0.12))
                                .frame(width: 130, height: 130)
                            
                            if currentStep == 0 {
                                // Dynamic Target Graphic
                                VStack(spacing: 6) {
                                    Text("$780.00")
                                        .font(.system(size: 26, weight: .bold, design: .rounded))
                                        .foregroundColor(FinFlowTheme.textPrimary)
                                    
                                    Text("78% Intact • Day 4")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(FinFlowTheme.sproutGreenDark)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Capsule().fill(FinFlowTheme.sproutGreenLight))
                                }
                            } else if currentStep == 1 {
                                // Sprout Graphic
                                SproutPlantView(capacityPercentage: 78)
                            } else {
                                // Receipt OCR Graphic with Laser Line
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(FinFlowTheme.surfaceContainerHigh)
                                        .frame(width: 90, height: 110)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(FinFlowTheme.brand.opacity(0.4))
                                            .frame(width: 44, height: 6)
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(FinFlowTheme.textSecondary.opacity(0.3))
                                            .frame(width: 60, height: 4)
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(FinFlowTheme.textSecondary.opacity(0.3))
                                            .frame(width: 50, height: 4)
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(FinFlowTheme.brandDark.opacity(0.6))
                                            .frame(width: 36, height: 8)
                                    }
                                    
                                    // Animated Cyan Laser
                                    Rectangle()
                                        .fill(FinFlowTheme.cyanGlow)
                                        .frame(width: 86, height: 2)
                                        .shadow(color: FinFlowTheme.cyanGlow, radius: 4)
                                        .offset(y: laserYOffset)
                                }
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                                        laserYOffset = 40
                                    }
                                }
                            }
                        }
                        .frame(height: 150)
                        
                        // Text Description
                        VStack(spacing: 10) {
                            Text(steps[currentStep].title)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(FinFlowTheme.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text(steps[currentStep].subtitle)
                                .font(.system(size: 15))
                                .foregroundColor(FinFlowTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .lineSpacing(4)
                        }
                    }
                    .padding(32)
                }
                .frame(maxWidth: 580, maxHeight: 420)
                
                // Bottom Button Action
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button {
                            withAnimation(.spring()) {
                                currentStep -= 1
                            }
                        } label: {
                            Text("Back")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(FinFlowTheme.textSecondary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Capsule().fill(FinFlowTheme.surfaceContainerHighest))
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                    }
                    
                    Button {
                        if currentStep < steps.count - 1 {
                            withAnimation(.spring()) {
                                currentStep += 1
                            }
                        } else {
                            withAnimation {
                                onComplete()
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text(currentStep == steps.count - 1 ? "Launch FinFlow" : "Continue")
                                .font(.system(size: 16, weight: .bold))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(FinFlowTheme.brand)
                                .shadow(color: FinFlowTheme.glowBrand, radius: 12, x: 0, y: 4)
                        )
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.lift)
                }
                
                Spacer()
            }
        }
    }
}
