function [ Z ] = paralel( z1,z2 )
%PARALLEL Summary of this function goes here
%   Detailed explanation goes here
Z=zeros(size(z1));
den=z1+z2;
num=z1.*z2;
Z=num./den;
