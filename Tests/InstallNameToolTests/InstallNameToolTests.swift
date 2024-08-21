import XCTest
@testable import InstallNameTool

final class InstallNameToolTests: XCTestCase {
    func testExample() throws {
        let installNameTool = InstallNameTool(url: .init(fileURLWithPath: "/Volumes/FrameworkLab/Numbers/Frameworks/TSCharts.framework/Versions/A/TSCharts"))
        try installNameTool.addRunPath("/Volumes/FrameworkLab/Numbers/Frameworks")
    }
}
