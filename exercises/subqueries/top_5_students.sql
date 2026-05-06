-- Завдання:
--      Знайти топ-5 студентів у кожному курсі за отриманими балами
--      Очікувані колонки результату:
--          - назва курсу (course_name)
--          - ідентифікатор студента (student_id)
--          - повне ім'я студента (student_full_name)
--          - бал (grade)
--          - ранг (rank)
--      Результат відсортувати за:
--          - назвою курсу, потім за рангом (зростання), потім за іменем студента

-- Рішення:
WITH ranks_of_students as (
    SELECT c.name as course_name, e.student_id, p.first_name || ' ' || p.last_name as student_full_name,
        e.grade, ROW_NUMBER() over (PARTITION BY c.course_id ORDER BY e.grade desc, p.first_name || ' ' || p.last_name) as student_rank
    FROM enrolment e
    	JOIN course c on e.course_id = c.course_id
    	JOIN student s on e.student_id = s.student_id
    	JOIN person p on s.person_id = p.person_id
    WHERE e.grade is not null
)

SELECT course_name as "course_name", student_id as "student_id",
       student_full_name as "student_full_name", grade as "grade", student_rank as "rank"
FROM ranks_of_students ros
WHERE ros.student_rank <= 5
ORDER BY course_name, rank asc, student_full_name;