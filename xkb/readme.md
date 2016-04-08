`cz-prog` is a standard US qwerty keyboard with several keys replaced by
the special symbols of the Czech alphabet.

* keys `1234567890` are replaced by `+ěščřžýáíé`,
* keys like `escrzyaie` and `tdn` have `AltGr` and `AltGr+Shift` variants,
* `ů`, `Ů` are under `AltGr(+Shift)+;`,
* `É` is under `AltGr+Shift+é`.

-----------

The xkb file was created with

    setxkbmap cz-prog -print > cz-prog.xkb
