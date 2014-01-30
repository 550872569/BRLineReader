//
//  LineReaderTests.m
//  BRLineReaderTests
//
//  Created by Bjørn Olav Ruud on 24.01.14.
//  Copyright (c) 2014 Bjørn Olav Ruud. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRLineReader.h"

@interface BRLineReaderTests : XCTestCase

@end

@implementation BRLineReaderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLineReader
{
    NSArray *tests = @[
        @{
            @"lines": @"",
            @"assertID": @"Empty"
        },
        @{
            @"lines": @"Line01\nLine02\nLine03",
            @"assertID": @"Three lines"
        },
        @{
            @"lines": @"Line04\n\nLine05",
            @"assertID": @"Double newline"
        },
    ];

    for (NSDictionary *test in tests) {
        NSString *lines = test[@"lines"];
        NSArray *lineComponents = ([lines length] > 0) ? [lines componentsSeparatedByString:@"\n"] : @[];
        NSData *data = [lines dataUsingEncoding:NSUTF8StringEncoding];

        BRLineReader *lineReader = [[BRLineReader alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray *linesFromData = [NSMutableArray array];
        NSString *line = nil;
        while ((line = [lineReader readTrimmedLine])) {
            [linesFromData addObject:line];
        }
        XCTAssert(lineReader.linesRead == [lineComponents count], @"%@: Wrong read line count.", test[@"assertID"]);
        XCTAssertEqualObjects(lineComponents, linesFromData, @"%@: Lines from data are not same as reference.", test[@"assertID"]);
    }
}

- (void)testStringInit
{
    NSString *lines = @"Line01\nLine02\nLine03";
    NSArray *lineComponents = [lines componentsSeparatedByString:@"\n"];
    BRLineReader *lineReader = [[BRLineReader alloc] initWithString:lines];
    NSMutableArray *linesFromData = [NSMutableArray array];
    NSString *line = nil;
    while ((line = [lineReader readTrimmedLine])) {
        [linesFromData addObject:line];
    }
    XCTAssert(lineReader.linesRead == [lineComponents count], @"%@: Wrong read line count.", @"String init");
    XCTAssertEqualObjects(lineComponents, linesFromData, @"%@: Lines from data are not same as reference.", @"String init");
}

@end
