import PackageDescription

let package = Package(
    name: "Mapper",
    dependencies: [
    	.Package(url: "https://github.com/Zewo/InterchangeData.git", majorVersion: 0, minor: 4)
    ]
)
