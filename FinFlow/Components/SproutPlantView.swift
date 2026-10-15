//
//  SproutPlantView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct SproutPlantView: View {
    public var capacityPercentage: Int
    public var isWatering: Bool
    public var onWaterTap: () -> Void
    
    @State private var isBreathing: Bool = false
    
    public init(
        capacityPercentage: Int,
        isWatering: Bool = false,
        onWaterTap: @escaping () -> Void = {}
    ) {
        self.capacityPercentage = capacityPercentage
        self.isWatering = isWatering
        self.onWaterTap = onWaterTap
    }
    
    public var body: some View {
        Button(action: onWaterTap) {
            ZStack {
                // Background Radiance Glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                FinFlowTheme.sproutGreen.opacity(0.35),
                                FinFlowTheme.sproutGreenLight.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 75
                        )
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(isBreathing ? 1.12 : 0.96)
                    .animation(Animation.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: isBreathing)
                
                // Falling Water Droplet Animation during watering
                if isWatering {
                    VStack {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 20))
                            .foregroundColor(FinFlowTheme.brand)
                            .transition(.scale.combined(with: .opacity))
                            .offset(y: -40)
                    }
                    .animation(.easeOut(duration: 0.6), value: isWatering)
                }
                
                // Plant Leaves & Pot
                VStack(spacing: 3) {
                    // Foliage Leaves
                    ZStack {
                        // Left Leaf
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 30))
                            .foregroundColor(FinFlowTheme.sproutGreen)
                            .rotationEffect(.degrees(isBreathing ? -32 : -22))
                            .offset(x: -12, y: 4)
                        
                        // Right Leaf
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 34))
                            .foregroundColor(FinFlowTheme.sproutGreenDark)
                            .rotationEffect(.degrees(isBreathing ? 24 : 14))
                            .offset(x: 10, y: -2)
                        
                        // Center Bud / Blossom if capacity is high
                        if capacityPercentage >= 70 {
                            Circle()
                                .fill(FinFlowTheme.brand)
                                .frame(width: 10, height: 10)
                                .offset(x: -1, y: -16)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1.5)
                                        .offset(x: -1, y: -16)
                                )
                        }
                    }
                    .animation(Animation.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: isBreathing)
                    
                    // Main Stem
                    Capsule()
                        .fill(FinFlowTheme.sproutGreenDark)
                        .frame(width: 5, height: 20)
                    
                    // Ceramic Spatial Pot
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        FinFlowTheme.surfaceContainerHigh,
                                        FinFlowTheme.surfaceContainerHighest
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 48, height: 32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                            )
                        
                        HStack(spacing: 2) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 13))
                                .foregroundColor(FinFlowTheme.brand)
                            
                            Text("\(capacityPercentage)%")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(FinFlowTheme.textPrimary)
                        }
                    }
                }
                .offset(y: 6)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .hoverEffect(.lift)
        .onAppear {
            isBreathing = true
        }
    }
}
