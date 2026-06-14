# AI Beauty App

AI Beauty App is an AI-powered iOS application that helps users analyze skin conditions, estimate skin age, track beauty progress, and receive personalized skincare recommendations.

## Overview

The goal of this project is to build an AI beauty assistant that can:

* Analyze facial images
* Detect skin concerns
* Estimate skin age
* Recommend skincare products and treatments
* Track improvements over time
* Measure the effectiveness of skincare routines and aesthetic treatments

## Current MVP (Version 0.1)

The first working version focuses on AI-powered facial and skin analysis.

### Features

#### Facial Analysis

* Age estimation using DeepFace
* Gender prediction using DeepFace

#### Skin Analysis

* Skin score calculation
* Estimated skin age
* Brightness analysis
* Redness analysis
* Texture analysis
* Pigmentation analysis

#### Mobile App

* Photo upload
* Camera integration
* Analysis results display
* SwiftUI user interface

## Architecture

### Frontend

* SwiftUI
* iOS

### Backend

* FastAPI
* Python

### Computer Vision

* OpenCV (cv2)
* DeepFace
* NumPy

## Workflow

1. User uploads a facial photo.
2. SwiftUI sends the image to a FastAPI backend.
3. OpenCV extracts skin-related features:

   * Brightness
   * Redness
   * Texture
   * Pigmentation
4. DeepFace predicts:

   * Age
   * Gender
5. The backend calculates:

   * Skin Score
   * AI Skin Age
6. Results are returned to the iOS app.

## Planned Features

### Recommendation Engine

* Personalized skincare recommendations
* Product suggestions
* Treatment recommendations
* Lifestyle improvement suggestions

### Beauty Progress Tracking

* Historical analysis records
* Skin score trends
* AI age trends
* Beauty journey tracking

### Before & After Comparison

* Improvement score
* Side-by-side comparison
* AI-generated progress summary

### AI Beauty Coach

* Conversational beauty assistant
* Personalized beauty guidance
* Long-term skin improvement planning

## Project Status

Current Status: MVP in Development

Completed:

* SwiftUI application
* FastAPI backend
* DeepFace integration
* OpenCV skin analysis
* Skin scoring algorithm
* AI skin age estimation

In Progress:

* Recommendation engine
* Prompt engineering
* UI improvements

Planned:

* User accounts
* History tracking
* Before/after comparison
* Cloud deployment
* AI Beauty Coach

## Documentation

See:

* AI Beauty App Design and Plan.md

for detailed product vision, roadmap, feature design, and sprint planning.

## Author

Fang Fang

M.S. Computer Science
San Jose State University
