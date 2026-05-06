-- Завдання:
--      Знайти студентів, чий середній бал перевищує середній бал їхньої групи
--      Використати два CTE: один для середнього балу студента, інший для середнього балу групи
--      Очікувані колонки результату:
--          - ідентифікатор студента (student_id)
--          - повне ім'я студента (full_name)
--          - назва групи (group_name)
--          - середній бал студента (avg_student_grade) - округлити результат до 2 знаків після коми
--          - середній бал групи (avg_group_grade) - округлити результат до 2 знаків після коми
--      Результат відсортувати за:
--          - назвою групи, потім за середнім балом студента (спадання), потім за іменем студента

-- Рішення:
WITH students_avg_score as (
    SELECT student_id, avg(grade) as raw_avg
    FROM enrolment e
    GROUP BY e.student_id
),
groups_avg_score AS (
    SELECT s.group_id, avg(e.grade) as raw_group_avg
    FROM student s
        JOIN enrolment e on s.student_id = e.student_id
    GROUP BY s.group_id
)
SELECT 
    s.student_id as "student_id", 
    p.first_name || ' ' || p.last_name as "full_name", 
    sg.name as "group_name",
    ROUND(sa.raw_avg, 2) as "avg_student_grade", 
    ROUND(ga.raw_group_avg, 2) as "avg_group_grade"
FROM student s
    JOIN person p on s.person_id = p.person_id
    JOIN student_group sg on s.group_id = sg.group_id
    JOIN students_avg_score sa on s.student_id = sa.student_id
    JOIN groups_avg_score ga on s.group_id = ga.group_id
WHERE ROUND(sa.raw_avg, 2) > ROUND(ga.raw_group_avg, 2)
ORDER BY sg.name, sa.raw_avg desc, p.first_name || ' ' || p.last_name;