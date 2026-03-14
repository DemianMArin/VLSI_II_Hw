import numpy as np

# 0 dBm 632 mV
zero = 632e-3
# 30 dBm 
thirty = 10**(30/20)
# -30 dBm
minus30 = (zero/thirty)
print(f"-30dBm: {minus30}")
print(f"-30dBm: {(minus30*(10**3)):.3f}m")

input = 225.687
output = 11.754
Gain = input/output
print(f"Gain: {Gain}")
# Conversion Gain
cGain = input/(output/2)
print(f"Conversion Gain: {cGain}")

R = 2*np.pi*(5.2e9)*(6e-9)*(4)
print(f"R: {R}")

#LO Leakage
Vant = 317.303e-6
VLO = 225e-3
rev_iso = Vant/VLO
print(f"\nReverse Isolation: {rev_iso}")
rev_iso_log10 = 10*np.log10(rev_iso)
rev_iso_log20 = 20*np.log10(rev_iso)
print(f"10: {rev_iso_log10}, 20: {rev_iso_log20}")

#IP3
fLO = 5.13e9
fr1 = 5.195e9
fr2 = 5.205e9
org1_down = fr1-fLO
org2_down = fr2-fLO
im1 = (2*fr1 - fr2)
im2 = (2*fr2 - fr1)
im1_down = im1 - fLO
im2_down = im2 - fLO
print(f"\nTone1: {fr1/1e9}G, Tone2: {fr2/1e9}G")
print(f"IM1: {im1/1e9}G, IM2: {im2/1e9}G")
print(f"Org1Down: {org1_down/1e6}M, Org2Down: {org2_down/1e6}M")
print(f"IM1 DownConv: {im1_down/1e6}M, IM2 DownConv: {im2_down/1e6}M")


