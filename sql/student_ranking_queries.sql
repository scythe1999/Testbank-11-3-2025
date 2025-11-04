-- MySQL queries to compute ranking information for assessment and TOS exam results.
-- Replace :exam_id with the target exam identifier before running the query.

-- Assessment ranking: recompute rank positions directly from stored scores.
SELECT
    ssa.exam_id,
    ssa.studentid,
    ssa.firstname,
    ssa.lastname,
    ssa.period,
    ssa.score,
    COALESCE(
        ssa.rank_position,
        DENSE_RANK() OVER (PARTITION BY ssa.exam_id ORDER BY ssa.score DESC, ssa.studentid ASC)
    ) AS computed_rank
FROM criminology_studentsscoreassessment AS ssa
WHERE ssa.exam_id = :exam_id
ORDER BY computed_rank, ssa.studentid;

-- TOS ranking: recompute rank positions directly from stored scores.
SELECT
    sst.exam_id,
    sst.studentid,
    sst.firstname,
    sst.lastname,
    sst.period,
    sst.score,
    COALESCE(
        sst.rank_position,
        DENSE_RANK() OVER (PARTITION BY sst.exam_id ORDER BY sst.score DESC, sst.studentid ASC)
    ) AS computed_rank
FROM criminology_studentsscoretos AS sst
WHERE sst.exam_id = :exam_id
ORDER BY computed_rank, sst.studentid;

-- To persist the computed ranking back into the tables, run the UPDATE below.
-- This will synchronize the stored rank_position with the dense rank ordering.
UPDATE criminology_studentsscoreassessment AS ssa
JOIN (
    SELECT
        id,
        DENSE_RANK() OVER (PARTITION BY exam_id ORDER BY score DESC, studentid ASC) AS computed_rank
    FROM criminology_studentsscoreassessment
    WHERE exam_id = :exam_id
) ranked ON ranked.id = ssa.id
SET ssa.rank_position = ranked.computed_rank
WHERE ssa.exam_id = :exam_id;

UPDATE criminology_studentsscoretos AS sst
JOIN (
    SELECT
        id,
        DENSE_RANK() OVER (PARTITION BY exam_id ORDER BY score DESC, studentid ASC) AS computed_rank
    FROM criminology_studentsscoretos
    WHERE exam_id = :exam_id
) ranked ON ranked.id = sst.id
SET sst.rank_position = ranked.computed_rank
WHERE sst.exam_id = :exam_id;
