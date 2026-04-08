/* BÀI 4: TOP 5 TỪ TÍCH CỰC & TIÊU CỰC THEO TỪNG CATEGORY */

-- 1. Đọc dữ liệu từ Bài 1
data_bai1 = LOAD 'ketqua_bai1' USING PigStorage(';') AS (id:int, category:chararray, aspect:chararray, polarity:chararray, word:chararray);

-- 2. TẨY RỬA POLARITY (Đảm bảo không dính ký tự ẩn \r, \n)
clean_data = FOREACH data_bai1 GENERATE category, word, REPLACE(LOWER(polarity), '[^a-z]', '') AS polarity;

-- ========================================================
-- Ý 1: 5 TỪ TÍCH CỰC NHẤT THEO CATEGORY
-- ========================================================
pos_data = FILTER clean_data BY polarity == 'positive';
group_pos = GROUP pos_data BY (category, word);
count_pos = FOREACH group_pos GENERATE FLATTEN(group) AS (category, word), COUNT(pos_data) AS total;

group_pos_by_cat = GROUP count_pos BY category;
top_5_pos = FOREACH group_pos_by_cat {
    result = TOP(5, 2, count_pos);
    GENERATE FLATTEN(result);
};

-- ========================================================
-- Ý 2: 5 TỪ TIÊU CỰC NHẤT THEO CATEGORY
-- ========================================================
neg_data = FILTER clean_data BY polarity == 'negative';
group_neg = GROUP neg_data BY (category, word);
count_neg = FOREACH group_neg GENERATE FLATTEN(group) AS (category, word), COUNT(neg_data) AS total;

group_neg_by_cat = GROUP count_neg BY category;
top_5_neg = FOREACH group_neg_by_cat {
    result = TOP(5, 2, count_neg);
    GENERATE FLATTEN(result);
};

-- ========================================================
-- LƯU KẾT QUẢ
-- ========================================================
STORE top_5_pos INTO 'ketqua_bai4/tu_tich_cuc' USING PigStorage(';');
STORE top_5_neg INTO 'ketqua_bai4/tu_tieu_cuc' USING PigStorage(';');