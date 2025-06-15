#!/bin/csh

source ~/cshrc
xrun -f file.f -access +rwc  -coverage U -covdut testbench -covoverwrite
imc -load /home/cc/Downloads/SV_module/Lab40_layered_testbench/cov_work/scope/test
