import os

def MakeSamplesArray(directory):
    samples = []
    for sample in os.listdir(directory):
        if not sample.startswith('.'):
            samples.append(sample)