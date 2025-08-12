# Azure Networking Module Implementation

This module dynamically provisions a Virtual Network (VNet) with subnets and configures routing and security for front-end and back-end tiers.

---

## 🔧 Module Components

### Virtual Network Creation
- VNet is created **dynamically** using input CIDR ranges.
- Supports multiple address spaces.

### Subnet Creation
- Subnets are provisioned **dynamically** for each VNet.
- Naming and CIDRs are passed as lists of lists for multi-tier structures (e.g., frontend, backend).

---

## Custom Route Tables

- **Separate route tables** are created for:
  - Frontend Subnet (e.g., public route to internet)
  - Backend Subnet (e.g., private routes for internal communication)
- Each subnet is **explicitly associated** with its corresponding route table.
- The Private Route table will allow traffic only from public subnet not from internet

---

## Custom Network Security Groups (NSGs)

- **Frontend NSG**:
  - Allows public traffic (e.g., HTTP/HTTPS).
- **Backend NSG**:
  - Allows internal traffic (e.g., SSH, database ports).
- NSGs are **individually created and associated** with the respective subnets.

---

## Virtual Machines and Network Interfaces

- **Public IP Address**:
  - A **static public IP** was created and assigned to the NIC in the **frontend subnet**.

- **2 Network Interface Cards (NICs)** were created:
  - **Public NIC**: Associated with the **frontend subnet** and attached to a **public IP address**.
  - **Private NIC**: Associated with the **backend subnet** without a public IP.

- **2 Linux Virtual Machines (VMs)** were deployed:
  - **Public VM**: Connected to the **public NIC** (frontend subnet).
  - **Private VM**: Connected to the **private NIC** (backend subnet).


## Key Features

- Fully modular, reusable networking setup.
- Clean separation of frontend and backend tiers.
- No hardcoded values; dynamically generated from input variables.
- NSG and Route Table association is **explicit and readable**.


![Azure Networking Diagram](./networking.png)