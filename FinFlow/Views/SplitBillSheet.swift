//
//  SplitBillSheet.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct SplitBillSheet: View {
    @Environment(FinFlowStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var totalBillString: String = "86.40"
    @State private var numberOfPeople: Double = 3
    @State private var tipPercentage: Double = 18
    @State private var isRequested: Bool = false
    
    public init() {}
    
    private var totalBill: Double {
        Double(totalBillString) ?? 0.0
    }
    
    private var tipAmount: Double {
        totalBill * (tipPercentage / 100.0)
    }
    
    private var grandTotal: Double {
        totalBill + tipAmount
    }
    
    private var perPersonShare: Double {
        guard numberOfPeople > 0 else { return 0 }
        return grandTotal / numberOfPeople
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Per-Person Hero Result
                VStack(spacing: 6) {
                    Text("Each Person Owes")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(FinFlowTheme.textSecondary)
                    
                    Text("$\(String(format: "%.2f", perPersonShare))")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(FinFlowTheme.brand)
                    
                    Text("Grand Total: $\(String(format: "%.2f", grandTotal)) (incl. $\(String(format: "%.2f", tipAmount)) tip)")
                        .font(.system(size: 12))
                        .foregroundColor(FinFlowTheme.textTertiary)
                }
                .padding(.top, 10)
                
                // Interactive Settings
                VStack(spacing: 20) {
                    // Total Bill Input
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bill Subtotal")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        HStack {
                            Text("$")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(FinFlowTheme.textSecondary)
                            TextField("0.00", text: $totalBillString)
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(FinFlowTheme.surfaceSecondary)
                        )
                    }
                    
                    // Number of People Slider
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Split Among")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(FinFlowTheme.textSecondary)
                            Spacer()
                            Text("\(Int(numberOfPeople)) People")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(FinFlowTheme.brand)
                        }
                        
                        Slider(value: $numberOfPeople, in: 2...10, step: 1)
                            .tint(FinFlowTheme.brand)
                    }
                    
                    // Tip Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tip Percentage")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        HStack(spacing: 8) {
                            ForEach([15, 18, 20, 25], id: \.self) { tip in
                                let isSelected = Int(tipPercentage) == tip
                                Button {
                                    tipPercentage = Double(tip)
                                } label: {
                                    Text("\(tip)%")
                                        .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                                        .foregroundColor(isSelected ? .white : FinFlowTheme.textPrimary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(isSelected ? FinFlowTheme.brand : FinFlowTheme.surfaceSecondary)
                                        )
                                }
                                .buttonStyle(.plain)
                                .hoverEffect(.highlight)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                // Actions
                VStack(spacing: 12) {
                    Button {
                        isRequested = true
                        store.addTransaction(
                            merchant: "Split Dining Bill",
                            amount: perPersonShare,
                            category: .dining,
                            note: "Split with \(Int(numberOfPeople)) people"
                        )
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            dismiss()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: isRequested ? "checkmark.circle.fill" : "applelogo")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text(isRequested ? "My Share Logged & Requests Sent" : "Log My Share ($\(String(format: "%.2f", perPersonShare)))")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isRequested ? FinFlowTheme.sproutGreen : FinFlowTheme.brand)
                                .shadow(color: FinFlowTheme.glowBrand, radius: 10, x: 0, y: 4)
                        )
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.lift)
                }
            }
            .padding(24)
            .navigationTitle("Split Bill")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 440, minHeight: 520)
    }
}
