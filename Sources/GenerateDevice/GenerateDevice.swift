import ArgumentParser
import Device
import Foundation
import SQLite
import Stencil
import StencilSwiftKit

@main
struct GenerateDevice: ParsableCommand {
    @Argument(help: "The path to device_traits.db file", completion: .file(extensions: ["db"]))
    var deviceTraits: String

    func run() throws {
        let connection = try Connection(deviceTraits)
        let devices = try connection.devices

        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        let environment = Environment(loader: FileSystemLoader(bundle: [.module]), extensions: [ext])

        let rendered = try environment.renderTemplate(name: "Templates/Device.swift.stencil", devices: devices)

        print(rendered)
    }
}
