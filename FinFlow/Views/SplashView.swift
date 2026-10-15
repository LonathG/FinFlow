//
//  SplashView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct SplashView: View {
    public var onDismiss: () -> Void
    
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var glowOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 20
    @State private var isPulsing: Bool = false
    
    public init(onDismiss: @escaping () -> Void = {}) {
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            // Ambient Ice & Cobalt Radial Backdrop
            RadialGradient(
                colors: [
                    FinFlowTheme.surfaceSecondary,
                    FinFlowTheme.background,
                    Color(hex: "DCE8FE")
                ],
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            // Atmospheric Pulsing Rings
            ZStack {
                Circle()
                    .stroke(FinFlowTheme.brand.opacity(0.15), lineWidth: 1.5)
                    .frame(width: 260, height: 260)
                    .scaleEffect(isPulsing ? 1.15 : 0.95)
                    .opacity(isPulsing ? 0.8 : 0.4)
                
                Circle()
                    .stroke(FinFlowTheme.sproutGreen.opacity(0.12), lineWidth: 1.5)
                    .frame(width: 360, height: 360)
                    .scaleEffect(isPulsing ? 1.08 : 0.92)
                    .opacity(isPulsing ? 0.6 : 0.2)
            }
            .animation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: isPulsing)
            
            VStack(spacing: 28) {
                // Central Glowing Sprout Emblem
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    FinFlowTheme.brand,
                                    FinFlowTheme.brandDark
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 110, height: 110)
                        .shadow(color: FinFlowTheme.glowBrand, radius: 24, x: 0, y: 10)
                    
                    Circle()
                        .stroke(Color.white.opacity(0.35), lineWidth: 2)
                        .frame(width: 110, height: 110)
                    
                    VStack(spacing: 2) {
                        HStack(spacing: -3) {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 26))
                                .foregroundColor(FinFlowTheme.sproutGreenLight)
                                .rotationEffect(.degrees(-24))
                            
                            Image(systemName: "leaf.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color.white)
                                .rotationEffect(.degrees(18))
                        }
                        
                        Capsule()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 4, height: 16)
                    }
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                // Typography Suite
                VStack(spacing: 8) {
                    Text("FinFlow")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(FinFlowTheme.textPrimary)
                        .tracking(-0.8)
                    
                    Text("Spatial Personal Finance & Living Garden")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(FinFlowTheme.textSecondary)
                    
                    Text("Powered by SproutFinance Engine")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(FinFlowTheme.brand)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(FinFlowTheme.surfaceContainerHighest)
                        )
                        .padding(.top, 4)
                }
                .offset(y: textOffset)
                .opacity(logoOpacity)
                
                // Action Pill
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        onDismiss()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text("Enter Spatial Workspace")
                            .font(.system(size: 16, weight: .bold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(FinFlowTheme.brand)
                            .shadow(color: FinFlowTheme.glowBrand, radius: 14, x: 0, y: 6)
                    )
                }
                .buttonStyle(.plain)
                .hoverEffect(.lift)
                .padding(.top, 16)
                .opacity(logoOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoOpacity = 1.0
                textOffset = 0
            }
            isPulsing = true
        }
    }
}
