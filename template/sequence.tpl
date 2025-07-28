class {{seq_name}} extends uvm_sequence#({{txn_name}});
  `uvm_object_utils({{seq_name}})

  function new(string name = "{{seq_name}}");
    super.new(name);
  endfunction

  virtual task body();
    {{txn_name}} tx;
    repeat (3) begin
      tx = {{txn_name}}::type_id::create("tx");
      assert(tx.randomize());
      start_item(tx);
      finish_item(tx);
    end
  endtask
endclass

