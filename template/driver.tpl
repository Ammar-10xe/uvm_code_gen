//
// -----------------------------------------------------------------------------
// Copyright (c) 2024 Your Company, All Rights Reserved
//
// This file is part of the {{vip_name}}_vip project.
//
// The {{vip_name}}_vip project is licensed under the
// Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -----------------------------------------------------------------------------
//

`ifndef {{vip_name}}_DRIVER_SV
`define {{vip_name}}_DRIVER_SV

class {{vip_name}}_driver extends uvm_driver #({{txn_name}});

  // Component utils macro
  `uvm_component_utils({{vip_name}}_driver)

  // Virtual interface handle
  virtual {{vip_name}}_if vif;

  // Constructor
  function new(string name = "{{vip_name}}_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase: get configuration, like the virtual interface
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual {{vip_name}}_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found in config_db")
    end
  endfunction : build_phase

  // Run phase: main driver logic
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Driver run phase starting...", UVM_MEDIUM)
    forever begin
      // Get the next transaction from the sequencer
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), $sformatf("Driving transaction: %s", req.sprint()), UVM_HIGH)

      // Drive the transaction onto the interface
      drive_transaction(req);

      // Indicate that the transaction is done
      seq_item_port.item_done();
    end
  endtask : run_phase

  // Task to drive a single transaction
  protected virtual task drive_transaction({{txn_name}} tx);
    // This is where you would put the pin-level protocol logic
    // For example:
    vif.addr <= tx.addr;
    vif.wr   <= tx.wr;
    vif.wdata <= tx.data;
    vif.valid <= 1;
    
    // Wait for the DUT to be ready
    @(posedge vif.clk);
    while (!vif.ready) begin
      @(posedge vif.clk);
    end
    
    vif.valid <= 0;
    `uvm_info(get_type_name(), "Transaction driven.", UVM_HIGH)
  endtask : drive_transaction

endclass : {{vip_name}}_driver

`endif // {{vip_name}}_DRIVER_SV
