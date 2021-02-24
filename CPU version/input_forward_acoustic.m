%% input
close all;
clear all;

% load image
vp=ones(3000,3000)*2000;

% dimensions
dt=10^-3;
dx=10;
dz=10;
nt=100;
nx=size(vp,1);
nz=size(vp,2);

X=[0,dx*nx];
Z=[0,-dz*nz];

% generate empty density
C.rho=ones(nx,nz)*1;

% Lame constants
C.lambda=C.rho.*vp.^2;
%%
% source
% magnitude
M=2.7;

s1=fix(nx/2);
s3=fix(nz/2);
%%
% point interval in time steps
plot_interval=100;

p2=mfilename('fullpath');



% source frequency [Hz]
freq=5;

% source signal
singles=rickerWave(freq,dt,nt,M);

% give source signal
src=zeros(nt,1);
src=1*repmat(singles,[1,length(s3)]);

s1t=dx*s1;
s3t=-dz*s3;

% figure path
path=[p2 '/'];

tic;
%% pass parameters to solver
acoustic_2D(dt,dx,dz,nt,nx,nz,...
    X,Z,...
    s1,s3,src,...
    s1t,s3t, ...
    C, ...
    plot_interval, ...
    path);

toc;
%%
tic;
a=zeros(5000,5000)+ones(5000,5000);
toc;