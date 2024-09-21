{ config, lib, pkgs, ... }:

{
  services.udev.extraRules = ''
    ###########################################################################
    #                                                                         #
    #  52-digilent-usb.rules -- UDEV rules for Digilent USB Devices           #
    #                                                                         #
    ###########################################################################
    # Create "/dev" entries for Digilent device's with read and write
    # permission granted to all users.
    ATTRS{idVendor}=="1443", MODE:="666"
    ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Digilent", MODE:="666"


    ###########################################################################
    #                                                                         #
    #  52-xilinx-ftdi-usb.rules -- UDEV rules for Xilinx USB Devices          #
    #                                                                         #
    ###########################################################################
    # version 0001
    # Create "/dev" entries for Xilinx device's with read and write
    # permission granted to all users.
    ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Xilinx", MODE:="666"

    # version 0002
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
  '';
}
