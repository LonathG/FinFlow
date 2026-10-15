//
//  EditTransactionSheet.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct EditTransactionSheet: View {
    @Environment(FinFlowStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    public var transaction: Transaction
    
    @State private var merchant: String
    @State private var amountString: String
    @State private var selectedCategory: ExpenseCategory
    @State private var note: String
    
    public init(transaction: Transaction) {
        self.transaction = transaction
        _merchant = State(initialValue: transaction.merchant)
        _amountString = State(initialValue: String(format: "%.2f", transaction.amount))
        _selectedCategory = State(initialValue: transaction.category)
        _note = State(initialValue: transaction.note ?? "")
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Large Amount Input
                VStack(spacing: 6) {
                    Text("Transaction Amount")
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
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Merchant / Location")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        TextField("Merchant Name", text: $merchant)
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
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Note / Tag")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        TextField("Note", text: $note)
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
                
                // Save and Delete Buttons
                VStack(spacing: 10) {
                    Button {
                        let amount = Double(amountString) ?? transaction.amount
                        store.updateTransaction(
                            id: transaction.id,
                            merchant: merchant,
                            amount: amount,
                            category: selectedCategory,
                            note: note.isEmpty ? nil : note
                        )
                        dismiss()
                    } label: {
                        Text("Save Changes")
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
                    
                    Button {
                        store.deleteTransaction(id: transaction.id)
                        dismiss()
                    } label: {
                        Text("Delete Transaction")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(FinFlowTheme.coral)
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.highlight)
                }
            }
            .padding(24)
            .navigationTitle("Edit Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 440, minHeight: 500)
    }
}
