#----------------------------------------
# JasperGold Version Info
# tool      : JasperGold 2018.03
# platform  : Linux 3.10.0-1160.el7.x86_64
# version   : 2018.03p001 64 bits
# build date: 2018.04.24 18:13:05 PDT
#----------------------------------------
# started Thu Oct 02 14:46:58 CST 2025
# hostname  : superdome2
# pid       : 113762
# arguments : '-label' 'session_0' '-console' 'superdome2:45489' '-style' 'windows' '-data' 'AQAAADx/////AAAAAAAAA3oBAAAAEABMAE0AUgBFAE0ATwBWAEU=' '-proj' '/home/user1/avsd25/avsd2541/AVSD_Homework/Homework1/N26132047/build/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/user1/avsd25/avsd2541/AVSD_Homework/Homework1/N26132047/build/jgproject/.tmp/.initCmds.tcl' '../script/superlint.tcl'
check_superlint -init
clear -all

# Config rules
config_rtlds -rule -enable -domain { LINT }
config_rtlds -rule -disable -tag { CAS_IS_DFRC SIG_IS_DLCK SIG_NO_TGFL SIG_NO_TGRS SIG_NO_TGST FSM_NO_MTRN FSM_NO_TRRN }
# avsd2025_constraint //
config_rtlds -rule  -disable -category { NAMING AUTO_FORMAL_DEAD_CODE AUTO_FORMAL_SIGNALS AUTO_FORMAL_ARITHMETIC_OVERFLOW }
config_rtlds -rule  -disable -tag { IDN_NR_SVKY ARY_MS_DRNG IDN_NR_AMKY IDN_NR_CKYW IDN_NR_SVKW ARY_NR_LBND VAR_NR_INDL INS_NR_PTEX INP_NO_USED OTP_NR_ASYA FLP_NR_MXCS OTP_UC_INST OTP_NR_UDRV REG_NR_TRRC INS_NR_INPR MOD_NS_GLGC } 
config_rtlds -rule  -disable -tag { REG_NR_RWRC  }
config_rtlds -rule  -disable -tag { BUS_IS_FLOT ASG_IS_XRCH }
#config_rtlds -rule  -reset -sync
# avsd2025_constraint //

analyze -sv \
    +incdir+../include \
    +incdir+../src \
    ../src/top.sv

elaborate -bbox true -top top

# Setup clock and reset
clock clk
reset rst

# Setup for CTL check
set_superlint_fsm_ctl_livelock true
set_superlint_fsm_ctl_deadlock true

# Extract checks
check_superlint -extract

# Prove
set_superlint_prove_parallel_tasks on
set_prove_no_traces true
