{ ... }: {

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="303a", TAG+="uaccess"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", TAG+="uaccess"
  '';

}
