/* BÀI 3: KHÍA CẠNH TÍCH CỰC & TIÊU CỰC NHẤT (BẢN DÙNG HÀM TOP) */

-- 1. Đọc dữ liệu
raw_data = LOAD 'clean_hotel_review' USING PigStorage(';') AS (id:int, comment:chararray, category:chararray, aspect:chararray, polarity:chararray);

-- 2. Lọc bỏ dòng NULL và làm sạch cột polarity (chống lỗi rác dữ liệu)
valid_data = FILTER raw_data BY (polarity IS NOT NULL);
clean_data = FOREACH valid_data GENERATE aspect, REPLACE(LOWER(polarity), '[^a-z]', '') AS polarity;

-- ========================================================
-- TÌM POSITIVE
-- ========================================================
pos_data = FILTER clean_data BY polarity == 'positive';
group_pos = GROUP pos_data BY aspect;
count_pos = FOREACH group_pos GENERATE group AS aspect, COUNT(pos_data) AS total;

-- Thay vì ORDER BY, ta dùng GROUP ALL và hàm TOP để lấy 1 dòng có 'total' lớn nhất
group_all_pos = GROUP count_pos ALL;
top_positive = FOREACH group_all_pos {
    result = TOP(1, 1, count_pos); -- Lấy top 1 dựa trên cột số 1 (cột total)
    GENERATE FLATTEN(result);
};

-- ========================================================
-- TÌM NEGATIVE
-- ========================================================
neg_data = FILTER clean_data BY polarity == 'negative';
group_neg = GROUP neg_data BY aspect;
count_neg = FOREACH group_neg GENERATE group AS aspect, COUNT(neg_data) AS total;

group_all_neg = GROUP count_neg ALL;
top_negative = FOREACH group_all_neg {
    result = TOP(1, 1, count_neg); -- Lấy top 1 dựa trên cột số 1 (cột total)
    GENERATE FLATTEN(result);
};

-- ========================================================
-- IN KẾT QUẢ
-- ========================================================

STORE top_positive INTO 'ketqua_bai3/khia_canh_tich_cuc' USING PigStorage(';');
STORE top_negative INTO 'ketqua_bai3/khia_canh_tieu_cuc' USING PigStorage(';');