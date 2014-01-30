`BRLineReader` is a class for iOS and OS X that reads text data line by line.

Data can be read from file or from a supplied `NSData` object. If reading from file it will be represented by a memory-mapped data object.

All ASCII based text encodings and variable length encodings like UTF-8 are supported, but multibyte encodings like UTF-16 are not since the line delimiter must be represented with a single byte.

## Installation

Add the BRLineReader.[h|m] files to your project and #import the header file.

## Usage

```obj-c
NSString *path = @"/path/to/file";
BRLineReader *lineReader = [[BRLineReader alloc] initWithFile:path encoding:NSUTF8StringEncoding];
NSString *line = nil;
while ((line = [lineReader readTrimmedLine])) {
    // Do things with line...
}
```

## License

This software is licensed under the [MIT license](http://choosealicense.com/licenses/mit/). See LICENSE for details.
