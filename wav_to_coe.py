import wave

def wav_to_coe(wav_file, coe_file):
    try:
        # WAV fájl megnyitása
        with wave.open(wav_file, 'rb') as wav:
            # Minták tulajdonságainak ellenőrzése
            channels = wav.getnchannels()
            sample_width = wav.getsampwidth()
            frame_rate = wav.getframerate()
            num_frames = wav.getnframes()

            if channels != 1:
                raise ValueError("Csak mono WAV fájl támogatott.")
            if sample_width != 2:
                raise ValueError("Csak 16 bites WAV fájl támogatott.")

            # Minták olvasása
            frames = wav.readframes(num_frames)
            
            # Minták átalakítása hexadecimális formátumba
            samples = [frames[i] + (frames[i + 1] << 8) for i in range(0, len(frames), 2)]
            samples = [sample if sample < 32768 else sample - 65536 for sample in samples]  # Signed 16-bit conversion

        # COE fájl létrehozása
        with open(coe_file, 'w') as coe:
            coe.write("memory_initialization_radix=16;\n")
            coe.write("memory_initialization_vector=\n")
            coe.write(",\n".join(f"{sample & 0xFFFF:04X}" for sample in samples))
            coe.write(";\n")
        print(f"A COE fájl sikeresen létrehozva: {coe_file}")

    except Exception as e:
        print(f"Hiba történt: {e}")

# Használat
wav_to_coe("song.wav", "song_wav.coe")
