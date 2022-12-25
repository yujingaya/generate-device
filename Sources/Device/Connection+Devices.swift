import Algorithms
import SQLite

extension Connection {
    public var devices: [Device] {
        get throws {
            let devices = Table("Devices")

            let productType = Expression<String>("ProductType")
            let productDescription = Expression<String>("ProductDescription")

            let select = devices.select(productType, productDescription)

            return try prepare(select)
                .map { row in
                    Device(
                        productType: row[productType],
                        productDescription: row[productDescription]
                    )
                }
                .uniqued { device in
                    device.productType
                }
        }
    }
}
