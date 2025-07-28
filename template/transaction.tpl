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

`ifndef {{txn_name}}_SV
`define {{txn_name}}_SV

class {{txn_name}} extends uvm_sequence_item;

  // Data payload
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit         wr; // 0 for read, 1 for write

  // Utility and Field Macros
  `uvm_object_utils_begin({{txn_name}})
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(wr, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "{{txn_name}}");
    super.new(name);
  endfunction : new

  // Constraints
  constraint c_addr {
    // Example constraint: word-aligned addresses
    addr[1:0] == 2'b0;
  }

endclass : {{txn_name}}

`endif // {{txn_name}}_SV
