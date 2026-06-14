from fastapi import FastAPI, UploadFile, File
from deepface import DeepFace
import tempfile
import shutil
import cv2
import numpy as np

app = FastAPI()


def analyze_skin(image_path):
    img = cv2.imread(image_path)

    if img is None:
        return None

    img = cv2.resize(img, (512, 512))

    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    brightness = np.mean(hsv[:, :, 2])
    redness = np.mean(img[:, :, 2]) - np.mean(img[:, :, 1])
    texture = cv2.Laplacian(gray, cv2.CV_64F).var()
    pigmentation = np.std(gray)

    brightness_score = float(np.clip(brightness / 255 * 100, 0, 100))
    redness_score = float(np.clip(100 - redness, 0, 100))
    texture_score = float(np.clip(100 - texture / 10, 0, 100))
    pigmentation_score = float(np.clip(100 - pigmentation, 0, 100))

    skin_score = (
        brightness_score * 0.25
        + redness_score * 0.25
        + texture_score * 0.25
        + pigmentation_score * 0.25
    )

    skin_age = 55 - skin_score * 0.20 + (100 - pigmentation_score) * 0.12
    skin_age = int(np.clip(round(skin_age), 18, 80))

    return {
        "skin_score": skin_score,
        "skin_age": skin_age,
        "brightness_score": brightness_score,
        "redness_score": redness_score,
        "texture_score": texture_score,
        "pigmentation_score": pigmentation_score,
    }


@app.post("/analyze")
async def analyze(file: UploadFile = File(...)):
    with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as tmp:
        shutil.copyfileobj(file.file, tmp)
        image_path = tmp.name

    skin = analyze_skin(image_path)

    if skin is None:
        return {"error": "Could not read image"}

    gender = "Unknown"
    deepface_age = None

    try:
        face_result = DeepFace.analyze(
            img_path=image_path,
            actions=["age", "gender"],
            enforce_detection=False,
        )

        if isinstance(face_result, list):
            face_result = face_result[0]

        deepface_age = int(face_result.get("age", 0))
        gender = face_result.get("dominant_gender", "Unknown")

    except Exception:
        pass

    if deepface_age:
        ai_skin_age = int(round(deepface_age * 0.3 + skin["skin_age"] * 0.7))
    else:
        ai_skin_age = skin["skin_age"]

    return {
        "gender": gender,
        "skin_score": round(skin["skin_score"], 1),
        "ai_skin_age": ai_skin_age,
        "brightness_score": round(skin["brightness_score"], 1),
        "redness_score": round(skin["redness_score"], 1),
        "texture_score": round(skin["texture_score"], 1),
        "pigmentation_score": round(skin["pigmentation_score"], 1),
        "main_concern": "Pigmentation / uneven skin tone",
    }
