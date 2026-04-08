/* BÀI 2: CÁC THAO TÁC THỐNG KÊ (BẢN XUẤT FILE) */

-- ========================================================
-- YÊU CẦU 1: THỐNG KÊ TỪ VỰNG (Dùng kết quả của Bài 1)
-- ========================================================
data_bai1 = LOAD 'ketqua_bai1' USING PigStorage(';') AS (id:int, category:chararray, aspect:chararray, polarity:chararray, word:chararray);
group_word = GROUP data_bai1 BY word;
word_count = FOREACH group_word GENERATE group AS word, COUNT(data_bai1) AS total;
word_over_500 = FILTER word_count BY total > 500;

-- ========================================================
-- YÊU CẦU 2 & 3: THỐNG KÊ CATEGORY VÀ ASPECT (Dùng file data sạch)
-- ========================================================
clean_raw = LOAD 'clean_hotel_review' USING PigStorage(';') AS (id:int, comment:chararray, category:chararray, aspect:chararray, polarity:chararray);

-- Yêu cầu 2
group_cat = GROUP clean_raw BY category;
cat_count = FOREACH group_cat GENERATE group AS category, COUNT(clean_raw) AS total_comments;

-- Yêu cầu 3
group_aspect = GROUP clean_raw BY aspect;
aspect_count = FOREACH group_aspect GENERATE group AS aspect, COUNT(clean_raw) AS total_comments;

-- ========================================================
-- LƯU KẾT QUẢ VÀO THƯ MỤC KETQUABAI2
-- ========================================================
-- Tạo 3 thư mục con bên trong thư mục ketqua_bai2 để phân loại rõ ràng

STORE word_over_500 INTO 'ketqua_bai2/thong_ke_tu' USING PigStorage(';');
STORE cat_count INTO 'ketqua_bai2/thong_ke_category' USING PigStorage(';');
STORE aspect_count INTO 'ketqua_bai2/thong_ke_aspect' USING PigStorage(';');