vboxmanage getextradata $1 enumerate
# will display something like:
# Key: GUI/LastGuestSizeHint, Value: 800,600

#set height, width 
# optional 4th param if you are using vm with multiple monitors (blank for screen #1, then screen #2 is '1')
vboxmanage setextradata $1 GUI/LastGuestSizeHint$4 $2,$3
vboxmanage getextradata $1 enumerate