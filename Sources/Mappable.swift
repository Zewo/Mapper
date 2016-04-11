import StructuredData

public protocol Mappable: StructuredDataInitializable {
    
    init(mapper: Mapper) throws
    
}

extension Mappable {
    public init(structuredData: StructuredData) throws {
        try self.init(mapper: structuredData.mapper)
    }
}

extension Mappable {
    
    public static func makeWith(structuredData structuredData: StructuredData) -> Self? {
        do {
            return try self.init(mapper: structuredData.mapper)
        } catch {
            return nil
        }
    }
    
}