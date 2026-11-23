/*
 * @file MIAtlasTable.swift
 * @description Define MIAtlasTable class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

#if os(OSX)

import MultiDataKit
import MultiUIKit
import AppKit
import Foundation

public class MIAtlasTable
{
        public static let MaxAsciiCode                  = 128
        public static let tableRowNum                   = 16
        public static let tableColumnNum                = MaxAsciiCode / tableRowNum

        public struct GlyphInfo {
                public let character:  Character
                public let frame:      CGRect
                public let uvMin:      CGPoint
                public let uvMax:      CGPoint

                public init(character: Character, frame: CGRect, uvMin: CGPoint, uvMax: CGPoint) {
                        self.character = character
                        self.frame = frame
                        self.uvMin = uvMin
                        self.uvMax = uvMax
                }
        }

        public struct FontAtlas {
                public let      nsImage:        MIImage
                public let      cgImage:        CGImage
                public let      glyphs:         [Character: GlyphInfo]
                public let      cellSize:       CGSize

                public init(nsImage: MIImage, cgImage: CGImage, glyphs: [Character : GlyphInfo], cellSize: CGSize) {
                        self.nsImage  = nsImage
                        self.cgImage  = cgImage
                        self.glyphs   = glyphs
                        self.cellSize = cellSize
                }
        }

        public init() {
                
        }

        public static func glyphParam(for asciicode: Int) -> GlyphParams {
                let col  = asciicode % MIAtlasTable.tableColumnNum
                let row  = asciicode / MIAtlasTable.tableColumnNum
                return GlyphParams(asciiCode: UInt32(asciicode), atlasColumns: UInt32(col),
                                   atlasRows: UInt32(row), reserved: 0)
        }

        public func allocateFontAtras(font: MIFont) -> FontAtlas {
                let cellsize    = MIAtlasTable.atlasCellSize(for: font)
                let tablewidth  = cellsize.width  * CGFloat(MIAtlasTable.tableColumnNum)
                let tableheight = cellsize.height * CGFloat(MIAtlasTable.tableRowNum)

                let bitmapRep = NSBitmapImageRep(
                    bitmapDataPlanes: nil,
                    pixelsWide: Int(tablewidth),
                    pixelsHigh: Int(tableheight),
                    bitsPerSample: 8,
                    samplesPerPixel: 4,
                    hasAlpha: true,
                    isPlanar: false,
                    colorSpaceName: .deviceRGB,
                    bytesPerRow: 0,
                    bitsPerPixel: 0
                )!

                bitmapRep.size = CGSize(width: tablewidth, height: tableheight)

                guard let context = NSGraphicsContext(bitmapImageRep: bitmapRep) else {
                        fatalError("Failed to create graphics context")
                }

                var glyphmap: [Character: GlyphInfo] = [:]

                NSGraphicsContext.saveGraphicsState()
                NSGraphicsContext.current = context

                let tablerect = CGRect(
                        origin: .zero,
                        size: CGSize(
                                width: tablewidth,
                                height: tableheight
                        )
                )

                clearRect(table: tablerect)

                for code in 0..<MIAtlasTable.MaxAsciiCode {
                        let colidx = code % MIAtlasTable.tableColumnNum
                        let rowidx = code / MIAtlasTable.tableColumnNum

                        let xpos = CGFloat(colidx) * cellsize.width
                        let ypos = CGFloat(rowidx) * cellsize.height

                        guard let scalar = UnicodeScalar(code) else {
                                continue
                        }

                        let character = Character(scalar)

                        let glyphinfo = drawFont(
                                xPosition: xpos,
                                yPosition: ypos,
                                cellSize: cellsize,
                                font: font,
                                character: character
                        )
                        glyphmap[character] = glyphinfo
                }

                NSGraphicsContext.restoreGraphicsState()

                let image = NSImage(
                    size: CGSize(
                        width: tablewidth,
                        height: tableheight
                    )
                )

                image.addRepresentation(bitmapRep)

                guard let cgImage = bitmapRep.cgImage else {
                    fatalError("Failed to create CGImage")
                }

                return FontAtlas(
                    nsImage:    image,
                    cgImage:    cgImage,
                    glyphs:     glyphmap,
                    cellSize:   cellsize
                )
        }

        // locked by image
        private func drawFont(xPosition xpos: CGFloat, yPosition ypos: CGFloat, cellSize cellsize: CGSize, font: MIFont, character char: Character) -> GlyphInfo {
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: MIColor.white
                ]

                let str  = String(char)
                let size = (str as NSString).size(withAttributes: attrs)

                let lineHeight = font.ascender - font.descender
                let drawPoint = CGPoint(
                    x: xpos + (cellsize.width - size.width) * 0.5,
                    y: ypos +
                       (cellsize.height - lineHeight) * 0.5 -
                       font.descender
                )

                (str as NSString).draw(
                    at: drawPoint,
                    withAttributes: attrs
                )

                let frame = CGRect(
                    x:          xpos,
                    y:          ypos,
                    width:      cellsize.width,
                    height:     cellsize.height
                )

                let tablewidth  = cellsize.width  * CGFloat(MIAtlasTable.tableColumnNum)
                let tableheight = cellsize.height * CGFloat(MIAtlasTable.tableRowNum)

                return GlyphInfo(
                    character: char,
                    frame: frame,
                    uvMin: CGPoint(
                        x: frame.minX / CGFloat(tablewidth),
                        y: frame.minY / CGFloat(tableheight)
                    ),
                    uvMax: CGPoint(
                        x: frame.maxX / CGFloat(tablewidth),
                        y: frame.maxY / CGFloat(tableheight)
                    )
                )
        }

        /* A Swift implementation for macOS to find the maximum glyph size
         * among all ASCII characters supported by an NSFont
         */
        private static func atlasCellSize(for font: MIFont) -> CGSize {
                var maxbounds: CGRect = CGRect.zero
                let ctfont = font as CTFont

                for code in 0..<256 {
                        guard let scalar = UnicodeScalar(code) else {
                                continue
                        }

                        let char = UniChar(scalar.value)
                        var glyph: CGGlyph = 0

                        if CTFontGetGlyphsForCharacters(ctfont, [char], &glyph, 1) {
                                let rect = CTFontGetBoundingRectsForGlyphs(
                                        ctfont, .default, [glyph], nil, 1)
                                maxbounds = maxbounds.union(rect)
                        }
                }
                let width  = ceil(maxbounds.width)
                let height = ceil(font.ascender - font.descender + font.leading)
                return CGSize(width: width, height: height)
        }

        private func clearRect(table rect: CGRect) {
                #if os(OSX)
                        let rrect: NSRect = rect
                        MIColor.clear.setFill()
                        rrect.fill()
                #else
                        UIColor.clear.setFill()
                        UIRectFill(
                                CGRect(x: 0, y: 0, width: rect.width, height: rect.height
                        )
                )
                #endif
        }
}
#endif // os(OSX)
