//
//  WeeklyAnalyticsView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

public struct WeeklyAnalyticsView: View {
    @Environment(FinFlowStore.self) private var store
    
    @State private var isThisWeek: Bool = true
    @State private var searchQuery: String = ""
    
    public init() {}
    
    private var displayedTransactions: [Transaction] {
        var list = store.transactions
        if !searchQuery.isEmpty {
            list = list.filter {
                $0.merchant.localizedCaseInsensitiveContains(searchQuery) ||
                $0.category.rawValue.localizedCaseInsensitiveContains(searchQuery) ||
                ($0.note?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            }
        }
        return list
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 28) {
                // MARK: - Top Header & Timeframe Switcher
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Weekly Analytics & Curve")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(FinFlowTheme.textPrimary)
                        
                        Text("Cubic bezier spending curve & categorical breakdown")
                            .font(.system(size: 14))
                            .foregroundColor(FinFlowTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Segmented Timeframe Switcher
                    HStack(spacing: 4) {
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                isThisWeek = true
                                store.selectedTimeframe = .thisWeek
                            }
                        } label: {
                            Text("This Week")
                                .font(.system(size: 14, weight: isThisWeek ? .bold : .medium))
                                .foregroundColor(isThisWeek ? .white : FinFlowTheme.textSecondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(isThisWeek ? FinFlowTheme.brand : Color.clear))
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                        
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                isThisWeek = false
                                store.selectedTimeframe = .lastWeek
                            }
                        } label: {
                            Text("Last Week")
                                .font(.system(size: 14, weight: !isThisWeek ? .bold : .medium))
                                .foregroundColor(!isThisWeek ? .white : FinFlowTheme.textSecondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(!isThisWeek ? FinFlowTheme.brand : Color.clear))
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                    }
                    .padding(4)
                    .background(
                        Capsule()
                            .fill(FinFlowTheme.surfaceContainerHighest)
                    )
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                
                // MARK: - Interactive Cubic Bezier Curve Card
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.white.opacity(0.92))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1.5)
                        )
                        .shadow(color: FinFlowTheme.floatingShadow, radius: 20, x: 0, y: 8)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(isThisWeek ? "Current Cycle Spending Momentum" : "Previous Week Historical Curve")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(FinFlowTheme.textPrimary)
                                
                                Text(isThisWeek ? "$\(String(format: "%.2f", store.totalSpent)) spent of $1,000.00 allowance" : "$310.50 settled across 7 days")
                                    .font(.system(size: 13))
                                    .foregroundColor(FinFlowTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(isThisWeek ? FinFlowTheme.sproutGreen : FinFlowTheme.textSecondary)
                                    .frame(width: 8, height: 8)
                                
                                Text(isThisWeek ? "On Pace (-12% vs last week)" : "Historical Baseline")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(isThisWeek ? FinFlowTheme.sproutGreenDark : FinFlowTheme.textSecondary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(isThisWeek ? FinFlowTheme.sproutGreenLight : FinFlowTheme.surfaceContainerHighest)
                            )
                        }
                        
                        // Sparkline Chart Component
                        SparklineChartView(isThisWeek: isThisWeek)
                    }
                    .padding(28)
                }
                .padding(.horizontal, 28)
                
                // MARK: - KPI Telemetry Bento Tiles
                HStack(spacing: 18) {
                    MetricTile(
                        title: "Total Spent",
                        value: isThisWeek ? "$\(String(format: "%.2f", store.totalSpent))" : "$310.50",
                        subtext: isThisWeek ? "78% Remaining" : "Cycle Completed",
                        icon: "creditcard.fill",
                        tint: FinFlowTheme.brand
                    )
                    
                    MetricTile(
                        title: "Daily Burn Rate",
                        value: isThisWeek ? "$55.00" : "$62.10",
                        subtext: "Optimal under $71/d",
                        icon: "flame.fill",
                        tint: FinFlowTheme.sproutGreen
                    )
                    
                    MetricTile(
                        title: "Projected Weekend",
                        value: "$160.00",
                        subtext: "Buffer available: $220",
                        icon: "calendar.badge.clock",
                        tint: Color(hex: "485466")
                    )
                    
                    MetricTile(
                        title: "Largest Expense",
                        value: "$77.20",
                        subtext: "Trader Joe's",
                        icon: "bag.fill",
                        tint: Color(hex: "8E111C")
                    )
                }
                .padding(.horizontal, 28)
                
                // MARK: - Category Distribution Bar
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Category Allocation Share")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(FinFlowTheme.textPrimary)
                        
                        Spacer()
                    }
                    
                    // Segmented Distribution Bar
                    GeometryReader { geo in
                        HStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ExpenseCategory.groceries.color)
                                .frame(width: geo.size.width * 0.54)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ExpenseCategory.dining.color)
                                .frame(width: geo.size.width * 0.20)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ExpenseCategory.transport.color)
                                .frame(width: geo.size.width * 0.14)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ExpenseCategory.shopping.color)
                                .frame(width: geo.size.width * 0.10)
                        }
                    }
                    .frame(height: 12)
                    
                    // Legend
                    HStack(spacing: 20) {
                        LegendItem(title: "Groceries (54%)", color: ExpenseCategory.groceries.color)
                        LegendItem(title: "Dining (20%)", color: ExpenseCategory.dining.color)
                        LegendItem(title: "Transport (14%)", color: ExpenseCategory.transport.color)
                        LegendItem(title: "Shopping (10%)", color: ExpenseCategory.shopping.color)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 28)
                
                // MARK: - Searchable History Ledger
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Transaction History")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(FinFlowTheme.textPrimary)
                            
                            Text("\(displayedTransactions.count) recorded items")
                                .font(.system(size: 13))
                                .foregroundColor(FinFlowTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Search Field
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(FinFlowTheme.textSecondary)
                            
                            TextField("Search transactions...", text: $searchQuery)
                                .font(.system(size: 14))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(FinFlowTheme.surfaceSecondary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(FinFlowTheme.borderIce, lineWidth: 1)
                                )
                        )
                        .frame(width: 240)
                    }
                    .padding(.horizontal, 28)
                    
                    VStack(spacing: 10) {
                        ForEach(displayedTransactions) { tx in
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
                    .padding(.horizontal, 28)
                }
                .padding(.bottom, 60)
            }
        }
    }
}

// MARK: - Metric Tile
struct MetricTile: View {
    let title: String
    let value: String
    let subtext: String
    let icon: String
    let tint: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(FinFlowTheme.textSecondary)
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(tint)
            }
            
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(FinFlowTheme.textPrimary)
            
            Text(subtext)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(FinFlowTheme.textTertiary)
        }
        .padding(18)
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

// MARK: - Legend Item
struct LegendItem: View {
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(FinFlowTheme.textSecondary)
        }
    }
}
