import ArgumentParser
import Stencil
import StencilSwiftKit

extension Environment {
    public func renderTemplate(name: String, devices: [Device], format: OutputFormat) throws -> String {
        try renderTemplate(
            name: name,
            context: [
                "devices": devices,
                "access-level": format.accessLevel.rawValue
            ]
        )
    }
}

public struct OutputFormat: ParsableArguments {
    @Flag(help: "Set access level modifier for Device enumeration")
    public var accessLevel: AccessLevel = .internal

    public init() {}
}

public enum AccessLevel: String, EnumerableFlag {
    case `public`
    case `internal`
}
