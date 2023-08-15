--Populate f_food_items table
INSERT INTO f_food_items(food_item_number,description,price,regular_code,promo_code)
VALUES(60,'Cake',130.09,'20',NULL);
INSERT INTO f_food_items(food_item_number,description,price,regular_code,promo_code)
VALUES(65,'Icream Cake',253.59,NULL,'110');
--Populate f_orders table
INSERT INTO f_orders(order_number,order_date,order_total,cust_id,staff_id)
VALUES(5800,TO_DATE('12-10-2022','mm-dd-yyyy'),383.68,123,12);
--Populate f_order_lines table
INSERT INTO f_order_lines(order_number,food_item_number,quantity)
VALUES(5800,60,1);
INSERT INTO f_order_lines(order_number,food_item_number,quantity)
VALUES(5800,65,1);
