import Foundation

public struct InstallNameTool {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    private enum Command: String, CaseIterable {
        case changeMainLibraryInstallName = "-id"
        case changeLinkedLibraryInstallName = "-change"
        case replaceRunPath = "-rpath"
        case addRunPath = "-add_rpath"
        case deleteRunPath = "-delete_rpath"
    }

    /// Changes the rpath path name old to new in the specified Mach-O binary. More than one of these options can be specified. If the Mach-O binary does not contain the old rpath path name in a specified -rpath it is an error.
    public func replaceRunPath(from: String, to: String) throws {
        try TaskRunner.runCommand(.replaceRunPath, for: url, arguments: from, to)
    }

    /// Adds the rpath path name new in the specified Mach-O binary. More than one of these options can be specified. If the Mach-O binary already contains the new rpath path name specified in -add_rpath it is an error.
    public func addRunPath(_ rpath: String) throws {
        try TaskRunner.runCommand(.addRunPath, for: url, arguments: rpath)
    }

    /// deletes the rpath path name old in the specified Mach-O binary. More than one of these options can be specified. If the Mach-O binary does not contains the old rpath path name specified in -delete_rpath it is an error.
    public func deleteRunPath(_ rpath: String) throws {
        try TaskRunner.runCommand(.deleteRunPath, for: url, arguments: rpath)
    }
    
    public func changeLinkedLibraryInstallName(from linkedLibrary: String, to newInstallName: String) throws {
        try TaskRunner.runCommand(.changeLinkedLibraryInstallName, for: url, arguments: linkedLibrary, newInstallName)
    }
    
    /// Changes the shared library identification name of a dynamic shared library to name. If the Mach-O binary is not a dynamic shared library and the -id option is specified it is ignored.

    public func setMainInstallName(_ newInstallName: String) throws {
        try TaskRunner.runCommand(.changeMainLibraryInstallName, for: url, arguments: newInstallName)
    }

    public enum Error: LocalizedError {
        case commonError(String)
        public var errorDescription: String? {
            switch self {
            case .commonError(let string):
                string
            }
        }
    }
    
    private enum TaskRunner {
        static func runCommand(_ command: Command, for fileURL: URL, arguments: String...) throws {
            let process = Process()
            process.executableURL = .init(fileURLWithPath: "/usr/bin/install_name_tool")
            var finalArguments: [String] = []
            finalArguments.append(command.rawValue)
            finalArguments.append(contentsOf: arguments)
            finalArguments.append(fileURL.path)
            process.arguments = finalArguments
            let errorPipe = Pipe()
            process.standardError = errorPipe
            try process.run()
            process.waitUntilExit()
            if process.terminationStatus != 0 {
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                if let errorString = String(data: errorData, encoding: .utf8) {
                    throw Error.commonError(errorString)
                }
            }
        }
    }
}
