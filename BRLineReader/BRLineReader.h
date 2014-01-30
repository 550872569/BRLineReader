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

#import <Foundation/Foundation.h>

/**
 `BRLineReader` is a class for iOS and OS X that reads text data line by line.

 Data can be read from file or from a supplied `NSData` object. If reading from
 file it will be represented by a memory-mapped data object.

 All ASCII based text encodings and variable length encodings like UTF-8 are
 supported, but multibyte encodings like UTF-16 are not since the line delimiter
 must be represented with a single byte.

 For efficient memory management when dealing with large data sets it is recommended
 to put each iteration of a line reading loop in an `\@autoreleasepool` block.
 */
@interface BRLineReader : NSObject

/// Data object the lines are read from.
@property (readonly, nonatomic) NSData *data;

/// Data range of last line read.
@property (readonly, nonatomic) NSRange lastLineRange;

/// Character that separates lines. Defaults to '\\n'.
@property (assign, nonatomic) unsigned char lineDelimiter;

/// Number of lines read from current start position.
@property (readonly, nonatomic) NSUInteger linesRead;

/// Character set used to trim line. Defaults to `whitespaceAndNewlineCharacterSet`.
@property (strong, nonatomic) NSCharacterSet *lineTrimCharacters;

/// Encoding of input text.
@property (readonly, nonatomic) NSStringEncoding stringEncoding;

/**
 Init reader with data from file using supplied string encoding. File will be
 loaded using memory mapping. If file doesn't exist the data property will be nil.

 @param filePath Path to file.
 @param encoding Text encoding of file.
 */
- (instancetype)initWithFile:(NSString *)filePath encoding:(NSStringEncoding)encoding;

/**
 Init reader with existing data object using supplied string encoding. The data
 object is not copied.

 @param data Data object.
 @param encoding Text encoding of data.
 */
- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

/**
 Init reader with string object using UTF-8 string encoding.

 @param string String object.
 */
- (instancetype)initWithString:(NSString *)string;

/**
 @return Next line, or nil if there are no more lines.
 */
- (NSString *)readLine;

/**
 @return Next line trimmed using `lineTrimCharacters` set, or nil if there are
         no more lines.
 */
- (NSString *)readTrimmedLine;

/**
 Start reading lines from a specific data position.

 @param position Data position (in bytes) to start reading lines from.
 */
- (void)setLineSearchPosition:(NSUInteger)position;

@end
