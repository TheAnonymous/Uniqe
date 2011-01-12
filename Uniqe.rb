# coding: utf-8
#der teile zum parsen von hwdetect --modules & mkinitcpio -M

begin
system("mkinitcpio -M >> module.txt") 
system("hwdetect --modules >> module.txt")
myFile = File.new("module.txt", "r")
rescue
  puts("Bitte führen Sie es als root aus!")
  puts("Bitte kontrollieren Sie ob Sie hwdetect & mkinitcpio installiert haben")
  gets
  exit(0)
end
alleWoerter = Array.new(0)
tempWoerter = Array.new();
myFile.each_line { |line|
  if line.length >= 20
    tempWoerter = line.split( ' ')
    alleWoerter.concat(tempWoerter)
  end
  if line.length < 20
    alleWoerter.push(line)
  end
}
myFile.close

alleWoerter.sort!
alleWoerter.each_index { |item|
  alleWoerter[item] = alleWoerter[item].delete "\n"
  alleWoerter[item] = alleWoerter[item].delete ")"
  alleWoerter[item] = alleWoerter[item].delete "MODULES=("
  }

#Der Teil zum parsen von lsmod
system("lsmod > lsmod.txt")
begin
datei2 = File.new("lsmod.txt","r")
rescue
   puts("Ungültiger Pfad!")
  gets
  exit(0)
end
zeile = Array.new(0)
datei2.each_line { |tempzeile|
  zeile.push(tempzeile.split(" ")[0])
}
datei2.close

alleWoerter.concat(zeile)
alleWoerter.sort!
alleWoerter.uniq!  
alleWoerter.delete("Modules")
alleWoerter.delete("Module")
alleWoerter.delete("autodetected:")

ausgabe = ''
  alleWoerter.each{
  |wort|
  ausgabe << wort
  ausgabe << " "
  }
  
  datei = File.new("Uniqe-Modules.txt","w")
  datei.puts(ausgabe)
  datei.close
puts("============================================================")
puts(ausgabe)
puts("============================================================")
system("chmod 777 Uniqe-Modules.txt")
File.delete("lsmod.txt")
File.delete("module.txt")
