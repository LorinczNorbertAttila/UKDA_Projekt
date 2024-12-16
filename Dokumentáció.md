# Újrakonfigurálható digitális áramkörök projekt

## *Projekt célja*

A projekt magába foglalja egy Nexys A7 modellű FPGA lapra tervezett zenelejátszót, mely Block RAM memóriából olvassa ki az egyszerűbb, dekódolást nem igénylő, hangfájlokat, majd ezek lejátszását, szüneteltetését, illetve megállítását biztosítja. Mindezek kivitelezése komplex állapotgépek segítségével van megvalosítva, amely a gördülékenyebb munkafolyamathoz járul hozzá.

## *Tervezés*

 **1. Architektúra**
 
 Az audio lejátszó rendszer moduláris architektúrára épül, ahol az egyes funkcionális egységek elkülönítetten működnek és egy top modul integrálja őket. A rendszer hierarchikus felépítésű, szinkron FPGA design, amely globális órajellel vezérli a folyamatokat.

 **2. Tervezési módszer**
 
 A rendszer a fentről le tervezési módszer elvén készült, amely annyit tesz, hogy a rendszer tervezése magasabb szintű absztrakcióval kezdődött, majd fokozatosan lebomlott részletekre. Ennek lépési a következők voltak:
 - A teljes rendszer specifikációjának és funkcióinak meghatározása (top modul szinten).
 - A rendszert funkcionális egységekre bontása.
 - Minden egység különálló modulokkénti implementálása, majd integrálása

**3. Moduláris tervezés**


