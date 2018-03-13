
function [patterns,N,N_pattern]=read_patterns(number)

if number == 3
    pattern_list=[1,2,3];
else 
    pattern_list=[1,2,3,4];
end

N=60;
N_pattern=8;

figure(1)

file='pinkpanther4.tif';
patt2d=double(imread(file));
patt_max=max(max(patt2d));
patt_min=min(min(patt2d));
plevel=160;
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
patt2d=sign(patt2d-plevel);
size(patt2d);
for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix,iy);
        patt2ds(ix,iy)=patt2d(ix,iy);
    end
end
patterns(1,:)=reshape(ptemp,N*N,1);
subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),1)
imagesc(patt2ds,[-1 1])
axis square
title(' Patterns')

file='neuron.tif';
patt2d=double(imread(file));
patt_max=max(max(patt2d));
patt_min=min(min(patt2d));
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
%patt2d=sign(patt2d);
plevel=100;
patt2d=sign(patt2d-plevel);
size(patt2d);
for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix,iy);
        patt2ds(ix,iy)=patt2d(ix,iy);
    end
end
patterns(2,:)=reshape(ptemp,N*N,1);
subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),2)
imagesc(patt2ds,[-1 1])
axis square

%file='receptive_field_2.tif';
%file='wrigley.tif';
file='miracle.tif';
%file='toby.tif';
patt2d=double(imread(file));
patt_max=max(max(patt2d));
patt_min=min(min(patt2d));
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
%patt2d=sign(patt2d);
plevel=130;
patt2d=sign(patt2d-plevel);
patt2d=-patt2d;
size(patt2d);
for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix,iy);
        patt2ds(ix,iy)=patt2d(ix,iy);
    end
end
patterns(3,:)=reshape(ptemp,N*N,1);
subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),3)
imagesc(patt2ds,[-1 1])
axis square

%file='receptive_field_2.tif';
%file='wrigley_2.tif';
%file='miracle.tif';
%file='toby.tif';
file='monkey.tif';
patt2d=double(imread(file));
patt_max=max(max(patt2d));
patt_min=min(min(patt2d));
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
%patt2d=sign(patt2d);
plevel=120;
patt2d=sign(patt2d-plevel);
size(patt2d);
for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix,iy);
        patt2ds(ix,iy)=patt2d(ix,iy);
    end
end
patterns(4,:)=reshape(ptemp,N*N,1);
subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),4)
imagesc(patt2ds,[-1 1])
axis square

ncoarse=10;
file='pictures1.tif';
patt2d=double(imread(file));
size(patt2d);
patt_max=max(max(patt2d(:,:,1)));
patt_min=min(min(patt2d(:,:,1)));
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
%patt2d=sign(patt2d-plevel);
patt2d_orig=plevel-2*(patt2d(:,:,1)-patt_min)*plevel/(patt_max-patt_min);
patt2d_orig=-patt2d_orig;
xoffset=6; yoffset=1;
patt2d=coarsen(patt2d_orig,ncoarse);
size(patt2d);

for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
        patt2ds(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
    end
end
patterns(5,:)=reshape(ptemp,N*N,1);
size(patt2ds);
subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),5)
imagesc(patt2ds,[-1 1])
axis square

ncoarse=10;
file='pictures3.tif';
patt2d=double(imread(file));
size(patt2d);
patt_max=max(max(patt2d(:,:,1)));
patt_min=min(min(patt2d(:,:,1)));
%plevel=2;
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
%patt2d=sign(patt2d-plevel);
patt2d_orig=plevel-2*(patt2d(:,:,1)-patt_min)*plevel/(patt_max-patt_min);
patt2d_orig=-patt2d_orig;

patt2d=coarsen(patt2d_orig,ncoarse);
size(patt2d);
xoffset=0; yoffset=0;
for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
        patt2ds(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
    end
end
patterns(6,:)=reshape(ptemp,N*N,1);

subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),6)
imagesc(patt2ds,[-1 1])
axis square

ncoarse=10;
file='pictures4.tif';
patt2d=double(imread(file));
size(patt2d);
patt_max=max(max(patt2d(:,:,1)));
patt_min=min(min(patt2d(:,:,1)));
%plevel=2;
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
%patt2d=sign(patt2d-plevel);
patt2d_orig=plevel-2*(patt2d(:,:,1)-patt_min)*plevel/(patt_max-patt_min);
patt2d_orig=-patt2d_orig;
patt2d=coarsen(patt2d_orig,ncoarse);

size(patt2d);
xoffset=5; yoffset=0;
for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
        patt2ds(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
    end
end
patterns(7,:)=reshape(ptemp,N*N,1);
subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),7)
imagesc(patt2ds,[-1 1])
axis square

ncoarse=8;
file='mouse.tif';
patt2d=double(imread(file));
size(patt2d);
patt_max=max(max(patt2d(:,:,1)));
patt_min=min(min(patt2d(:,:,1)));
%plevel=2;
%patt2d=2*patt2d/(patt_max-patt_min)-(patt_max+patt_min)/(patt_max-patt_min);
%patt2d=sign(patt2d-plevel);
patt2d_orig=plevel-2*(patt2d(:,:,1)-patt_min)*plevel/(patt_max-patt_min);
patt2d_orig=-patt2d_orig;
patt2d=coarsen(patt2d_orig,ncoarse);

size(patt2d);
xoffset=0; yoffset=10;
for ix=1:N
    for iy=1:N
        ptemp(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
        patt2ds(ix,iy)=patt2d(ix+xoffset,iy+yoffset);
    end
end
patterns(8,:)=reshape(ptemp,N*N,1);

subplot(ceil(sqrt(N_pattern)),ceil(sqrt(N_pattern)),8)
imagesc(patt2ds,[-1 1])
axis square


patterns=patterns(pattern_list,:);
N_pattern=length(pattern_list);

end % read_pattern


%%%%%%%%%%%%%%%%
function pattern_out=coarsen(pattern,npixels)

[nx,ny]=size(pattern);

for ix=1:floor(nx/npixels)
    for iy=1:floor(ny/npixels)
        pattern_out(ix,iy)=0;
        for ixpix=1:npixels
            for iypix=1:npixels
                pattern_out(ix,iy)=pattern_out(ix,iy)+pattern((ix-1)*npixels+ixpix,(iy-1)*npixels+iypix);
            end
        end
    end
end

pattern_out=pattern_out/npixels^2;

end
