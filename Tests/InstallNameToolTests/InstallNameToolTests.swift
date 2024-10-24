import XCTest
@testable import InstallNameTool

final class InstallNameToolTests: XCTestCase {
    func testExample() throws {
        let installNameTool = InstallNameTool(url: .init(fileURLWithPath: "/Volumes/Code/Dump/TSTables.framework/Versions/A/TSTables"))
        try installNameTool.changeLinkedLibraryInstallName(from: "@rpath/TSKit.framework/Versions/A/TSKit", to: "/Volumes/Code/Dump/iWork_macOS_14.1/TSKit.framework/Versions/A/TSKit")
    }
}
