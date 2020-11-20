//
//  CoreDataManager.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/15/20.
//

#import "DatabaseManager.h"
#import <sqlite3.h>
@interface DatabaseManager ()
@property (nonatomic, strong) NSString *documetDirectory;
@property (nonatomic, strong) NSString *dbPath;
@property (nonatomic, retain) NSString *databaseFileName;
@property (nonatomic, assign, readwrite) sqlite3 *dbPointer;


- (void)copyDatabaseFileIntoDocumentsDirectoryIfNeeded: (NSString *)destPath;
- (void)createdDatabaseIfNeeded;
- (void)createTableIfRequired;

- (sqlite3 *)openConnection;
- (void)closeConnection;
- (sqlite3_stmt *)prepareStatement: (const char *)sql;

@end

@implementation DatabaseManager


+ (id)sharedManager {
    static DatabaseManager * shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    
    if (self = [super init]) {
        self.databaseFileName = @"StoredBooksInfo.db";
    }
    return self;
}
- (void)dealloc {
    sqlite3_close(self.dbPointer);
}
- (void)startDatabase {
    [self createdDatabaseIfNeeded];
    self.dbPointer = [self openConnection];
    [self createTableIfRequired];
}

- (void)copyDatabaseFileIntoDocumentsDirectoryIfNeeded: (NSString *)destPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    if(![fileManager fileExistsAtPath: destPath]) {
        NSString *sourcePath = [[mainBundle resourcePath]stringByAppendingPathComponent:self.databaseFileName];
        NSError *error;
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        if (error) {
            NSLog(@"error coping sourchPath to destinationPath\n - %@", error.localizedDescription);
        }
        
    } else {
        NSLog(@"Path Already Exists: %@", self.dbPath);
    }
    
}
- (void)createdDatabaseIfNeeded  {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documetDirectory = [paths objectAtIndex:0];
    NSString *destinationPath = [self.documetDirectory stringByAppendingPathComponent:self.databaseFileName];
    if (destinationPath) {
        self.dbPath = destinationPath;
        [self copyDatabaseFileIntoDocumentsDirectoryIfNeeded:destinationPath];
    } else {
        NSLog(@"Error Destination Path Failed to create");
    }
    
}

- (void)createTableIfRequired {
    const char *createTableQuery = "CREATE TABLE IF NOT EXISTS BookInfo (Title TEXT, Subtitle TEXT, Authors TEXT, Category TEXT, Publisher TEXT, PublishedDate TEXT, Description TEXT, PageCount INTEGER,  AverageRating REAL, Language TEXT,  Thumbnail TEXT,InfoLink TEXT, PreviewLink TEXT, Id INTEGER NOT NULL UNIQUE, PRIMARY KEY(Id AUTOINCREMENT));";
    sqlite3_stmt * createTableStatement = [self prepareStatement: createTableQuery];
    if (sqlite3_step(createTableStatement) == SQLITE_DONE) {
        NSLog(@"Created table Success");
    } else {
        NSLog(@"Created table Failed");
    }
    sqlite3_finalize(createTableStatement);
}

- (sqlite3 *)openConnection {
    
    sqlite3 *dbPointer;
    if (sqlite3_open([self.dbPath UTF8String], &dbPointer) == SQLITE_OK) {
        return dbPointer;
        
    } else {
        sqlite3_close(dbPointer);
        NSLog(@"error - Failed to open(sqlite3)");
    }
    return NULL;
}
- (void)closeConnection {
    sqlite3_close(self.dbPointer);
    
}
- (sqlite3_stmt *)prepareStatement: (const char *)sql {
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(self.dbPointer, sql, -1, &statement, NULL) == SQLITE_OK) {
        NSLog(@"prepare success");
        return statement;
    }
    NSLog(@"prepare Failed");
    return nil;
}


- (void)deleteBook:(int)bookId {
    const char *deleteQuery = "DELETE FROM BookInfo WHERE Id = ?;";
    sqlite3_stmt * deleteStatement = [self prepareStatement:deleteQuery];
    if (sqlite3_bind_int(deleteStatement, 1, bookId) == SQLITE_OK) {
        if (sqlite3_step(deleteStatement) == SQLITE_DONE) {
            NSLog(@"delete success");
            
        } else {
            NSLog(@"delete Failed");
        }
    } else {
        NSLog(@"Error bind to delete row");
    }
    sqlite3_finalize(deleteStatement);
}

- (void)insert:(nonnull Book *)book {
    const char *insertQuery = "INSERT INTO BookInfo (Title, Subtitle, Authors, Category, Publisher, PublishedDate, Description, PageCount, AverageRating, Language, Thumbnail ,InfoLink, PreviewLink) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    sqlite3_stmt * insertStatement = [self prepareStatement: insertQuery];
    NSLog(@"book title: %@", book.title);
    
    if (sqlite3_bind_text(insertStatement, 1, [book.title UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 2, [book.subtitle UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 3, [book.author UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 4, [book.category UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 5, [book.publisher UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 6, [book.publishedDate UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 7, [book.descriptionInfo UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 8, [book.pageCount UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 9, [book.averageRating UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 10, [book.language UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 11, [book.thumbnail UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 12, [book.infoLink UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK && sqlite3_bind_text(insertStatement, 13, [book.previewLink UTF8String], -1, SQLITE_TRANSIENT) == SQLITE_OK) {
        
        if (sqlite3_step(insertStatement) == SQLITE_DONE) {
            NSLog(@"insert in bd Success");
        } else {
            NSLog(@"Failed insert to db");
        }
    }
    else {
        NSLog(@"Faided to bind to aqlite");
        
    }
    sqlite3_finalize(insertStatement);
}

- (nonnull NSArray<Book *> *)readBooks {
    const char * readQuery = "SELECT *FROM BookInfo;";
    sqlite3_stmt *readStatement = [self prepareStatement:readQuery];
    NSMutableArray<Book *> *tempBooks = [NSMutableArray new];
    while(sqlite3_step(readStatement) == SQLITE_ROW) {
        char *titleChars = (char *)sqlite3_column_text(readStatement, 0);
        char *subtitleChars = (char *)sqlite3_column_text(readStatement, 1);
        char *authorChars = (char *)sqlite3_column_text(readStatement, 2);
        char *categoryChars = (char *)sqlite3_column_text(readStatement, 3);
        char *publisherChars = (char *)sqlite3_column_text(readStatement, 4);
        char *publishedDateChars = (char *)sqlite3_column_text(readStatement, 5);
        char *descriptionChars = (char *)sqlite3_column_text(readStatement, 6);
        char *pageCountChars = (char *)sqlite3_column_text(readStatement, 7);
        char *avgRatingChars = (char *)sqlite3_column_text(readStatement, 8);
        char *languageChars = (char *)sqlite3_column_text(readStatement, 9);
        char *thumbnailChars = (char *)sqlite3_column_text(readStatement, 10);
        char *infoLinkChars = (char *)sqlite3_column_text(readStatement, 11);
        char *previewLinkChars = (char *)sqlite3_column_text(readStatement, 12);
        int uniqueId = sqlite3_column_int(readStatement, 0);
        
        NSString *title = [[NSString alloc] initWithUTF8String:titleChars];
        NSString *subtitle = [[NSString alloc] initWithUTF8String:subtitleChars];
        NSString *author = [[NSString alloc] initWithUTF8String:authorChars];
        NSString *category = [[NSString alloc] initWithUTF8String:categoryChars];
        NSString *publisher = [[NSString alloc] initWithUTF8String:publisherChars];
        NSString *publishedDate = [[NSString alloc] initWithUTF8String:publishedDateChars];
        NSString *description = [[NSString alloc] initWithUTF8String:descriptionChars];
        NSString *pageCount = [[NSString alloc] initWithUTF8String:pageCountChars];
        NSString *avgRating = [[NSString alloc] initWithUTF8String:avgRatingChars];
        NSString *language = [[NSString alloc] initWithUTF8String:languageChars];
        NSString *thumbnail = [[NSString alloc] initWithUTF8String:thumbnailChars];
        NSString *infoLink = [[NSString alloc] initWithUTF8String:infoLinkChars];
        NSString *previewLink = [[NSString alloc] initWithUTF8String:previewLinkChars];
        
        Book *book = [Book alloc];
        book.title = title;
        book.subtitle = subtitle;
        book.author = author;
        book.category = category;
        book.publisher = publisher;
        book.publishedDate = publishedDate;
        book.descriptionInfo = description;
        book.pageCount = pageCount;
        book.averageRating = avgRating;
        book.language = language;
        book.thumbnail = thumbnail;
        book.infoLink = infoLink;
        book.previewLink = previewLink;
        book.uniqueId = uniqueId;

        [tempBooks addObject:book];

    }
    sqlite3_finalize(readStatement);
    return tempBooks;
}

- (void)updateBook:(nonnull Book *)book bookId: (int)bookId {
}

@end
