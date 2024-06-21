//
//  web3.swift
//  Copyright © 2022 Argent Labs Limited. All rights reserved.
//

import Foundation

enum EthereumSignerError: Error {
    case emptyRawTransaction
    case unknownError
}

public extension EthereumAccountProtocol {
    func signRaw(_ transaction: EthereumTransaction) async throws -> Data {
        let signed: SignedTransaction = try await sign(transaction: transaction)
        guard let raw = signed.raw else {
            throw EthereumSignerError.unknownError
        }
        return raw
    }

    func sign(transaction: EthereumTransaction) async throws -> SignedTransaction {
        guard let raw = transaction.raw else {
            throw EthereumSignerError.emptyRawTransaction
        }

        guard let signature = try? await sign(data: raw) else {
            throw EthereumSignerError.unknownError
        }

        return SignedTransaction(transaction: transaction, signature: signature)
    }
}
