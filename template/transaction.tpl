class {{txn_name}} extends uvm_sequence_item;
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit write_en;

  `uvm_object_utils({{txn_name}})

  function new(string name = "{{txn_name}}");
    super.new(name);
  endfunction
endclass

