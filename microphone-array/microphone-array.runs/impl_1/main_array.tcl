proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Labtools 27-147} -limit 4294967295

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  set_param xicom.use_bs_reader 1
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.cache/wt [current_project]
  set_property parent.project_dir C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array [current_project]
  add_files -quiet C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/synth_1/main_array.dcp
  add_files -quiet C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/cascaded_integrator_comb_synth_1/cascaded_integrator_comb.dcp
  set_property netlist_only true [get_files C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/cascaded_integrator_comb_synth_1/cascaded_integrator_comb.dcp]
  add_files -quiet C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/half_band_FIR_synth_1/half_band_FIR.dcp
  set_property netlist_only true [get_files C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/half_band_FIR_synth_1/half_band_FIR.dcp]
  add_files -quiet C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/lp_FIR_synth_1/lp_FIR.dcp
  set_property netlist_only true [get_files C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/lp_FIR_synth_1/lp_FIR.dcp]
  read_xdc -mode out_of_context -ref cascaded_integrator_comb -cells U0 c:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/sources_1/ip/cascaded_integrator_comb/cascaded_integrator_comb_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/sources_1/ip/cascaded_integrator_comb/cascaded_integrator_comb_ooc.xdc]
  read_xdc -mode out_of_context -ref half_band_FIR -cells U0 c:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/sources_1/ip/half_band_FIR/half_band_FIR_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/sources_1/ip/half_band_FIR/half_band_FIR_ooc.xdc]
  read_xdc -mode out_of_context -ref lp_FIR -cells U0 c:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/sources_1/ip/lp_FIR/lp_FIR_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/sources_1/ip/lp_FIR/lp_FIR_ooc.xdc]
  read_xdc C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.srcs/constrs_1/new/main_array.xdc
  link_design -top main_array -part xc7a100tcsg324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  catch {update_ip_catalog -quiet -current_ip_cache {c:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.cache} }
  opt_design 
  write_checkpoint -force main_array_opt.dcp
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force main_array_placed.dcp
  catch { report_io -file main_array_io_placed.rpt }
  catch { report_clock_utilization -file main_array_clock_utilization_placed.rpt }
  catch { report_utilization -file main_array_utilization_placed.rpt -pb main_array_utilization_placed.pb }
  catch { report_control_sets -verbose -file main_array_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force main_array_routed.dcp
  catch { report_drc -file main_array_drc_routed.rpt -pb main_array_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -file main_array_timing_summary_routed.rpt -pb main_array_timing_summary_routed.pb }
  catch { report_power -file main_array_power_routed.rpt -pb main_array_power_summary_routed.pb }
  catch { report_route_status -file main_array_route_status.rpt -pb main_array_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force main_array.bit 
  if { [file exists C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/synth_1/main_array.hwdef] } {
    catch { write_sysdef -hwdef C:/Users/coltmw/Documents/GitHub/ecen4024-microphone-array/microphone-array/microphone-array.runs/synth_1/main_array.hwdef -bitfile main_array.bit -meminfo main_array_bd.bmm -file main_array.sysdef }
  }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

