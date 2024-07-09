import sounddevice as sd
import wave
import subprocess
import os
from pathlib import Path
import numpy as np

def record_audio(filename, duration, fs=44100):
    print("Recording...")
    recording = sd.rec(int(duration * fs), samplerate=fs, channels=2, dtype='int16')
    sd.wait()
    print("Recording finished")

    # Save the recording to a WAV file
    with wave.open(filename, 'w') as wf:
        wf.setnchannels(2)
        wf.setsampwidth(2)
        wf.setframerate(fs)
        wf.writeframes(recording.tobytes())

def run_octave_script(script_name):
    octave_path = r'"C:\Program Files\GNU Octave\Octave-9.1.0\octave-launch.exe"'
    command = f'{octave_path} --eval "{script_name}"'
    print(f"Running command: {command}")
    subprocess.run(command, shell=True, check=True)

def play_audio(filename):
    print("Playing audio...")
    # Open the WAV file
    wf = wave.open(filename, 'rb')
    # Extract audio parameters
    fs = wf.getframerate()
    channels = wf.getnchannels()
    frames = wf.readframes(wf.getnframes())
    # Convert frames to numpy array
    frames = np.frombuffer(frames, dtype='int16')
    # Reshape the frames to match the number of channels
    frames = frames.reshape(-1, channels)
    # Play the audio
    sd.play(frames, samplerate=fs)
    sd.wait()
    print("Audio playback finished")

# Define the project directory
project_dir = Path(__file__).parent.resolve() 

# Define file paths
input_audio_filename = 'voz_original.wav'
output_audio_filename = 'voz_modificada_manual.wav'
input_audio_path = project_dir / input_audio_filename
output_audio_path = project_dir / output_audio_filename

# Parameters
duration = 5  # seconds
script_name = 'pitch'

# Record audio
record_audio(str(input_audio_path), duration)

# Check if file was saved correctly
if input_audio_path.exists():
    print(f"File {input_audio_path} saved successfully.")
else:
    print(f"File {input_audio_path} not found. Please check the recording process.")

# Run Octave script
run_octave_script(script_name)
print("Processed successfully.")

# Play the processed audio
play_audio(str(output_audio_path))
