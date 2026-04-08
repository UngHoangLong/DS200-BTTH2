/* SCRIPT TIỀN XỬ LÝ: LỌC RÁC DATA GỐC */

-- 1. Đọc dữ liệu gốc
raw_data = LOAD 'hotel-review.csv' USING PigStorage(';') AS (id:int, comment:chararray, category:chararray, aspect:chararray, polarity:chararray);

-- 2. Lọc bỏ các dòng bị khuyết bình luận (chỉ giữ lại dòng có chứa chữ cái hoặc số)
clean_data = FILTER raw_data BY comment MATCHES '.*[a-zA-Z0-9]+.*';

-- 3. Xuất dữ liệu sạch ra một thư mục mới (giữ nguyên cấu trúc 5 cột và dấu chấm phẩy)
STORE clean_data INTO 'clean_hotel_review' USING PigStorage(';');