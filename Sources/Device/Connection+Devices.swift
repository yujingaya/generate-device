import Algorithms
import SQLite

extension Connection {
    var devicesTable: Table { Table("Devices") }
    var deploymentVariantsTable: Table { Table("DeploymentVariant") }

    var target: Expression<String> { Expression<String>("Target") }
    var productType: Expression<String> { Expression<String>("ProductType") }
    var productDescription: Expression<String> { Expression<String>("ProductDescription") }

    var deviceTarget: Expression<String> { Expression<String>("DeviceTarget") }
    var deploymentTarget: Expression<String> { Expression<String>("DeploymentTarget") }

    var thinningConfiguration: Expression<String?> { Expression<String?>("ThinningConfiguration") }

    public var devices: [Device] {
        get throws {
            let select = devicesTable
                .select(target, productType, productDescription, thinningConfiguration)
                .order(productType)

            return try prepare(select)
                .map { row in
                    let target = row[target]
                    let productType = row[productType]
                    let productDescription = row[productDescription]
                    let thinningConfiguration = row[thinningConfiguration]

                    let deploymentTargets = try deploymentTargets(
                        target: target,
                        thinningConfiguration: thinningConfiguration
                    )

                    guard let maximumDeploymentTarget = deploymentTargets.max() else {
                        throw DeviceParsingError()
                    }

                    return Device(
                        productType: productType,
                        productDescription: productDescription,
                        maximumDeploymentTarget: maximumDeploymentTarget
                    )
                }
                .chunked {
                    $0.productType
                }
                .map { (productType, devicesWithSameProductType) in
                    let device = devicesWithSameProductType.first!
                    let maximumDeploymentTarget = devicesWithSameProductType.map { $0.maximumDeploymentTarget }.max()!

                    print("\(device.productDescription) supports up to \(maximumDeploymentTarget)")
                    return Device(
                        productType: productType,
                        productDescription: device.productDescription,
                        maximumDeploymentTarget: maximumDeploymentTarget
                    )
                }
        }
    }

    func deploymentTargets(
        target deviceTargetString: String,
        thinningConfiguration thinningConfigurationString: String?
    ) throws -> [DeploymentTarget] {
        let select = deploymentVariantsTable
            .select(deploymentTarget)
            .where(deviceTarget == deviceTargetString && thinningConfiguration == thinningConfigurationString)

        return try prepare(select)
            .map { row in
                try DeploymentTarget(row[deploymentTarget])
            }
    }
}

struct DeviceParsingError: Error {}
