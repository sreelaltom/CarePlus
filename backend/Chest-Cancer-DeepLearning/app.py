import streamlit as st
from PIL import Image
import os
from ChestCancerDetection.pipeline.prediction import PredictionPipeline

# Streamlit UI
st.title("🩺 Chest Cancer Detection")
st.write("Upload an X-ray or MRI image for cancer detection.")

# File uploader
uploaded_file = st.file_uploader("Choose an image...", type=["jpg", "png", "jpeg"])

if uploaded_file is not None:
    # Save uploaded file
    image_path = os.path.join("uploaded_images", uploaded_file.name)
    os.makedirs("uploaded_images", exist_ok=True)

    with open(image_path, "wb") as f:
        f.write(uploaded_file.getbuffer())

    # Display uploaded image
    image = Image.open(uploaded_file)
    resized_image = image.resize((200, 200)) 
    st.image(resized_image, caption="Uploaded Image", use_column_width=False)

    # Make Prediction
    predictor = PredictionPipeline(image_path)
    result = predictor.predict()

    # Display result
    st.subheader("Prediction Result:")
    st.success(f"🔬 {result['image']}")
    
    # Display confidence score
    st.write(f"Confidence Score: **{result['confidence']:.4f}**")
