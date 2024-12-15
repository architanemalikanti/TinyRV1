
import random;

print("                           // addr  size result seven_seg")

n = 3100
result = 0
for i in range(n):
  value = random.randint(0,99)
  result = result + value
  seven_seg = result & 0x1f
  print(f"      mem[14'h{i:04x}] <= {value: >2}; // {i*4:04x} {i+1: >5} {result: >6} {seven_seg: >2}");

