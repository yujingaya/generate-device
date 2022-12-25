import ArgumentParser
import Device
import Foundation
import SQLite
import Stencil
import StencilSwiftKit

@main
struct GenerateDevice: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Generate Device.swift from a device_traits.db file",
        usage: """
            generate-device [--output <output>] <device-traits>
            """,
        version: "0.1.0"
    )

    @OptionGroup(title: "Output format")
    var outputFormat: OutputFormat

    @Option(
        name: [.short, .customLong("minimum-deployment-target")],
        help: "Omit devices that doesn't support specified deployment target"
    )
    var minimumDeploymentTarget: DeploymentTarget?

    @Option(name: [.short, .customLong("output")], help: "Write output to a specified file")
    var outputFile: String?

    @Argument(help: "The path to device_traits.db file", completion: .file(extensions: ["db"]))
    var deviceTraits: String

    func run() throws {
        let connection = try Connection(deviceTraits)
        var devices = try connection.devices
        if let minimumDeploymentTarget {
            devices = devices.filter { $0.maximumDeploymentTarget >= minimumDeploymentTarget }
        }

        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        let environment = Environment(loader: FileSystemLoader(bundle: [.module]), extensions: [ext])

        let rendered = try environment.renderTemplate(
            name: "Templates/Device.swift.stencil",
            devices: devices,
            format: outputFormat
        )

        if let outputFile {
            try rendered.write(toFile: outputFile, atomically: true, encoding: .utf8)
        }
        else {
            print(rendered)
        }
    }
}
