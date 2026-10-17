/*
 * @file ImageTextureSample.swift
 * @description Sample program to draw image texture
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiGraphicsKit
import MultiDataKit
import MultiUIKit
import Metal
import AppKit
import Foundation

public func imageTextureSample(device dev: MTLDevice) -> Bool
{
        /* load PNG image */
        guard let img = loadImage() else {
                return false
        }

        return true
}

private func loadImage() -> MIImage?
{
        guard let resdir = FileManager.default.resourceDirectory else {
                NSLog("No resource directory")
                return nil
        }
        let filepath = resdir.appendingPathComponent("Images/steel-wheels.png")
        if let img = MIImage(contentsOf: filepath) {
                return img
        } else {
                NSLog("Failed to load image from \(filepath.path())")
                return nil
        }
}

