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
        private static let NULL_CHAR  = MICharacter(asciiCode: MIAsciiCode.null.rawValue)
        private static let SPACE_CHAR = MICharacter(asciiCode: MIAsciiCode.space.rawValue)

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

        public func resize(width w: Int, height h: Int) {
                resize(height: h)
                resize(width: w)
        }

        public func resize(height h: Int) {
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

        public func resize(width w: Int) {
                for i in 0..<mHeight {
                        var line = mText[i]
                        if w > mWidth {
                                line.append(contentsOf: Array(repeating: MIMetalText.NULL_CHAR, count: w - mWidth))
                                mText[i] = line
                        } else if w < mWidth {
                                line.removeLast(mWidth - w)
                                mText[i] = line
                        }
                }
                mWidth = w
        }

        private func allocateNewline(width: Int) -> Array<MICharacter> {
                return Array<MICharacter>(repeating: MIMetalText.NULL_CHAR, count: width)
        }
}
