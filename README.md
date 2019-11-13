# Docker Dev Env for Nativescript with Vue

## Easy to use container for fast development using a physical device

### Usage

* Connect your smartphone by USB ( tested only on Android )
* Change variables in the `docker-compose.yaml` file
* Start the container with `docker-compose up`
* Enter the container with `docker run -it *container_name* /bin/bash`
* Enter the folder where your application resides
* Run `tns doctor` to check that Nativescript is installed correctly
* Run `tns devices` to see if your smartphone has been detected by NS
* Run `tns debug android` to build the app and install it on your smartphone

NS compiles new code on the fly and updates the view on your smartphone as you modify the code.

