from Crypto.Cipher import AES
import binascii

# Khóa 128-bit (16 bytes) đã cho
key_hex = '6b6b6b6b65656565797979792e2e2e2e'  # Đảm bảo khóa có 32 ký tự hex (16 bytes)
key = binascii.unhexlify(key_hex)  # Chuyển đổi từ hex sang bytes

# Đảm bảo khóa có độ dài 16 bytes
if len(key) != 16:
    raise ValueError("Khóa phải có độ dài 128 bits (16 bytes)")

# Thông điệp đầu vào
message = 'abcdef1234567890'  # Đảm bảo thông điệp có độ dài phù hợp

# Chuyển đổi từ Unicode sang bytes
message_bytes = message.encode('utf-8')  # Chuyển đổi thành bytes
print(f'Input Message (Hex): {binascii.hexlify(message_bytes).decode()}')

# Căn chỉnh thông điệp
message_bytes = message_bytes.ljust(16)  # Đảm bảo độ dài 16 bytes

# Khởi tạo AES với khóa
cipher = AES.new(key, AES.MODE_ECB)  # Sử dụng chế độ ECB
ciphertext = cipher.encrypt(message_bytes)  # Mã hóa

print(f'Encrypted Token (Hex): {ciphertext.hex()}')

# Giải mã
decrypted_message = cipher.decrypt(ciphertext).strip() 
print(f'Decrypted Message: {decrypted_message.decode()}')