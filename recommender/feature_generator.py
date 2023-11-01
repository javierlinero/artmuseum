import codecs
import contextlib
import io
import pickle
import PIL
import requests
import tensorflow as tf
import torch
from keras.preprocessing.image import img_to_array
import psycopg2

resnet = tf.keras.applications.resnet50.ResNet50(
    include_top=True,
    weights='imagenet',
    input_tensor=None,
    input_shape=None,
    pooling=None,
    classes=1000,
)

def url_to_features(url):
  try:
    img_url_ext = '/full/full/0/default.jpg'
    url = url + img_url_ext
    res = requests.get(url)
    img = PIL.Image.open(io.BytesIO(res.content)).resize((224, 224), PIL.Image.Resampling.LANCZOS)
    img = img_to_array(img)
    return torch.from_numpy(resnet([img[None, :]]).numpy())
  except:
    return None

def write_tensor_to_file(file, tensor):
  file.write(codecs.encode(pickle.dumps(tensor.numpy()), "base64").decode())

def write_features():
  num_features = 3
  with psycopg2.connect(database="init_db",
                        user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                        host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                        port="5432", sslmode="require") as connection:
    with contextlib.closing(connection.cursor()) as cursor:

      query_str = 'SELECT artwork_id, imageurl FROM artworks'
      cursor.execute(query_str)
      artwork_table = cursor.fetchall()

      i = 0
      for row in artwork_table:
        file = open('features/' + str(row[0]), 'w')
        write_tensor_to_file(file, url_to_features(row[1]))

        i += 1
        if num_features != -1 and i == num_features:
          break

if __name__ == '__main__':
  write_features()
