//
//  RedKeyInputMethodController.h
//  redkey
//
//  Created by Bruce Doan on 7/22/15.
//  Copyright (c) 2015 Huy Doan. All rights reserved.
//

#ifndef redkey_RedKeyInputMethodController_h
#define redkey_RedKeyInputMethodController_h

#import <InputMethodKit/InputMethodKit.h>

@interface RedKeyInputMethodController : IMKInputController {
    NSString* composingString;
    NSString* originalString;
    long cursorPosition;
    NSRange replacementRange;
}
@end


#endif
