//
//  DashboardView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct DashboardView: View {
    @Environment(FinFlowStore.self) private var store
    @State private var selectedCategoryFilter: ExpenseCategory? = nil
    
    public init() {}
    
    private var filteredTransactions: [Transaction] {
        if let cat = selectedCategoryFilter {
            return store.transactions.filter { $0.category == cat }
        }
        return store.transactions
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 28) {
                // MARK: - Top Greeting Bar
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Hello, \(store.userName)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(FinFlowTheme.textSecondary)
                        
                        Text("Weekly Overview")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(FinFlowTheme.textPrimary)
                    }
                    
                    Spacer()
                    
                    // Unread Notification Trigger
                    Button {
                        store.hasUnreadNotifications.toggle()
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(Color.white.opacity(0.85))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Circle()
                                        .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                                )
                                .shadow(color: FinFlowTheme.cardShadow, radius: 8, x: 0, y: 3)
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 19))
                                .foregroundColor(FinFlowTheme.textSecondary)
                                .frame(width: 48, height: 48)
                            
                            if store.hasUnreadNotifications {
                                Circle()
                                    .fill(FinFlowTheme.brand)
                                    .frame(width: 11, height: 11)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .offset(x: -3, y: 3)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.lift)
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                
                // MARK: - Hero Focal Card: Sprout Garden Remaining Allowance
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.white.opacity(0.92))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1.5)
                        )
                        .shadow(color: FinFlowTheme.floatingShadow, radius: 24, x: 0, y: 10)
                    
                    HStack(spacing: 32) {
                        // Left Column: Allowance Metrics
                        VStack(alignment: .leading, spacing: 14) {
                            // Status Pill
                            HStack(spacing: 8) {
                                HStack(spacing: 6) {
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(FinFlowTheme.sproutGreen)
                                    
                                    Text("Remaining Allowance")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(FinFlowTheme.brandDark)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(FinFlowTheme.surfaceContainerHighest))
                                
                                Text("Day \(store.dayOfCycle) of \(store.totalDaysInCycle)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(FinFlowTheme.textSecondary)
                                    .textCase(.uppercase)
                            }
                            
                            // Huge Tabular Monetary Display
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("$\(String(format: "%.2f", store.remainingAllowance))")
                                    .font(.system(size: 46, weight: .bold, design: .rounded))
                                    .foregroundColor(FinFlowTheme.textPrimary)
                            }
                            
                            Text("of $\(String(format: "%.2f", store.weeklyTarget)) weekly target")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(FinFlowTheme.textSecondary)
                            
                            // Capacity Intact Progress Bar
                            VStack(alignment: .leading, spacing: 6) {
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(FinFlowTheme.surfaceContainerHigh)
                                            .frame(height: 10)
                                        
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        FinFlowTheme.brand,
                                                        FinFlowTheme.sproutGreen
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: max(14, geo.size.width * CGFloat(store.capacityIntactPercentage) / 100.0), height: 10)
                                    }
                                }
                                .frame(height: 10)
                                
                                HStack {
                                    Text("\(store.capacityIntactPercentage)% capacity intact")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(FinFlowTheme.sproutGreenDark)
                                    
                                    Spacer()
                                    
                                    Text("+$\(String(format: "%.0f", store.paceDifference)) under pace")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(FinFlowTheme.textSecondary)
                                }
                            }
                            .padding(.top, 4)
                        }
                        
                        Spacer()
                        
                        // Right Column: Interactive Living Sprout Plant Widget
                        VStack(spacing: 8) {
                            SproutPlantView(
                                capacityPercentage: store.capacityIntactPercentage,
                                isWatering: store.isWatering,
                                onWaterTap: {
                                    store.waterPlant()
                                }
                            )
                            
                            Text(store.plantGrowthStage)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(FinFlowTheme.sproutGreenDark)
                            
                            Text("Tap sprout to nourish")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(FinFlowTheme.textTertiary)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(32)
                }
                .padding(.horizontal, 28)
                
                // MARK: - Tactical Quick Action Dock
                HStack(spacing: 16) {
                    QuickActionButton(
                        title: "Scan Receipt",
                        subtitle: "Neural OCR",
                        icon: "viewfinder",
                        accentColor: FinFlowTheme.brand
                    ) {
                        withAnimation {
                            store.selectedTab = .scanner
                        }
                    }
                    
                    QuickActionButton(
                        title: "Add Expense",
                        subtitle: "Manual Entry",
                        icon: "plus.circle.fill",
                        accentColor: FinFlowTheme.sproutGreen
                    ) {
                        store.showAddExpenseModal = true
                    }
                    
                    QuickActionButton(
                        title: "Split Bill",
                        subtitle: "Fair Share",
                        icon: "person.2.fill",
                        accentColor: Color(hex: "485466")
                    ) {
                        store.showSplitBillModal = true
                    }
                    
                    QuickActionButton(
                        title: "Weekly Curve",
                        subtitle: "Analytics",
                        icon: "chart.xyaxis.line",
                        accentColor: Color(hex: "8E111C")
                    ) {
                        withAnimation {
                            store.selectedTab = .analytics
                        }
                    }
                }
                .padding(.horizontal, 28)
                
                // MARK: - Active Category Envelopes Grid
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Active Budget Envelopes")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(FinFlowTheme.textPrimary)
                        
                        Spacer()
                        
                        Text("4 Envelopes Active")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(FinFlowTheme.textSecondary)
                    }
                    .padding(.horizontal, 28)
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 18), GridItem(.flexible(), spacing: 18)], spacing: 18) {
                        ForEach(store.categories) { cat in
                            CategoryEnvelopeCard(category: cat) {
                                if selectedCategoryFilter == cat.category {
                                    selectedCategoryFilter = nil
                                } else {
                                    selectedCategoryFilter = cat.category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                }
                
                // MARK: - Recent Transactions Ledger
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Recent Transactions")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(FinFlowTheme.textPrimary)
                            
                            Text("Real-time expense stream")
                                .font(.system(size: 13))
                                .foregroundColor(FinFlowTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Category Filter Chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(title: "All", isSelected: selectedCategoryFilter == nil) {
                                    selectedCategoryFilter = nil
                                }
                                
                                ForEach(ExpenseCategory.allCases) { cat in
                                    FilterChip(title: cat.rawValue, isSelected: selectedCategoryFilter == cat) {
                                        if selectedCategoryFilter == cat {
                                            selectedCategoryFilter = nil
                                        } else {
                                            selectedCategoryFilter = cat
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    VStack(spacing: 10) {
                        if filteredTransactions.isEmpty {
                            Text("No transactions found for this filter.")
                                .font(.system(size: 14))
                                .foregroundColor(FinFlowTheme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 30)
                        } else {
                            ForEach(filteredTransactions) { tx in
                                TransactionRowView(
                                    transaction: tx,
                                    onEdit: {
                                        store.editingTransaction = tx
                                    },
                                    onDelete: {
                                        store.deleteTransaction(id: tx.id)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                }
                .padding(.bottom, 60)
            }
        }
    }
}

// MARK: - Tactical Quick Action Button
struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accentColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(FinFlowTheme.textSecondary)
                }
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
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
        .buttonStyle(.plain)
        .hoverEffect(.lift)
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : FinFlowTheme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected ? FinFlowTheme.brand : FinFlowTheme.surfaceContainerHighest)
                )
        }
        .buttonStyle(.plain)
        .hoverEffect(.highlight)
    }
}
