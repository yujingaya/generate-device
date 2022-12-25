import Stencil
import StencilSwiftKit

extension Environment {
    public func renderTemplate(name: String, devices: [Device]) throws -> String {
        try renderTemplate(name: name, context: ["devices": devices])
    }
}
