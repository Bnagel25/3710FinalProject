
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name IO_Controller_Test -dir "C:/3710_project/IO_Controller_Test/IO_Controller_Test/planAhead_run_3" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/3710_project/IO_Controller_Test/IO_Controller_Test/IO_Controller.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/3710_project/IO_Controller_Test/IO_Controller_Test} }
set_property target_constrs_file "Nexys3_IO.ucf" [current_fileset -constrset]
add_files [list {Nexys3_IO.ucf}] -fileset [get_property constrset [current_run]]
link_design
