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
