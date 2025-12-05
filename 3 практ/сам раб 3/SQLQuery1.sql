USE master;
GO

IF DB_ID('EdusphereDB') IS NOT NULL
BEGIN
    ALTER DATABASE EdusphereDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EdusphereDB;
END
GO

CREATE DATABASE EdusphereDB;
GO

ALTER DATABASE EdusphereDB SET READ_COMMITTED_SNAPSHOT ON;
GO

USE EdusphereDB;
GO

-- 1. Users
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active', 'Blocked'))
);
GO

-- 2. Roles
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE CHECK (RoleName IN ('Student', 'Instructor', 'Admin'))
);
GO

-- 3. UserRoles
CREATE TABLE UserRoles (
    UserID INT NOT NULL,
    RoleID INT NOT NULL,
    PRIMARY KEY (UserID, RoleID),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) ON DELETE CASCADE
);
GO

-- 4. Instructors
CREATE TABLE Instructors (
    InstructorID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    Bio NVARCHAR(500),
    ExperienceYears INT NOT NULL CHECK (ExperienceYears >= 0),
    CONSTRAINT FK_Instructors_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- 5. Students
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    BirthDate DATE,
    City NVARCHAR(100),
    CONSTRAINT FK_Students_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- 6. Courses
CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    InstructorID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Language NVARCHAR(50) NOT NULL,
    Level NVARCHAR(20) NOT NULL CHECK (Level IN ('Beginner', 'Intermediate', 'Advanced')),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Draft' CHECK (Status IN ('Draft', 'Published', 'Archived')),
    CONSTRAINT FK_Courses_Instructors FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID) ON DELETE NO ACTION
);
GO

-- 7. CourseCategories
CREATE TABLE CourseCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500)
);
GO

-- 8. CourseCategoryMap
CREATE TABLE CourseCategoryMap (
    CourseID INT NOT NULL,
    CategoryID INT NOT NULL,
    PRIMARY KEY (CourseID, CategoryID),
    CONSTRAINT FK_CCM_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    CONSTRAINT FK_CCM_Categories FOREIGN KEY (CategoryID) REFERENCES CourseCategories(CategoryID) ON DELETE CASCADE
);
GO

-- 9. Lessons
CREATE TABLE Lessons (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    OrderNo INT NOT NULL CHECK (OrderNo > 0),
    DurationMinutes INT NOT NULL CHECK (DurationMinutes > 0),
    CONSTRAINT FK_Lessons_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    CONSTRAINT UQ_Course_LessonOrder UNIQUE (CourseID, OrderNo)
);
GO

-- 10. Assignments
CREATE TABLE Assignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    LessonID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    MaxScore INT NOT NULL CHECK (MaxScore > 0),
    DeadlineAt DATETIME2,
    CONSTRAINT FK_Assignments_Lessons FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID) ON DELETE CASCADE
);
GO

-- 11. Enrollments
CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    State NVARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (State IN ('Requested', 'Active', 'Completed', 'Canceled')),
    CONSTRAINT FK_Enrollments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE NO ACTION,
    CONSTRAINT FK_Enrollments_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE NO ACTION,
    CONSTRAINT UQ_Student_Course UNIQUE (StudentID, CourseID)
);
GO

-- 12. Submissions
CREATE TABLE Submissions (
    SubmissionID INT IDENTITY(1,1) PRIMARY KEY,
    AssignmentID INT NOT NULL,
    StudentID INT NOT NULL,
    SubmittedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ContentURI NVARCHAR(500) NOT NULL,
    CONSTRAINT FK_Submissions_Assignments FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID) ON DELETE CASCADE,
    CONSTRAINT FK_Submissions_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE NO ACTION,
    CONSTRAINT UQ_Assignment_Student UNIQUE (AssignmentID, StudentID)
);
GO

-- 13. Grades
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    SubmissionID INT NOT NULL UNIQUE,
    Score INT NOT NULL CHECK (Score >= 0),
    GradedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    GradedByInstructorID INT NOT NULL,
    CONSTRAINT FK_Grades_Submissions FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID) ON DELETE CASCADE,
    CONSTRAINT FK_Grades_Instructors FOREIGN KEY (GradedByInstructorID) REFERENCES Instructors(InstructorID) ON DELETE NO ACTION
);
GO

-- 14. Reviews
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    CourseID INT NOT NULL,
    StudentID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(1000),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Reviews_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    CONSTRAINT FK_Reviews_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE NO ACTION,
    CONSTRAINT UQ_Course_Student_Review UNIQUE (CourseID, StudentID)
);
GO

-- 15. Certificates
CREATE TABLE Certificates (
    CertificateID INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID INT NOT NULL UNIQUE,
    CertificateCode NVARCHAR(50) NOT NULL UNIQUE,
    IssuedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Certificates_Enrollments FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID) ON DELETE NO ACTION
);
GO

-- 16. Payments
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    Currency NVARCHAR(3) NOT NULL DEFAULT 'RUB',
    PaidAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Provider NVARCHAR(100),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Succeeded', 'Failed')),
    CONSTRAINT FK_Payments_Enrollments FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID) ON DELETE NO ACTION
);
GO

-- Заполнение данными В ПРАВИЛЬНОМ ПОРЯДКЕ
-- Сначала создаем роли
INSERT INTO Roles (RoleName) VALUES ('Student'), ('Instructor'), ('Admin');

-- Затем пользователей
INSERT INTO Users (FullName, Email, Phone, PasswordHash)
VALUES
(N'Иванов И.И.', 'ivanov@example.com', '+79001112233', 'hash1'),
(N'Петрова М.М.', 'petrova@example.com', '+79012223344', 'hash2');

-- Назначаем роли
INSERT INTO UserRoles (UserID, RoleID) VALUES (1,2), (2,1); -- Иванов - инструктор, Петрова - студент

-- Создаем преподавателя и студента
INSERT INTO Instructors (UserID, Bio, ExperienceYears) VALUES (1, N'Преподаватель Python', 5);
INSERT INTO Students (UserID, BirthDate, City) VALUES (2, '2000-05-10', N'Москва');

-- Создаем курс
INSERT INTO Courses (InstructorID, Title, Language, Level, Price, Status)
VALUES (1, N'Python с нуля', 'Python', 'Beginner', 5999.00, 'Published');

-- Создаем категорию
INSERT INTO CourseCategories (CategoryName, Description)
VALUES (N'Программирование', N'Языки и алгоритмы');

-- Связываем курс и категорию
INSERT INTO CourseCategoryMap (CourseID, CategoryID) VALUES (1,1);

-- Создаем урок
INSERT INTO Lessons (CourseID, Title, OrderNo, DurationMinutes)
VALUES (1, N'Основы Python', 1, 15);

-- Создаем задание
INSERT INTO Assignments (LessonID, Title, MaxScore, DeadlineAt)
VALUES (1, N'Hello World', 10, DATEADD(DAY, 7, GETDATE()));

-- Создаем зачисление
INSERT INTO Enrollments (StudentID, CourseID, State)
VALUES (1, 1, 'Active'); -- Студент №1 (Петрова) зачислена на курс

-- Создаем решение
INSERT INTO Submissions (AssignmentID, StudentID, ContentURI)
VALUES (1, 1, N'http://example.com/submission1'); -- Решение от студента №1 по заданию №1

-- Создаем оценку
INSERT INTO Grades (SubmissionID, Score, GradedByInstructorID)
VALUES (1, 8, 1); -- Оценка 8 от преподавателя №1

-- Создаем отзыв
INSERT INTO Reviews (CourseID, StudentID, Rating, ReviewText)
VALUES (1, 1, 5, N'Отличный курс!');

-- Создаем сертификат
INSERT INTO Certificates (EnrollmentID, CertificateCode)
VALUES (1, N'CERT-001');

-- Создаем платеж
INSERT INTO Payments (EnrollmentID, Amount, Status)
VALUES (1, 5999.00, 'Succeeded');

-- Проверка 1: Вывести по одной строке из каждой таблицы с номером и именем
SELECT 1 AS Num, 'Users' AS TableName, UserID, FullName, Email FROM Users ORDER BY UserID;
SELECT 2 AS Num, 'Roles' AS TableName, RoleID, RoleName FROM Roles ORDER BY RoleID;
SELECT 3 AS Num, 'UserRoles' AS TableName, UserID, RoleID FROM UserRoles ORDER BY UserID;
SELECT 4 AS Num, 'Instructors' AS TableName, InstructorID, UserID, Bio FROM Instructors ORDER BY InstructorID;
SELECT 5 AS Num, 'Students' AS TableName, StudentID, UserID, City FROM Students ORDER BY StudentID;
SELECT 6 AS Num, 'Courses' AS TableName, CourseID, Title, Language FROM Courses ORDER BY CourseID;
SELECT 7 AS Num, 'CourseCategories' AS TableName, CategoryID, CategoryName FROM CourseCategories ORDER BY CategoryID;
SELECT 8 AS Num, 'CourseCategoryMap' AS TableName, CourseID, CategoryID FROM CourseCategoryMap ORDER BY CourseID;
SELECT 9 AS Num, 'Lessons' AS TableName, LessonID, Title, DurationMinutes FROM Lessons ORDER BY LessonID;
SELECT 10 AS Num, 'Assignments' AS TableName, AssignmentID, Title, MaxScore FROM Assignments ORDER BY AssignmentID;
SELECT 11 AS Num, 'Enrollments' AS TableName, EnrollmentID, StudentID, CourseID, State FROM Enrollments ORDER BY EnrollmentID;
SELECT 12 AS Num, 'Submissions' AS TableName, SubmissionID, AssignmentID, StudentID, ContentURI FROM Submissions ORDER BY SubmissionID;
SELECT 13 AS Num, 'Grades' AS TableName, GradeID, SubmissionID, Score FROM Grades ORDER BY GradeID;
SELECT 14 AS Num, 'Reviews' AS TableName, ReviewID, CourseID, StudentID, Rating FROM Reviews ORDER BY ReviewID;
SELECT 15 AS Num, 'Certificates' AS TableName, CertificateID, EnrollmentID, CertificateCode FROM Certificates ORDER BY CertificateID;
SELECT 16 AS Num, 'Payments' AS TableName, PaymentID, EnrollmentID, Amount, Status FROM Payments ORDER BY PaymentID;

-- Проверка 2: Считать и явно показать количество
SELECT 'Таблиц создано:' AS Info, COUNT(*) AS Count
FROM sys.tables
WHERE name IN (
    'Users','Roles','UserRoles','Instructors','Students','Courses',
    'CourseCategories','CourseCategoryMap','Lessons','Assignments','Enrollments',
    'Submissions','Grades','Reviews','Certificates','Payments'
);
GO