import PackageDescription

let package = Package(
    name: "StructuredDataMapper",
    dependencies: [
    	.Package(url: "https://github.com/Zewo/InterchangeData.git", majorVersion: 0, minor: 4)
    ]
)
