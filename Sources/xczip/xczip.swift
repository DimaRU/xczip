//
//  xczip.swift
//  
//
//  Created by Dmitriy Borovikov on 07.01.2022.
//

import Foundation
import ArgumentParser
import ZIPFoundation

@main
struct xczip: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "xczip",
                                                    abstract: "Create xcframework zip archive for swift binary package.",
                                                    version: "1.0.0")

    @Argument(help: "Path to xcframework.")
    var path: String

    @Option(name: .long, help: ArgumentHelp("Force compressed files modification date.",
                                            discussion: "Date format must be M-d-yyyy"))
    var date: String

    @Option(name: .long, help: ArgumentHelp("Force compressed files modification time.",
                                            discussion: "Time format must be hh:mm:ss"))
    var time: String?

    @Option(name: .shortAndLong, help: "Created archive path.")
    var outputPath: String?

    mutating func run() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-d-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "hh:mm:ss"
        timeFormater.timeZone = TimeZone(abbreviation: "GMT")

        guard var forceDate = dateFormatter.date(from: date) else {
            print("Wrong date format. Must be mm-dd-yyyy.")
            throw ExitCode(2)
        }
        
        if let time = time {
            timeFormater.defaultDate = forceDate
            guard let timePart = timeFormater.date(from: time) else {
                print("Wrong time format. Must be mm:hh:ss.")
                throw ExitCode(2)
            }
            forceDate = timePart
        }
            
        let fileManager = FileManager()
        let sourceURL = URL(fileURLWithPath: path)
        let destinationURL: URL
        if let outputPath = outputPath {
            destinationURL = URL(fileURLWithPath: outputPath)
        } else {
            destinationURL = sourceURL.appendingPathExtension("zip")
        }
        do {
            try fileManager.zipItem(at: sourceURL, to: destinationURL, compressionMethod: .deflate, forceDate: forceDate)
        } catch {
            print("Creation of ZIP archive failed with error:", error.localizedDescription)
            throw ExitCode(1)
        }
    }
}
