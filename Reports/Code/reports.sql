-- #1 Most Requested Author
SELECT 
    b.Author, 
    COUNT(r.RequestID) AS TotalRequests
FROM Request r
JOIN Book b ON r.BookID = b.BookID
GROUP BY b.Author
ORDER BY TotalRequests DESC
LIMIT 3;


-- #2 Most Borrowed Book
SELECT 
    b.Name AS BookName,
    COUNT(l.LoanID) AS TotalLoans
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
GROUP BY b.BookID
ORDER BY TotalLoans DESC
LIMIT 3;


-- #3 Library with the Most Loans
SELECT 
    lib.Name AS LibraryName,
    COUNT(l.LoanID) AS TotalLoans
FROM Loan l
JOIN Library lib ON l.FromLibraryID = lib.LibraryID
GROUP BY lib.LibraryID
ORDER BY TotalLoans DESC
LIMIT 1;


-- #4 Percentage of Loans Returned Late
SELECT 
    ROUND(100.0 * SUM(CASE WHEN ReturnDate > DueDate THEN 1 ELSE 0 END) / COUNT(*), 2) AS LateReturnPercentage
FROM Loan
WHERE ReturnDate IS NOT NULL;


-- #5 Active vs Returned Loans
SELECT 
    SUM(CASE WHEN ReturnDate IS NULL THEN 1 ELSE 0 END) AS ActiveLoans,
    SUM(CASE WHEN ReturnDate IS NOT NULL THEN 1 ELSE 0 END) AS ReturnedLoans
FROM Loan;


-- #6 Number of Books in Interlibrary Loan
SELECT 
    COUNT(*) AS InterlibraryBooks
FROM Book
WHERE InterlibraryLoan = 1;


-- #7 Average Fine Amount
SELECT 
    ROUND(AVG(Amount), 2) AS AverageFine
FROM Fine;


-- #8️ Publisher with the Most Borrows
SELECT 
    b.Publisher,
    COUNT(l.LoanID) AS TotalLoans
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
GROUP BY b.Publisher
ORDER BY TotalLoans DESC
LIMIT 5;

-- #9 Top Book Publishers
SELECT 
    b.Publisher,
    COUNT(l.LoanID) AS TotalLoans
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
GROUP BY b.Publisher
ORDER BY TotalLoans DESC
LIMIT 5;


-- #10 Books Never Borrowed
SELECT 
    b.BookID,
    b.Name AS BookName
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
WHERE l.LoanID IS NULL;


-- #11 People with Outstanding Fines
SELECT 
    lc.CardHolderName,
    SUM(f.Amount) AS TotalOutstanding
FROM Fine f
JOIN Loan l ON f.LoanID = l.LoanID
JOIN LibraryCard lc ON l.LibraryCardID = lc.LibraryCardID
WHERE f.PaidStatus = 0
GROUP BY lc.LibraryCardID;


-- #12 Average Loan Duration (in days)
SELECT 
    ROUND(AVG(
        JULIANDAY(COALESCE(ReturnDate, DATE('now'))) - JULIANDAY(LoanDate)
    ), 2) AS Average_Loan_Duration_in_days
FROM Loan;


-- #13 Most Active Library Based on Loans
SELECT 
    lib.Name AS LibraryName,
    COUNT(l.LoanID) AS TotalActivity
FROM Loan l
JOIN Library lib 
    ON lib.LibraryID = l.FromLibraryID 
    OR lib.LibraryID = l.ToLibraryID
GROUP BY lib.LibraryID
ORDER BY TotalActivity DESC
LIMIT 1;


-- #14 Most Popular Genre
SELECT 
    b.Genres,
    COUNT(l.LoanID) AS TotalLoans
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
GROUP BY b.Genres
ORDER BY TotalLoans DESC
LIMIT 1;


-- #15 Most Popular Book Format
SELECT 
    b.Format,
    COUNT(l.LoanID) AS TotalLoans
FROM Loan l
JOIN Book b ON l.BookID = b.BookID
GROUP BY b.Format
ORDER BY TotalLoans DESC
LIMIT 1;

