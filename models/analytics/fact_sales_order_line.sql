{#
Yêu cầu #0103b:
- Lấy thêm dữ liệu cho bảng này

| Tên gốc         | Tên mới      |
|-----------------|--------------|
| stock_item_id   | product_id   |

#}



SELECT 
  order_line_id AS sales_order_line_id
  , quantity
  , unit_price
  , quantity * unit_price AS gross_amount
FROM `duckdata-320210.wide_world_importers.sales__order_lines`
