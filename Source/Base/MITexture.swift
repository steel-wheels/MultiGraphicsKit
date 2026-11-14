/*
 * @file MITexture.swift
 * @description Extend MTLTexture class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import MultiUIKit
import Metal
import MetalKit
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public class MIScalableTexture
{
        private var mDevice:    MTLDevice
        private var mImage:     MIScalableImage
        private var mTexture:   MTLTexture?

        public init(device dev: MTLDevice, image img: MIScalableImage) {
                mDevice         = dev
                mImage          = img
                mTexture        = nil
        }

        public func texture() throws -> MTLTexture {
                if let tex = mTexture {
                        return tex
                } else {
                        throw MIGraphicsError.nullObject
                }
        }

        public func resize(to newsize: CGSize) throws -> Bool {
                let resized = mImage.resize(to: newsize)
                if mTexture == nil || resized {
                        mTexture = try MIScalableTexture.allocateTexture(device: mDevice, image: mImage.image, options: nil)
                        return true
                } else {
                        return false
                }
        }

        private static func allocateTexture(device dev: MTLDevice, image img: MIImage, options opts: [MTKTextureLoader.Option : Any]?) throws -> MTLTexture {
                guard let cgimg = img.cgImage else {
                        throw MIGraphicsError.convertFailed
                }
                let loader = MTKTextureLoader(device: dev)
                return try loader.newTexture(cgImage: cgimg, options: opts)
        }
}

