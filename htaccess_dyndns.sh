#!/bin/sh

#Pfad, wo die .htaccess liegt
htpath="/volume1/web/"

cd $htpath #Springt an den Speicheort

sed -i '/#DDNS-IP/d' .htaccess #Entfernt die Zeile mit #DDNS-IP aus der Datei "i" ##Funktionert
#i sollte eine Textdatein sein

#Urgesetin, der Textverarbeitung
#Die Textdatei wird verändert, anstatt das Ergebnis auf Standardausgabe auszugeben
#die Zeile, die mit #DDNS-IP beginnt wird gelöscht 

anzahl=$(grep -c "#DDNS$" .htaccess) #gibt die Anzal der #DDNS wieder und speicher die Zahl in Varialbe "anzahl"

ddns=$(grep -i "#DDNS$" .htaccess) #in Variable ddns speichern
ddns_a=( $ddns ) #in Array umwandeln 

i=1
a=0
b=4

while [ $i -le $anzahl ] #läuft solange ab, bis "i" kleiner gleich "anzahl" ist
do
    ddns_p="${ddns_a[2 + $a]}" #ruft immer die Domain auf
    ip_var=$(nslookup $ddns_p) #schickt die Domain an nslookup und holt sich Infos
    ip_a=( $ip_var ) #in Array
    ip="${ip_a[9]}" #aus Array die IP

    ddns_part="${ddns_a[@]:$a:$b}" #den Suchbegriff definieren, der die Positon angibt, an dem die IP eingefügt werden soll
    sed -i '/'"$ddns_part"'/a Allow from '"$ip"' #DDNS-IP' .htaccess #Text mit IP wird eingefügt

    a=$(( $a + 4 ))
    i=$(( $i + 1 ))
done

chmod 444 .htaccess #Richtige Schreib- und Leserechte vergeben um Fehler 403 zu vermeiden
