clear;
clc;
close all;

data = xlsread("sim.xls");
R = rCalc(data);

csvwrite("R.csv", R);