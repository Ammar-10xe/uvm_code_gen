class {{ design_name }}_monitor extends uvm_monitor;

  `uvm_component_utils({{ design_name }}_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // Monitor logic here
  endtask
endclass
