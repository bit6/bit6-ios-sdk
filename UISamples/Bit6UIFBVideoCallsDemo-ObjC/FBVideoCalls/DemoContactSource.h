//
//  Bit6DemoContactSource.h
//  Bit6
//
//  Created by Carlos Thurber on 04/12/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoContactSource : NSObject <BXUContactSource>

@property (nullable, strong, nonatomic) NSDictionary<NSString*,id<BXUContact>> *dataSource;

@end

@interface DemoContact : NSObject <BXUContact>

@property (nonnull, nonatomic, strong) NSString *uri;
@property (nonnull, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSURL *avatarURL;

- (nonnull instancetype)initWithURI:(nonnull NSString*)uri name:(nonnull NSString*)name avatarURLString:(nullable NSString*)avatarURLString;

@end
