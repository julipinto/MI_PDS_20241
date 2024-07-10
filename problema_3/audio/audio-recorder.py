import tkinter as tk
from tkinter import messagebox
from tkinter import PhotoImage
import sounddevice as sd
import wave
import subprocess
import os
from pathlib import Path
import numpy as np

class AudioRecorderApp:
    def __init__(self, master):
        self.master = master
        master.title("")
        master.geometry("300x300")
        master.configure(bg='#f0f0f0')

        self.is_recording = False

        self.mic_icon = PhotoImage(file="mic.png")
        self.mic_icon_recording = PhotoImage(file="mic_recording.png")
        self.play_icon = PhotoImage(file="play.png")
        self.stop_icon = PhotoImage(file="stop.png")
        self.loading_icon = PhotoImage(file="loading.png")

        self.label = tk.Label(master, text="Pitch Recorder - MI PDS", font=("Helvetica", 16), bg='#f0f0f0')
        self.label.pack(pady=10)

        self.mic_button = tk.Button(master, image=self.mic_icon, command=self.start_recording, bg='#f0f0f0', bd=0)
        self.mic_button.pack(pady=20)

        self.stop_button = tk.Button(master, image=self.stop_icon, command=self.stop_recording, bg='#f0f0f0', bd=0)
        self.stop_button.pack(pady=20)

        self.play_button = tk.Button(master, image=self.play_icon, command=self.play_audio, bg='#f0f0f0', bd=0)
        self.play_button.pack(pady=20)

        self.project_dir = Path(__file__).parent.resolve()
        self.input_audio_filename = 'voz_original.wav'
        self.output_audio_filename = 'voz_modificada_manual.wav'
        self.input_audio_path = self.project_dir / self.input_audio_filename
        self.output_audio_path = self.project_dir / self.output_audio_filename

        self.recording = None
        self.fs = 44100

    def start_recording(self):
        if not self.is_recording:
            self.is_recording = True

            self.mic_button.config(image=self.mic_icon_recording)
            self.play_button.config(image=self.loading_icon)

            self.recording = sd.rec(int(10 * self.fs), samplerate=self.fs, channels=2, dtype='int16')
            self.master.after(10000, self.stop_recording)

    def stop_recording(self):
        if self.is_recording:
            sd.stop()
            self.is_recording = False
            self.mic_button.config(image=self.mic_icon)
            messagebox.showinfo("", "Gravação finalizada!")
            self.save_recording()

    def save_recording(self):
        with wave.open(str(self.input_audio_path), 'w') as wf:
            wf.setnchannels(2)
            wf.setsampwidth(2)
            wf.setframerate(self.fs)
            wf.writeframes(self.recording.tobytes())
        self.run_octave_script('pitch')
        messagebox.showinfo("", "Áudio processado com sucesso!")
        self.play_button.config(image=self.play_icon)

    def run_octave_script(self, script_name):
        octave_path = r'"C:\Program Files\GNU Octave\Octave-9.1.0\octave-launch.exe"'
        command = f'{octave_path} --eval "{script_name}"'
        subprocess.run(command, shell=True, check=True)

    def play_audio(self):
        if self.output_audio_path.exists():
            wf = wave.open(str(self.output_audio_path), 'rb')
            fs = wf.getframerate()
            channels = wf.getnchannels()
            frames = wf.readframes(wf.getnframes())
            frames = np.frombuffer(frames, dtype='int16')
            frames = frames.reshape(-1, channels)
            sd.play(frames, samplerate=fs)
            sd.wait()           
        else:
            messagebox.showerror("Error", f"File {self.output_audio_filename} not found")

if __name__ == "__main__":
    root = tk.Tk()
    app = AudioRecorderApp(root)
    root.mainloop()