import numpy as np
import pandas as pd

import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.callbacks import EarlyStopping

from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, classification_report

#Getting data for training
data = pd.read_excel("/content/FireRiskDataExamples.xlsx", engine="openpyxl")

data.columns = [
    'Temperatura', 'Humedad', 'Viento',
    'Var4', 'Var5', 'Var6', 'Var7', 'Var8', 'Var9', 'Riesgo'
]

#Inputs and Outputs

X = data[['Temperatura', 'Humedad', 'Viento']].values
y = data['Riesgo'].values

print(X.shape)
print(y.shape)

#We normalized the entries
X_norm = np.zeros_like(X, dtype=float)

X_norm[:, 0] = X[:, 0] / 50
X_norm[:, 1] = X[:, 1]
X_norm[:, 2] = X[:, 2] / 100

#We check the normalized examples are correctly
for i in range(5):
  print(
      f"Temp: {X[i, 0]} -> {X_norm[i, 0]: .3f} | "
      f"Hum: {X[i, 1]} -> {X_norm[i, 1]: .3f} | "
      f"Viento: {X[i, 2]} -> {X_norm[i, 2]: .3f} | "
  )


#We divided the datasets
X_temp, X_test, y_temp, y_test = train_test_split(
    X_norm, y,
    test_size=0.15,
    random_state=42,
    stratify=y
)

X_train, X_val, y_train, y_val = train_test_split(
    X_temp, y_temp,
    test_size=0.176,
    random_state=42,
    stratify=y_temp
)

print(f"Total: {X_norm.shape[0]}")
print(f"Total: {X_train.shape[0]}")
print(f"Total: {X_val.shape[0]}")
print(f"Total: {X_test.shape[0]}")

#We define the model and compile it
model = Sequential([
    Dense(8, activation="relu", input_shape=(3,)),
    Dense(3, activation="softmax")
])

model.compile(
    optimizer="adam",
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"]
)

#Early stop -> Stop training if the loss does not improve during validation.
early_stop = EarlyStopping(
    monitor="val_loss",
    patience=10,
    restore_best_weights=True
)

for layer in model.layers:
  print(layer.name, layer.activation)

for i, layer in enumerate(model.layers):
  weights = layer.get_weights()
  if weights:
    print(f"Capa {i} pesos:", weights[0].shape, "bias:", weights[1].shape)


#Training
history = model.fit(
    X_train, y_train,
    validation_data=(X_val, y_val),
    epochs=200,
    batch_size=16,
    callbacks=[early_stop],
    verbose=1
)

#We create graphics of Loss
import matplotlib.pyplot as plt
plt.plot(history.history["loss"], label="train")
plt.plot(history.history["val_loss"], label="val")
plt.legend()
plt.show()

#We evaluated the model.
test_loss, test_acc = model.evaluate(X_test, y_test)
print("Test accuracy:", test_acc)

y_pred = np.argmax(model.predict(X_test), axis=1)

print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))


#We show how the network turned out.
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

nn_structure = [3, 8, 3]
input_names = ["Temperature", "Humidity", "Wind"]
output_names = ["HIGH", "MEDIUM", "LOW"]

dot = plot_neural_network(nn_structure, input_labels=input_names, output_labels=output_names)
dot.render("network", format="png", view=True)

#PDF with graphs to view results
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import seaborn as sns
import numpy as np
from sklearn.metrics import confusion_matrix, roc_curve, auc
from sklearn.preprocessing import label_binarize

with PdfPages("analisis_modelo.pdf") as pdf:
  # Accuracy
    plt.figure()
    plt.plot(history.history['accuracy'], label='Train Accuracy')
    plt.plot(history.history['val_accuracy'], label='Val Accuracy')
    plt.xlabel('Epochs')
    plt.ylabel('Accuracy')
    plt.legend()
    plt.title('Accuracy vs Epochs')
    pdf.savefig()
    plt.close()

    # Loss
    plt.figure()
    plt.plot(history.history['loss'], label='Train Loss')
    plt.plot(history.history['val_loss'], label='Val Loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.title('Loss vs Epochs')
    pdf.savefig()
    plt.close()

    y_pred = model.predict(X_test)
    y_pred_classes = np.argmax(y_pred, axis=1)

    cm = confusion_matrix(y_test, y_pred_classes)

    plt.figure()
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
    plt.xlabel('Predicted')
    plt.ylabel('True')
    plt.title('Confusion Matrix')
    pdf.savefig()
    plt.close()

    max_probs = np.max(y_pred, axis=1)

    plt.figure()
    plt.hist(max_probs, bins=20)
    plt.xlabel('Confidence')
    plt.ylabel('Samples')
    plt.title('Prediction Confidence Distribution')
    pdf.savefig()
    plt.close()

    y_test_bin = label_binarize(y_test, classes=[0, 1, 2])

    plt.figure()
    for i in range(3):
        fpr, tpr, _ = roc_curve(y_test_bin[:, i], y_pred[:, i])
        roc_auc = auc(fpr, tpr)
        plt.plot(fpr, tpr, label=f'Clase {i} (AUC = {roc_auc:.2f})')

    plt.plot([0, 1], [0, 1], 'k--')
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.legend()
    plt.title('ROC Curves Multiclass')
    pdf.savefig()
    plt.close()

    img = mpimg.imread('network.png')

    plt.figure(figsize=(8, 6))
    plt.imshow(img)
    plt.axis('off')
    plt.title('Neural Network Architecture')
    pdf.savefig()
    plt.close()


# We export the model as a tflite model
import tensorflow as tf

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open("modelo_riesgo.tflite", "wb") as f:
    f.write(tflite_model)

print("Modelo exportado a TensorFlow Lite")

#Save and convert for using on MultiRiskApp
model.save("fire_model.keras")

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open("fire_model.tflite", "wb") as f:
    f.write(tflite_model)

print("Ready for using")