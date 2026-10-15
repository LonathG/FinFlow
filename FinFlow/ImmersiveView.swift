//
//  ImmersiveView.swift
//  FinFlow
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(FinFlowStore.self) private var store
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    var body: some View {
        RealityView { content, attachments in
            // Create central plant anchor in user's space
            let plantAnchor = Entity()
            plantAnchor.position = [0, 1.1, -1.6]
            
            // Ceramic Base Pot
            let potMesh = MeshResource.generateCylinder(height: 0.22, radius: 0.18)
            let potMat = SimpleMaterial(
                color: UIColor(red: 0.92, green: 0.95, blue: 1.0, alpha: 1.0),
                roughness: 0.15,
                isMetallic: false
            )
            let pot = ModelEntity(mesh: potMesh, materials: [potMat])
            plantAnchor.addChild(pot)
            
            // Main Sprout Trunk / Stem
            let stemMesh = MeshResource.generateCylinder(height: 0.42, radius: 0.035)
            let stemMat = SimpleMaterial(
                color: UIColor(red: 0.0, green: 0.43, blue: 0.21, alpha: 1.0),
                roughness: 0.2,
                isMetallic: false
            )
            let stem = ModelEntity(mesh: stemMesh, materials: [stemMat])
            stem.position = [0, 0.32, 0]
            plantAnchor.addChild(stem)
            
            // Lush Foliage Canopy (Living Sprout)
            let canopyMesh = MeshResource.generateSphere(radius: 0.26)
            let canopyMat = SimpleMaterial(
                color: UIColor(red: 0.22, green: 0.70, blue: 0.39, alpha: 0.95),
                roughness: 0.25,
                isMetallic: false
            )
            let canopy = ModelEntity(mesh: canopyMesh, materials: [canopyMat])
            canopy.position = [0, 0.58, 0]
            plantAnchor.addChild(canopy)
            
            // Orbiting Spatial Envelopes
            let envelopes: [(String, SIMD3<Float>, UIColor)] = [
                ("groceries_tag", [-0.48, 0.48, 0.15], UIColor(red: 0.17, green: 0.35, blue: 1.0, alpha: 1.0)),
                ("dining_tag", [0.48, 0.52, 0.10], UIColor(red: 0.28, green: 0.33, blue: 0.40, alpha: 1.0)),
                ("transport_tag", [-0.32, 0.74, -0.15], UIColor(red: 0.0, green: 0.43, blue: 0.21, alpha: 1.0)),
                ("shopping_tag", [0.36, 0.70, -0.15], UIColor(red: 0.56, green: 0.07, blue: 0.11, alpha: 1.0))
            ]
            
            for (tagId, pos, color) in envelopes {
                let sphereMesh = MeshResource.generateSphere(radius: 0.065)
                let sphereMat = SimpleMaterial(color: color, roughness: 0.1, isMetallic: true)
                let sphere = ModelEntity(mesh: sphereMesh, materials: [sphereMat])
                sphere.position = pos
                plantAnchor.addChild(sphere)
                
                if let attachment = attachments.entity(for: tagId) {
                    attachment.position = pos + [0, 0.10, 0]
                    plantAnchor.addChild(attachment)
                }
            }
            
            // Front Spatial Control HUD
            if let hud = attachments.entity(for: "spatial_hud") {
                hud.position = [0, 0.9, -1.0]
                content.add(hud)
            }
            
            content.add(plantAnchor)
        } attachments: {
            Attachment(id: "groceries_tag") {
                SpatialEnvelopeTag(title: "Groceries", spent: 120.00, total: 200.00, tint: FinFlowTheme.brand)
            }
            
            Attachment(id: "dining_tag") {
                SpatialEnvelopeTag(title: "Dining", spent: 45.00, total: 80.00, tint: Color(hex: "485466"))
            }
            
            Attachment(id: "transport_tag") {
                SpatialEnvelopeTag(title: "Transport", spent: 32.00, total: 50.00, tint: FinFlowTheme.sproutGreen)
            }
            
            Attachment(id: "shopping_tag") {
                SpatialEnvelopeTag(title: "Shopping", spent: 23.00, total: 100.00, tint: Color(hex: "8E111C"))
            }
            
            Attachment(id: "spatial_hud") {
                SpatialGardenHUD()
            }
        }
    }
}

// MARK: - Spatial Envelope Tag
struct SpatialEnvelopeTag: View {
    let title: String
    let spent: Double
    let total: Double
    let tint: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(tint)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(FinFlowTheme.textPrimary)
                
                Text("$\(String(format: "%.0f", spent)) of $\(String(format: "%.0f", total))")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(FinFlowTheme.textSecondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: FinFlowTheme.floatingShadow, radius: 10, x: 0, y: 4)
        )
    }
}

// MARK: - Spatial Garden HUD
struct SpatialGardenHUD: View {
    @Environment(FinFlowStore.self) private var store
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(FinFlowTheme.sproutGreen)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Living Sprout Garden")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(FinFlowTheme.textPrimary)
                    
                    Text("\(store.capacityIntactPercentage)% Allowance Intact • \(store.plantGrowthStage)")
                        .font(.system(size: 13))
                        .foregroundColor(FinFlowTheme.sproutGreenDark)
                }
                
                Spacer()
                
                // Water Plant Action
                Button {
                    store.waterPlant()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "drop.fill")
                            .foregroundColor(FinFlowTheme.brand)
                        Text("Water Sprout")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(FinFlowTheme.surfaceContainerHighest))
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
                
                // Exit Immersion Button
                Button {
                    Task { @MainActor in
                        appModel.immersiveSpaceState = .inTransition
                        await dismissImmersiveSpace()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(FinFlowTheme.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(FinFlowTheme.surfaceContainerHighest))
                }
                .buttonStyle(.plain)
                .hoverEffect(.highlight)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: FinFlowTheme.floatingShadow, radius: 24, x: 0, y: 10)
        )
        .frame(width: 480)
    }
}
