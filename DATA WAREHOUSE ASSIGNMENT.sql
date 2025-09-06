CREATE DATABASE UNIVERSITYDB;

USE UniversityDB;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Major VARCHAR(50)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade CHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Students (StudentID, Name, Age, Major) VALUES
(1, 'Alice', 20, 'Computer Science'),
(2, 'Bob', 22, 'Data Science'),
(3, 'Charlie', 21, 'Computer Science'),
(4, 'Diana', 23, 'Data Science'),
(5, 'Ethan', 19, 'Mathematics'),
(6, 'Fiona', 20, 'Computer Science'),
(7, 'George', 24, 'Data Science'),
(8, 'Hannah', 22, 'Computer Science'),
(9, 'Ian', 21, 'Data Science'),
(10, 'Julia', 23, 'Computer Science'),
(11, 'Kevin', 25, 'Data Science'),
(12, 'Liam', 22, 'Computer Science'),
(13, 'Mona', 24, 'Data Science'),
(14, 'Nate', 17, 'Undeclared'),
(15, 'Olivia', 23, 'Physics');

SELECT * FROM Students;

INSERT INTO Courses (CourseID, CourseName, Credits) VALUES
(101, 'Database Systems', 4),
(102, 'Algorithms', 4),
(103, 'Machine Learning', 3),
(104, 'Web Development', 3);

SELECT * FROM Courses;

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1, 1, 101, 'A'),
(2, 2, 103, 'B'),
(3, 3, 102, 'A'),
(4, 4, 103, 'C'),
(5, 1, 102, 'B'),
(6, 6, 101, 'A-'),
(7, 7, 103, 'B+'),
(8, 8, 102, 'C+'),
(9, 9, 103, 'A'),
(10, 2, 101, 'B');

SELECT * FROM Enrollments;

-- ====================================================================
-- Executing All Provided Queries
-- ====================================================================

-- Question: How do you define a temporary table for departments?
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

-- Question: How can you add a new 'Email' column to the Students table?
ALTER TABLE Students ADD Email VARCHAR(100);

SELECT * FROM Students;

-- Question: How do you completely remove the Departments table?
DROP TABLE Departments;

-- Question: How do you add a rule to ensure students are at least 17?
ALTER TABLE Students ADD CONSTRAINT AgeCheck CHECK (Age >= 17);


-- Question: How do you remove the age-checking rule?
ALTER TABLE Students DROP CONSTRAINT AgeCheck;

-- Question: How do you update the major for student with ID 1 to 'Data Science'?
UPDATE Students SET Major = 'Data Science' WHERE StudentID = 1;

SELECT * FROM Students;

-- Question: How do you remove all student records for students younger than 18?
DELETE FROM Students WHERE Age < 18;

SELECT * FROM Students;

-- Question: Show the name and major of all students who are older than 19.
SELECT Name, Major FROM Students WHERE Age > 19;

-- Question: What is the average age of all students?
SELECT AVG(Age) AS AvgAge FROM Students;

-- Question: Which majors have more than 5 students, and what is the count for each?
SELECT Major, COUNT(*) AS StudentCount
FROM Students
GROUP BY Major
HAVING COUNT(*) > 5;

-- Question: List all information for students older than 20 and in 'Computer Science'.
SELECT * FROM Students WHERE Age > 20 AND Major = 'Computer Science';

-- Question: How can you rank students based on their grades?
SELECT s.Name, e.Grade,
RANK() OVER (ORDER BY Grade ASC) AS RankInClass
FROM Enrollments e JOIN Students s ON e.StudentID = s.StudentID;


-- Question: List student names and the courses they are enrolled in.
SELECT s.Name, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- Question: Show all students and their courses, including students not enrolled in any course.
SELECT s.Name, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- Question: Generate every possible combination of a student paired with a course.
SELECT s.Name, c.CourseName
FROM Students s CROSS JOIN Courses c;

-- Question: Find pairs of different students who are in the same major.
SELECT s1.Name AS Student1, s2.Name AS Student2
FROM Students s1
JOIN Students s2 ON s1.Major = s2.Major AND s1.StudentID <> s2.StudentID;

-- Question: For each major, provide a comma-separated list of student names.
SELECT Major, STRING_AGG(Name, ', ') AS Students
FROM Students
GROUP BY Major;

-- Question: Find students who are older than the average student age.
SELECT Name FROM Students
WHERE Age > (SELECT AVG(Age) FROM Students);

-- Question: Get the names of students who have received a grade 'A' in any course.
SELECT Name FROM Students s
WHERE EXISTS (
    SELECT 1 FROM Enrollments e
    WHERE e.StudentID = s.StudentID AND e.Grade = 'A'
);

-- Question: Display each major and its calculated average age.
SELECT Major, AvgAge
FROM (SELECT Major, AVG(Age) AS AvgAge FROM Students GROUP BY Major) AS t;

-- Question: Create a single list of all student names and course names.
SELECT Name FROM Students
UNION
SELECT CourseName FROM Courses;

-- Question: Find student IDs present in both Students and Enrollments tables.
SELECT StudentID FROM Students
INTERSECT
SELECT StudentID FROM Enrollments;

-- Question: Find students registered but not enrolled in any course.
SELECT Name FROM Students
WHERE StudentID IN (
    SELECT StudentID FROM Students
    EXCEPT
    SELECT StudentID FROM Enrollments
);

-- Question: How to perform several changes as a single atomic operation?
BEGIN TRANSACTION;
INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES (16, 1, 104, 'A');
UPDATE Students SET Major = 'AI' WHERE StudentID = 1;
COMMIT TRANSACTION;

-- Question: How do you create an index to speed up searches on the Major column?
CREATE INDEX idx_student_major ON Students(Major);

-- Question: How can you check if the index is used?
SELECT * FROM Students WHERE Major = 'Data Science';

-- Question: How do you remove the index?
DROP INDEX idx_student_major ON Students;


-- Question: List all students, sorted by age in descending order.
SELECT Name, Age
FROM Students
ORDER BY Age DESC;

-- Question: List students, sorted first by age (descending), then by name (ascending).
SELECT Name, Age
FROM Students
ORDER BY Age DESC, Name ASC;

-- Question: Show the top 5 oldest students.
SELECT TOP 5 Name, Age
FROM Students
ORDER BY Age DESC;

-- Question: Using a CTE, find students who are older than the average age.
WITH AvgAgeCTE AS (
    SELECT AVG(Age) AS AgeValue FROM Students
)
SELECT Name, Age
FROM Students, AvgAgeCTE
WHERE Students.Age > AvgAgeCTE.AgeValue;