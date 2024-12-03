import wave

def wav_to_coe(wav_file, coe_file):
    with wave.open(wav_file, 'rb') as wav:
        # Ellenőrizzük a WAV fájl paramétereit
        num_channels = wav.getnchannels()
        sample_width = wav.getsampwidth()  # 2 byte -> 16 bit
        sample_rate = wav.getframerate()
        num_frames = wav.getnframes()

        if sample_width != 2:
            raise ValueError("Csak 16 bites WAV fájl támogatott.")
        if num_channels != 1:
            raise ValueError("Csak monó WAV fájl támogatott.")

        # Minták beolvasása
        frames = wav.readframes(num_frames)
        samples = [int.from_bytes(frames[i:i+2], byteorder='little', signed=True)
                   for i in range(0, len(frames), 2)]

    # COE fájl létrehozása
    with open(coe_file, 'w') as coe:
        coe.write("memory_initialization_radix=10;\n")  # Decimális formátum
        coe.write("memory_initialization_vector=\n")
        
        for i, sample in enumerate(samples):
            coe.write(f"{sample}")
            if i < len(samples) - 1:
                coe.write(",\n")  # Az utolsó minta után ne legyen vessző
            else:
                coe.write(";\n")

    print(f"COE fájl létrehozva: {coe_file}")


# Használat
#wav_to_coe("input.wav", "output.coe")
