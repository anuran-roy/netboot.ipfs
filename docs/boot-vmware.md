# Boot from VMware 

### VMware Fusion

These instructions are for setting up netboot.ipfs in a VM on VMware's Fusion for MacOS.

### Create the VM

* Add a new virtual machine.
* Select "Install from disc or image".
* Click on "Use another disk or disc image...".
* Download and select the netboot.ipfs ISO.
* On the Choose Operating System Screen, select the OS type you are planning on installing.  If you plan on testing multiple types of installs, you can just choose a CentOS 64-bit OS.
* Click the "Customize Settings" and give the VM a name, like "netboot.ipfs".

This will create your VM.  

### Running the VM

_You'll need to adjust the memory settings of the VM to ensure you'll have enough memory to run the OS installers in memory.  Typically it's good to bump the memory up to 2GB or even 4GB._

* Click the wrench icon and click on Processors & Memory and bump up the memory to the desired amount of memory.
* Start the VM up and you should see the netboot.ipfs loader.
* If you determine you no longer want to boot from netboot.ipfs, you can either change the boot order to boot from the hard drive by default or delete the ISO from the VM.
