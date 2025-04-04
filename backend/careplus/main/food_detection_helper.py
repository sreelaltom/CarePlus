# ml_helpers.py
import io
import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from django.core.files.uploadedfile import InMemoryUploadedFile
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__)) 
FOOD_MODEL_PATH = os.path.join(BASE_DIR, "indian_food_classifier_second.h5")

if not os.path.exists(FOOD_MODEL_PATH):
    raise FileNotFoundError(f"Food model not found at {FOOD_MODEL_PATH}")

food_model = load_model(FOOD_MODEL_PATH)

className=['Aapam', 'Adhirasam', 'Aloo Gobi', 'Aloo Matar', 'Aloo Methi', 'Aloo Tikki', 'Avial', 'Basundi', 'Bhakarwadi', 'Bhindi Masala', 'Biriyani', 'Bisibelebath', 'Boondi', 'Butter Chicken', 'Carrot Halwa', 'Chai', 'Chana Masala', 'Chapathi', 'Chicken Tikka', 'Chola Poori', 'Chutney', 'Dabeli', 'Dal Bati Churma', 'Dal Makhani', 'Dal Tadka', 'Dhokla', 'Double Ka Meetha', 'Dum Aloo', 'Egg', 'Ghevar', 'Gulab Jamun', 'Halwa', 'Idly', 'Jaangri', 'Jalebi', 'Kaathi Rolls', 'Kachori', 'Kadai Paneer', 'Kadhi Pakoda', 'Kakinada Khaja', 'Kalakand', 'Karela Bharta', 'Kesari', 'Khakhra', 'Khandvi', 'Kheer', 'Kofta', 'Kothu Parotta', 'Kulfi', 'Kuzhi Paniyaram', 'Laddu', 'Lassi', 'Litti Chokha', 'Malapua', 'Masala Dosa', 'Medu Vada', 'Meen Gravy', 'Milk Peda', 'Misti Doi', 'Modak', 'Mushroom', 'Mysore Pak', 'Naan', 'Nan Khatai', 'Navrattan Korma', 'Noodles', 'Paani Puri', 'Pakoda', 'Palak Paneer', 'Paneer Butter Masala', 'Paneer Tikka', 'Paratha', 'Pav Bhaji', 'Payasam', 'Phirni', 'Plain Dosa', 'Poha', 'Pongal', 'Poori', 'Pootharekulu', 'Puttu', 'Rabri', 'Rajma Chawal', 'Rasgulla', 'Rasmalai', 'Rava Kichadi', 'Rice', 'Sambar', 'Samosa', 'Sarson ka Saag Makki ki Roti', 'Shankarpali', 'Shrikhand', 'Siddu', 'Sohan Papdi', 'Somaas', 'Tandoori Chicken', 'Thepla', 'Ulunthu Vada', 'Upma', 'Uthapam', 'Vada Pav']  # Get class index
# class_labels = train_generator.class_indices  # Mapping from labels to index
# class_labels = {v: k for k, v in class_labels.items()}  # Reverse mapping

dishes_nutrition = {
    'Aapam': {'calories': 120, 'carbohydrates': 25, 'proteins': 2, 'fats': 1, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Adhirasam': {'calories': 150, 'carbohydrates': 30, 'proteins': 2, 'fats': 3, 'vitamins': {'Vitamin A', 'Vitamin B2', 'Vitamin E'}},
'Aloo Gobi': {'calories': 160, 'carbohydrates': 20, 'proteins': 4, 'fats': 6, 'vitamins': {'Vitamin C', 'Vitamin K', 'Vitamin B6'}},
'Aloo Matar': {'calories': 140, 'carbohydrates': 22, 'proteins': 5, 'fats': 4, 'vitamins': {'Vitamin A', 'Vitamin C', 'Vitamin B1'}},
'Aloo Methi': {'calories': 130, 'carbohydrates': 18, 'proteins': 4, 'fats': 5, 'vitamins': {'Vitamin C', 'Vitamin K', 'Vitamin B2'}},
'Aloo Tikki': {'calories': 180, 'carbohydrates': 28, 'proteins': 3, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Avial': {'calories': 100, 'carbohydrates': 12, 'proteins': 3, 'fats': 5, 'vitamins': {'Vitamin A', 'Vitamin B6', 'Vitamin C'}},
'Basundi': {'calories': 250, 'carbohydrates': 30, 'proteins': 6, 'fats': 12, 'vitamins': {'Vitamin D', 'Vitamin B12', 'Vitamin A'}},
'Bhakarwadi': {'calories': 200, 'carbohydrates': 22, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin E', 'Vitamin C'}},
'Bhindi Masala': {'calories': 120, 'carbohydrates': 14, 'proteins': 3, 'fats': 6, 'vitamins': {'Vitamin K', 'Vitamin C', 'Vitamin B2'}},
'Biriyani': {'calories': 300, 'carbohydrates': 40, 'proteins': 10, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin B6', 'Vitamin D'}},
'Bisibelebath': {'calories': 220, 'carbohydrates': 35, 'proteins': 6, 'fats': 6, 'vitamins': {'Vitamin C', 'Vitamin B1', 'Vitamin A'}},
'Boondi': {'calories': 180, 'carbohydrates': 24, 'proteins': 2, 'fats': 8, 'vitamins': {'Vitamin B2', 'Vitamin E', 'Vitamin D'}},
'Butter Chicken': {'calories': 320, 'carbohydrates': 8, 'proteins': 20, 'fats': 24, 'vitamins': {'Vitamin D', 'Vitamin B12', 'Vitamin A'}},
'Carrot Halwa': {'calories': 260, 'carbohydrates': 38, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin A', 'Vitamin C', 'Vitamin E'}},
'Chai': {'calories': 90, 'carbohydrates': 15, 'proteins': 2, 'fats': 2, 'vitamins': {'Vitamin D', 'Vitamin B2', 'Vitamin A'}},
'Chana Masala': {'calories': 180, 'carbohydrates': 25, 'proteins': 9, 'fats': 4, 'vitamins': {'Vitamin B6', 'Vitamin C', 'Vitamin K'}},
'Chapathi': {'calories': 120, 'carbohydrates': 20, 'proteins': 3, 'fats': 2, 'vitamins': {'Vitamin B1', 'Vitamin B3', 'Vitamin E'}},
'Chicken Tikka': {'calories': 280, 'carbohydrates': 6, 'proteins': 24, 'fats': 18, 'vitamins': {'Vitamin B6', 'Vitamin B12', 'Vitamin D'}},
'Chola Poori': {'calories': 330, 'carbohydrates': 40, 'proteins': 7, 'fats': 15, 'vitamins': {'Vitamin A', 'Vitamin B1', 'Vitamin D'}},
'Chutney': {'calories': 60, 'carbohydrates': 6, 'proteins': 1, 'fats': 3, 'vitamins': {'Vitamin C', 'Vitamin E', 'Vitamin K'}},
'Dabeli': {'calories': 250, 'carbohydrates': 35, 'proteins': 6, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Dal Bati Churma': {'calories': 400, 'carbohydrates': 50, 'proteins': 10, 'fats': 15, 'vitamins': {'Vitamin B6', 'Vitamin A', 'Vitamin E'}},
'Dal Makhani': {'calories': 270, 'carbohydrates': 26, 'proteins': 11, 'fats': 12, 'vitamins': {'Vitamin B1', 'Vitamin B9', 'Vitamin D'}},
'Dal Tadka': {'calories': 200, 'carbohydrates': 22, 'proteins': 9, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Dhokla': {'calories': 160, 'carbohydrates': 22, 'proteins': 6, 'fats': 5, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin K'}},
'Double Ka Meetha': {'calories': 300, 'carbohydrates': 35, 'proteins': 5, 'fats': 15, 'vitamins': {'Vitamin A', 'Vitamin D', 'Vitamin B12'}},
'Dum Aloo': {'calories': 180, 'carbohydrates': 20, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin C', 'Vitamin B6', 'Vitamin A'}},
'Egg': {'calories': 70, 'carbohydrates': 1, 'proteins': 6, 'fats': 5, 'vitamins': {'Vitamin D', 'Vitamin B12', 'Vitamin A'}},
'Ghevar': {'calories': 250, 'carbohydrates': 40, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin E', 'Vitamin A'}},
'Gulab Jamun': {'calories': 300, 'carbohydrates': 45, 'proteins': 5, 'fats': 12, 'vitamins': {'Vitamin D', 'Vitamin B2', 'Vitamin A'}},
'Halwa': {'calories': 280, 'carbohydrates': 35, 'proteins': 4, 'fats': 14, 'vitamins': {'Vitamin A', 'Vitamin B1', 'Vitamin E'}},
'Idly': {'calories': 90, 'carbohydrates': 18, 'proteins': 2, 'fats': 1, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Jaangri': {'calories': 260, 'carbohydrates': 38, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin A', 'Vitamin B2', 'Vitamin D'}},
'Jalebi': {'calories': 250, 'carbohydrates': 40, 'proteins': 3, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin E'}},
'Kaathi Rolls': {'calories': 300, 'carbohydrates': 35, 'proteins': 10, 'fats': 12, 'vitamins': {'Vitamin B6', 'Vitamin C', 'Vitamin D'}},
'Kachori': {'calories': 270, 'carbohydrates': 30, 'proteins': 5, 'fats': 14, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin D'}},
'Kadai Paneer': {'calories': 280, 'carbohydrates': 20, 'proteins': 10, 'fats': 18, 'vitamins': {'Vitamin B12', 'Vitamin D', 'Vitamin A'}},
'Kadhi Pakoda': {'calories': 220, 'carbohydrates': 18, 'proteins': 6, 'fats': 12, 'vitamins': {'Vitamin B2', 'Vitamin A', 'Vitamin C'}},
'Kakinada Khaja': {'calories': 240, 'carbohydrates': 32, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin D', 'Vitamin A'}},
'Kalakand': {'calories': 200, 'carbohydrates': 25, 'proteins': 6, 'fats': 8, 'vitamins': {'Vitamin B12', 'Vitamin D', 'Vitamin A'}},
'Karela Bharta': {'calories': 100, 'carbohydrates': 10, 'proteins': 3, 'fats': 5, 'vitamins': {'Vitamin C', 'Vitamin B1', 'Vitamin K'}},
'Kesari': {'calories': 180, 'carbohydrates': 30, 'proteins': 2, 'fats': 6, 'vitamins': {'Vitamin A', 'Vitamin B2', 'Vitamin E'}},
'Khakhra': {'calories': 120, 'carbohydrates': 18, 'proteins': 3, 'fats': 4, 'vitamins': {'Vitamin B1', 'Vitamin E', 'Vitamin C'}},
'Khandvi': {'calories': 140, 'carbohydrates': 20, 'proteins': 5, 'fats': 5, 'vitamins': {'Vitamin B2', 'Vitamin C', 'Vitamin A'}},
'Kheer': {'calories': 250, 'carbohydrates': 35, 'proteins': 6, 'fats': 10, 'vitamins': {'Vitamin D', 'Vitamin A', 'Vitamin B12'}},
'Kofta': {'calories': 300, 'carbohydrates': 25, 'proteins': 10, 'fats': 18, 'vitamins': {'Vitamin B6', 'Vitamin D', 'Vitamin A'}},
'Kothu Parotta': {'calories': 350, 'carbohydrates': 40, 'proteins': 10, 'fats': 16, 'vitamins': {'Vitamin B1', 'Vitamin B6', 'Vitamin C'}},
'Kulfi': {'calories': 220, 'carbohydrates': 25, 'proteins': 5, 'fats': 12, 'vitamins': {'Vitamin D', 'Vitamin A', 'Vitamin B2'}},
'Kuzhi Paniyaram': {'calories': 150, 'carbohydrates': 20, 'proteins': 4, 'fats': 5, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin E'}},
'Laddu': {'calories': 280, 'carbohydrates': 30, 'proteins': 5, 'fats': 14, 'vitamins': {'Vitamin A', 'Vitamin B1', 'Vitamin D'}},
'Lassi': {'calories': 150, 'carbohydrates': 18, 'proteins': 6, 'fats': 6, 'vitamins': {'Vitamin D', 'Vitamin B12', 'Vitamin A'}},
'Litti Chokha': {'calories': 320, 'carbohydrates': 35, 'proteins': 8, 'fats': 15, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Malapua': {'calories': 300, 'carbohydrates': 40, 'proteins': 5, 'fats': 14, 'vitamins': {'Vitamin A', 'Vitamin B2', 'Vitamin D'}},
'Masala Dosa': {'calories': 230, 'carbohydrates': 30, 'proteins': 6, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Medu Vada': {'calories': 190, 'carbohydrates': 20, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin K', 'Vitamin C'}},
'Meen Gravy': {'calories': 200, 'carbohydrates': 8, 'proteins': 20, 'fats': 10, 'vitamins': {'Vitamin D', 'Vitamin B12', 'Vitamin A'}},
'Milk Peda': {'calories': 220, 'carbohydrates': 30, 'proteins': 6, 'fats': 10, 'vitamins': {'Vitamin A', 'Vitamin D', 'Vitamin B2'}},
'Misti Doi': {'calories': 200, 'carbohydrates': 25, 'proteins': 6, 'fats': 8, 'vitamins': {'Vitamin D', 'Vitamin A', 'Vitamin B12'}},
'Modak': {'calories': 180, 'carbohydrates': 30, 'proteins': 4, 'fats': 6, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Mushroom': {'calories': 22, 'carbohydrates': 3, 'proteins': 3, 'fats': 0.3, 'vitamins': {'Vitamin D', 'Vitamin B3', 'Vitamin B2'}},
'Mysore Pak': {'calories': 400, 'carbohydrates': 35, 'proteins': 4, 'fats': 24, 'vitamins': {'Vitamin A', 'Vitamin E', 'Vitamin B1'}},
'Naan': {'calories': 260, 'carbohydrates': 40, 'proteins': 7, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin D', 'Vitamin B2'}},
'Nan Khatai': {'calories': 150, 'carbohydrates': 20, 'proteins': 2, 'fats': 7, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin E'}},
'Navrattan Korma': {'calories': 280, 'carbohydrates': 25, 'proteins': 6, 'fats': 16, 'vitamins': {'Vitamin C', 'Vitamin A', 'Vitamin B6'}},
'Noodles': {'calories': 300, 'carbohydrates': 40, 'proteins': 8, 'fats': 12, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin E'}},
'Paani Puri': {'calories': 150, 'carbohydrates': 20, 'proteins': 3, 'fats': 6, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Pakoda': {'calories': 200, 'carbohydrates': 18, 'proteins': 4, 'fats': 12, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin D'}},
'Palak Paneer': {'calories': 240, 'carbohydrates': 12, 'proteins': 10, 'fats': 16, 'vitamins': {'Vitamin A', 'Vitamin C', 'Vitamin B12'}},
'Paneer Butter Masala': {'calories': 300, 'carbohydrates': 15, 'proteins': 10, 'fats': 22, 'vitamins': {'Vitamin A', 'Vitamin D', 'Vitamin B12'}},
'Paneer Tikka': {'calories': 270, 'carbohydrates': 10, 'proteins': 14, 'fats': 20, 'vitamins': {'Vitamin D', 'Vitamin B12', 'Vitamin A'}},
'Paratha': {'calories': 210, 'carbohydrates': 28, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin D', 'Vitamin A'}},
'Pav Bhaji': {'calories': 250, 'carbohydrates': 30, 'proteins': 6, 'fats': 12, 'vitamins': {'Vitamin C', 'Vitamin B1', 'Vitamin A'}},
'Payasam': {'calories': 280, 'carbohydrates': 32, 'proteins': 5, 'fats': 12, 'vitamins': {'Vitamin B12', 'Vitamin A', 'Vitamin D'}},
'Phirni': {'calories': 230, 'carbohydrates': 28, 'proteins': 5, 'fats': 10, 'vitamins': {'Vitamin A', 'Vitamin D', 'Vitamin B2'}},
'Plain Dosa': {'calories': 160, 'carbohydrates': 28, 'proteins': 3, 'fats': 4, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Poha': {'calories': 180, 'carbohydrates': 30, 'proteins': 4, 'fats': 6, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Pongal': {'calories': 220, 'carbohydrates': 32, 'proteins': 5, 'fats': 8, 'vitamins': {'Vitamin A', 'Vitamin B1', 'Vitamin D'}},
'Poori': {'calories': 220, 'carbohydrates': 20, 'proteins': 3, 'fats': 12, 'vitamins': {'Vitamin B1', 'Vitamin D', 'Vitamin E'}},
'Pootharekulu': {'calories': 150, 'carbohydrates': 22, 'proteins': 2, 'fats': 5, 'vitamins': {'Vitamin A', 'Vitamin B1', 'Vitamin E'}},
'Puttu': {'calories': 180, 'carbohydrates': 35, 'proteins': 4, 'fats': 2, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Rabri': {'calories': 300, 'carbohydrates': 25, 'proteins': 6, 'fats': 18, 'vitamins': {'Vitamin A', 'Vitamin D', 'Vitamin B12'}},
'Rajma Chawal': {'calories': 250, 'carbohydrates': 38, 'proteins': 9, 'fats': 6, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Rasgulla': {'calories': 180, 'carbohydrates': 25, 'proteins': 4, 'fats': 6, 'vitamins': {'Vitamin A', 'Vitamin D', 'Vitamin B2'}},
'Rasmalai': {'calories': 250, 'carbohydrates': 22, 'proteins': 7, 'fats': 14, 'vitamins': {'Vitamin A', 'Vitamin D', 'Vitamin B12'}},
'Rava Kichadi': {'calories': 200, 'carbohydrates': 28, 'proteins': 5, 'fats': 8, 'vitamins': {'Vitamin A', 'Vitamin B1', 'Vitamin C'}},
'Rice': {'calories': 130, 'carbohydrates': 28, 'proteins': 2, 'fats': 0.3, 'vitamins': {'Vitamin B1', 'Vitamin E', 'Vitamin B6'}},
'Sambar': {'calories': 150, 'carbohydrates': 18, 'proteins': 6, 'fats': 4, 'vitamins': {'Vitamin A', 'Vitamin C', 'Vitamin B1'}},
'Samosa': {'calories': 260, 'carbohydrates': 28, 'proteins': 4, 'fats': 14, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin D'}},
'Sarson ka Saag Makki ki Roti': {'calories': 320, 'carbohydrates': 35, 'proteins': 8, 'fats': 14, 'vitamins': {'Vitamin A', 'Vitamin C', 'Vitamin K'}},
'Shankarpali': {'calories': 170, 'carbohydrates': 24, 'proteins': 2, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin D'}},
'Shrikhand': {'calories': 200, 'carbohydrates': 20, 'proteins': 6, 'fats': 10, 'vitamins': {'Vitamin A', 'Vitamin B2', 'Vitamin D'}},
'Siddu': {'calories': 220, 'carbohydrates': 30, 'proteins': 6, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}},
'Sohan Papdi': {'calories': 180, 'carbohydrates': 28, 'proteins': 2, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin E', 'Vitamin A'}},
'Somaas': {'calories': 210, 'carbohydrates': 22, 'proteins': 4, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin D'}},
'Tandoori Chicken': {'calories': 270, 'carbohydrates': 4, 'proteins': 28, 'fats': 14, 'vitamins': {'Vitamin B12', 'Vitamin D', 'Vitamin A'}},
'Thepla': {'calories': 180, 'carbohydrates': 20, 'proteins': 4, 'fats': 8, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin C'}},
'Ulunthu Vada': {'calories': 200, 'carbohydrates': 22, 'proteins': 5, 'fats': 10, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Upma': {'calories': 190, 'carbohydrates': 28, 'proteins': 4, 'fats': 6, 'vitamins': {'Vitamin B1', 'Vitamin A', 'Vitamin C'}},
'Uthapam': {'calories': 180, 'carbohydrates': 30, 'proteins': 5, 'fats': 4, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin D'}},
'Vada Pav': {'calories': 300, 'carbohydrates': 35, 'proteins': 6, 'fats': 14, 'vitamins': {'Vitamin B1', 'Vitamin C', 'Vitamin A'}}

}
    

def predict_food_from_memory(file: InMemoryUploadedFile):
    try:
        file_stream = io.BytesIO(file.read())
        img = image.load_img(file_stream, target_size=(224, 224))
        img_array = image.img_to_array(img) / 255.0
        img_array = np.expand_dims(img_array, axis=0)

        predictions = food_model.predict(img_array)[0]
        top_idx = np.argmax(predictions)
        top_label = className[top_idx]
        nutririons = dishes_nutrition[top_label]
        confidence = float(predictions[top_idx])

        return {
            "prediction": top_label,
            "nutririons" : nutririons,
            "confidence": round(confidence, 4)
        }
    except Exception as e:
        return {"error": str(e)}
