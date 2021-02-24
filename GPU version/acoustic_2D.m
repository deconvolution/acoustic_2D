function acoustic_2D(dt,dx,dz,nt,nx,nz,...
    X,Z,...
    s1,s3,src,...
    s1t,s3t, ...
    C, ...
    plot_interval, ...
    path)
%% create folder for figures

if ~exist(path,'dir')
    mkdir(path)
end

n_picture=1;

if plot_interval~=0
    if ~exist([path '/forward_pic/'],'dir')
        mkdir([path '/forward_pic/'])
    end
end
%% source
ind_sor=sub2ind([nx,nz],s1,s3);
%% monoclinic 2D solver xz plane (symmetric plane)
v1=gpuArray(zeros(nx,nz,'single'));
v3=v1;

p=v1;
ts=v1;
ts2=v1;

l=1;
p(ind_sor)=p(ind_sor)+src(1,:);
%%
tic;
for l=2:nt-1
    %% compute sigma
    v1_x=D(v1,1)/dx;
    v3_z=D(v3,3)/dz;
    p=-dt*(C.lambda.*(v1_x+v3_z)) ...
        +p;
    p(ind_sor)=p(ind_sor)+src(l,:);
    %% compute v
    v1=dt./C.rho.*(D(-p,-1)/dx)...
        +v1;
    v3=dt./C.rho.*(D(-p,-3)/dz)...
        +v3;
    %% plot
    if plot_interval~=0
        if mod(l,plot_interval)==0 || l==nt-1
           
            hfig=figure('Visible','off');
            imagesc(X,Z,p');
            set(gca,'ydir','normal');
            colorbar;
            xlabel({['x [m]']});
            ylabel({['z [m]']});
            title({['t=' num2str(l*dt) 's'],['p [Pa]']});
            xlabel('x [m]');
            ylabel('z [m]');
            colorbar;
            hold on;
            
            ax2=plot(s1t,s3t,'v','color',[1,0,0]);
            hold on;
            
            print(gcf,[path './forward_pic/' num2str(n_picture) '.png'],'-dpng','-r200');
            n_picture=n_picture+1;
            
        end
    end
    
    fprintf('\n time step=%d/%d',l+1,nt);
    fprintf('\n    epalsed time=%.2fs',toc);
    fprintf('\n    n_picture=%d',n_picture);
    d=clock;
    fprintf('\n    current time=%d %d %d %d %d %.0d',d(1),d(2),d(3),d(4),d(5),d(6));
    
end
%%
