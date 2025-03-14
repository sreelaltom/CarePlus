import pytesseract
from pdf2image import convert_from_path

# Set the path to Tesseract-OCR (Modify this path if necessary)
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

def extract_text_from_pdf(pdf_path):
    """Extracts text from a PDF file using OCR."""
    try:
        images = convert_from_path(pdf_path)  # Convert PDF pages to images
        text = ""
        for img in images:
            text += pytesseract.image_to_string(img)  # Extract text from each page
        return text
    except Exception as e:
        print(f"Error: {e}")
        return ""
import google.generativeai as genai
import os
import json
import matplotlib.pyplot as plt
from pymongo import MongoClient
from dotenv import load_dotenv

# Load API Key from .env
load_dotenv()
genai.configure(api_key=os.getenv("GENAI_API_KEY"))

# Connect to MongoDB
client = MongoClient("mongodb://localhost:27017/")
db = client["medical_database"]
collection = db["lab_reports"]

def clean_and_format_lab_results(raw_text, username):
    """Uses Gemini AI to clean extracted lab test results and format into JSON."""
    prompt = f"""
    Convert the following unstructured medical lab report into structured JSON:

    ```
    {raw_text}
    ```

    Ensure the JSON contains:
    - "username": Username extracted from token.
    - "patient": Name, Age, Gender, Bill Number.
    - "test_results": List of test results with:
      - "test_name": Name of the test.
      - "observed_value": Measured value.
      - "units": Measurement units.
      - "reference_range": Normal range.
    - "validated_by": Doctor or lab assistant's name.

    Return only valid JSON format.
    """

    try:
        model = genai.GenerativeModel("gemini-pro")
        response = model.generate_content(prompt)
        cleaned_json = json.loads(response.text)
        
        # Add username from token
        cleaned_json["username"] = username

        return cleaned_json
    except Exception as e:
        return {"error": str(e)}

def save_to_mongo(cleaned_json):
    """Saves the structured JSON to MongoDB."""
    try:
        collection.insert_one(cleaned_json)
        print("✅ Data successfully stored in MongoDB")
    except Exception as e:
        print("❌ MongoDB Error:", str(e))

def fetch_user_test_history(username, test_name):
    """Fetches test history of a user for a specific test."""
    query = {"username": username, "test_results.test_name": test_name}
    records = list(collection.find(query, {"_id": 0, "test_results": 1}))

    # Extract values for visualization
    dates = []
    values = []

    for record in records:
        for test in record["test_results"]:
            if test["test_name"] == test_name:
                dates.append(record.get("date", "Unknown Date"))
                values.append(test["observed_value"])

    return dates, values

def plot_test_history(username, test_name):
    """Visualizes the test history of a user."""
    dates, values = fetch_user_test_history(username, test_name)

    if not dates:
        print(f"❌ No records found for {test_name} of user {username}")
        return

    plt.figure(figsize=(10, 5))
    plt.plot(dates, values, marker='o', linestyle='-', color='b')
    plt.xlabel("Date")
    plt.ylabel("Test Value")
    plt.title(f"{test_name} History for {username}")
    plt.xticks(rotation=45)
    plt.grid()
    plt.show()

# Example Usage
raw_extracted_text = """
March 11, 2025 - 22:22:03
Extracted Text: 
Name ADI GOWRI A Bill No. 86009
Age 18 Gender Female
Test Results:
Calcium 91 mg/dL (95-105)
Cholesterol 163 mg/dL (190-220)
Bilirubin Total 0.7 mg/dL (0.4-1.2)
Validated by: Dr. Shivakumar S
"""

# Clean and Store Data
username = "john_doe"
cleaned_json_data = clean_and_format_lab_results(raw_extracted_text, username)
save_to_mongo(cleaned_json_data)

# Fetch & Visualize History
plot_test_history(username, "Calcium")
