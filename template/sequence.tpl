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

`ifndef {{seq_name}}_SV
`define {{seq_name}}_SV

class {{seq_name}} extends uvm_sequence #({{txn_name}});

  // Object utils macro
  `uvm_object_utils({{seq_name}})

  // Constructor
  function new(string name = "{{seq_name}}");
    super.new(name);
  endfunction : new

  // Task body: defines the behavior of the sequence
  virtual task body();
    `uvm_info(get_type_name(), "Sequence starting...", UVM_MEDIUM)

    // Create a transaction
    req = {{txn_name}}::type_id::create("req");

    // Start the item, wait for it to be randomized
    start_item(req);

    // Randomize the transaction with constraints
    if (!req.randomize() with {
        wr == 1; // It's a write transaction
        addr == 32'h1234_5678;
    }) begin
      `uvm_error(get_type_name(), "Failed to randomize transaction")
    end

    // Finish the item, sending it to the driver
    finish_item(req);

    `uvm_info(get_type_name(), "Sequence finished.", UVM_MEDIUM)
  endtask : body

endclass : {{seq_name}}

`endif // {{seq_name}}_SV
