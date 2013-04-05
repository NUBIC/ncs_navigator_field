//
//  NUEndpoint.h
//  
//
//  Created by Jacob Van Order on 2/14/13.
//
//

#import <Foundation/Foundation.h>

@class NUEndpointEnvironment;

@interface NUEndpoint : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *endpointImage;
@property (nonatomic, strong) NSArray *environmentArray;
@property (nonatomic, strong) NUEndpointEnvironment *enviroment;
@property (nonatomic, strong) NSNumber *isManualEndpoint;

-(instancetype)initWithDataDictionary:(NSDictionary *)dataDictionary;

+(NUEndpoint *)userEndpointOnDisk;

+(BOOL)deleteUserEndpoint;
-(void) writeToDisk;

+(NUEndpoint *) migrateUserToAutoLocation;

- (id) objectForKeyedSubscript:(NSString *)keyString;

@end
