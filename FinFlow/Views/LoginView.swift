//
//  LoginView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct LoginView: View {
    public var onLoginSuccess: () -> Void
    
    @State private var email: String = "alex.morgan@sprout.io"
    @State private var password: String = "••••••••••••"
    @State private var isAuthenticating: Bool = false
    @State private var opticIDActive: Bool = false
    
    public init(onLoginSuccess: @escaping () -> Void = {}) {
        self.onLoginSuccess = onLoginSuccess
    }
    
    public var body: some View {
        ZStack {
            FinFlowTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header Branding
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(FinFlowTheme.brand)
                            .frame(width: 70, height: 70)
                            .shadow(color: FinFlowTheme.glowBrand, radius: 16, x: 0, y: 6)
                        
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    
                    Text("FinFlow")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    
                    Text("Secure Spatial Authentication")
                        .font(.system(size: 15))
                        .foregroundColor(FinFlowTheme.textSecondary)
                }
                .padding(.top, 20)
                
                // Login Glass Bento Card
                VStack(spacing: 20) {
                    // Optic ID Fast Pass Button
                    Button {
                        opticIDActive = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            opticIDActive = false
                            withAnimation {
                                onLoginSuccess()
                            }
                        }
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(FinFlowTheme.sproutGreenLight)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: opticIDActive ? "checkmark.circle.fill" : "opticid")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(opticIDActive ? FinFlowTheme.sproutGreen : FinFlowTheme.brand)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(opticIDActive ? "Optic ID Verified" : "Sign In with Optic ID")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(FinFlowTheme.textPrimary)
                                
                                Text("Look & tap to unlock instantly")
                                    .font(.system(size: 12))
                                    .foregroundColor(FinFlowTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(FinFlowTheme.textTertiary)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(FinFlowTheme.surfaceSecondary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.lift)
                    
                    HStack {
                        Rectangle()
                            .fill(FinFlowTheme.borderIce)
                            .frame(height: 1)
                        Text("or with credentials")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(FinFlowTheme.textTertiary)
                        Rectangle()
                            .fill(FinFlowTheme.borderIce)
                            .frame(height: 1)
                    }
                    .padding(.vertical, 4)
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email Address")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        TextField("name@example.com", text: $email)
                            .font(.system(size: 15))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                                    )
                            )
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Master Keycode")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        SecureField("Password", text: $password)
                            .font(.system(size: 15))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                                    )
                            )
                    }
                    
                    // Sign In Button
                    Button {
                        isAuthenticating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            isAuthenticating = false
                            withAnimation {
                                onLoginSuccess()
                            }
                        }
                    } label: {
                        HStack {
                            if isAuthenticating {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Authenticate")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(FinFlowTheme.brand)
                                .shadow(color: FinFlowTheme.glowBrand, radius: 10, x: 0, y: 4)
                        )
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.lift)
                    .padding(.top, 6)
                }
                .padding(28)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.88))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1.5)
                        )
                        .shadow(color: FinFlowTheme.floatingShadow, radius: 24, x: 0, y: 10)
                )
                .frame(maxWidth: 460)
                
                Spacer()
            }
        }
    }
}
