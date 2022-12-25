import ArgumentParser

public struct DeploymentTarget: Equatable {
    let majorVersion: Int
    let minorVersion: Int
}

extension DeploymentTarget: CustomStringConvertible {
    public var description: String {
        "\(majorVersion).\(minorVersion)"
    }
}

extension DeploymentTarget: Comparable {
    public static func < (lhs: DeploymentTarget, rhs: DeploymentTarget) -> Bool {
        if lhs.majorVersion != rhs.majorVersion {
            return lhs.majorVersion < rhs.majorVersion
        } else {
            return lhs.minorVersion < rhs.minorVersion
        }
    }
}

extension DeploymentTarget: Decodable {
    public init(_ string: String) throws {
        guard let separator = string.firstIndex(of: "."),
              let majorVersion = Int(string[..<separator]),
              let minorVersion = Int(string[string.index(after: separator)...]) else {
            throw DeploymentTargetParsingError()
        }

        self.majorVersion = majorVersion
        self.minorVersion = minorVersion
    }
}

extension DeploymentTarget: ExpressibleByArgument {
    public init?(argument: String) {
        try? self.init(argument)
    }
}

struct DeploymentTargetParsingError: Error {}
