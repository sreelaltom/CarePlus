from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import JSONResponse
from PIL import Image
import numpy as np
import os
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image


app = FastAPI()

MODEL_PATHS = {
    "chest_cancer": os.path.join("artifacts","training","model.h5"),
    #"brain_tumor": os.path.join("models", "brain_tumor_model.h5"),
    #"kidney_stone": os.path.join("models", "kidney_stone_model.h5"),
}


def load_selected_model(model_type):
    if model_type in MODEL_PATHS:
        return load_model(MODEL_PATHS[model_type])
    else:
        return None


def predict_cancer(model,image_path):
    try:
        test_image = image.load_img(image_path, target_size=(224, 224))  
        test_image = image.img_to_array(test_image) / 255.0  
        test_image = np.expand_dims(test_image, axis=0)

        prediction_probs = model.predict(test_image) 

        if prediction_probs.shape[1] == 1: #(single neuron output)
            confidence_score = float(prediction_probs[0][0])
            prediction_label = "Normal" if confidence_score > 0.5 else "Adenocarcinoma Cancer"
        else:  #(multiple neurons output)
            predicted_class = np.argmax(prediction_probs)
            confidence_score = float(np.max(prediction_probs))
            class_labels = ["Adenocarcinoma Cancer", "Normal"] 
            prediction_label = class_labels[predicted_class]

        return {
            "prediction": prediction_label,
            "confidence": round(confidence_score, 4)
        }

    except Exception as e:
        return {"error": str(e)}

@app.post("/predict/")
async def predict(file: UploadFile = File(...), model_type: str = Form(...)):
    model = load_selected_model(model_type)
    if model is None:
        return JSONResponse(content={"error": "Invalid model type. Choose from chest_cancer, brain_tumor, kidney_stone"}, status_code=400)

    image_path = os.path.join("uploaded_images", file.filename)
    os.makedirs("uploaded_images", exist_ok=True)

    with open(image_path, "wb") as f:
        f.write(await file.read())

    result = predict_cancer(model, image_path)

    return JSONResponse(content={"model": model_type, "prediction": result["prediction"], "confidence": result["confidence"]})
