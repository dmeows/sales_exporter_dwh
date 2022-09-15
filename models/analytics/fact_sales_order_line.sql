{#
Ở bài trước, mình đã viết query để lấy 3 cột và đặt lại tên. Trong bài này, mình cần phải thêm "derived facts" (số liệu được tính toán).
Yêu cầu #0102:
- Sửa query để có thể tính gross_amount (doanh thu) trên model
#}



SELECT 
  order_line_id AS sales_order_line_id
  , quantity
  , unit_price
FROM `duckdata-320210.wide_world_importers.sales__order_lines`
