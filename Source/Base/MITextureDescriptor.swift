/*
 * @file MITextureDescriptor.swift
 * @description Extend MTLTextureDescriptor class
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

public extension MTLTextureDescriptor
{
        class func textureImageDescriptor(image img: CGImage) -> MTLTextureDescriptor {
                let descriptor = MTLTextureDescriptor.texture2DDescriptor(
                    pixelFormat:        .rgba8Unorm,
                    width:              img.width,
                    height:             img.height,
                    mipmapped:          false
                )
                //descriptor.usage = [.shaderRead, .shaderWrite]
                descriptor.usage = [.shaderRead, .renderTarget]
                return descriptor
        }
}

