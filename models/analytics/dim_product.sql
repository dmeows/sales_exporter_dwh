{#
Yêu cầu #0103a:
- Xem thông tin và dữ liệu của bảng "warehouse__stock_items"
- Sửa câu query bên dưới để lấy 3 cột và đặt lại tên:

| Tên gốc         | Tên mới      |
|-----------------|--------------|
| stock_item_id   | product_id   |
| stock_item_name | product_name |
| brand           | brand_name   |

#}


SELECT 
  *
FROM `duckdata-320210.wide_world_importers.warehouse__stock_items`
