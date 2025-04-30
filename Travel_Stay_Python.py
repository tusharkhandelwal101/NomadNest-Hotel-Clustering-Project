import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt


import mysql.connector

from sqlalchemy.engine.url import URL
from sqlalchemy import create_engine

db_url = URL.create(
    drivername="mysql+mysqlconnector",
    username="root",
    password="Tushar@123",  
    host="localhost",
    port=3306,
    database="project_traveldb"
)

engine = create_engine(db_url)


# Fetch the updated data (assuming table name is Travel_Stay_Data)
df = pd.read_sql("SELECT * FROM Travel_Stay_Data", con=engine)



# # Convert dates to datetime format
# df['CheckInDate'] = pd.to_datetime(df['CheckInDate'], format='%Y-%m-%d')
# df['CheckOutDate'] = pd.to_datetime(df['CheckOutDate'], format='%Y-%m-%d')



# Group data by City and RoomType to get average values
grouped = df.groupby(['City', 'RoomType']).agg({
    'OccupancyRate': 'mean',
    'RevenuePerBed': 'mean',
    'CustomerAcquisitionCost': 'mean',
    'FeedbackRating': 'mean',
    'StayDuration': 'mean'
}).reset_index()

# Step 4: Encode categorical variables and scale numerical ones
ct = ColumnTransformer(transformers=[
    ('encoder', OneHotEncoder(), ['City', 'RoomType'])  # Encode City and RoomType
], remainder='passthrough')  # Keep the remaining columns (numerical ones)

X = ct.fit_transform(grouped)

# Step 5: Standardize the data (with_mean=False to handle sparse matrix)
sc = StandardScaler(with_mean=False)  # with_mean=False to avoid error with sparse matrix
X_scaled = sc.fit_transform(X)

# Step 6: Clustering with KMeans
kmeans = KMeans(n_clusters=4, random_state=42)  # Choose the number of clusters (4 here)
grouped['Cluster'] = kmeans.fit_predict(X_scaled)  # Assign the cluster labels

# Step 7: Visualize the Elbow Method to determine optimal K
wcss = []
for i in range(1, 11):  # Trying different values of K (1 to 10)
    kmeans = KMeans(n_clusters=i, init='k-means++', random_state=42)
    kmeans.fit(X_scaled)
    wcss.append(kmeans.inertia_)

plt.plot(range(1, 11), wcss)
plt.xlabel("No. of Clusters")
plt.ylabel("WCSS (Within-Cluster Sum of Squares)")
plt.title("Elbow Method for Optimal K")
plt.show()

# Step 8: Export the result for Power BI or further analysis
grouped.to_csv("TravelClusterOutput.csv", index=False)

# Step 9: Check the final clustered data
grouped.head()
