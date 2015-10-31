//
//  NSMutableURLRequest+Parameters.h
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURLRequest (Parameters)

@property(nonatomic, readonly) NSDictionary *parameters;
@property(nonatomic, readonly) BOOL isMultipart;

@end

//

@interface NSMutableURLRequest (Parameters)

@property(nonatomic, retain) NSDictionary *parameters;
@property(nonatomic, readonly) BOOL isMultipart;

- (void)setHTTPBodyWithString:(NSString *)body;

- (void)attachFileWithName:(NSString *)name filename:(NSString*)filename contentType:(NSString *)contentType data:(NSData*)data;

@end
