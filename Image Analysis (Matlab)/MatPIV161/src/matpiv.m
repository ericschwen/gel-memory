function [xw,yw,uw,vw,SnR,Pkh,u2,v2]=matpiv(varargin)
% MATPIV - the Particle Image Velocimetry toolbox for MATLAB
%
% function [xw,yw,uw,vw,snr,pkh]=matpiv(im1,im2,winsize,Dt,overlap...
% ,method,wocofile,mask,ustart,vstart)
%
% IM1 and IM2 are the images to perform PIV with.
% WINSIZE is the size of the interrogation windows, DT is the time
% between images, OVERLAP is the overlap of interrogation wins 
% (measured in percent), METHOD defines the method for calculating
% velocities (single pass='single', multiple passes='multi', 
% autocorrelation='auto' and phase correlation (single pass)= 'phase'. 
%
% Autocorrelation requires only one image and this should be 
% specified as IM1. In the place of the second image one should 
% specify the artificial window shift present, using square 
% brackets. If no window shift is available, specify [0 0],
%
% WINSIZE can be a N*2 vector containing the size of the interrogation regions 
% (x and y). F.eks inserting [64 64;64 64;32 32;32 32;16 16;16 16] will 
% cause MATPIV to use 6 passes starting with 64*64 windows and ending with 16*16.
% It is also possible to use something like [64 64;64 32;32 32;32 16;32 16]
% resulting in 5 passes ending up with 32*16 pixels large interrogation regions.
%
% WOCOFILE is a file as produced by the m-file DEFINEWOCO. The 
% latter file calculates the linear pixel to world mapping 
% coefficients (using the m-file TLS) and saves them to WOCOFILE
% (Typically called 'worldco1.mat'). WOCOFILE can be omitted 
% when calling MATPIV. The results will then be measured in
% pixels and pixels/cm.
% Please consult a decent book on PIV for a better explanation 
% and theoretical understanding of the subject.
%
% Latest addition is an extension of the MULTIPASS method and uses
% one more pass than the original version. It is called 'multin'.
%
% See also:
%            INTPEAK, DEFINEWOCO, PIXEL2WORLD, VALIDATE
%            SINGLEPASS, MULTIPASS, DESAMPLEPASS, HISTOOP
%            DIFFQUANT, INTQUANT, AUTOPASS

% MatPIV v. 1.6.1  Copyright J.K.Sveen (jks@math.uio.no),
%                  Department of Mathematics, Mechanics Division
%                  University of Oslo, Norway
%
% Distributed under the terms of the terms of the 
% GNU General Public License
%
% Time Stamp: 16:27, Jul 17, 2004
%
% Signal-To-Noise-Ratio calculation method by 
% Alex Liberzon and Roi Gurka.

%%%%%%%%%%%%%%%% Declarations
               %
validvec=3;    % Threshold value for use with the 
               % Vector validation needed in multipass operation 
%%%%%%%%%%%%%%%%

fprintf('\n');
% asign the input paramteres in VARARGIN to the appropriate variables
if length(varargin)==1
    fil=varargin{:}; fil=fil(1:end-2); eval(fil);
    if (ischar(msk)& ~isempty(msk)), mss=load(msk);ms=mss.maske; end
    if exist('ustart','var')==0, ustart=[]; vstart=[]; end
end
if nargin==5
  [im1,im2,winsize,Dt,overlap]=deal(varargin{:}); ms=''; ustart=[];vstart=[];
elseif nargin==6
  [im1,im2,winsize,Dt,overlap,method]=deal(varargin{:}); ms='';
   ustart=[];vstart=[];
elseif nargin==7
  [im1,im2,winsize,Dt,overlap,method,wocofile]=deal(varargin{:});
  ms=''; ustart=[];vstart=[]; 
elseif nargin==8
  [im1,im2,winsize,Dt,overlap,method,wocofile,msk]=deal(varargin{:});
  if (ischar(msk) & ~isempty(msk)), mss=load(msk);ms=mss.maske; else, ms=msk; end
   ustart=[];vstart=[];
elseif nargin==10
  [im1,im2,winsize,Dt,overlap,method,wocofile,msk,ustart,vstart]=deal(varargin{:});
  if ischar(msk), mss=load(msk);ms=mss.maske; end
end

if strcmp(method,'single')==1
  [x,y,u,v,SnR,Pkh,u2]=singlepass(im1,im2,winsize,Dt,overlap,ms);
elseif strcmp(method,'norm')==1
  [x,y,u,v,SnR,Pkh,u2,v2]=normpass(im1,im2,winsize,Dt,overlap,ms);
elseif ~isempty(findstr(method,'multi')) %~=0
    if size(winsize,1)>1
      if winsize(end,1)~=winsize(end-1,1)
	disp('Adding one iteration so that there are 2 iterations with')
	disp('the final interrogation window size')
	disp('   ')
	winsize=[winsize;winsize(end,:)];
      end
      iter=size(winsize,1);
    else
      iter=str2num(method(6:end));
    end
    
    if isempty(iter)
      iter=3;
    end

    if strcmp(method,'multin') | size(winsize,1)>1
      [x,y,u,v,SnR,Pkh]=multipassx(im1,im2,winsize,...
				   Dt,overlap,validvec,ms,iter, ...
				   ustart,vstart); 
    elseif strcmp(method,'multi') & size(winsize,1)==1
      [x,y,u,v,SnR,Pkh]=multipass(im1,im2,winsize,...
				   Dt,overlap,validvec,ms); 
    end
    
elseif strcmp(method,'mqd')==1
    [x,y,u,v,SnR,Pkh]=mqd(im1,im2,winsize,Dt,overlap,ms); 
elseif strcmp(method,'auto')==1
    if ischar(im2)==1
        disp(['Window shift should be a numeric vector',...
                'in sqaure brackets, not a string!'])
        return
    else
        wshift=im2;
    end
    [x,y,u,v,SnR,Pkh]=autopass(im1,winsize,Dt,overlap,wshift,ms);
    A=imread(im1); mfigure,(1),clf,imshow(A,[],'truesize')
    axis on, hold on, mfigure(1) 
    quiver(x,y,u,v,2,'g'), title('Measurements in pixel coordinates'); axis ij  
else
    disp('NOT A VALID CALCULATION METHOD!'); return
end

if nargin>6 | nargin==1
    if ~isempty(wocofile)
        % Transform from pixel coordinates to world coordinates.
        % You need to have a file called "worldco*.mat" as produced by the
        % DEFINEWOCO m-file in the present directory.
        % Change 'linear' to 'nonlinear' if you want nonlinear mapping.
        D=dir(wocofile);
        if size(D,1)==1
            mapp=load(D(1).name);
            [xw,yw,uw,vw]=pixel2world(u,v,x,y,mapp.comap(:,1),mapp.comap(:,2));
        else
            disp('No such world coordinate file present!')
            xw=x; yw=y;
            uw=u; vw=v;
            return
        end
        %save pixelcordinateresults.mat x y u v
    else
        %disp('No world coordinate file specified!')
        xw=x; yw=y;
        uw=u; vw=v; 
    end
elseif (nargin<=7 & nargin>1) | isempty(wocofile)
    %disp('No coordinate mapping file specified.')
    %disp('Using pixel coordinates!')
    xw=x; yw=y;
    uw=u; vw=v;
end

if nargout==1
    xw.x=xw;  xw.y=yw;
    xw.u=uw;  xw.v=vw;
    xw.snr=SnR; xw.pkh=Pkh;
end
