//
//  ReceiptScannerView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct ReceiptScannerView: View {
    @Environment(FinFlowStore.self) private var store
    
    @State private var selectedSampleIndex: Int = 0
    @State private var laserOffset: CGFloat = -140
    @State private var isLaserScanning: Bool = false
    @State private var isLogging: Bool = false
    @State private var showSuccessBanner: Bool = false
    
    private var currentSample: ReceiptScanSample {
        ReceiptScanSample.samples[selectedSampleIndex]
    }
    
    public init() {}
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 28) {
                // MARK: - Top Control Bar
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Vision OCR Scanner")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(FinFlowTheme.textPrimary)
                        
                        Text("Neural receipt detection & itemization")
                            .font(.system(size: 14))
                            .foregroundColor(FinFlowTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Sample Selector Pills
                    HStack(spacing: 8) {
                        ForEach(0..<ReceiptScanSample.samples.count, id: \.self) { idx in
                            let sample = ReceiptScanSample.samples[idx]
                            let isSelected = selectedSampleIndex == idx
                            
                            Button {
                                withAnimation(.spring()) {
                                    selectedSampleIndex = idx
                                }
                            } label: {
                                Text(sample.merchant.components(separatedBy: " ").first ?? sample.merchant)
                                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? .white : FinFlowTheme.textSecondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(isSelected ? FinFlowTheme.brand : FinFlowTheme.surfaceContainerHighest)
                                    )
                            }
                            .buttonStyle(.plain)
                            .hoverEffect(.highlight)
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                
                // MARK: - Main Dual-Pane Scanner Layout
                HStack(alignment: .top, spacing: 28) {
                    // LEFT PANE: Spatial Viewfinder HUD
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color(hex: "0D1117"))
                            .frame(height: 480)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                            )
                            .shadow(color: FinFlowTheme.floatingShadow, radius: 20, x: 0, y: 10)
                        
                        // Simulated Receipt Canvas Background
                        VStack(spacing: 12) {
                            Text(currentSample.merchant.uppercased())
                                .font(.system(size: 15, weight: .black, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.85))
                                .padding(.top, 32)
                            
                            Text("RECEIPT #\(Int.random(in: 48201...99302)) • \(currentSample.timestampString)")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.45))
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                                .padding(.horizontal, 30)
                            
                            // Line Items
                            VStack(spacing: 10) {
                                ForEach(currentSample.items) { item in
                                    HStack {
                                        Text(item.title)
                                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                                            .foregroundColor(Color.white.opacity(0.8))
                                        
                                        Spacer()
                                        
                                        Text("$\(String(format: "%.2f", item.price))")
                                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                                            .foregroundColor(Color.white.opacity(0.95))
                                    }
                                    .padding(.horizontal, 32)
                                }
                            }
                            .padding(.top, 10)
                            
                            Spacer()
                            
                            Divider()
                                .background(Color.white.opacity(0.2))
                                .padding(.horizontal, 30)
                            
                            HStack {
                                Text("TOTAL DUE")
                                    .font(.system(size: 16, weight: .black, design: .monospaced))
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text("$\(String(format: "%.2f", currentSample.totalAmount))")
                                    .font(.system(size: 20, weight: .black, design: .monospaced))
                                    .foregroundColor(FinFlowTheme.cyanGlow)
                            }
                            .padding(.horizontal, 32)
                            .padding(.bottom, 36)
                        }
                        .frame(height: 480)
                        
                        // Neural Bounding Boxes Overlay
                        GeometryReader { geo in
                            ForEach(currentSample.boundingBoxes) { box in
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(box.isKeyMetric ? FinFlowTheme.cyanGlow : FinFlowTheme.sproutGreen, lineWidth: box.isKeyMetric ? 2.5 : 1.5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill((box.isKeyMetric ? FinFlowTheme.cyanGlow : FinFlowTheme.sproutGreen).opacity(0.12))
                                    )
                                    .frame(
                                        width: geo.size.width * box.width,
                                        height: geo.size.height * box.height
                                    )
                                    .position(
                                        x: geo.size.width * (box.x + box.width / 2),
                                        y: geo.size.height * (box.y + box.height / 2)
                                    )
                            }
                        }
                        .frame(height: 480)
                        
                        // Animated Sweeping Cyan Laser Beam
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        FinFlowTheme.cyanGlow.opacity(0),
                                        FinFlowTheme.cyanGlow,
                                        FinFlowTheme.cyanGlow.opacity(0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 2.5)
                            .shadow(color: FinFlowTheme.cyanGlow, radius: 8, x: 0, y: 0)
                            .offset(y: laserOffset)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                                    laserOffset = 180
                                }
                            }
                        
                        // Corner Reticles (Brackets)
                        VStack {
                            HStack {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 34, weight: .light))
                                    .foregroundColor(FinFlowTheme.cyanGlow)
                                Spacer()
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 34, weight: .light))
                                    .foregroundColor(FinFlowTheme.cyanGlow)
                                    .rotationEffect(.degrees(90))
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 34, weight: .light))
                                    .foregroundColor(FinFlowTheme.cyanGlow)
                                    .rotationEffect(.degrees(-90))
                                Spacer()
                                Image(systemName: "viewfinder")
                                    .font(.system(size: 34, weight: .light))
                                    .foregroundColor(FinFlowTheme.cyanGlow)
                                    .rotationEffect(.degrees(180))
                            }
                        }
                        .padding(20)
                        .frame(height: 480)
                        
                        // Top Confidence Pill
                        VStack {
                            HStack {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(FinFlowTheme.sproutGreen)
                                        .frame(width: 8, height: 8)
                                    
                                    Text("\(String(format: "%.1f", currentSample.confidence * 100))% Confidence • Neural OCR Active")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color.black.opacity(0.65)))
                                
                                Spacer()
                            }
                            .padding(24)
                            
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // RIGHT PANE: Parsed OCR Extraction Card
                    VStack(alignment: .leading, spacing: 20) {
                        // Merchant & Status
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(currentSample.merchant)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(FinFlowTheme.textPrimary)
                                
                                Text(currentSample.timestampString)
                                    .font(.system(size: 13))
                                    .foregroundColor(FinFlowTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            // Category Badge
                            HStack(spacing: 5) {
                                Image(systemName: currentSample.category.icon)
                                    .font(.system(size: 13, weight: .semibold))
                                Text(currentSample.category.rawValue)
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .foregroundColor(currentSample.category.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(currentSample.category.backgroundTint))
                        }
                        
                        Divider()
                            .background(FinFlowTheme.borderIce)
                        
                        // Parsed Items Ledger
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Detected Line Items (\(currentSample.items.count))")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(FinFlowTheme.textPrimary)
                            
                            VStack(spacing: 8) {
                                ForEach(currentSample.items) { item in
                                    HStack {
                                        Text(item.title)
                                            .font(.system(size: 14))
                                            .foregroundColor(FinFlowTheme.textPrimary)
                                        
                                        Spacer()
                                        
                                        Text("$\(String(format: "%.2f", item.price))")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(FinFlowTheme.textPrimary)
                                    }
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(FinFlowTheme.surfaceSecondary.opacity(0.5))
                                    )
                                }
                            }
                        }
                        
                        Divider()
                            .background(FinFlowTheme.borderIce)
                        
                        // Monetary Breakdown
                        VStack(spacing: 8) {
                            HStack {
                                Text("Subtotal")
                                    .font(.system(size: 14))
                                    .foregroundColor(FinFlowTheme.textSecondary)
                                Spacer()
                                Text("$\(String(format: "%.2f", currentSample.subtotal))")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(FinFlowTheme.textPrimary)
                            }
                            
                            HStack {
                                Text("Tax")
                                    .font(.system(size: 14))
                                    .foregroundColor(FinFlowTheme.textSecondary)
                                Spacer()
                                Text("$\(String(format: "%.2f", currentSample.tax))")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(FinFlowTheme.textPrimary)
                            }
                            
                            HStack {
                                Text("Total Amount")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(FinFlowTheme.textPrimary)
                                Spacer()
                                Text("$\(String(format: "%.2f", currentSample.totalAmount))")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(FinFlowTheme.brand)
                            }
                            .padding(.top, 4)
                        }
                        
                        // Confirm & Log Expense Button
                        Button {
                            isLogging = true
                            store.addTransaction(
                                merchant: currentSample.merchant,
                                amount: currentSample.totalAmount,
                                category: currentSample.category,
                                paymentMethod: currentSample.paymentMethod,
                                note: "Auto-scanned via Vision OCR (\(currentSample.items.count) items)",
                                isScanned: true
                            )
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isLogging = false
                                withAnimation {
                                    showSuccessBanner = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        showSuccessBanner = false
                                        store.selectedTab = .dashboard
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 10) {
                                if isLogging {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text("Log to FinFlow Ledger")
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(FinFlowTheme.brand)
                                    .shadow(color: FinFlowTheme.glowBrand, radius: 12, x: 0, y: 5)
                            )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.lift)
                        .padding(.top, 6)
                        
                        if showSuccessBanner {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(FinFlowTheme.sproutGreen)
                                
                                Text("Expense logged! Sprout Garden nourished.")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(FinFlowTheme.sproutGreenDark)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(FinFlowTheme.sproutGreenLight)
                            )
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(26)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.88))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(FinFlowTheme.borderIce, lineWidth: 1.5)
                            )
                            .shadow(color: FinFlowTheme.floatingShadow, radius: 20, x: 0, y: 8)
                    )
                    .frame(maxWidth: 420)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 60)
            }
        }
    }
}
