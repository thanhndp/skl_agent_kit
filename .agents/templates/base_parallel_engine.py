import os
import concurrent.futures
from pathlib import Path
import logging

# [SECURITY GUARDRAIL]: Strict Network Ban
# Đoạn mã này để chặn bất kỳ gói mở rộng nào cố gắng liên lạc Internet (Chống Data Privacy Leak).
import socket
def block_network():
    def guard(*args, **kwargs):
        raise Exception("Network Security Violation: PII Data cannot leave processing environment!")
    socket.socket = guard
block_network()

# Cấu hình Chunk & Worker từ Config
# Bạn có thể tự parse yaml hoặc thay đổi mặc định này.
MAX_WORKERS = 4
BATCH_CHUNK_SIZE = 10

INPUT_DIR = Path('../1_input/structured')
OUTPUT_DIR = Path('../3_output')

logging.basicConfig(level=logging.INFO, format='%(asctime)s - [%(levelname)s] - %(message)s')

def process_file(file_path):
    """
    [INSERT LOGIC HERE]
    Thay thế ruột logic của hàm này bằng lệnh Business logic (ví dụ: Pandas, OCR, Regex)
    Hàm hiện tại chỉ làm ví dụ In tên file ra.
    """
    try:
        # Ví dụ: Mở file, lấy dữ liệu bảng...
        temp_out = OUTPUT_DIR / f"processed_{file_path.name}"
        
        # [SECURITY GUARDRAIL]: Xung đột ghi đè Race Condition
        # Không được lưu trực tiếp vào 1 file chung. Phải lưu ra temp phân mảnh.
        with open(temp_out, 'w', encoding='utf-8') as f:
            f.write(f"Processed: {file_path.name}")
            
        return True, file_path.name
    except Exception as e:
        return False, str(e)


def chunked_iterable(iterable, size):
    """
    [SECURITY GUARDRAIL]: Memory Safety Generator
    Ép vòng lặp chạy theo từng Lô 10 file, xong RAM thì nhả ra làm lô mới, tránh OOM.
    """
    chunk = []
    for item in iterable:
        chunk.append(item)
        if len(chunk) == size:
            yield chunk
            chunk = []
    if chunk:
        yield chunk

def main():
    if not INPUT_DIR.exists():
        logging.error(f"Thu muc {INPUT_DIR} hien khong ton tai. Vui long dua file vao truoc.")
        return

    all_files = [f for f in INPUT_DIR.iterdir() if f.is_file()]
    logging.info(f"Phat hien tong cong {len(all_files)} files.")

    # [GUARDRAIL]: Map - Parallel Processing
    for batch_idx, batch_files in enumerate(chunked_iterable(all_files, BATCH_CHUNK_SIZE)):
        logging.info(f"Bat dau Batch #{batch_idx + 1} ({len(batch_files)} files)")
        
        with concurrent.futures.ProcessPoolExecutor(max_workers=MAX_WORKERS) as executor:
            results = list(executor.map(process_file, batch_files))
            
            for success, msg in results:
                if not success:
                    logging.error(f"Loi xu ly file: {msg}")

    # [GUARDRAIL]: Reduce - Merge Final
    logging.info("Tien hanh Ghen ghep (Merge/Reduce) bao cao cuoi (optional)...")
    # Viet code vao day de gom 10 cai temp_xxx.csv thanh report.pdf...

if __name__ == "__main__":
    main()
