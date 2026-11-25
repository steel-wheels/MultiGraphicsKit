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
        public struct MICharacter {
                var     asciiCode:      Int

                public init(asciiCode: Int) {
                        self.asciiCode = asciiCode
                }
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
                                let space = MICharacter(asciiCode: MIAsciiCode.space)
                                line.append(contentsOf: Array(repeating: space, count: w - mWidth))
                                mText[i] = line
                        } else if w < mWidth {
                                line.removeLast(mWidth - w)
                                mText[i] = line
                        }
                }
                mWidth = w
        }

        private func allocateNewline(width: Int) -> Array<MICharacter> {
                let space = MICharacter(asciiCode: MIAsciiCode.space)
                return Array<MICharacter>(repeating: space, count: width)
        }
}
