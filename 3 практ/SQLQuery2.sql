USE UniversityDB;
GO
INSERT INTO Students (FullName, Email, BirthDate, GroupName)
VALUES
(N'Иванов Алексей', 'ivanov.a@example.com', '2003-05-12', N'ИС-1'),
(N'Петрова Мария', 'petrova.m@example.com', '2004-02-18', N'ИС-1'),
(N'Сидоров Дмитрий', 'sidorov.d@example.com', '2003-11-30', N'ИС-2'),
(N'Кузнецова Анна', 'kuznetsova.a@example.com', '2004-07-22', N'ИС-2'),
(N'Смирнов Сергей', 'smirnov.s@example.com', '2003-09-05', N'ИС-1');
SELECT * FROM Students;
GO
INSERT INTO Courses (Title, Hours, IsActive)
VALUES
(N'Основы программирования', 72, 1),
(N'Базы данных', 54, 1),
(N'Веб-разработка', 90, 1),
(N'Математический анализ', 108, 0);
SELECT * FROM Courses;
GO
INSERT INTO Enrollments (StudentID, CourseID, EnrollDate)
VALUES
(1, 1, '2024-09-01'),
(1, 2, '2024-09-01'),
(2, 1, '2024-09-02'),
(3, 3, '2024-09-03'),
(4, 1, '2024-09-04'),
(4, 3, '2024-09-04'),
(5, 2, '2024-09-05');
SELECT * FROM Enrollments;
GO