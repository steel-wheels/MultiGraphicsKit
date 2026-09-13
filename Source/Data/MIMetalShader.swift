/*
 * @file MIMetalShader.swift
 * @description Define MIMetalShader class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MetalKit
import Foundation

public class MIMetalShader
{
        private var mLibrary:   MTLLibrary

        public init(library lib: MTLLibrary) {
                mLibrary = lib
        }
}

