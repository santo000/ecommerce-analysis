SELECT
  cohort_year,
  cohort_week,
  EXTRACT(week
  FROM
    Data_dodania_zam__wienia)-cohort_week AS weeks_after_join,
  cohort_size,
  COUNT(DISTINCT Imi___i_nazwisko) AS people_left
FROM (
  SELECT
    a.*,
    b.cohort_size
  FROM (
    SELECT
      Imi___i_nazwisko,
      ID_klienta,
      Data_dodania_zam__wienia,
      Od,
      DO,
      Kwota,
      Dni_dostaw,
      EXTRACT (year
      FROM
        MIN(Data_dodania_zam__wienia) OVER (PARTITION BY Imi___i_nazwisko)) AS cohort_year,
      EXTRACT (week
      FROM
        MIN(Data_dodania_zam__wienia) OVER (PARTITION BY Imi___i_nazwisko)) AS cohort_week
    FROM
      `strange-calling-215618.charlie.charlie_cleaned` ) a
  JOIN (
    SELECT
      EXTRACT(year
      FROM
        first_order_date) AS cohort_year,
      EXTRACT(week
      FROM
        first_order_date) AS cohort_week,
      COUNT(first_imie) AS cohort_size
    FROM
      `strange-calling-215618.charlie.charlie_first_orders`
    GROUP BY
      1,
      2 ) b
  ON
    a.cohort_week = b.cohort_week
    AND a.cohort_year = b.cohort_year )
GROUP BY
  1,
  2,
  3,
  4
ORDER BY
  2 DESC