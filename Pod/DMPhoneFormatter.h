//
//  DMPhoneFormatter.h
//  polyphone
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 East Media Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPhoneFormatter : NSObject

+ (id)defaultFormatter;

- (NSString *)autoFormat:(NSString *)phoneNumber positionOffset:(NSInteger *)offset;
- (NSString *) removeGarbageChars: (NSString *)originalString;

@end
