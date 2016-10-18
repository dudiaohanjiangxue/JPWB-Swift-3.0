//
//  JPGlobalTool.swift
//  JPWB
//
//  Created by KC on 16/10/14.
//  Copyright © 2016年 KC. All rights reserved.
//

import UIKit

class JPGlobalTool: NSObject {

}



func JPLog(_ items: Any..., fileName: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        if items.count == 0 {
            print(fileName, funcName, lineNum);
        }else {
            
            print(fileName, funcName, lineNum, items);
        }
    #endif
}
