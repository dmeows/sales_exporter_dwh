{# 
Tương tự các bảng dimension khác, cột date cũng sẽ cần có 1 bảng dimension để lưu các thông tin về ngày/tháng/năm, ví dự như: thứ mấy trong ngày dạng chữ, tháng dạng chữ, trong tuần hay cuối tuần, ngày lễ, năm tài chính.
Tuy nhiên, bảng "dim_date" là một bảng đặc biệt, vì mình sẽ dùng code để tạo ra chứ không xử lý từ data thô.

Yêu cầu #0111a:
- Viết câu query để sinh ra bảng "dim_date" trong khoảng 2010-01-01 đến 2030-12-31
- Cần có các cột sau:

| Tên cột               | Ví dụ             | Giải thích                       |
|-----------------------|-------------------|----------------------------------|
| date                  | 2022-02-15        | Loại dữ liệu là DATE             |
| day_of_week           | Monday, Tuesday   |                                  |
| day_of_week_short     | Mon, Tue          |                                  |
| is_weekday_or_weekend | Weekday, Weekend  |                                  |
| year_month            | 2022-02-01        | Đưa về đầu tháng (date truncate) |
| month                 | January, February |                                  |
| year                  | 2022-01-01        | Đưa về đầu năm (date truncate)   |
| year_number           | 2022              |                                  |

#}


WITH dim_date__generate_date_array AS (
  SELECT 
    date
  FROM UNNEST(GENERATE_DATE_ARRAY('2010-01-01', '2030-12-31', INTERVAL 1 DAY)) AS date
)

, dim_date__enrich_from_date AS (
  SELECT 
    *
    , FORMAT_DATE('%A', date) AS day_of_week
    , FORMAT_DATE('%a', date) AS day_of_week_short
    , DATE_TRUNC(date, MONTH) AS year_month
    , FORMAT_DATE('%B', date) AS month
    , DATE_TRUNC(date, YEAR) AS year
    , EXTRACT(YEAR FROM date) AS year_number
  FROM dim_date__generate_date_array
)

, dim_date__enrich AS (
  SELECT 
    *
    , CASE
      WHEN day_of_week_short IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN 'Weekday'
      WHEN day_of_week_short IN ('Sat', 'Sun') THEN 'Weekend'
      ELSE 'Undefined' END
      AS is_weekday_or_weekend
  FROM dim_date__enrich_from_date
)

SELECT 
  date 
  , day_of_week
  , day_of_week_short
  , is_weekday_or_weekend
  , year_month
  , month
  , year
  , year_number
FROM dim_date__enrich
