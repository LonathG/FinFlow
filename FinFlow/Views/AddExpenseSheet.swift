//
//  AddExpenseSheet.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct AddExpenseSheet: View {
    @Environment(FinFlowStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var merchant: String = ""
    @State private var amountString: String = ""
    @State private var selectedCategory: ExpenseCategory = .groceries
    @State private var paymentMethod: String = "Apple Pay (•• 4821)"
    @State private var note: String = ""
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Large Amount Input
                VStack(spacing: 6) {
                    Text("Expense Amount")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(FinFlowTheme.textSecondary)
                    
                    HStack(spacing: 2) {
                        Text("$")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        TextField("0.00", text: $amountString)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(FinFlowTheme.textPrimary)
                            .frame(maxWidth: 220)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.top, 10)
                
                // Form Fields
                VStack(spacing: 16) {
                    // Merchant Name
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Merchant / Location")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        TextField("e.g. Whole Foods, Blue Bottle", text: $merchant)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(FinFlowTheme.surfaceSecondary)
                            )
                    }
                    
                    // Category Picker Pills
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Budget Category")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(ExpenseCategory.allCases) { cat in
                                    let isSelected = selectedCategory == cat
                                    Button {
                                        selectedCategory = cat
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: cat.icon)
                                                .font(.system(size: 13))
                                            Text(cat.rawValue)
                                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                        }
                                        .foregroundColor(isSelected ? .white : cat.color)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(isSelected ? cat.color : cat.backgroundTint)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .hoverEffect(.highlight)
                                }
                            }
                        }
                    }
                    
                    // Note Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Note / Tag (Optional)")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        TextField("e.g. Lunch with team, pantry refill", text: $note)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(FinFlowTheme.surfaceSecondary)
                            )
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                // Save Button
                Button {
                    let amount = Double(amountString) ?? 0.0
                    guard amount > 0, !merchant.isEmpty else { return }
                    
                    store.addTransaction(
                        merchant: merchant,
                        amount: amount,
                        category: selectedCategory,
                        paymentMethod: paymentMethod,
                        note: note.isEmpty ? nil : note
                    )
                    dismiss()
                } label: {
                    Text("Add to FinFlow Ledger")
                        .font(.system(size: 16, weight: .bold))
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
                .disabled(amountString.isEmpty || merchant.isEmpty)
                .opacity((amountString.isEmpty || merchant.isEmpty) ? 0.5 : 1.0)
            }
            .padding(24)
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 440, minHeight: 480)
    }
}
