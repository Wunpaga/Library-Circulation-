PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Fine;
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Request;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Worker;
DROP TABLE IF EXISTS LibraryCard;
DROP TABLE IF EXISTS Library;

CREATE TABLE Library (
    LibraryID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Address TEXT,
    Phone TEXT
);

CREATE TABLE LibraryCard (
    LibraryCardID INTEGER PRIMARY KEY,
    CardHolderName TEXT NOT NULL,
    IssueDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    Address TEXT,
    Email TEXT UNIQUE,
    PhoneNumber TEXT,
    CHECK (ExpiryDate > IssueDate)
);

CREATE TABLE Worker (
    WorkerID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Address TEXT,
    Email TEXT UNIQUE,
    PhoneNumber TEXT
);

CREATE TABLE Book (
    BookID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Genres TEXT,
    Editor TEXT,
    Format TEXT,
    Available INTEGER NOT NULL CHECK (Available IN (0,1)),
    ISBN TEXT UNIQUE,
    DDC TEXT UNIQUE,
    LC TEXT UNIQUE,
    Floor TEXT,
    Author TEXT,
    Publisher TEXT,
    PublishedDate DATE,
    Edition TEXT,
    InterlibraryLoan INTEGER NOT NULL CHECK (InterlibraryLoan IN (0,1)),
    DatePurchased DATE,
    LendingStatus TEXT
);

CREATE TABLE Request (
    RequestID INTEGER PRIMARY KEY,
    LibraryCardID INTEGER NOT NULL,
    BookID INTEGER NOT NULL,
    RequestDate DATE NOT NULL,
    Status TEXT NOT NULL,
    FOREIGN KEY (LibraryCardID) REFERENCES LibraryCard(LibraryCardID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

CREATE TABLE Loan (
    LoanID INTEGER PRIMARY KEY,
    BookID INTEGER NOT NULL,
    LibraryCardID INTEGER NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    LoanType TEXT NOT NULL,
    FromLibraryID INTEGER,
    ToLibraryID INTEGER,
    RequestID INTEGER,
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (LibraryCardID) REFERENCES LibraryCard(LibraryCardID),
    FOREIGN KEY (FromLibraryID) REFERENCES Library(LibraryID),
    FOREIGN KEY (ToLibraryID) REFERENCES Library(LibraryID),
    FOREIGN KEY (RequestID) REFERENCES Request(RequestID),
    CHECK (DueDate >= LoanDate),
    CHECK (ReturnDate IS NULL OR ReturnDate >= LoanDate)
);

CREATE TABLE Fine (
    FineID INTEGER PRIMARY KEY,
    LoanID INTEGER NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    PaidStatus INTEGER NOT NULL CHECK (PaidStatus IN (0,1)),
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
);
