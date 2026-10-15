//
//  TransactionRowView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct TransactionRowView: View {
    public var transaction: Transaction
    public var onEdit: () -> Void = {}
    public var onDelete: () -> Void = {}
    
    public init(
        transaction: Transaction,
        onEdit: @escaping () -> Void = {},
        onDelete: @escaping () -> Void = {}
    ) {
        self.transaction = transaction
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    public var body: some View {
        HStack(spacing: 14) {
            // Category Icon Badge
            ZStack {
                Circle()
                    .fill(transaction.category.backgroundTint)
                    .frame(width: 44, height: 44)
                
                Image(systemName: transaction.category.icon)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(transaction.category.color)
            }
            
            // Merchant & Details
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(transaction.merchant)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    
                    if transaction.isScannedReceipt {
                        HStack(spacing: 3) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 10, weight: .bold))
                            Text("OCR")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(FinFlowTheme.brand)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(FinFlowTheme.surfaceContainerHighest)
                        )
                    }
                }
                
                HStack(spacing: 6) {
                    Text(transaction.formattedDateString)
                        .font(.system(size: 12))
                        .foregroundColor(FinFlowTheme.textSecondary)
                    
                    Text("•")
                        .font(.system(size: 10))
                        .foregroundColor(FinFlowTheme.textTertiary)
                    
                    Text(transaction.paymentMethod)
                        .font(.system(size: 12))
                        .foregroundColor(FinFlowTheme.textSecondary)
                }
            }
            
            Spacer()
            
            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text("-$\(String(format: "%.2f", transaction.amount))")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(FinFlowTheme.textPrimary)
                
                Text(transaction.category.rawValue)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(transaction.category.color)
            }
            
            // Context Action Triggers
            HStack(spacing: 4) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(FinFlowTheme.textSecondary)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(Color.white.opacity(0.8)))
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(FinFlowTheme.coral)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(FinFlowTheme.coralLight))
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
            }
            .padding(.leading, 4)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(FinFlowTheme.borderIce.opacity(0.8), lineWidth: 1)
                )
        )
        .shadow(color: FinFlowTheme.cardShadow.opacity(0.5), radius: 6, x: 0, y: 2)
    }
}
