-- Завдання:
--      Для кожного курсу знайти мінімальний семестр, в якому він може читатись
--      Очікувані колонки результату:
--          - ідентифікатор курсу (course_id)
--          - назва курсу (name)
--          - мінімальний рік (min_year)
--      Результат відсортувати за:
--          - мінімальним роком (зростання), потім за назвою курсу

-- Рішення:
WITH RECURSIVE prerequisite_for_course as (
    SELECT c.course_id, 1 as min_year
    FROM course c
    	LEFT JOIN course_prerequisite cp on c.course_id = cp.course_id
    WHERE cp.course_id is null

    UNION ALL

    SELECT cp.course_id, pt.min_year + 1
    FROM course_prerequisite cp
    	JOIN prerequisite_for_course pt on cp.prerequisite_course_id = pt.course_id
),

min_semester_for_studing_course as (
    SELECT course_id, max(min_year) as min_year
    FROM prerequisite_for_course
    GROUP BY course_id
)

SELECT c.course_id as "course_id", c.name as "name", msfsc.min_year as "min_year"
FROM course c
	INNER JOIN min_semester_for_studing_course msfsc on c.course_id = msfsc.course_id
ORDER BY msfsc.min_year asc, c.name;