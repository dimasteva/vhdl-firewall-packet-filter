# VHDL Firewall – Malicious Packet Detection on FPGA

This project was developed during a research program at the Petnica Science Center. The goal was to design and implement a basic **firewall system using VHDL** that detects **malicious network packets** in real time.

## 🔍 Project Overview

The system receives full network packets as input via a wide `std_logic_vector`, extracting relevant fields such as:

- MAC address
- IP address
- Protocol type
- EtherType
- Port number

It then evaluates the packet against **predefined rules**, outputting:

- `'1'` if the packet is **safe**
- `'0'` if the packet is **malicious**

## ⚙️ Technologies Used

- **VHDL** – For hardware description
- **GHDL** – For simulation and testing
- **GTKWave** – For waveform visualization

## 📦 Packet Parsing

The packet is parsed directly from the 12000-bit wide input using bit slicing. Specific byte ranges are used to extract:

- `PortI` (bytes 36–37)
- `EtherType` (bytes 12–13)
- `MAC` (destination MAC, 6 bytes)
- `IP address` (destination IP, 4 bytes)
- `Protocol` (1 byte)

## 🛡️ Detection Logic

The rules for detecting a malicious packet include:

- MAC address equals `FF:FF:FF:FF:FF:FF`
- Destination IP is `192.168.3.255`
- Protocol is not TCP or UDP (e.g., not `0x06` or `0x11`)
- **Port number is 1024 or higher**

If any of these conditions are met, the packet is flagged as **malicious**.

## 🧪 Testing

Testing was performed using **GHDL** with a set of simulated packet inputs to verify detection logic.

## 🚫 FPGA Integration

Due to time constraints, the firewall was **not physically deployed** to the FPGA board. Instead, we modified an existing VHDL codebase provided by our mentors, which included low-level **read/write interfaces** for interacting with the board. Our work focused on integrating the detection logic into that framework.
