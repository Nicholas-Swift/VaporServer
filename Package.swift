import PackageDescription

let package = Package(
    name: "VaporServer",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
        .Package(url:"https://github.com/vapor/jwt.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/postgresql-provider", majorVersion: 1, minor: 1),
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

