//
//  DMPhoneFormatterTextField.m
//  DMPhoneFormatter
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhoneFormatterTextField.h"

#import "DMPhoneFormatter.h"

@interface UITextField() <UITextFieldDelegate>

@end

@implementation DMPhoneFormatterTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self == nil) return nil;
    
    [self initView];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self initView];
    
    return self;
}

- (void)initView {
    [self addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0 && range.length == 1 && range.location == (textField.text.length - 1)) {
        NSString *text = [[DMPhoneFormatter defaultFormatter] removeGarbageChars:textField.text];
        NSString *newText = [text stringByReplacingCharactersInRange:NSMakeRange(text.length - 1, 1) withString:@""];
        
        NSString *frmText = [[DMPhoneFormatter defaultFormatter] formatNumber:newText];
        textField.text = frmText;
        
        NSInteger offset = [self indexOfDigitAtIndex:[newText length]];
        [self moveCursorToPosition:offset];
        
        return NO;
    }
    
    return YES;
}

- (void)textChanged:(UITextField *)sender {
    NSInteger offset = [self digitCursorPosition];
    NSString *text = [[DMPhoneFormatter defaultFormatter] formatNumber:sender.text];
    
    sender.text = text;
    
    if (offset != NSNotFound) {
        NSInteger index = [self indexOfDigitAtIndex:offset];
        
        [self moveCursorToPosition:index];
    }
    
    if (self.changeBlock) {
        self.changeBlock(self);
    }
}

- (void)moveCursorToPosition:(NSInteger)offset {
    // set cursor position
    UITextPosition *beginning = [self beginningOfDocument];
    UITextPosition *newSelectedRange = [self positionFromPosition:beginning offset:offset];
    UITextRange *textRange = [self textRangeFromPosition:newSelectedRange toPosition:newSelectedRange];
    
    [self setSelectedTextRange:textRange];
}

- (NSInteger)digitCursorPosition {
    
    UITextRange *textRange = self.selectedTextRange;
    UITextPosition *posStart = textRange.start;
    UITextPosition *posEnd = textRange.end;
    
    NSInteger startEndOffset = [self offsetFromPosition:posStart toPosition:posEnd];
    if (startEndOffset != 0) return NSNotFound;
    
    NSInteger offset = [self offsetFromPosition:[self beginningOfDocument] toPosition:posStart];
    if (offset == 0) return offset;
    
    NSInteger digitIndex = 0;
    NSInteger length = [self.text length];
    for (int i = 0; i < length; i++) {
        unichar c = [self.text characterAtIndex:i];
        
        if ([DMPhoneFormatter isDigitChar:c]) {
            
            digitIndex++;
        }
        
        if ((i + 1) >= offset) {
            break;
        }
    }
    
    return digitIndex;
}

- (NSInteger)indexOfDigitAtIndex:(NSInteger)index {
    
    NSInteger digitIndex = 0;
    NSInteger length = [self.text length];
    for (int i = 0; i < length; i++) {
        unichar c = [self.text characterAtIndex:i];
        
        if ([DMPhoneFormatter isDigitChar:c]) {
            
            digitIndex++;
        }
        
        if (digitIndex == index) {
            return i + 1;
        }
    }
    
    return NSNotFound;
}

@end
