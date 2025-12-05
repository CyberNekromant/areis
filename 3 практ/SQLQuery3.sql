USE UniversityDB;
GO
-- 1. Все студенты + курсы
SELECT 
    s.FullName,
    s.GroupName,
    c.Title AS CourseTitle,
    c.Hours,
    e.EnrollDate
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID
ORDER BY s.FullName, c.Title;
GO
-- 2. Сколько студентов на каждом активном курсе
SELECT 
    c.Title,
    COUNT(e.StudentID) AS StudentsCount
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
WHERE c.IsActive = 1
GROUP BY c.CourseID, c.Title
ORDER BY StudentsCount DESC;
GO
-- 3. Студенты без записей
SELECT 
    s.StudentID,
    s.FullName,
    s.GroupName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.EnrollmentID IS NULL;
GO
-- 4. Структура FK 
SELECT 
    name AS FK_Name,
    OBJECT_NAME(parent_object_id) AS TableFrom,
    OBJECT_NAME(referenced_object_id) AS TableTo
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('Enrollments');
GO