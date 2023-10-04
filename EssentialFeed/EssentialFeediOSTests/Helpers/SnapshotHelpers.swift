//
//  SnapshotHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Jonathan Denney on 1/12/23.
//

import UIKit
import XCTest

extension XCTestCase {
    func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )

            try snapshotData?.write(to: snapshotURL)
            XCTFail("Record succeeded - use `assert` from now on", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

    func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)

        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representations from snapshot", file: file, line: line)
            return
        }

        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting", file: file, line: line)
            return
        }

        if !match(snapshotData, storedSnapshotData, tolerance: 0.0001) {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)

            try? snapshotData.write(to: temporarySnapshotURL)

            let errorMessage = "New snapshot data does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), stored snapshot URL: \(snapshotURL)"

            XCTFail(errorMessage, file: file, line: line)
        }
    }

    private func match(_ oldData: Data, _ newData: Data, tolerance: Float = 0) -> Bool {
        if oldData == newData { return true }

        guard let oldImage = UIImage(data: oldData)?.cgImage, let newImage = UIImage(data: newData)?.cgImage else {
            return false
        }

        guard oldImage.width == newImage.width, oldImage.height == newImage.height else {
            return false
        }

        let minBytesPerRow = min(oldImage.bytesPerRow, newImage.bytesPerRow)
        let bytesCount = minBytesPerRow * oldImage.height

        var oldImageByteBuffer = [UInt8](repeating: 0, count: bytesCount)
        guard let oldImageData = data(for: oldImage, bytesPerRow: minBytesPerRow, buffer: &oldImageByteBuffer) else {
            return false
        }

        var newImageByteBuffer = [UInt8](repeating: 0, count: bytesCount)
        guard let newImageData = data(for: newImage, bytesPerRow: minBytesPerRow, buffer: &newImageByteBuffer) else {
            return false
        }

        if memcmp(oldImageData, newImageData, bytesCount) == 0 { return true }

        return match(oldImageByteBuffer, newImageByteBuffer, tolerance: tolerance, bytesCount: bytesCount)
    }

    private func data(for image: CGImage, bytesPerRow: Int, buffer: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
        guard
            let space = image.colorSpace,
            let context = CGContext(
                data: buffer,
                width: image.width,
                height: image.height,
                bitsPerComponent: image.bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: space,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
        else { return nil }

        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))

        return context.data
    }

    private func match(_ bytes1: [UInt8], _ bytes2: [UInt8], tolerance: Float, bytesCount: Int) -> Bool {
        var differentBytesCount = 0
        for i in 0 ..< bytesCount where bytes1[i] != bytes2[i] {
            differentBytesCount += 1

            let percentage = Float(differentBytesCount) / Float(bytesCount)
            if percentage > tolerance {
                return false
            }
        }
        return true
    }

    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }

    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }

        return data
    }
}

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        return SnapshotConfiguration(
            size: CGSize(width: 390, height: 844),
            safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 55, left: 8, bottom: 42, right: 8),
            traitCollection: UITraitCollection(traitsFrom: [
                .init(forceTouchCapability: .unavailable),
                .init(layoutDirection: .leftToRight),
                .init(preferredContentSizeCategory: contentSize),
                .init(userInterfaceIdiom: .phone),
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(displayScale: 3),
                .init(accessibilityContrast: .normal),
                .init(displayGamut: .P3),
                .init(userInterfaceStyle: style)
            ]))
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone(style: .light)

    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }

    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }

    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }

    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}
