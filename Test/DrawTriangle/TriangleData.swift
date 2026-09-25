//
//  TriangleData.swift
//  DrawTriangle
//
//  Created by Tomoo Hamada on 2026/09/22.
//

import MultiGraphicsKit
import MultiUIKit
import MetalKit
import Foundation

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A type and a function implementation that configures the color and position data
 for the three vertices of a triangle.
*/

/// Defines the binding index values for passing buffer arguments to GPU function parameters.
///
/// The binding values define an agreement between:
/// - The app's main code in Objective-C that submits the data to the GPU
/// - The shader code that defines the GPU functions, which receive the data through their parameters
///
/// The value needs to match between the two sides of exchange for the data to get
/// to the correct place.
public enum InputBufferIndex: Int
{
    /// The buffer binding index value that stores the triangle's vertex data.
    ///
    /// The data at this binding index stores an array of three ``VertexData`` instances.
    case InputBufferIndexForVertexData          = 0

    /// The buffer binding index value that stores the app's viewport's size.
    ///
    /// The vertex shader calculates the pixel coordinates of the triangle's vertices
    /// based on the size of the app's viewport.
    case InputBufferIndexForViewportSize        = 1
}

/// A type that stores the vertex data for one triangle.
public struct TriangleData {
        public var vertex0:     MIVertex
        public var vertex1:     MIVertex
        public var vertex2:     MIVertex

        public init(v0: MIVertex, v1: MIVertex, v2: MIVertex) {
                self.vertex0 = v0
                self.vertex1 = v1
                self.vertex2 = v2
        }
}

/// Configures an equilateral triangle's vertex data.
///
/// The function assigns:
/// - Red, green, and blue, to the first, second, and third vertices, respectively
/// - The positions along on a circle that circumscribes the triangle,
/// which are 120° apart from each other
///
/// - Parameters:
///   - radius: The radius of the circle that circumscribes the equilateral triangle.
///   - rotationInDegrees: An angle of rotation for the triangle, in degrees.
///   - triangleData: A pointer to a triangle data instance.

public func triangleRedGreenBlue(radius: Float, rotationInDegrees: Float) -> TriangleData {
        /// An angle, in radians, that's equal to the rotation.
        let angle0: Float = rotationInDegrees * Float.pi / 180.0
        /// This is the equivalent of adding 120° to the first angle.
        let angle1: Float = angle0 + (2.0 * Float.pi  / 3.0)
        /// An angle, in radians, one-third of a circle more than the previous angle.
        /// This is the equivalent of adding 240° to the first angle.
        let angle2: Float = angle0 + (4.0 * Float.pi  / 3.0)
        /// The position of the triangle's first vertex.
        let position0 = CGPoint(x: Double(radius * cos(angle0)), y: Double(radius * sin(angle0)))
        /// The position of the triangle's second vertex.
        let position1 = CGPoint(x: Double(radius * cos(angle1)), y: Double(radius * sin(angle1)))
        /// The position of the triangle's third vertex.
        let position2 = CGPoint(x: Double(radius * cos(angle2)), y: Double(radius * sin(angle2)))

        let vertex0 = MIVertex(position: position0, color: CGColor.red)
        let vertex1 = MIVertex(position: position1, color: CGColor.green)
        let vertex2 = MIVertex(position: position2, color: CGColor.blue)
        return TriangleData(v0: vertex0, v1: vertex1, v2: vertex2)
}

/// Configures an equilateral triangle's vertex data
/// and copies the bytes into a Metal buffer's pointer.
///
/// - Parameters:
///   - rotationInDegrees: An angle of rotation for the triangle, in degrees.
///   - bufferContents: A pointer from an `MTLBuffer` instance's `contents` property.

public func configureVertexDataForBuffer(rotationInDegrees: Int) -> TriangleData {
        let radius: Float = Float(360)
        let angle:  Float = Float(rotationInDegrees % 360)
        return triangleRedGreenBlue(radius: radius, rotationInDegrees: angle)
}
