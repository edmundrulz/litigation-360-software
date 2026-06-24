# L360 - PHASE 10K COURT REGISTRY PATCH

## Added Locations
1. Industrial Court of Malaysia Kuala Lumpur
2. Mahkamah Perusahaan Malaysia Kuala Lumpur
3. PERKESO Wilayah Persekutuan Kuala Lumpur
4. PERKESO Headquarters Jalan Ampang
5. SOCSO Headquarters Jalan Ampang

## Source Locations
- Industrial Court / Mahkamah Perusahaan KL:
  Level 14, Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur

- PERKESO Wilayah Persekutuan Kuala Lumpur:
  Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur

- PERKESO Headquarters / SOCSO HQ:
  Menara PERKESO, 281, Jalan Ampang, 50538 Kuala Lumpur

## Runtime Tests
After restart:
- http://localhost:5000/api/enterprise/navigation/courts
- http://localhost:5000/api/enterprise/navigation/courts/Industrial%20Court%20of%20Malaysia%20Kuala%20Lumpur
- http://localhost:5000/api/enterprise/navigation/courts/PERKESO%20Headquarters%20Jalan%20Ampang

## Rule
This patch only updates deterministic court registry defaults. It does not call Google Maps/Waze yet.
