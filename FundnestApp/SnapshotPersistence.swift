import Foundation

struct SnapshotPersistence {
    private let fileURL: URL

    init(fileURL: URL? = nil) {
        if let fileURL {
            self.fileURL = fileURL
            return
        }

        let directory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        self.fileURL = directory.appendingPathComponent("fundnest-snapshot.json")
    }

    func load() -> FundnestSnapshot? {
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return try? JSONDecoder.fundnest.decode(FundnestSnapshot.self, from: data)
    }

    func save(_ snapshot: FundnestSnapshot) {
        guard let data = try? JSONEncoder.fundnest.encode(snapshot) else {
            return
        }
        try? data.write(to: fileURL, options: [.atomic])
    }
}

private extension JSONDecoder {
    static var fundnest: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

private extension JSONEncoder {
    static var fundnest: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
