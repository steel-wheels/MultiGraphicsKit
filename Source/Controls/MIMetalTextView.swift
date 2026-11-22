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

open class MIMetalTextView: MIMetalView
{
        public struct MICharacter {
                var     char:   Character
                public init(char: Character) {
                        self.char = char
                }
        }

}

