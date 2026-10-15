//
//  Garden3DView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI
import RealityKit

public struct Garden3DView: View {
    @Environment(FinFlowStore.self) private var store
    @Environment(AppModel.self) private var appModel
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    public init() {}
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 28) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Living Sprout Garden")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(FinFlowTheme.textPrimary)
                        
                        Text("3D spatial visualization of your budget health & growth")
                            .font(.system(size: 14))
                            .foregroundColor(FinFlowTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Immersive Space Toggle Button
                    ToggleImmersiveSpaceButton()
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                
                // Central 3D Garden Showcase Card
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.white.opacity(0.92))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1.5)
                        )
                        .shadow(color: FinFlowTheme.floatingShadow, radius: 24, x: 0, y: 10)
                    
                    VStack(spacing: 24) {
                        // Interactive Sprout Centerpiece
                        SproutPlantView(
                            capacityPercentage: store.capacityIntactPercentage,
                            isWatering: store.isWatering,
                            onWaterTap: {
                                store.waterPlant()
                            }
                        )
                        .scaleEffect(1.3)
                        .padding(.vertical, 20)
                        
                        // Vitality Health Status
                        VStack(spacing: 6) {
                            Text(store.plantGrowthStage)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(FinFlowTheme.sproutGreenDark)
                            
                            Text("\(store.capacityIntactPercentage)% of your weekly allowance remains intact")
                                .font(.system(size: 15))
                                .foregroundColor(FinFlowTheme.textSecondary)
                        }
                        
                        // Water Action & Immersion Buttons
                        HStack(spacing: 16) {
                            Button {
                                store.waterPlant()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 16))
                                    Text(store.isWatering ? "Nourishing..." : "Water Garden (+5% Vitality)")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule()
                                        .fill(FinFlowTheme.brand)
                                        .shadow(color: FinFlowTheme.glowBrand, radius: 10, x: 0, y: 4)
                                )
                            }
                            .buttonStyle(.plain)
                            .hoverEffect(.lift)
                            
                            ToggleImmersiveSpaceButton()
                        }
                        .padding(.top, 8)
                    }
                    .padding(36)
                }
                .padding(.horizontal, 28)
                
                // Garden Insights Grid
                HStack(spacing: 18) {
                    InsightCard(
                        title: "Soil Moisture",
                        value: "\(Int(round(store.plantVitality * 100)))%",
                        status: "Optimal",
                        icon: "humidity.fill",
                        color: FinFlowTheme.brand
                    )
                    
                    InsightCard(
                        title: "Nourishment Count",
                        value: "\(store.waterCount)x",
                        status: "This Cycle",
                        icon: "drop.triangle.fill",
                        color: FinFlowTheme.sproutGreen
                    )
                    
                    InsightCard(
                        title: "Expected Bloom",
                        value: "3 Days",
                        status: "Sunday Night",
                        icon: "sun.max.fill",
                        color: Color(hex: "FBBC05")
                    )
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 60)
            }
        }
    }
}

// MARK: - Insight Card
struct InsightCard: View {
    let title: String
    let value: String
    let status: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(FinFlowTheme.textSecondary)
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(FinFlowTheme.textPrimary)
            
            Text(status)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                )
        )
        .shadow(color: FinFlowTheme.cardShadow, radius: 8, x: 0, y: 3)
    }
}
