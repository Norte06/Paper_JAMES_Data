 &time_control
 run_days                            = 0,
 run_hours                           = 0,
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = <yr1>,<yr1>,<yr1>,
 start_month                         = <mo1>,<mo1>,<mo1>,
 start_day                           = <dy1>,<dy1>,<dy1>,
 start_hour                          = <hr1>,<hr1>,<hr1>,
 start_minute                        = 00,00,00,
 start_second                        = 00,00,00,
 end_year                            = <yr2>,<yr2>,<yr2>,
 end_month                           = <mo2>,<mo2>,<mo2>,
 end_day                             = <dy2>,<dy2>,<dy2>,
 end_hour                            = <hr2>,<hr2>,<hr2>,
 end_minute                          = 00,00,00,
 end_second                          = 00,00,00,
 interval_seconds                    = 21600
 input_from_file                     = .true.,.true.,.true.,
 history_interval_h                  = <his_int_h>,<his_int_h>,<his_int_h>,
 frames_per_outfile                  = <his_nb_out>,<his_nb_out>,<his_nb_out>,
 restart                             = .<rst>.,
 restart_interval_h                  = <rst_int_h>,
 override_restart_timers             = .true.
 write_hist_at_0h_rst                = .true.,
 iofields_filename                   = "myoutfields_aw.txt"
 ignore_iofields_warning             = .true.
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 io_form_auxinput4                   = 2
 auxinput4_inname                    = "wrflowinp_d01"
 auxinput4_interval                  = 360, 360, 360,
 debug_level                         = 0
 /

 &domains
 time_step                           = <dt>.,
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 1,
 max_dom                             = 1,
 e_we                                = 501,
 e_sn                                = 326,
 e_vert                              = 60,
 p_top_requested                     = 5000,
 num_metgrid_levels                  = 38,
 num_metgrid_soil_levels             = 4,
 dx                                  = 8894.198,
 dy                                  = 8894.198,
 grid_id                             = 1,     2,     3,
 parent_id                           = 0,     1,     2,
 i_parent_start                      = 1,32,35,
 j_parent_start                      = 1,153,24,
 parent_grid_ratio                   = 1,5,3,
 parent_time_step_ratio              = 1,5,3,
 feedback                            = 1,
 smooth_option                       = 2
 num_ext_model_couple_dom            = 1,
 nproc_x                             = <nproc_x>,
 nproc_y                             = <nproc_y>,
 numtiles                            = 1
 /

 &physics
 mp_physics                          = 6,     6,     6,
 ra_lw_physics                       = 1,     1,     1,
 ra_sw_physics                       = 1,     1,     1,
 radt                                = 10,    5,     5,
 sf_sfclay_physics                   = 1,     1,     1,
 sf_surface_physics                  = 2,     2,     2,
 sf_urban_physics                    = 0,     0,     0,
 bl_pbl_physics                      = 5,     5,     5,
 bldt                                = 0,     0,     0,
 bl_mynn_tkebudget                   = 1,     1,     1,
 cu_physics                          = 2,     0,     0,
 cudt                                = 5,     5,     5,
 isfflx                              = 1,
 ifsnow                              = 0,
 icloud                              = 1,
 surface_input_source                = 1,
 num_land_cat                        = 21,
 num_soil_layers                     = 4,
 sst_update                          = 0,
 lagday                              = 150,
 sst_skin                            = 0,
 isftcflx                            = 0,
 prec_acc_dt                         = 360., 360., 360.,
 /

 &dynamics
 rk_ord                              = 3,
 diff_opt                            = 1,1,1,
 km_opt                              = 4,4,4,
 diff_6th_opt                        = 0,0,0,
 diff_6th_factor                     = 0.12,0.12,0.12,
 damp_opt                            = 0,
 dampcoef                            = 0.2,0.2,0.2
 zdamp                               = 5000.,5000.,5000.,
 w_damping                           = 0,
 base_temp                           = 290.
 khdif                               = 0,0,0,
 kvdif                               = 0,0,0,
 smdiv                               = 0.1,0.1,0.1,
 emdiv                               = 0.01,0.01,0.01,
 epssm                               = 0.1,0.1,0.1,
 non_hydrostatic                     = .true., .true., .true.,
 h_mom_adv_order                     = 5,5,5,
 v_mom_adv_order                     = 3,3,3,
 h_sca_adv_order                     = 5,5,5,
 v_sca_adv_order                     = 3,3,3,
 moist_adv_opt                       = 1,1,1,     
 scalar_adv_opt                      = 2,2,2,     
 tke_adv_opt                         = 2,2,2,
 tracer_adv_opt                      = 0,0,0,
 tracer_opt                          = 5,5,5,
 dyn_opt                             = 2,
 gwd_opt                             = 1,
 time_step_sound                     = 4,
 /

 &bdy_control
 spec_bdy_width                      = 5,
 spec_zone                           = 1,
 relax_zone                          = 4,
 specified                           = .true., .false.,.false.,
 nested                              = .false., .true., .true.,
 spec_exp                            = 0.33,
 periodic_x                          = .false.,
 symmetric_xs                        = .false.,
 symmetric_xe                        = .false.,
 open_xs                             = .false.,
 open_xe                             = .false.,
 periodic_y                          = .false.,
 symmetric_ys                        = .false.,
 symmetric_ye                        = .false.,
 open_ys                             = .false.,
 open_ye                             = .false.,
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = <niotaskpg>,
 nio_groups = <niogp>,
 /

 &fdda
 /
