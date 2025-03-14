import numpy as np
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import os



class PredictionPipeline:
    def __init__(self,filename):
        self.filename =filename


    
    def predict(self):
        ## load model
        
        model = load_model(os.path.join("artifacts","training", "model.h5"))
        #model = load_model(os.path.join("model", "model.h5"))

         # Load and preprocess the image
        test_image = image.load_img(self.filename, target_size=(224, 224))
        test_image = image.img_to_array(test_image) / 255.0  # Normalize
        test_image = np.expand_dims(test_image, axis=0)

        # Get prediction probabilities
        prediction_probs = model.predict(test_image)[0]  # Get the first (and only) sample
        confidence_score = np.max(prediction_probs)  # Get the highest probability

        # Get class label
        class_index = np.argmax(prediction_probs)
        class_names = ["Adenocarcinoma Cancer", "Normal"]  # Update this as per your model
        prediction_label = class_names[class_index]

        return {
            "image": prediction_label,
            "confidence": confidence_score
        }