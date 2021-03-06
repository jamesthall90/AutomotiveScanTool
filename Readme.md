# Automotive Scan Tool (AST)

This project’s objective is to access a vehicle’s Controller Area Network (CAN) to retrieve any Diagnostic Trouble Codes (DTCs) from the vehicle’s Engine Control Module (ECM) along with archiving and, potentially clearing them from the vehicle.

All data retrieved from the CAN will be transmitted to a cloud storage service, from which it can be accessed via an iOS application.

This project utilizes a Particle Electron IOT Device which connects to the vehicle’s OBDII port via a Carloop adaptor device.

The Particle transmits data received from the OBDII connection to the Particle Cloud via a 3G cellular connection, Wi-Fi, or low-energy Bluetooth, depending on which Particle device is used.
