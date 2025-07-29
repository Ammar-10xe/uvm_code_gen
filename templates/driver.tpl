class {{ design_name }}_driver extends uvm_driver;

  `uvm_component_utils({{ design_name }}_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // Driver logic here
  endtask
endclass
