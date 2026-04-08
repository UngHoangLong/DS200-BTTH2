/* BÀI 1: CHUẨN HÓA DỮ LIỆU (BẢN HOÀN HẢO)
- Lọc rác
- Chữ thường
- Xóa dấu câu
- Tách từ
- Lọc stopword
*/

-- 1. Đọc dữ liệu
data = LOAD 'hotel-review.csv' USING PigStorage(';') AS (id:int, comment:chararray, category:chararray, aspect:chararray, polarity:chararray);
stopwords = LOAD 'stopwords.txt' AS (word:chararray);

-- 2. LỌC RÁC: Chỉ giữ lại dòng có bình luận hợp lệ
filtered_data = FILTER data BY comment MATCHES '.*[a-zA-Z0-9]+.*';

-- 3. CHỮ THƯỜNG
lower_comment = FOREACH filtered_data GENERATE id, category, aspect, polarity, LOWER(comment) AS comment_lower;

-- 4. TẨY RỬA DẤU CÂU (BƯỚC MỚI THÊM)
-- Thay thế các dấu câu phổ biến bằng một khoảng trắng
clean_comment = FOREACH lower_comment GENERATE id, category, aspect, polarity, REPLACE(comment_lower, '[.,!?;:\\-&%"\'/()\\+]', ' ') AS comment_clean;

-- 5. TÁCH TỪ: Băm từ cái câu đã được dọn sạch dấu câu
words = FOREACH clean_comment GENERATE id, category, aspect, polarity, FLATTEN(TOKENIZE(comment_clean)) AS word;

-- 6. LỌC STOPWORD: Kết nối và loại bỏ
joined_words = JOIN words BY word LEFT, stopwords BY word;
filtered_words = FILTER joined_words BY stopwords::word IS NULL;

-- 7. DỌN DẸP
bai1_result = FOREACH filtered_words GENERATE words::id AS id, words::category AS category, words::aspect AS aspect, words::polarity AS polarity, words::word AS word;

-- 8. LƯU KẾT QUẢ
STORE bai1_result INTO 'ketqua_bai1' USING PigStorage(';');