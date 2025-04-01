import requests
import json
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

extracted_text = """
oMALABEOOT
MEDICAL COLLEGE HOSPITAL THIRUVANANTHAPURAM,

cHealth Kerala
NCH TVM, THIRUVANANTHAPURAM - 6950111 Ph:04712528225

Qualitative/Quantitative Laboratory Reports

UHI Trvs262002230301 MIO Bareode AEH HFN HERA
Name ADI GOWRI A Bill No.

AgeGonder 18 11 M Female Bil Date

BIOCHEMISTRY LAB
ca86009 acca ran Fecolved : 0602/2026 1055. Last Result Validated: s/022004 1241
Pino Investigation Name ‘Observed Value Units Reference Range Remarks
1 Calcium 91 95-105
Cholasterot 163 mgt 190-220

3. LET {Liver Function Test]

31. Bilirubin Tota o7 rmghat 04-12

32 Binutin Direct o2 gi 0-03

33 SGOT wut 5-46

a4 SGPT “4 ‘un 46

35 Akaline phosphatase 70 un 18-308

38 Total Prown 72 oft 5-@

37 Abumin 41 oi 30-50

38 Globulin e} ato sit 2-4

4 Phosphorus 40 magi 25-45

5 RBS [Random Blood Suger} 74 rmgldt. 20-140

© AFT(Urea Crea UA)

81 Blood Urea 19 mgt. 19-40

62 Crestinine 07 moi «08-42

63 Urea a7 mg 24-70

7 Sodium Potassium

7:1 Blood Sodium 126 mégt 188-146

72. Bod Potassium 40 me gt 3-55

Sample Validated by Last Result Validated by

SANTHOSH KUMAR C PLuunir Laboratory Assist) SHIVAKUMAR § itor Tosi

CLINICAL PATHOLOGY OP LAB

‘ossa01aeniood EDTA Fiecoived ; 06/02/2004 10:55 Laat Result Validated :o6/o2/onke 12:22

yonerat 19
va ee Fleport generated on: onm02%2024 08:1
"""

# Ensure API key exists
if not OPENROUTER_API_KEY:
    raise ValueError("API Key is missing. Set OPENROUTER_API_KEY in your .env file.")

# Make the API request
response = requests.post(
    url="https://openrouter.ai/api/v1/chat/completions",
    headers={
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
    },
    data=json.dumps({
        "model": "mistralai/mistral-small-3.1-24b-instruct:free",
        "messages": [
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": "Analyze this medical text and structure it into JSON format:"},
                    {"type": "text", "text": extracted_text}
                ]
            }
        ],
    })
)

# Handle the response
try:
    response.raise_for_status()  # Check for HTTP errors
    structured_data = response.json()
    print(json.dumps(structured_data, indent=4))  # Pretty print JSON response
except requests.exceptions.RequestException as e:
    print("API Request Error:", str(e))
except json.JSONDecodeError:
    print("Failed to decode JSON response.")
