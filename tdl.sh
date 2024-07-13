#!/bin/bash

echo "                        xxxxxxxx                                                                    "
echo "                   xxxxxxxxxxxxxxxxxx                                              xxxxx            "
echo "               xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx            xxxxxxxxxxxxxxxxxxxxxx      "
echo "             xxxxxxxxxxx       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     "
echo "           xxxxxxxxx       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx          xxxxxxxxx   "
echo "         xxxxxxxx       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     xxxxxxxxx      "
echo "        xxxxxxx       xxxxxxxxxx    xxxxxx              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx           "
echo "        xxxxx       xxxxxxxxx        xxxxx             xxxxxxxxx                                    "
echo "         xx       xxxxxxxx          xxxxxx          xxxxxxxxx                 xxxxxxxxx   xxxxxxxxxx"
echo "                xxxxxxxx            xxxxxx       xxxxxxxxxx                  xxxxxxxxx   xxxxxxxxxx "
echo "               xxxxxxx             xxxxxxx      xxxxxxxxxx                 xxxxxxxxxx   xxxxxxxxxx  "
echo "              xxxxxx              xxxxxxxx    xxxxxxxxxx                  xxxxxxxxxx   xxxxxxxxxx   "
echo "             xxxxxx              xxxxxxxx   xxxxxxxxxxx                  xxxxxxxxxx   xxxxxxxxx     "
echo "            xxxxxx              xxxxxxxx   xxxxxxxxxxx                  xxxxxxxxx    xxxxxxxxx      "
echo "            xxxxx              xxxxxxxx   xxxxxxxxxx                   xxxxxxxxx   xxxxxxxxxx       "
echo "            xxxxx            xxxxxxxxx  xxxxxxxxxx                    xxxxxxxxx   xxxxxxxxxx        "
echo "            xxxxx          xxxxxxxxx   xxxxxxxxxx            xxxxxxxxxxxxxxxxx   xxxxxxxxxx         "
echo "            xxxxxx      xxxxxxxxxx    xxxxxxxxxx         xxxxxxxxxxxxxxxxxxxx   xxxxxxxxxx          "
echo "            xxxxxxxxxxxxxxxxxxxx     xxxxxxxxxx       xxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxx            "
echo "              xxxxxxxxxxxxxxxx     xxxxxxxxxxx     xxxxxxxxxxxxxxxxxxxxxxx   xxxxxxxxxx             "
echo "                xxxxxxxxx         xxxxxxxxxxx   xxxxxxxxxxxx   xxxxxxxxxx   xxxxxxxxxx   xxx        "
echo "  xxxxxxxx                       xxxxxxxxxxx   xxxxxxxxxxxx   xxxxxxxxxx  xxxxxxxxxxx  xxxxxx       "
echo " xxxxxxxxx                     xxxxxxxxxxxx   xxxxxxxxxxx   xxxxxxxxxxx  xxxxxxxxxxx  xxxxxx        "
echo "xxxxxxxxxxx                   xxxxxxxxxxx    xxxxxxxxxxx   xxxxxxxxxxx xxxxxxxxxxxx xxxxxxx         "
echo "xxxxxxxxxx                 xxxxxxxxxxxx      xxxxxxxxx   xxxxxxxxxxx  xxxxxxxxxxxx xxxxxxx          "
echo "xxxxxxxxx               xxxxxxxxxxxxx        xxxxxxxx  xxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx            "
echo " xxxxxxxxx         xxxxxxxxxxxxxxxx          xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx              "
echo "  xxxxxxxxxxxxxxxxxxxxxxxxxxxxx               xxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxx                "
echo "     xxxxxxxxxxxxxxxxxxxxxx                    xxxxxxxxxx    xxxxxxxx     xxxxxxxx                  "
echo "          xxxxxxxxxx                                                                                "

if [ -f /home/$USER/.tdl/data.kv ]; then
    echo 'tdl is login'
else
    echo -n "Hello , welcome to the tdl! Choose an option to login (1 desktop|2 code|3 qr|) enter a number :     "
    read option
    if [ "$option" == "1" ]; then
      tdl login -T desktop
     elif [ "$option" == "2" ]; then
      tdl login -T code
     elif [ "$option" == "3" ]; then
      tdl login -T qr
      echo "Sorry , the commend no exists"
    fi
fi
  
  
  
echo -n "Hello , welcome to the tdl! Choose an option to login (1 Pro|2 Free|) enter a number :     "
 read option
 if [ "$option" == "1" ]; then
    while :
    do
     echo -n "Hello , welcome to the tdl! Choose an option to upload dirs or files (1 default|2 other channel) enter a number :       "   
     read option   
     if [ "$option" == "1" ]; then
       echo "Please enter the name of the file or folder:" 
       read NAME
       PFILE=$(find . -name "$NAME")
       RFIND=$(basename "$PFILE")
       FPATH="$(cd "$(dirname "$PFILE")"; pwd -P)"
       tdl up -p "$FPATH/$RFIND"  
      elif [ "$option" == "2" ]; then
       tdl chat ls  
       echo "Please enter the number of channel to upload folder or file"
       read CHANNEL
       echo "Please enter the name of the file or folder:" 
       read NAME
       PFILE=$(find . -name "$NAME")
       RFIND=$(basename "$PFILE")
       FPATH="$(cd "$(dirname "$PFILE")"; pwd -P)"
       tdl up -p "$FPATH/$RFIND"  -c $CHANNEL
     fi
   done
  elif [ "$option" == "2" ]; then
   while :
   do
     echo -n "Hello , welcome to the tdl! Choose an option to upload folder or file (1 default|2 other channel) enter a number :       "   
     read option   
     if [ "$option" == "1" ]; then
       echo "Please enter the name of the file or folder:" 
       read NAME
       PFILE=$(find . -name "$NAME")
       RFIND=$(basename "$PFILE")
       FPATH="$(cd "$(dirname "$PFILE")"; pwd -P)"
       find "$(cd "$(dirname "$PFILE")"; pwd -P)" -maxdepth 1 -size +2G | while read FILE; do
         cd "$FPATH" && split -b 1G -d "$FILE" "$RFIND.part"
         cd $HOME/Downloads
         find . -name "$RFIND.part*" >> "$RFIND".sh
         sed -i 's\./\tdl up -p /\' "$RFIND.sh" \
	 	 chmod +x "$RFIND.sh"
         ./"$RFIND.sh"
       done
       tdl up -p "$FPATH/$RFIND"
      elif [ "$option" == "2" ]; then
       tdl chat ls      
       echo "Please enter the number of channel to upload folder or file"
       read CHANNEL
       echo "Please enter the name of the file or folder:" 
       read NAME
       PFILE=$(find . -name "$NAME")
       RFIND=$(basename "$PFILE")
       FPATH="$(cd "$(dirname "$PFILE")"; pwd -P)"
       find "$(cd "$(dirname "$PFILE")"; pwd -P)" -maxdepth 1 -size +2G | while read FILE; do
         cd "$FPATH" && split -b 1G -d "$FILE" "$RFIND.part"
         cd $HOME/Downloads
         find . -name "$RFIND.part*" >> "$RFIND".sh
         sed -i "s|./|tdl up -c $CHANNEL -p |" "$RFIND.sh"
         chmod +x "$RFIND.sh"
	     if [ -f "$RFIND.sh" ]; then
             ./"$RFIND.sh"
         else 
             tdl up -p "$FPATH/$RFIND" -c $CHANNEL
         fi
       done
	 fi
   done
 fi
