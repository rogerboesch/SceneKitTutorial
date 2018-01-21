//
//  RBTerrain.swift
//  Terrain creation
//
//  Created by Roger Boesch on 12/07/16.
//  Inspired by Obj-C code created by Steven Troughton-Smith on 24/12/11.
//

import Foundation
import SceneKit

public typealias RBTerrainFormula = ((Int32, Int32) -> (Double))

// -----------------------------------------------------------------------------

public class RBTerrain: SCNNode {
    private var _heightScale = 256
    private var _terrainWidth = 32
    private var _terrainLength = 32
    private var _terrainGeometry: SCNGeometry?
    private var _texture: RBImage?
    private var _color = RBColor.white
    
    public var formula: RBTerrainFormula?
    
    // -------------------------------------------------------------------------
    // MARK: - Properties
    
    public var length: Int {
        get {
            return _terrainLength
        }
    }
    
    // -------------------------------------------------------------------------
    
    public var width: Int {
        get {
            return _terrainLength
        }
    }
    
    // -------------------------------------------------------------------------

    public var texture: RBImage? {
        get {
            return _texture
        }
        set(value) {
            _texture = value
            
            if (_terrainGeometry != nil && _texture != nil) {
                let material = SCNMaterial()
                material.diffuse.contents = _texture!
                material.isLitPerPixel = true
                material.diffuse.magnificationFilter = .none
                material.diffuse.wrapS = .repeat
                material.diffuse.wrapT = .repeat
                material.diffuse.contentsTransform = SCNMatrix4MakeScale(RBFloat(_terrainWidth*2), RBFloat(_terrainLength*2), 1)
                
                _terrainGeometry!.firstMaterial = material
                _terrainGeometry!.firstMaterial!.isDoubleSided = true
            }
        }
    }
    
    // -------------------------------------------------------------------------
    
    public var color: RBColor {
        get {
            return _color
        }
        set(value) {
            _color = value
            
            if (_terrainGeometry != nil) {
                let material = SCNMaterial()
                material.diffuse.contents = _color
                material.isLitPerPixel = true

                _terrainGeometry!.firstMaterial = material
                _terrainGeometry!.firstMaterial!.isDoubleSided = true
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Terrain formula
    
    public func valueFor(x: Int32, y: Int32) ->Double {
        if (formula == nil) {
            return 0.0
        }
        
        return formula!(x, y)
    }

    // -------------------------------------------------------------------------
    // MARK: - Geometry creation

    private func createGeometry() ->SCNGeometry {
        let cint: CInt = 0
        let sizeOfCInt = MemoryLayout.size(ofValue: cint)
        let float: RBFloat = 0.0
        let sizeOfFloat = MemoryLayout.size(ofValue: float)
        let vec2: vector_float2 = vector2(0, 0)
        let sizeOfVecFloat = MemoryLayout.size(ofValue: vec2)

        let w: CGFloat = CGFloat(_terrainWidth)
        let h: CGFloat = CGFloat(_terrainLength)
        let scale: Double = Double(_heightScale)

        var sources = [SCNGeometrySource]()
        var elements = [SCNGeometryElement]()

        let maxElements: Int = _terrainWidth * _terrainLength * 4
        var vertices = [SCNVector3](repeating:SCNVector3Zero, count:maxElements)
        var normals = [SCNVector3](repeating:SCNVector3Zero, count:maxElements)
        var uvList: [vector_float2] = []
        
        var vertexCount = 0
        let factor: CGFloat = 0.5

        for y in 0...Int(h-2) {
            for x in 0...Int(w-1) {
                let topLeftZ = valueFor(x: Int32(x), y: Int32(y+1)) / scale
                let topRightZ = valueFor(x: Int32(x+1), y: Int32(y+1)) / scale
                let bottomLeftZ = valueFor(x: Int32(x), y: Int32(y)) / scale
                let bottomRightZ = valueFor(x: Int32(x+1), y: Int32(y)) / scale
                
                let topLeft = SCNVector3Make(RBFloat(x)-RBFloat(factor), RBFloat(topLeftZ), RBFloat(y)+RBFloat(factor))
                let topRight = SCNVector3Make(RBFloat(x)+RBFloat(factor), RBFloat(topRightZ), RBFloat(y)+RBFloat(factor))
                let bottomLeft = SCNVector3Make(RBFloat(x)-RBFloat(factor), RBFloat(bottomLeftZ), RBFloat(y)-RBFloat(factor))
                let bottomRight = SCNVector3Make(RBFloat(x)+RBFloat(factor), RBFloat(bottomRightZ), RBFloat(y)-RBFloat(factor))

                vertices[vertexCount] = bottomLeft
                vertices[vertexCount+1] = topLeft
                vertices[vertexCount+2] = topRight
                vertices[vertexCount+3] = bottomRight

                let xf = CGFloat(x)
                let yf = CGFloat(y)

                uvList.append(vector_float2(Float(xf/w), Float(yf/h)))
                uvList.append(vector_float2(Float(xf/w), Float((yf+factor)/h)))
                uvList.append(vector_float2(Float((xf+factor)/w), Float((yf+factor)/h)))
                uvList.append(vector_float2(Float((xf+factor)/w), Float(yf/h)))
                
                vertexCount += 4
            }
        }

        let source = SCNGeometrySource(vertices: vertices)
        sources.append(source)

        let geometryData = NSMutableData()

        var geometry: CInt = 0
        while (geometry < CInt(vertexCount)) {
            let bytes: [CInt] = [geometry, geometry+2, geometry+3, geometry, geometry+1, geometry+2]
            geometryData.append(bytes, length: sizeOfCInt*6)
            geometry += 4
        }

        let element = SCNGeometryElement(data: geometryData as Data, primitiveType: .triangles, primitiveCount: vertexCount/2, bytesPerIndex: sizeOfCInt)
        elements.append(element)
        
        for normalIndex in 0...vertexCount-1 {
            normals[normalIndex] = SCNVector3Make(0, 0, -1)
        }
        sources.append(SCNGeometrySource(normals: normals))

        let uvData = NSData(bytes: uvList, length: uvList.count * sizeOfVecFloat)
        let uvSource = SCNGeometrySource(data: uvData as Data, semantic: SCNGeometrySource.Semantic.texcoord, vectorCount: uvList.count, usesFloatComponents: true, componentsPerVector: 2, bytesPerComponent: sizeOfFloat, dataOffset: 0, dataStride: sizeOfVecFloat)
        sources.append(uvSource)
        
        _terrainGeometry = SCNGeometry(sources: sources, elements: elements)
        
        let material = SCNMaterial()
        material.isLitPerPixel = true
        material.diffuse.magnificationFilter = .none
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(RBFloat(_terrainWidth*2), RBFloat(_terrainLength*2), 1)
        material.diffuse.intensity = 1.0

        _terrainGeometry!.firstMaterial = material
        _terrainGeometry!.firstMaterial!.isDoubleSided = true
        
        return _terrainGeometry!
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Create terrain
    
    public func create(withImage image: RBImage?) {
        let terrainNode = SCNNode(geometry: createGeometry())
        self.addChildNode(terrainNode)
        
        if (image != nil) {
            self.texture = image
        }
        else {
            self.color = RBColor.green
        }
    }
    
    // -------------------------------------------------------------------------

    public func create(withColor color: RBColor) {
        let terrainNode = SCNNode(geometry: createGeometry())
        self.addChildNode(terrainNode)
        
        self.color = color
    }

    // -------------------------------------------------------------------------
    // MARK: - Initialisation
    
    public init(width: Int, length: Int, scale: Int) {
        super.init()
        
        _terrainWidth = width
        _terrainLength = length
        _heightScale = scale
    }

    // -------------------------------------------------------------------------

    required public init(coder: NSCoder) {
        fatalError("Not yet implemented")
    }

    // -------------------------------------------------------------------------
}
