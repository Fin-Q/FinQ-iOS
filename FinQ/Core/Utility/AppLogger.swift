//
//  AppLogger.swift
//  FinQ
//
//  Created by 권대윤 on 8/27/26.
//

import Foundation

enum LogLevel: String, Sendable {
    case debug = "🐛 DEBUG"
    case error = "❌ ERROR"
}

final class AppLogger: @unchecked Sendable {
    static let shared = AppLogger()

    private let maxFileSize: UInt64 = 512 // KB
    private let maxFileCount = 10 // 512KB × 10 = 5MB (로그 파일에 5MB 사용 목적)
    private let name = "logfile"
    private let directoryName = "Logs"

    private let fileManager = FileManager.default
    private let logQueue = DispatchQueue(label: "com.daeyunkwon.FinQ.AppLogger", qos: .utility)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()

    private lazy var directory: String = {
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return dirURL?.appendingPathComponent("Logs").path ?? NSTemporaryDirectory() + "Logs"
    }()

    enum LoggerMode: Sendable {
        case fileOnly
        case consoleOnly
        case both
    }
    private var currentLoggerMode: LoggerMode = .both

    private init() {}

    /// 로그 파일을 저장할 디렉토리 존재 여부를 확인하고 없으면 생성
    private func ensureDirectoryExists() {
        if !fileManager.fileExists(atPath: directory) {
            do {
                try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("❗️ Failed to create log directory: \(error)")
            }
        }
    }

    func setLoggerMode(mode: LoggerMode) {
        logQueue.async { [weak self] in
            self?.currentLoggerMode = mode
        }
    }

    private func logFileName(index: Int) -> String {
        return "\(name)_\(index).log"
    }

    private var currentLogPath: String {
        return (directory as NSString).appendingPathComponent(logFileName(index: 0)) // logfile_0.log이(가) 항상 최신 로그 파일
    }

    /// 로그메시지 형식 ex) 2025-06-11 15:30:25.123 [❌ ERROR] NetworkManager.swift:42 fetchData() → 네트워크 연결 실패
    func log(_ message: String, level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        let date = Date()

        logQueue.async { [weak self] in
            guard let self else { return }

            let filename = (file as NSString).lastPathComponent
            let logMessage = "\(formattedDate(date)) [\(level.rawValue)] \(filename):\(line) \(function) → \(message)\n"

            switch currentLoggerMode {
            case .fileOnly:
                rotateLogsIfNeeded()
                write(logMessage)

            case .consoleOnly:
                print(logMessage, terminator: "")

            case .both:
                print(logMessage, terminator: "")
                rotateLogsIfNeeded()
                write(logMessage)
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    private func write(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }

        ensureDirectoryExists() // 디렉토리 없으면 생성

        if !fileManager.fileExists(atPath: currentLogPath) { // 현재 로그 파일 없으면 생성
            fileManager.createFile(atPath: currentLogPath, contents: nil, attributes: nil)
        }

        if let handle = try? FileHandle(forWritingTo: URL(fileURLWithPath: currentLogPath)) {
            // 파일 맨 끝으로 포인터를 이동하고, 로그 메시지 기록
            handle.seekToEndOfFile()
            handle.write(data)
            handle.closeFile()
        }
    }

    private func rotateLogsIfNeeded() {
        let maxBytes = maxFileSize * 1024
        guard let attrs = try? fileManager.attributesOfItem(atPath: currentLogPath),
              let fileSize = attrs[.size] as? Int64, fileSize > maxBytes else {
            return
        }

        // 삭제 대상: 마지막 인덱스 파일
        let lastIndexPath = (directory as NSString).appendingPathComponent(logFileName(index: maxFileCount - 1))
        if fileManager.fileExists(atPath: lastIndexPath) {
            try? fileManager.removeItem(atPath: lastIndexPath)
        }

        // 한칸씩 뒤로 이동
        for i in (1..<maxFileCount).reversed() {
            let src = (directory as NSString).appendingPathComponent(logFileName(index: i - 1))
            let dst = (directory as NSString).appendingPathComponent(logFileName(index: i))
            if fileManager.fileExists(atPath: src) {
                try? fileManager.moveItem(atPath: src, toPath: dst)
            }
        }

        // 새 로그 파일 생성
        fileManager.createFile(atPath: currentLogPath, contents: nil, attributes: nil)
    }
}
