/* BÀI 5: TOP 5 TỪ LIÊN QUAN (TÍCH CỰC & TIÊU CỰC) THEO TỪNG ASPECT */

-- 1. Đọc dữ liệu từ kết quả Bài 1 (file đã tách từ)
data_bai1 = LOAD 'ketqua_bai1' USING PigStorage(';') AS (id:int, category:chararray, aspect:chararray, polarity:chararray, word:chararray);

-- 2. Làm sạch polarity (xóa \r, \n) để so sánh chính xác
clean_data = FOREACH data_bai1 GENERATE aspect, word, REPLACE(LOWER(polarity), '[^a-z]', '') AS polarity;

-- ========================================================
-- PHẦN 1: 5 TỪ LIÊN QUAN NHẤT KHI KHÁCH KHEN (POSITIVE)
-- ========================================================
pos_data = FILTER clean_data BY polarity == 'positive';
group_pos = GROUP pos_data BY (aspect, word);
count_pos = FOREACH group_pos GENERATE FLATTEN(group) AS (aspect, word), COUNT(pos_data) AS total;

-- Gom theo Aspect để chọn ra Top 5 từ có total cao nhất
group_pos_by_aspect = GROUP count_pos BY aspect;
top_5_pos_aspect = FOREACH group_pos_by_aspect {
    result = TOP(5, 2, count_pos); -- Lấy top 5 dựa trên cột total
    GENERATE FLATTEN(result);
};

-- ========================================================
-- PHẦN 2: 5 TỪ LIÊN QUAN NHẤT KHI KHÁCH CHÊ (NEGATIVE)
-- ========================================================
neg_data = FILTER clean_data BY polarity == 'negative';
group_neg = GROUP neg_data BY (aspect, word);
count_neg = FOREACH group_neg GENERATE FLATTEN(group) AS (aspect, word), COUNT(neg_data) AS total;

-- Gom theo Aspect để chọn ra Top 5 từ có total cao nhất
group_neg_by_aspect = GROUP count_neg BY aspect;
top_5_neg_aspect = FOREACH group_neg_by_aspect {
    result = TOP(5, 2, count_neg);
    GENERATE FLATTEN(result);
};

-- ========================================================
-- LƯU KẾT QUẢ VÀO THƯ MỤC
-- ========================================================
-- Hãy nhớ xóa thư mục ketqua_bai5 trước khi chạy lệnh này
STORE top_5_pos_aspect INTO 'ketqua_bai5/tu_lien_quan_tich_cuc' USING PigStorage(';');
STORE top_5_neg_aspect INTO 'ketqua_bai5/tu_lien_quan_tieu_cuc' USING PigStorage(';');