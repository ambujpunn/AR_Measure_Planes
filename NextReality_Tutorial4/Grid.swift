//
//  Grid.swift
//  NextReality_Tutorial4
//
//  Created by Ambuj Punn on 5/2/18.
//  Copyright © 2018 Ambuj Punn. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

// 5.2
extension ARPlaneAnchor {
    // Inches
    var width: Float { return self.extent.x * 39.3701}
    var height: Float { return self.extent.z * 39.3701}
}

class Grid : SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane!
    // 5.1
    var textGeometry: SCNText!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(anchor: ARPlaneAnchor) {
        planeGeometry.width = CGFloat(anchor.extent.x);
        planeGeometry.height = CGFloat(anchor.extent.z);
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeometry, options: nil))
        
        // 5.4
        if let textGeometry = self.childNode(withName: "textNode", recursively: true)?.geometry as? SCNText {
            // Update text to new size
            textGeometry.string = String(format: "%.1f\"", anchor.width) + " x " + String(format: "%.1f\"", anchor.height)
        }
    }
    
    // 5.3
    private func setup() {
        planeGeometry = SCNPlane(width: CGFloat(anchor.width), height: CGFloat(anchor.height))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"overlay_grid.png")
        
        planeGeometry.materials = [material]
        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        planeNode.physicsBody?.categoryBitMask = 2
        
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
        
        let textNodeMaterial = SCNMaterial()
        textNodeMaterial.diffuse.contents = UIColor.black
        
        // Set up text geometry
        textGeometry = SCNText(string: String(format: "%.1f\"", anchor.width) + " x " + String(format: "%.1f\"", anchor.height), extrusionDepth: 1)
        textGeometry.font = UIFont.systemFont(ofSize: 10)
        textGeometry.materials = [textNodeMaterial]
        
        // Integrate text node with text geometry
        let textNode = SCNNode(geometry: textGeometry)
        textNode.name = "textNode"
        textNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        addChildNode(textNode)
        addChildNode(planeNode)
    }
}
