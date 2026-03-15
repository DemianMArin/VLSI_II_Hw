import numpy as np

cin_static = 525e-18
cin_dynamic = 30e-18
cin_domino = 300e-18

cload_static = cin_static*4
cload_dynamic = cin_dynamic*4
cload_domino = cin_domino*4

print(f"C Load")
print(f"C load static: {cload_static/1e-15}")
print(f"C load dynamic: {cload_dynamic/1e-15}")
print(f"C load domino: {cload_domino/1e-15}")
