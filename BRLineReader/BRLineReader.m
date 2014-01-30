// The MIT License (MIT)
//
// Copyright (c) 2014 Bjørn Olav Ruud
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BRLineReader.h"

@implementation BRLineReader

#pragma mark - Lifecycle

- (instancetype)initWithFile:(NSString *)filePath encoding:(NSStringEncoding)encoding
{
    self = [super init];
    if (self) {
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:&error];
        if (!data) {
            NSLog(@"%@", [error localizedDescription]);
        }
        [self commonInitWithData:data encoding:encoding];
    }

    return self;
}

- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
    self = [super init];
    if (self) {
        [self commonInitWithData:data encoding:encoding];
    }

    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        [self commonInitWithData:data encoding:NSUTF8StringEncoding];
    }

    return self;
}

- (void)commonInitWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
    _data = data;
    _stringEncoding = encoding;
    _lineDelimiter = '\n';
    _lineTrimCharacters = [NSCharacterSet whitespaceAndNewlineCharacterSet];
}

#pragma mark - Public methods

- (NSString *)readLine
{
    NSUInteger dataLength = [_data length];
    NSUInteger beginPos = _lastLineRange.location + _lastLineRange.length;
    if (beginPos == dataLength) {
        // End of file
        return nil;
    }

    NSUInteger endPos = beginPos;
    unsigned char *buffer = (unsigned char *)[_data bytes];
    for (NSUInteger i = beginPos; i < dataLength; i++) {
        endPos = i;
        if (buffer[i] == _lineDelimiter) break;
    }

    // End of line found
    _lastLineRange = NSMakeRange(beginPos, endPos - beginPos + 1);
    NSData *lineData = [_data subdataWithRange:_lastLineRange];
    NSString *line = [[NSString alloc] initWithData:lineData encoding:_stringEncoding];
    _linesRead++;

    return line;
}

- (NSString *)readTrimmedLine
{
    return [[self readLine] stringByTrimmingCharactersInSet:_lineTrimCharacters];
}

- (void)setLineSearchPosition:(NSUInteger)position
{
    _lastLineRange = NSMakeRange(position, 0);
    _linesRead = 0;
}

@end
