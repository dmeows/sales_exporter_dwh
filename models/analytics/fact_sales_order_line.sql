{#
Bạn hãy làm theo yêu cầu bên dưới nha 😁
Yêu cầu #0101:
- Xem thông tin và dữ liệu của bảng "sales__order_lines"
- Sửa câu query SQL bên dưới để lấy 3 cột và đặt lại tên:

| Tên gốc       | Tên mới             |
|---------------|---------------------|
| order_line_id | sales_order_line_id |
| quantity      | quantity            |
| unit_price    | unit_price          |

#}


SELECT 
  order_line_id AS sales_order_line_id,
  quantity,
  unit_price
FROM `duckdata-320210.wide_world_importers.sales__order_lines`
