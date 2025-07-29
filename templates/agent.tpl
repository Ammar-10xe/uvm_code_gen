class {{ design_name }}_agent extends uvm_agent;
  `uvm_component_utils({{ design_name }}_agent)

  {{ design_name }}_driver driver;
  {{ design_name }}_monitor monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = {{ design_name }}_driver::type_id::create("driver", this);
    monitor = {{ design_name }}_monitor::type_id::create("monitor", this);
  endfunction
endclass
