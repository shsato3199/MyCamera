//
//  UIImageExtension.swift
//  MyCamera
//
//  Created by 佐藤翔馬 on 2024/04/07.
//

import Foundation
import UIKit

extension UIImage{
    func resized() -> UIImage?{
        //リサイズの比率をKさん
        let rate = 1024.0 / self.size.width
        //リサイズ後の画像サイズをKさん
        let targetSize = CGSize(width: self.size.width * rate,
                                height: self.size.height * rate)
        //新しいサイズに基づいて画像レンダラーを作成
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        //新しいサイズに基づいて下の画像を描画
        return renderer.image{_ in draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
