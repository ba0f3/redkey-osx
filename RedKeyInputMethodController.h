//
//  InputMethodController.h
//  RedKey
//
//  Created by Bruce Doan on 6/24/15.
//  Copyright (c) 2015 Huy Doan. All rights reserved.
//

#import <InputMethodKit/InputMethodKit.h>

@interface InputMethodController : IMKInputController {
    NSString* composingString;
    NSString* originalString;
    long cursorPosition;
    NSRange replacementRange;
}
@end