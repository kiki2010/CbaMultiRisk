import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout

#We get the data for training
data = pd.read_excel('/content/sample_data/DATOS_PARA_IA.xlsx', engine='openpyxl')

print(data.head())

data[['SPI', 'Precipitaciones', 'Intensidad', 'Humedad']] = data[['SPI', 'Precipitaciones', 'Intensidad', 'Humedad']].apply(pd.to_numeric, errors='coerce')

print(data[['SPI', 'Precipitaciones', 'Intensidad', 'Humedad']].isnull().sum())


X = data[['SPI', 'Precipitaciones', 'Intensidad', 'Humedad']].values
y = data['Riesgo']

scaler = StandardScaler()
X = scaler.fit_transform(X)

y = tf.keras.utils.to_categorical(y, num_classes=3)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

#Created the model
model = Sequential([
    Dense(8, activation='relu', input_shape=(4,)),  #4 entries
    Dropout(0.2),
    Dense(8, activation='relu'),
    Dense(3, activation='softmax')  # 3 outputs
])

#Compile the model
model.compile(optimizer='adam',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

#Train the model
history = model.fit(X_train, y_train,
                    validation_split=0.2,
                    epochs=500,
                    batch_size=16,
                    verbose=1)

loss, accuracy = model.evaluate(X_test, y_test)
print(f"loss: {loss:.4f}, accuracy: {accuracy:.4f}")

#Test the model
sample_input = [[4.0645, 47.50, 30.57, 0.57]]
sample_input_scaled = scaler.transform(sample_input)
sample_prediction = model.predict(sample_input_scaled)
predicted_class = np.argmax(sample_prediction, axis=1)

print(f"entry: {sample_input}")
print(f"predict: {predicted_class[0]}")

# Save
model.save("model.keras")

# Load
model = tf.keras.models.load_model('model.keras')

# Transform
converter = tf.lite.TFLiteConverter.from_keras_model(model)

tflite_model = converter.convert()

# save as .tflite
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)

print("Modelo convertido y guardado como 'model.tflite'")

import numpy as np
import tensorflow.lite as tflite

# Load the TFLite model
interpreter = tflite.Interpreter(model_path='model.tflite')
interpreter.allocate_tensors()

# Get input and output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Create input data
sample_input = np.array([[4.0645, 47.50, 30.57, 0.57]], dtype=np.float32)

# Set the data to the model
interpreter.set_tensor(input_details[0]['index'], sample_input)

# Run inference
interpreter.invoke()

# Retrieve the output result
output_data = interpreter.get_tensor(output_details[0]['index'])
predicted_class = np.argmax(output_data, axis=1)

print(f"Prediction result: {predicted_class[0]}")

from graphviz import Digraph

def plot_neural_network(layers, input_labels=None, output_labels=None):
    dot = Digraph()
    dot.attr(bgcolor="white")

    for i, label in enumerate(input_labels or range(layers[0])):
        dot.node(f"I{i}", shape="circle", style="filled", fillcolor="lightblue",
                 label=label, width="1", height="1", fixedsize="true")

    for l, num_neurons in enumerate(layers[1:]):
        for n in range(num_neurons):
            color = "lightcoral" if l < len(layers) - 2 else "lightgreen"
            label = output_labels[n] if l == len(layers) - 2 and output_labels else f"H{l+1}-{n+1}"
            dot.node(f"L{l+1}N{n}", shape="circle", style="filled", fillcolor=color,
                     label=label, width="1", height="1", fixedsize="true")

    for i in range(layers[0]):
        for n in range(layers[1]):
            dot.edge(f"I{i}", f"L1N{n}")

    for l in range(1, len(layers)-1):
        for n1 in range(layers[l]):
            for n2 in range(layers[l+1]):
                dot.edge(f"L{l}N{n1}", f"L{l+1}N{n2}")

    return dot

nn_structure = [4, 8, 8, 3]
input_names = ["SPI", "Humidity", "Precip.", "Precip. Rate"]
output_names = ["HIGH", "MEDIUM", "LOW"]

dot = plot_neural_network(nn_structure, input_labels=input_names, output_labels=output_names)
dot.render("network", format="png", view=True)