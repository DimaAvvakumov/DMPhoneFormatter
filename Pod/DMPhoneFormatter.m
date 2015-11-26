//
//  DMPhoneFormatter.m
//  polyphone
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 East Media Ltd. All rights reserved.
//

#import "DMPhoneFormatter.h"

@implementation DMPhoneFormatter

- (NSString *)autoFormat:(NSString *)phoneNumber {
    NSString *originalString = [self removeGarbageChars:phoneNumber];
    
    // original length
    NSUInteger originalStringLength = [originalString length];
    
    // check length
    if (originalStringLength == 0) return phoneNumber;
    
    NSMutableString *digitNumber = [NSMutableString stringWithCapacity:originalStringLength];
    
    BOOL digitWasFound = NO;
    NSInteger startLocation = 0;
    for (NSInteger i = 0; i < originalStringLength; i++) {
        unichar c = [originalString characterAtIndex:i];
        
        if (c >= '0' && c <= '9') {
            [digitNumber appendString:[NSString stringWithCharacters:&c length:1]];
            
            if (digitWasFound == NO) {
                startLocation = i;
            }
            digitWasFound = YES;
        } else if (digitWasFound) {
            break;
        }
    }
    
    // check digitNumber length. If it 0, then nothing to analize
    NSUInteger digitNumberLength = [digitNumber length];
    if (digitNumberLength == 0) return originalString;
    
    if (digitNumberLength < 2 || digitNumberLength > 10) return originalString;
    
    // vars
    unichar firstChar = [originalString characterAtIndex:0];
    BOOL firstIsPlus = (firstChar == '+') ? YES : NO;
    
    // for two digits
    if (digitNumberLength == 2) {
        unichar digit1 = [digitNumber characterAtIndex:0];
        unichar digit2 = [digitNumber characterAtIndex:1];
        
        BOOL firstExpr = NO;
        if (firstIsPlus && digit1 == '7') {
            firstExpr = YES;
        }
        if (NO == firstIsPlus && digit1 == '8') {
            firstExpr = YES;
        }
        
        if (firstExpr) {
            NSRange range = NSMakeRange(startLocation, digitNumberLength);
            NSString *formattedString = [NSString stringWithFormat:@"%c (%c  )", digit1, digit2];
            originalString = [originalString stringByReplacingCharactersInRange:range withString:formattedString];
        }
    }
    
    // for three
    if (digitNumberLength == 3) {
        unichar digit1 = [digitNumber characterAtIndex:0];
        unichar digit2 = [digitNumber characterAtIndex:1];
        unichar digit3 = [digitNumber characterAtIndex:2];
        
        BOOL firstExpr = NO;
        if (firstIsPlus && digit1 == '7') {
            firstExpr = YES;
        }
        if (NO == firstIsPlus && digit1 == '8') {
            firstExpr = YES;
        }
        
        if (firstExpr) {
            NSRange range = NSMakeRange(startLocation, digitNumberLength);
            NSString *formattedString = [NSString stringWithFormat:@"%c (%c%c )", digit1, digit2, digit3];
            originalString = [originalString stringByReplacingCharactersInRange:range withString:formattedString];
        }
    }
    
    // for four
    if (digitNumberLength == 4) {
        unichar digit1 = [digitNumber characterAtIndex:0];
        unichar digit2 = [digitNumber characterAtIndex:1];
        unichar digit3 = [digitNumber characterAtIndex:2];
        unichar digit4 = [digitNumber characterAtIndex:3];
        
        BOOL firstExpr = NO;
        if (firstIsPlus && digit1 == '7') {
            firstExpr = YES;
        }
        if (NO == firstIsPlus && digit1 == '8') {
            firstExpr = YES;
        }
        
        if (firstExpr) {
            NSRange range = NSMakeRange(startLocation, digitNumberLength);
            NSString *formattedString = [NSString stringWithFormat:@"%c (%c%c%c)", digit1, digit2, digit3, digit4];
            originalString = [originalString stringByReplacingCharactersInRange:range withString:formattedString];
        }
    }
    
    if (digitNumberLength == 5) {
        unichar digit1 = [digitNumber characterAtIndex:0];
        unichar digit2 = [digitNumber characterAtIndex:1];
        unichar digit3 = [digitNumber characterAtIndex:2];
        unichar digit4 = [digitNumber characterAtIndex:3];
        unichar digit5 = [digitNumber characterAtIndex:3];
        
        BOOL firstExpr = NO;
        if (firstIsPlus && digit1 == '7') {
            firstExpr = YES;
        }
        if (NO == firstIsPlus && digit1 == '8') {
            firstExpr = YES;
        }
        
        if (firstExpr) {
            NSRange range = NSMakeRange(startLocation, digitNumberLength);
            NSString *formattedString = [NSString stringWithFormat:@"%c (%c%c%c) %c", digit1, digit2, digit3, digit4, digit5];
            originalString = [originalString stringByReplacingCharactersInRange:range withString:formattedString];
        }
    }
    
    if (digitNumberLength == 6) {
        unichar digit1 = [digitNumber characterAtIndex:0];
        unichar digit2 = [digitNumber characterAtIndex:1];
        unichar digit3 = [digitNumber characterAtIndex:2];
        unichar digit4 = [digitNumber characterAtIndex:3];
        unichar digit5 = [digitNumber characterAtIndex:3];
        unichar digit6 = [digitNumber characterAtIndex:3];
        
        BOOL firstExpr = NO;
        if (firstIsPlus && digit1 == '7') {
            firstExpr = YES;
        }
        if (NO == firstIsPlus && digit1 == '8') {
            firstExpr = YES;
        }
        
        if (firstExpr) {
            NSRange range = NSMakeRange(startLocation, digitNumberLength);
            NSString *formattedString = [NSString stringWithFormat:@"%c (%c%c%c) %c%c", digit1, digit2, digit3, digit4, digit5, digit6];
            originalString = [originalString stringByReplacingCharactersInRange:range withString:formattedString];
        }
    }
    
    return originalString;
}

- (NSString *) removeGarbageChars: (NSString *)originalString {
    NSUInteger originalStringLength = [originalString length];
    
    // check length
    if (originalStringLength == 0) return originalString;
    
    NSMutableString *cleanString = [NSMutableString stringWithCapacity:originalStringLength];
    
    for (NSInteger i = 0; i < originalStringLength; i++) {
        unichar c = [originalString characterAtIndex:i];
        
        BOOL insert = NO;
        
        if (c >= '0' && c <= '9') {
            insert = YES;
        } else if (c == '+') {
            insert = YES;
        } else if (c == '*' || c == '#') {
            insert = YES;
        } else if (c == ',' || c == ';') {
            insert = YES;
        }
        
        if (insert) {
            [cleanString appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    
    return cleanString;
}

@end
