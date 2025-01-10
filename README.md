# Fedőlap

**Projekt címe:** Hanglejátszó megvalosítása FPGA fejlesztő lapon

**Hallgató neve:** Lőrincz Norbert Attila

**Szak:** Számítástehcnika

**Tantárgy:** Újrakonfigurálható digitális áramkörök

**Projekt véglegesítésének időpontja:** 2025.01.10

# Pontozás (saját vélemény)
| Feladat            | Pontszám |
| ------------------ | -------- |
| Jelenlét           | 13 |
| Általános          | 8 |
| Tervezés           | 8 |
| Mérések            | 0 |
| Dokumentáció össz. | 16 |
| Tervezés           | 9 |
| Implementálás      | 8 |
| Szimuláció         | 7 |
| Valós megvalósítás | 0 |
| Valós rendszer     | 0 |
| Projekt össz.      | 24 |
| Kérdések           | - |
| Összesen           | - |


# Projekt célja

A projekt célja egy Nexys A7-100T modellű FPGA-alapú hanglejátszó rendszer megvalósítása, amely képes digitális hangminták kezelésére és lejátszására, PWM alapú jelgenerálással. A rendszer magában foglalja a memóriaadatok vezérlését, időzítést és hangkimenet előállítását, mindez komplex állapotgépek kivitelezésével, amely a gördülékenyebb munkafolyamathoz járul hozzá.

# Követelmények

### Funkcionális követelmények:

1.  **Hangminták lejátszása**:  
    A rendszernek képesnek kell lennie digitális hangminták beolvasására és lejátszására az FPGA-n keresztül.
    
2.  **PWM alapú jelgenerálás**:  
    A rendszernek impulzusszélesség-modulációt (PWM) kell alkalmaznia a digitális hangminták analóg jellé alakításához.
    
3.  **Memória vezérlése**:  
    A blokk memória (BRAM) megfelelő kezelésének biztosítása az adatok írásához, olvasásához és lejátszáshoz.
    
4.  **Mintavételezési időzítés**:  
    Az audiolejátszáshoz szükséges mintavételezési frekvencia pontos előállítása.
    
5.  **Lejátszási vezérlés**:  
    A rendszernek támogatnia kell az audio lejátszásának, megállításának és szüneteltetésének vezérlését (play, stop, pause funkciók).
    
6.  **Reset funkció**:  
    A rendszernek képesnek kell lennie visszaállítani az alapállapotot a rendszer újraindításához.

### **Nem funkcionális követelmények**

1.  **Valós idejű működés**:  
    A lejátszásnak valós időben, késleltetés nélkül kell történnie.
    
2.  **Pontosság**:  
    A mintavételezési frekvencia (pl. 44,1 kHz) pontos betartása szükséges a minőségi hangkimenet érdekében.
    
3.  **Rendszer stabilitása**:  
    A rendszernek stabilan kell működnie hosszabb távú lejátszás során is, memóriakezelési hibák nélkül.
    
4.  **Alacsony fogyasztás**:  
    Az FPGA áramkörnek optimalizált energiafogyasztással kell működnie.
    
5.  **Skálázhatóság**:  
    A rendszer legyen könnyen bővíthető más mintavételezési frekvenciák vagy nagyobb memóriahasználat támogatására.
    
6.  **Modularitás**:  
    A rendszer elemei (mint például az időzítő, BRAM-vezérlő, PWM generátor) különálló modulokként legyenek implementálva, hogy egyszerűsítsék a karbantartást és fejlesztést.
    
7.  **Kompatibilitás**:  
    A rendszer kompatibilis legyen a Nexys A7-100T FPGA eszközzel és a fejlesztői környezettel (pl. Vivado).

# Tervezés
A tervezés az egyik legfontosabb pontja egy ilyen projekt kialakításában, hiszen terv nélkül nincs átláthatóság, rendszer a kódokban. Ennek első lépése a modulok meghatározása, azoknak a feladata és a köztük lévő kapcsolat kiépítése volt.
### Tömbvázlat

![IMG_3584](https://github.com/user-attachments/assets/a1af04e7-55ac-416a-b0cb-68709d49915f)

### Vivado-ban kigenerált tömbvázlat

![image](https://github.com/user-attachments/assets/2e69b3fb-57be-4345-9a5c-7ec3ddfcfc1d)


## Tervezés lépései
### Modulok leírásai:

 1. **`audio_output`**
    
    -   **Célja:**  Audio minták PWM (Pulse Width Modulation) formátumúra alakítása audio kimenethez.
    -   **Működés:** A bemeneti audio mintákat (32 bit) feldolgozza, a bal csatorna adatot (16 bit) PWM jellé alakítja, és az audio erősítő engedélyezéséhez szükséges jelet (audio_sd) állítja be.

 2. **`bram_controller`**

    -   **Célja:** Kommunikáció vezérlése a belső blokk memóriával (BRAM).
    -   **Működés:** Az adatokat olvassa a BRAM-ból, és megfelelően kezeli a memóriacímeket. Az aktuális állapot alapján biztosítja a mintaadatok továbbítását az audio kimenet számára.

 3. **`sample_timer`**

    -   **Célja:** Mintavételi ütemjel (sample_tick) generálása 44.1 kHz-es audio mintavételezéshez.
    -   **Működés:** Számlálót használ, amely az órajel ciklusok alapján számolja az időt, és a megfelelő periódusban generálja az ütemjelet.
    
 4. **`play_controller`**

    -   **Célja:** Lejátszás, szünet, és megállítás vezérlése.
    -   **Működés:** Állapotgép segítségével kezeli a `play`, `pause`, és `stop` jeleket. Az aktuális állapot szerint aktiválja az `enable` és `reset` jeleket.
    
 5. **`top_modul`**

    -   **Célja:** A teljes rendszer integrációja és működésének összefogása.
    -   **Működés:** A többi modul összehangolt vezérlését biztosítja. Az órajel, vezérlőjelek (`play`, `stop`, `pause`) alapján elindítja a lejátszást, mintavételezést, memóriahozzáférést és az audio kimeneti jelek generálását.
   
 6. **`blk_mem_gen_0` (BRAM memória)**

    -   **Célja:** A lejátszandó audio minták tárolása.
    -   **Működés:** Külső generált memória modul, amelyből a minták a `bram_controller` által kerülnek olvasásra. Inicializálása .coe fájlból történik.

## Modulok tervezései
A modulok először is papíron lettek megtervezve, ami egy biztos alapot adott a VHDL kódok kialakításában. Ugyanakkor a projekt sokat fejlődött a tervezés szakasza óta, amit az alábbi pont nagyon jól szemléltet, a terv mellett megtalálható a Vivado környezetben írt kész kód is:

### Állapotgépek magyarázata :

**1. `play_controller` modul:**

Ez az állapotgép vezérli az audio lejátszás folyamatát (indítás, megállítás, szüneteltetés).

-   **`INIT`**: Az eszköz inicializálása. A `reset` jel aktív.
-   **`RDY`**: Készenléti állapot. Vár a felhasználói parancsokra (`play`, `stop`).
-   **`PLAYING`**: Lejátszás folyamatban (`enable` aktív).
-   **`PAUSED`**: Lejátszás szüneteltetve (`enable` inaktív).
-   **`STOPPING`**: Lejátszás leállítása (`enable` inaktív). Állapotváltás a `RESETTING` állapotra.
-   **`RESETTING`**: Az állapotgép visszaállítása készenléti állapotba (`reset` aktív).


 **2. `sample_timer` modul:**

Ez az állapotgép az audio mintavételezéshez szükséges időzítést végzi.

-   **`INIT`**: Inicializálás. Várja az `enable` jel aktiválását.
-   **`RDY`**: Készen áll a számlálás indítására.
-   **`COUNTING`**: A számláló növeli az értékét, amíg el nem éri a `max_count` értéket.
-   **`TICK`**: Ha a számláló eléri a `max_count` értéket, egy `sample_tick` jelet generál. Ezután visszalép a `COUNTING` állapotba.


 **3. `bram_controller` modul:**

Ez a modul egy BRAM vezérlőt valósít meg, amely audio adatok olvasását és írását végzi.

-   **`INIT`**: Az állapotgép inicializálása.
-   **`IDLE`**: Nyugalmi állapot, várja a `write_enable` vagy `sample_tick` jelet.
    -   Ha `write_enable` aktív, `WRITE` állapotba lép.
    -   Ha `sample_tick` aktív, `READ` állapotba lép.
-   **`WRITE`**: Adatok írása a BRAM-ba (`wea` aktív). Ezután visszalép az `IDLE` állapotba.
-   **`READ`**: Adatok olvasásának indítása a BRAM-ból. Ezután `READ_WAIT` állapotba lép.
-   **`READ_WAIT`**: Várakozás az olvasás eredményére.
-   **`OUTPUT`**: Az olvasott adat továbbítása a `sample_data` kimenetre. Ezután visszalép az `IDLE` állapotba.


###Tervezés és megírt kód:

`audio_output`

![IMG_3585](https://github.com/user-attachments/assets/4c594161-a236-40b9-a5f3-eef307a3a490)

 Kész VHDL kód:

      entity audio_output is
        Port ( sample_data : in STD_LOGIC_VECTOR (31 downto 0);
               clk : in STD_LOGIC;
               reset: in STD_LOGIC;
               audio_pwm : out STD_LOGIC;
               audio_sd : out STD_LOGIC);
    end audio_output;
    
    architecture Behavioral of audio_output is
    
        --Belső jelek
        signal audio_left  : STD_LOGIC_VECTOR(15 downto 0);
        signal pwm_counter : unsigned(15 downto 0) := (others => '0');
        signal sample_tick : STD_LOGIC := '0';
        signal sample_counter : integer range 0 to 1000 := 0;
    
    begin
        -- Mintavételi frekvencia
        process(clk)
        begin
            if rising_edge(clk) then
                if sample_counter = 2267 then -- 100 MHz / 44.1 kHz
                    sample_counter <= 0;
                    sample_tick <= '1';
                else
                    sample_counter <= sample_counter + 1;
                    sample_tick <= '0';
                end if;
            end if;
        end process;
    
        -- Audio adatok feldolgozása
        process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    audio_left <= (others => '0');
                elsif sample_tick = '1' then
                    audio_left <= sample_data(31 downto 16);
                end if;
            end if;
        end process;
    
        -- PWM generálás
        process(clk)
        begin
            if rising_edge(clk) then
                pwm_counter <= pwm_counter + 1;
                if pwm_counter < unsigned(audio_left) then
                    audio_pwm <= '1';
                else
                    audio_pwm <= '0';
                end if;
            end if;
        end process;
    
        -- Audio erősítő engedélyezése
        audio_sd <= '1';
    end Behavioral;

`bram_controller`

![IMG_3586](https://github.com/user-attachments/assets/df94c5a7-78ce-4675-8cd0-8b59fa9544d1)


 Kész VHDL kód:

    entity bram_controller is
        port (
            clk : in  STD_LOGIC;         
            reset : in  STD_LOGIC;         
            sample_tick : in  STD_LOGIC;         
            write_enable: in  STD_LOGIC;        
            write_data : in  STD_LOGIC_VECTOR(31 downto 0); 
            write_address : in  STD_LOGIC_VECTOR(12 downto 0); 
            read_address : in  STD_LOGIC_VECTOR(12 downto 0); 
            douta : in  STD_LOGIC_VECTOR(31 downto 0); 
            sample_data : out STD_LOGIC_VECTOR(31 downto 0); 
            addra : out STD_LOGIC_VECTOR(12 downto 0); 
            dina : out STD_LOGIC_VECTOR(31 downto 0); 
            ena : out STD_LOGIC;         
            wea  : out STD_LOGIC_VECTOR(0 DOWNTO 0));
    end entity BRAM_Controller;
    
    architecture Behavioral of BRAM_Controller is
        -- Állapot típus deklaráció
        type state_type is (INIT, IDLE, WRITE, READ, READ_WAIT, OUTPUT);
        signal state, next_state : state_type;
    
        -- Regiszterek az adatok tárolására
        signal temp_sample_data : STD_LOGIC_VECTOR(31 downto 0);
    begin
    
        -- Állapotgép folyamat
        process (clk, reset)
        begin
            if reset = '1' then
                state <= INIT;
            elsif rising_edge(clk) then
                state <= next_state;
            end if;
        end process;
    
        -- Következ? állapot logika
        process (state, sample_tick, write_enable)
        begin
            -- Alapértékek
            next_state <= state;
            
            case state is
                when INIT =>
                    next_state <= IDLE;
    
                when IDLE =>
                    if write_enable = '1' then
                        next_state <= WRITE;
                    elsif sample_tick = '1' then
                        next_state <= READ;
                    end if;
    
                when WRITE =>
                    next_state <= IDLE;
    
                when READ =>
                    next_state <= READ_WAIT;
                
                when READ_WAIT =>
                    next_state <= OUTPUT;
    
                when OUTPUT =>
                    next_state <= IDLE;
    
                when others =>
                    next_state <= IDLE;
            end case;
        end process;
    
        -- Kimeneti logika
        process (state, write_data, write_address, read_address, douta)
        begin
            -- Alapértékek
            ena <= '0';
            wea <= "0";
            addra <= (others => '0');
            dina <= (others => '0');
            sample_data <= (others => '0');
            
            case state is
                when WRITE =>
                    ena <= '1';
                    wea <= "1";
                    addra <= write_address;
                    dina <= write_data;
    
                when READ =>
                    ena <= '1';
                    wea <= "0";
                    addra <= read_address;
                    
                when READ_WAIT => 
                    ena <= '1';
    
                when OUTPUT =>
                    sample_data <= douta;     -- Kiadás a sample_data vonalra
    
                when others =>
                    ena <= '0';
                    wea <= "0";
            end case;
        end process;
    
    end architecture Behavioral

`sample_timer`

![IMG_3587](https://github.com/user-attachments/assets/4fc004b3-138e-4ed7-8d88-04baa1309c15)

 Kész VHDL kód:

        entity sample_timer is
            Port ( clk : in STD_LOGIC;
                   enable : in STD_LOGIC;
                   reset: in STD_LOGIC;
                   sample_tick : out STD_LOGIC);
        end sample_timer;
        
        architecture Behavioral of sample_timer is
        
            -- Állapotok típusa
            type state_type is (INIT, RDY, COUNTING, TICK);
            signal current_state, next_state : state_type;
            
            constant max_count : integer:= 2267; -- Például 100 MHz / 44.1 kHz
            signal counter :  unsigned(11 downto 0) := (others => '0');
        
        begin
            
            -- Állapotregiszter frissítése
            process(clk)
            begin
                if rising_edge(clk) then
                    if reset = '1' then
                        current_state <= INIT;
                    else
                        current_state <= next_state;
                    end if;
                end if;
            end process;
            
            -- Állapotgép működése
            process(current_state, enable, counter)
            begin
                case current_state is
                    when INIT =>
                        if enable = '1' then
                            next_state <= RDY;
                        else
                            next_state <= INIT;
                        end if;
                    when RDY =>
                        next_state <= COUNTING;
                    when COUNTING =>
                        if counter = max_count then
                            next_state <= TICK;
                        else
                            next_state <= COUNTING;
                        end if;
                    when TICK =>
                        next_state <= COUNTING;
                    when others =>
                        next_state <= INIT;
                end case;
            end process;
        
            -- Számláló működése
            process(clk)
            begin
                if rising_edge(clk) then
                    if current_state = COUNTING then
                        if counter = to_unsigned(max_count, counter'length) then
                            counter <= (others => '0'); -- Ha eléri a max értéket akkor lenullázzuk
                        else
                            counter <= counter + 1;
                        end if;
                    else
                        counter <= (others => '0');
                    end if;
                end if;
            end process;
            
            -- sample tick jel generálása
            process(current_state)
            begin
                if current_state = TICK then
                    sample_tick <= '1';
                else
                    sample_tick <= '0';
                end if;
            end process;
        
        end Behavioral;
    
  `play_controller`

  ![IMG_3588](https://github.com/user-attachments/assets/f7f40aa0-5f8c-45c5-84fc-d86f0794d03c)

  Kész VHDL kód:
    
        entity play_controller is
            Port ( play : in STD_LOGIC;
                   stop : in STD_LOGIC;
                   pause  : in STD_LOGIC;
                   clk : in STD_LOGIC;
                   enable : out STD_LOGIC;
                   reset : out STD_LOGIC);
        end play_controller;
        
        architecture Behavioral of play_controller is
        
            -- Állapotok típusa
            type state_type is (INIT, RDY, PLAYING, STOPPING, PAUSED, RESETTING);
            signal current_state, next_state : state_type;
        
        begin
            
            -- Állapotregiszter frissítése
            process(clk)
            begin
                if rising_edge(clk) then
                    current_state <= next_state;
                end if;
            end process;
        	
        	-- Állapotgép működése
            process(current_state, play, stop, pause)
            begin
                --Kezdő értékek
                enable <= '0';
                reset <= '0';
                    
                case current_state is
                    when INIT =>
                        reset <= '1'; 
                        next_state <= RDY;
            
                    when RDY =>
                        if play = '1' then
                            next_state <= PLAYING;
                        elsif stop = '1' then
                            next_state <= RESETTING;
                        else
                            next_state <= RDY;
                        end if;
            
                    when PLAYING =>
                        enable <= '1'; --Lejátszás indítása
                        if stop = '1' then
                            next_state <= STOPPING;
                        elsif pause = '1' then
                            next_state <= PAUSED;
                        else
                            next_state <= PLAYING;
                        end if;
                        
                    when PAUSED =>
                        enable <= '0'; --Lejátszás szüneteltetése
                        if stop = '1' then
                            next_state <= RESETTING;
                        elsif play = '1' then
                            next_state <= PLAYING;
                        else
                            next_state <= PAUSED;
                        end if;
            
                    when STOPPING =>
                        enable <= '0'; --Lejátszás megállítása
                        next_state <= RESETTING;
            
                    when RESETTING =>
                        reset <= '1';
                        next_state <= RDY;
            
                    when others =>
                        next_state <= INIT;
            
                end case;
            end process;
        end Behavioral;
    
  `top_modul`
  
  A top_modulnak nem készült terv, mert csak a modulok összekapcsolása volt az eredeti terv, de ez kiegészült egy automatikus címgenerálással.
    
     Kész VHDL kód:
    entity top_modul is
        Port ( clk : in STD_LOGIC;
               play : in STD_LOGIC;
               stop : in STD_LOGIC;
               pause : in STD_LOGIC;
               audio_pwm : out STD_LOGIC;
               audio_sd : out STD_LOGIC);
    end top_modul;
    
    architecture Behavioral of top_modul is
    
    -- Komponens deklarációk
    
        component blk_mem_gen_0
            port (
                clka : in  STD_LOGIC;
                ena : in  STD_LOGIC;
                wea : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
                addra : in  STD_LOGIC_VECTOR(12 DOWNTO 0);
                dina : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
                douta : out STD_LOGIC_VECTOR(31 DOWNTO 0)
            );
        end component;
        
        component bram_controller
            port (
                clk : in  STD_LOGIC;
                reset : in  STD_LOGIC;
                sample_tick : in  STD_LOGIC;
                write_enable : in  STD_LOGIC;
                write_data : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
                write_address: in  STD_LOGIC_VECTOR(12 DOWNTO 0);
                read_address : in  STD_LOGIC_VECTOR(12 DOWNTO 0);
                douta : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
                sample_data : out STD_LOGIC_VECTOR(31 DOWNTO 0);
                addra : out STD_LOGIC_VECTOR(12 DOWNTO 0);
                dina : out STD_LOGIC_VECTOR(31 DOWNTO 0);
                ena : out STD_LOGIC;
                wea : out STD_LOGIC_VECTOR(0 DOWNTO 0)
            );
        end component;
    
        component sample_timer
            port (
                clk : in  STD_LOGIC;
                enable : in  STD_LOGIC;
                reset : in STD_LOGIC;
                sample_tick : out STD_LOGIC
            );
        end component;
    
        component audio_output
            port (
                sample_data : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
                clk : in  STD_LOGIC;
                reset: in STD_LOGIC;
                audio_pwm : out STD_LOGIC;
                audio_sd : out STD_LOGIC
            );
        end component;
    
        component play_controller
            port (
                play : in  STD_LOGIC;
                stop : in  STD_LOGIC;
                pause : in  STD_LOGIC;
                clk : in  STD_LOGIC;
                enable : out STD_LOGIC;
                reset  : out STD_LOGIC
            );
        end component;
    
        -- Bels? jelek
        signal enable_signal : STD_LOGIC;
        signal reset_signal : STD_LOGIC;
        signal sample_tick_signal : STD_LOGIC;
        signal bram_sample_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal douta_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal read_address_signal : STD_LOGIC_VECTOR (12 DOWNTO 0);
        signal addra_signal : STD_LOGIC_VECTOR(12 DOWNTO 0);
        signal dina_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal ena_signal : STD_LOGIC;
        signal wea_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        signal read_address_counter : STD_LOGIC_VECTOR(12 DOWNTO 0) := (others => '0');
    
    begin
    
        -- Számláló logika: növeli a read_address értékét sample tick-re
        process (clk, reset_signal)
        begin
            if reset_signal = '1' then
                read_address_counter <= (others => '0');  
            elsif rising_edge(clk) then
                if sample_tick_signal = '1' then
                    if read_address_counter = "1111111111111" then
                        read_address_counter <= (others => '0');  
                    else
                        read_address_counter <= std_logic_vector(unsigned(read_address_counter) + 1);
                    end if;
                end if;
            end if;
        end process;
        
        read_address_signal <= read_address_counter;
    
        -- Play controller kapcsolás
        playing : play_controller
            port map (
                play => play,
                stop => stop,
                pause => pause,
                clk => clk,
                enable => enable_signal,
                reset => reset_signal
            );
    
        -- Sample timer kapcsolás
        timer : sample_timer
            port map (
                clk => clk,
                enable => enable_signal,
                reset => reset_signal,
                sample_tick => sample_tick_signal
            );
    
        -- BRAM controller kapcsolás
        read : bram_controller
            port map (
                clk => clk,
                reset => reset_signal,
                sample_tick => sample_tick_signal,
                write_enable => '0',
                write_data => (others => '0'),
                write_address => (others => '0'),
                read_address => read_address_signal,
                douta => douta_signal,
                sample_data => bram_sample_data,
                addra => addra_signal,
                dina => dina_signal,
                ena => ena_signal,
                wea => wea_signal
            ); 
    
        -- Audio output kapcsolás
        audio : audio_output
            port map (
                sample_data => bram_sample_data,
                clk => clk,
                reset => reset_signal,
                audio_pwm => audio_pwm,
                audio_sd => audio_sd
            );
    
        -- BRAM modul kapcsolás
        bram : blk_mem_gen_0
            port map (
                clka => clk,
                ena => ena_signal,
                wea => wea_signal,
                addra => addra_signal,
                dina => dina_signal,
                douta => douta_signal
            );  
    
    end Behavioral;

# Tesztelés
A tesztelés fontos lépés az FPGA lapra feltöltés előtt, mivel lehetőséget biztosít arra, hogy ellenőrizzük a tervezett logika működését és hibákat felismerjük.
A Vivado-ban történő szimulációk segítenek az elméleti működés validálásában, lehetővé téve a potenciális problémák felismerését.

Két féle szimulációt hoztam létre, modulszintűt, és rendszerszintűt. A kiválasztott modulom szimulációra a `bram_controller`, hiszen kulcsfontosságú, hogy a zenéket ki lehet-e olvasni a BRAM memóriából. Ez jól is teljesített, de a `top_modul` szimulációm már nem állja meg a helyét, úgyhogy az még továbbfejlesztésre vár.

**`bram_controller` szimuláció**

![Screenshot (1)](https://github.com/user-attachments/assets/aa270e66-90bb-409b-afaf-1c744ec958c7)

Tesztbench:

        entity bram_controller_sim is
        --  Port ( );
        end bram_controller_sim;
        
        architecture Behavioral of bram_controller_sim is
        
         
            -- BRAM Controller Komponens
            component bram_controller
                port (
                    clk : in  STD_LOGIC;         
                    reset : in  STD_LOGIC;         
                    sample_tick : in  STD_LOGIC;         
                    write_enable : in  STD_LOGIC;        
                    write_data : in  STD_LOGIC_VECTOR(31 downto 0); 
                    write_address: in  STD_LOGIC_VECTOR(12 downto 0); 
                    read_address : in  STD_LOGIC_VECTOR(12 downto 0); 
                    douta : in  STD_LOGIC_VECTOR(31 downto 0); 
                    sample_data : out STD_LOGIC_VECTOR(31 downto 0); 
                    addra : out STD_LOGIC_VECTOR(12 downto 0); 
                    dina : out STD_LOGIC_VECTOR(31 downto 0); 
                    ena : out STD_LOGIC;         
                    wea : out STD_LOGIC_VECTOR(0 downto 0)
                );
            end component;
        
            -- Block Memory Generator Komponens
            component blk_mem_gen_0
                port (
                    clka : in  STD_LOGIC;
                    ena : in  STD_LOGIC;
                    wea : in  STD_LOGIC_VECTOR(0 downto 0);
                    addra : in  STD_LOGIC_VECTOR(12 downto 0);
                    dina : in  STD_LOGIC_VECTOR(31 downto 0);
                    douta : out STD_LOGIC_VECTOR(31 downto 0)
                );
            end component;
        
            -- Jelek
            signal clk : STD_LOGIC := '0';
            signal reset : STD_LOGIC := '1';
            signal sample_tick : STD_LOGIC := '0';
            signal write_enable : STD_LOGIC := '0';
            signal write_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
            signal write_address: STD_LOGIC_VECTOR(12 downto 0) := (others => '0');
            signal read_address : STD_LOGIC_VECTOR(12 downto 0) := (others => '0');
            signal douta : STD_LOGIC_VECTOR(31 downto 0);
            signal sample_data : STD_LOGIC_VECTOR(31 downto 0);
            signal addra : STD_LOGIC_VECTOR(12 downto 0);
            signal dina : STD_LOGIC_VECTOR(31 downto 0);
            signal ena : STD_LOGIC;
            signal wea : STD_LOGIC_VECTOR(0 downto 0);
        
            -- BRAM jelek
            signal bram_ena : STD_LOGIC;
            signal bram_wea : STD_LOGIC_VECTOR(0 downto 0);
            signal bram_addra : STD_LOGIC_VECTOR(12 downto 0);
            signal bram_dina : STD_LOGIC_VECTOR(31 downto 0);
            signal bram_douta : STD_LOGIC_VECTOR(31 downto 0);
        
            -- Órajel periódus
            constant clk_period : time := 10 ns;
        
        begin
        
            -- BRAM Controllert
            controller: bram_controller
                port map (
                    clk => clk,
                    reset => reset,
                    sample_tick => sample_tick,
                    write_enable => write_enable,
                    write_data => write_data,
                    write_address => write_address,
                    read_address => read_address,
                    douta => bram_douta,
                    sample_data => sample_data,
                    addra => bram_addra,
                    dina => bram_dina,
                    ena => bram_ena,
                    wea => bram_wea
                );
        
            -- Block Memory Generatort
            bram: blk_mem_gen_0
                port map (
                    clka => clk,
                    ena => bram_ena,
                    wea => bram_wea,
                    addra => bram_addra,
                    dina => bram_dina,
                    douta => bram_douta
                );
        
            -- Órajel generálás
            clk_process : process
            begin
                while true loop
                    clk <= '0';
                    wait for clk_period / 2;
                    clk <= '1';
                    wait for clk_period / 2;
                end loop;
            end process;
        
            -- Teszt folyamat
            sim: process
            begin
                -- Reset
                reset <= '1';
                wait for 5 * clk_period;
                wait for clk_period;
                reset <= '0';
                wait for clk_period;
        
                -- Olvasási m?velet
                for i in 0 to 10 loop
                    sample_tick <= '1';
                    read_address <= STD_LOGIC_VECTOR(to_unsigned(i, 13));  -- Olvasási cím
                    wait for clk_period;
                    sample_tick <= '0';
                    wait for clk_period;
                    
                end loop;
        
                -- Teszt vége
                wait for 10 * clk_period;
            end process;
        
        end Behavioral;
    
  **`top_modul` szimuláció**

![image](https://github.com/user-attachments/assets/b47c99a7-ceda-4293-9f67-d707a2f76587)

    
  Tesztbench:
    
        entity top_module_sim is
    --  Port ( );
    end top_module_sim;
    
    architecture Behavioral of top_module_sim is
    
        -- Komponens deklarációk
        component blk_mem_gen_0
            port (
                clka : in  STD_LOGIC;
                ena : in  STD_LOGIC;
                wea : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
                addra : in  STD_LOGIC_VECTOR(12 downto 0);
                dina : in  STD_LOGIC_VECTOR(31 downto 0);
                douta : out STD_LOGIC_VECTOR(31 downto 0)
            );
        end component;
    
        component bram_controller
            port (
                clk : in  STD_LOGIC;
                reset : in  STD_LOGIC;
                sample_tick : in  STD_LOGIC;
                write_enable : in  STD_LOGIC;
                write_data : in  STD_LOGIC_VECTOR(31 downto 0);
                write_address: in  STD_LOGIC_VECTOR(12 downto 0);
                read_address : in  STD_LOGIC_VECTOR(12 downto 0);
                douta : in  STD_LOGIC_VECTOR(31 downto 0);
                sample_data : out STD_LOGIC_VECTOR(31 downto 0);
                addra : out STD_LOGIC_VECTOR(12 downto 0);
                dina : out STD_LOGIC_VECTOR(31 downto 0);
                ena : out STD_LOGIC;
                wea : out STD_LOGIC_VECTOR(0 downto 0)
            );
        end component;
    
        component sample_timer
            port (
                clk : in  STD_LOGIC;
                enable : in  STD_LOGIC;
                reset : in STD_LOGIC;
                sample_tick : out STD_LOGIC
            );
        end component;
    
        component audio_output
            port (
                sample_data : in  STD_LOGIC_VECTOR(31 downto 0);
                clk : in  STD_LOGIC;
                reset: in STD_LOGIC;
                audio_pwm : out STD_LOGIC;
                audio_sd : out STD_LOGIC
            );
        end component;
    
        component play_controller
            port (
                play : in  STD_LOGIC;
                stop : in  STD_LOGIC;
                pause : in  STD_LOGIC;
                clk : in  STD_LOGIC;
                enable : out STD_LOGIC;
                reset  : out STD_LOGIC
            );
        end component;
    
        -- Jelek a teszthez
        signal clk : STD_LOGIC := '0';
        signal play : STD_LOGIC := '0';
        signal stop : STD_LOGIC := '0';
        signal pause : STD_LOGIC := '0';
        signal sample_tick : STD_LOGIC := '0';
        signal enable_signal : STD_LOGIC;
        signal reset_signal : STD_LOGIC;
        signal bram_sample_data : STD_LOGIC_VECTOR(31 downto 0);
        signal douta_signal : STD_LOGIC_VECTOR(31 downto 0);
        signal read_address_signal : STD_LOGIC_VECTOR(12 downto 0);
        signal addra_signal : STD_LOGIC_VECTOR(12 downto 0);
        signal dina_signal : STD_LOGIC_VECTOR(31 downto 0);
        signal ena_signal : STD_LOGIC;
        signal wea_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        signal audio_pwm : STD_LOGIC;
        signal audio_sd : STD_LOGIC;
    
        -- Órajel paraméterei
        constant clk_period : time := 10 ns;
        constant sample_tick_period : time := 100 ns;
    
    begin
    
        -- Órajel generátor
        clk_process : process
        begin
            while True loop
                clk <= '0';
                wait for clk_period / 2;
                clk <= '1';
                wait for clk_period / 2;
            end loop;
        end process;
        
    
        -- Komponensek összekötése
    
        playing : play_controller
            port map (
                play => play,
                stop => stop,
                pause => pause,
                clk => clk,
                enable => enable_signal,
                reset => reset_signal
            );
    
        timer : sample_timer
            port map (
                clk => clk,
                enable => enable_signal,
                reset => reset_signal,
                sample_tick => sample_tick
            );
    
        read : bram_controller
            port map (
                clk => clk,
                reset => reset_signal,
                sample_tick => sample_tick,
                write_enable => '0',
                write_data => (others => '0'),
                write_address => (others => '0'),
                read_address => read_address_signal,
                douta => douta_signal,
                sample_data => bram_sample_data,
                addra => addra_signal,
                dina => dina_signal,
                ena => ena_signal,
                wea => wea_signal
            ); 
    
        audio : audio_output
            port map (
                sample_data => bram_sample_data,
                clk => clk,
                reset => reset_signal,
                audio_pwm => audio_pwm,
                audio_sd => audio_sd
            );
    
        bram : blk_mem_gen_0
            port map (
                clka => clk,
                ena => ena_signal,
                wea => wea_signal,
                addra => addra_signal,
                dina => dina_signal,
                douta => douta_signal
            );
    
        -- Szimulációs forgatókönyv
        sim_proc: process
        begin
            -- Reset
            wait for 20 ns;
    
            -- Play
            play <= '1';
            wait for 50 ns;
            play <= '0';
            
            --sample_tick <= '0';
            --wait for clk_period / 2;
            --sample_tick <= '1';
            --wait for clk_period / 2;
    
            -- Pause
            pause <= '1';
            wait for 50 ns;
            pause <= '0';
    
            -- Stop
            stop <= '1';
            wait for 50 ns;
            stop <= '0';
    
            -- Vége
            wait for 1 ms;
            assert false report "End of simulation" severity failure;
        end process;
    
    end Behavioral;

