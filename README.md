# always work in progress

Every time I ask somebody about their dotfiles repo I hear something along the lines of "I've been planning to clean it up a bit"

Yes, I've also been planning to clean my dotfiles a bit... And I will get round to it eventually...
Oh and I just noticed that I already said that in the last line of this readme... smh

## gpg password prompt inline

https://stackoverflow.com/questions/41052538/git-error-gpg-failed-to-sign-data#answer-61314861

## allowing the ergo dox keyboard to wakeup the laptop:
# /etc/udev/rules.d/90-usb-wakeup.rules
ACTION=="add", SUBSYSTEM="usb", ATTRS{idVendor}=="feed", ATTRS{idProduct}=="1307", ATTR{power/wakeup}="enabled"
