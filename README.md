# blueX-firmware
Custom firmware for PCA10059 NRF52840 Dongle (from Nordic SemiConductors) and nRF52840 MDK USB Dongle (from MakerDiary), allowing to easily eavesdrop Bluetooth Low Energy communications and perform multiple active attacks based on InjectaBLE strategy.

It is forked from:

* Romain Cayre, Florent Galtier, Guillaume Auriol, Vincent Nicomette, Mohamed Kaâniche, et al.. [InjectaBLE: Injecting malicious traffic into established Bluetooth Low Energy connections](https://hal.laas.fr/hal-03193297). *IEEE/IFIP International Conference on Dependable Systems and Networks (DSN)*, Jun 2021, Taipei (virtual), Taiwan. **\[en\]**

## Installing the environment
* Install the latest ARM GCC Toolchain (C++ support needed), add it to your PATH variable
* Download the latest NRF5 SDK from nordic semiconductors
* Install nrfutil and add it to your PATH variable (only needed for pca10059 dongle)
* Set the SDK\_ROOT environment variable to match the SDK directory

## Compiling the firmware (pca10059)
Compiling the firmware is straightforward:
```
$ make
```

Then, you can use the send command to flash it on the dongle:
```
$ make send
```

The dongle should now be detected by your operating system:
```
$ lsusb
[...]
Bus 001 Device 039: ID 5a17:0000 BlueS Toolkit BlueX
[...]
```


## Compiling the firmware (mdk-dongle)
Compiling the firmware is straightforward:
```
$ make
```

Then, you can use the send command to flash it on the dongle after pressing the button and push into the USB port. When you run ``lsusb`` or ``mount``, you can find the initial MDK device:
```
$ mount | grep UF2BOOT
$ make send
```

The dongle should now be detected by your operating system:
```
$ lsusb
[...]
Bus 001 Device 039: ID 5a17:0000 BlueS Toolkit BlueX
[...]
```
