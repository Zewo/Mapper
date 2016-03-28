import PackageDescription

let package = Package(
    name: "Topo",
    dependencies: [
    	.Package(url: "https://github.com/Zewo/InterchangeData.git", majorVersion: 0, minor: 2)
    ]
)
