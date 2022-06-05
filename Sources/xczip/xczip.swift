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
                                                    version: "1.2.0")

    @Argument(help: "Path to xcframework.")
    var path: String

    @Option(name: .long, help: ArgumentHelp("Force compressed files modification date.",
                                            discussion: "Date format must be M-d-yyyy"))
    var date: String?

    @Option(name: .long, help: ArgumentHelp("Force compressed files modification time.",
                                            discussion: "Time format must be hh:mm:ss"))
    var time: String?

    @Option(name: .long, help: ArgumentHelp("Force compressed files modification date and time.",
                                            discussion: "Date format must be ISO 8601. Example: \"2022-04-11 11:48:47 +0200\""))
    var isoDate: String?

    @Option(name: .shortAndLong, help: "Path for created archive.")
    var outputPath: String?

    @Option(name: .shortAndLong, help: "Add comment to zip file.")
    var comment: String?

    mutating func run() throws {
        let forceDate: Date
        
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M-d-yyyy"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            guard var date = dateFormatter.date(from: date) else {
                print("Wrong date format. Must be mm-dd-yyyy.")
                throw ExitCode(2)
            }
            
            if let time = time {
                let timeFormater = DateFormatter()
                timeFormater.dateFormat = "hh:mm:ss"
                timeFormater.timeZone = TimeZone(abbreviation: "GMT")
                timeFormater.defaultDate = date
                guard let timePart = timeFormater.date(from: time) else {
                    print("Wrong time format. Must be mm:hh:ss.")
                    throw ExitCode(2)
                }
                date = timePart
            }
            forceDate = date
        } else if let isoDate = isoDate {
            let dateFormatter = ISO8601DateFormatter()
            let options: ISO8601DateFormatter.Options = [
                .withTimeZone,
                .withSpaceBetweenDateAndTime,
                .withTime,
                .withColonSeparatorInTime,
                .withDashSeparatorInDate,
                .withYear, .withMonth, .withDay
            ]
            dateFormatter.formatOptions = options
            guard let date = dateFormatter.date(from: isoDate) else {
                print("Wrong ISO 8601 date format.")
                throw ExitCode(2)
            }
            forceDate = date
        } else {
            print("Please provide date or iso date")
            throw ExitCode(2)
        }
        
        let fileManager = FileManager()
        let sourceURL = URL(fileURLWithPath: path)
        let archiveURL: URL
        if let outputPath = outputPath {
            archiveURL = URL(fileURLWithPath: outputPath)
        } else {
            archiveURL = sourceURL.appendingPathExtension("zip")
        }
        let commentData = comment?.data(using: .utf8) ?? Data()

        do {
            try fileManager.zipItem(at: sourceURL, to: archiveURL,
                                    compressionMethod: .deflate,
                                    forceDate: forceDate,
                                    zipFileCommentData: commentData)
        } catch {
            print("Creation of ZIP archive failed with error:", error.localizedDescription)
            throw ExitCode(1)
        }
    }
}
