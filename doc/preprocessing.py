import numpy as np
import pandas as pd

src = pd.read_csv("../data/us_county_latlng.csv")
src['fipsCountyCode'] = src['fipsCountyCode'].apply(lambda x: f"{x:05}")

df = pd.read_csv("../data/DisasterDeclarationsSummaries.csv")
df['declarationYear'] = df['declarationDate'].str.extract(r'(\d{4})')
df['latitude'] = np.nan
df['longitude'] = np.nan

for index, row in df.iterrows():
    string_number = f"{df.at[index,'fipsStateCode']:02}{df.at[index,'fipsCountyCode']:03}"
    matching_rows = src.loc[src['fipsCountyCode'] == string_number]
    if not matching_rows.empty:
        df.at[index, 'latitude'] = matching_rows.iloc[0]['lat']
        df.at[index, 'longitude'] = matching_rows.iloc[0]['lng']
df.to_csv("../out/DisasterDeclarationsSummariesCleaned.csv")

incidentTypes = df['incidentType'].unique()
incidentTypesCleaned = [s.replace(" ", "").replace("/", "") for s in incidentTypes]
for i in range(len(incidentTypes)):
    temp = df.loc[df['incidentType']==incidentTypes[i]]
    temp.to_csv(f"../out/DisasterDeclarationsSummaries{incidentTypesCleaned[i]}.csv", index=False)

for declarationYear in df['declarationYear'].unique():
    temp = df.loc[df['declarationYear']==declarationYear]
    temp.to_csv(f"../out/DisasterDeclarationsSummaries{declarationYear}.csv", index=False)