/*
 * @file MITexture.swift
 * @description Extend MTLTexture class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import MultiUIKit
import Metal
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public extension MTLTexture
{
        func copy(image img: CGImage){
                let width  = img.width
                let height = img.height

                let bytesPerPixel = 4
                let bytesPerRow   = bytesPerPixel * width

                var rawData = [UInt8](repeating: 0, count: Int(bytesPerRow * height))

                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let context = CGContext(
                    data: &rawData,
                    width: width,
                    height: height,
                    bitsPerComponent: 8,
                    bytesPerRow: bytesPerRow,
                    space: colorSpace,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                )!

                context.draw(img, in: CGRect(x: 0, y: 0, width: width, height: height))

                self.replace(
                    region: MTLRegionMake2D(0, 0, width, height),
                    mipmapLevel: 0,
                    withBytes: rawData,
                    bytesPerRow: bytesPerRow
                )
        }
}

