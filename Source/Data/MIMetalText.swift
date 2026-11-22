/*
 * @file MIMetalText.swift
 * @description Define MIMetalText class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Foundation

public class MIMetalText
{
        private static let NullChar  = MICharacter(asciiCode: MIAsciiCode.nullCode)

        public struct MICharacter {
                var     asciiCode:      Int

                public init(asciiCode: Int) {
                        self.asciiCode = asciiCode
                }

                public var isNull: Bool { get {
                        return asciiCode == MIAsciiCode.nullCode
                }}
        }

        private var     mText:          Array<Array<MICharacter>>
        private var     mWidth:         Int
        private var     mHeight:        Int

        public init() {
                mText           = []
                mWidth          = 0
                mHeight         = 0
        }

        public var text: Array<Array<MICharacter>> { get {
                return mText
        }}

        public func character(x: Int, y: Int) -> MICharacter? {
                if x < mWidth && y < mHeight {
                        return mText[y][x]
                } else {
                        return nil
                }
        }

        public func setCharacter(x: Int, y: Int, _ c: MICharacter) {
                if x < mWidth && y < mHeight {
                        mText[y][x] = c
                } else {
                        NSLog("[Error] failed to set character \(x) x \(y)")
                }
        }

        public func resize(width w: Int, height h: Int) {
                resize(height: h)
                resize(width: w)
        }

        private func resize(height h: Int) {
                if h > mHeight {
                        /* append lines */
                        let newline = allocateNewline(width: mWidth)
                        for _ in 0..<h-mHeight { mText.append(newline) }
                        mHeight = h
                } else if h < mHeight {
                        /* remove lines */
                        mText.removeLast(mHeight - h)
                        mHeight = h
                }
        }

        private func resize(width w: Int) {
                for i in 0..<mHeight {
                        var line = mText[i]
                        if w > mWidth {
                                line.append(contentsOf: Array(repeating: MIMetalText.NullChar, count: w - mWidth))
                                mText[i] = line
                        } else if w < mWidth {
                                line.removeLast(mWidth - w)
                                mText[i] = line
                        }
                }
                mWidth = w
        }

        private func allocateNewline(width: Int) -> Array<MICharacter> {
                return Array<MICharacter>(repeating: MIMetalText.NullChar, count: width)
        }
}
