//
//  Data+Ext.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 31.07.2024.
//

import Foundation
import CryptoKit
import CommonCrypto
import UIKit

extension Data {


    func md5() -> String {
        var context = CC_MD5_CTX()
        CC_MD5_Init(&context)

        self.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            _ = CC_MD5_Update(&context, pointer.baseAddress, CC_LONG(self.count))
        }

        var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
            _ = CC_MD5_Final(pointer.baseAddress, &context)
        }

        let result = digest.map { String(format: "%02hhx", $0) }.joined()
        return result
    }

}
