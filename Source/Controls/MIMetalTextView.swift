/*
 * @file MIMetalTextView.swift
 * @description Define MIMetalTextView class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import  MultiUIKit
import  MultiDataKit
import  MetalKit
#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)

#if os(OSX)

open class MIMetalTextView: MIMetalView
{
        typealias FontAtlas = MIAtlasTable.FontAtlas

        private var mFont               = NSFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
        private var mFontAtlas          : FontAtlas? = nil
        private var mText               = MIMetalText()
        private var mAtlasTable         = MIAtlasTable()
        private var mAtlasTexture       : MTLTexture? = nil

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
                do {
                        let atlas     = try mAtlasTable.allocateFontAtras(font: mFont)
                        mFontAtlas    = atlas
                        mAtlasTexture = try allocateTexture(image: atlas.cgImage, options: nil)
                } catch {
                        NSLog("[Error] Failed to allocate mAtlasTexture")
                }
        }

        open override func contentSizeUpdated(pointSize ptsize: CGSize, pixelSize pxsize: CGSize) {
                super.contentSizeUpdated(pointSize: ptsize, pixelSize: pxsize)
                guard let atlas = mFontAtlas else {
                        NSLog("[Error] No font atlas")
                        return
                }
                let cellSize = atlas.cellSize
                let width  = Int(ptsize.width  / cellSize.width)
                let height = Int(ptsize.height / cellSize.height)
                NSLog("metal: width=\(width), height=\(height)")
                mText.resize(width: width, height: height)
        }

        open override func draw(in view: MTKView) {
                guard let atlas = mFontAtlas else {
                        NSLog("[Error] No font atlas")
                        return
                }
                do {
                        let (uniforms, glyphs) = mText.allocateUniforms(fontAtlas: atlas)
                        if uniforms.count > 0 && glyphs.count > 0 {
                                let uniformBuf = try allocateUniformsBuffer(uniforms: uniforms)
                                let glyphBuf   = try allocateGlyphParamsBuffer(glyphParams: glyphs)
                        }
                } catch {
                        NSLog("[Error] Failed to allocate buffers")
                }
        }

        private func allocateUniformsBuffer(uniforms: Array<Uniforms>) throws -> MTLBuffer {
                let len = MemoryLayout<Uniforms>.stride * uniforms.count
                if let buf = self.device.makeBuffer(bytes: uniforms, length: len, options: .storageModeShared) {
                        return buf
                } else {
                        throw MIGraphicsError.objectAllocationFailure("MTLBuffer")
                }
        }

        private func allocateGlyphParamsBuffer(glyphParams: Array<GlyphParams>) throws -> MTLBuffer {
                let len = MemoryLayout<GlyphParams>.stride * glyphParams.count
                if let buf = self.device.makeBuffer(bytes: glyphParams, length: len, options: .storageModeShared) {
                        return buf
                } else {
                        throw MIGraphicsError.objectAllocationFailure("MTLBuffer")
                }
        }
}

#endif // os(OSX)

