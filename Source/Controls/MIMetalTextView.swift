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

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
                let atlas = mAtlasTable.allocateFontAtras(font: mFont)
                mFontAtlas = atlas
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
        }
}

#endif // os(OSX)

