   function shear_band_calculation

warning off;
% 
% N = 250;
ztot =1;
dz = 1;
% dx = zeros(N-1, ztot);
% dy = zeros(N-1, ztot);
zini = 1;

%%%%%%%%%%%%% set the data path %%%%%%%%%%%%%%%

bigpath = char('H:\2016_02_10.mdb\');

% pathlist = ...b  
% {'shear_rate_100_dz02_N200_dt0725s_2/' ...
% 'shear_rate_200_dz02_N200_dt0725s_2/' ...
% 'shear_rate_480_dz02_N200_dt0725s_2/' ...
% 'shear_rate_950_dz02_N200_dt0725s_2/' ...
% 'shear_rate_1800_dz02_N200_dt045s_2/' ...
% % };
% 
% pathlist= ...
%         {
%         '0' ...
%         '0005' ...
%         '\y_001V_' ...
        
%     '12' ...
%      '25' ...
%     '30' ...
%     
%     '01' ...
%     '02' ...
%     '05' ...
%     '1' ...
%     '2' ...
%     '5' ...
%     '10' ...
% %     '6' ...
%      };
% % {
% 'BottomMotionCalibraation_02Hz' ...
% }
% 
% pathlist2 = ...
%     {
%         'Top' ...
%         'Bottom' ...
%     
% 
%     };
% 
% for minpos = 2:1:16
% for pcnt=1:1:2
% for bcnt = 1:1:2 
% files = dir([bigpath num2str(pcnt)]);  
    %%%%%%%%%%%%% set the data path %%%%%%%%%%%%%%%
    
    file_path = ['G:\BackUp_Colloids_Data\2016_02_25\Gap_Uniaxial.mdb\Gap23_bottom6.lsm'];
%     file_path = 'C:\Data\Peizo_Test.mdb\Peizo_test_y_05V_x_05V.lsm'
    strainpathX = [file_path '_v_fieldX1.csv'];
    strainpathY = [file_path '_v_fieldY1.csv'];
    
    %%%%%%%%%%%%% set the data path %%%%%%%%%%%%%%%
    InfoImage = imfinfo(file_path);
    N = length(InfoImage);
    dx = zeros(N/2-1, ztot);
    dy = zeros(N/2-1, ztot);
    
    for zframe = zini : dz : ztot
        
        for time = 1 :1:N/2-1
            
            file1 = [file_path];
            K = imread(file1, 2*(ztot*(time-1)+zframe)-1);
            file1 = [file_path, num2str(time), '_temp.tif'];
            imwrite(K,file1);
            
            file2 = [file_path];
            K = imread(file2, 2*(ztot*(time)+zframe)-1 );
            file2 = [file_path, num2str(time+1), '_temp.tif'];
%                        
%             file2 = [file_path, num2str(time+1), '.tif'];
%             K = imread(file2,zframe);
%             file2 = [file_path, num2str(time+1), '_temp_2.tif'];
            imwrite(K,file2);
            
            %%%%%%%%%% calculate the piv %%%%%%%%%%%%%%%%%
            % Algorithm definitions
            windows = [512 32; 512 32];
            overlap = 0.5;  %Defines overlap of interrogation regions for matpiv.m
            method = 'multin';  %Defines evaluation mode for matpiv.m
            warning off Images:isrgb:obsoleteFunction;  %Turn off annoying warning
            
            Dt = 1;
            
            [x,y,u,v] = matpiv_gpu(file1, file2, windows, Dt, overlap, method);
            
            dx(time, zframe) = mean(u);
            dy(time, zframe) = mean(v);
            
            delete(file1); 
            delete(file2);
            
        end
        
        fprintf(['\n\n\n\n\n' file1 '\n']);
        
    end 
    
% end

 csvwrite(strainpathX, dx);
 csvwrite(strainpathY, dy);

% end
end
% end
% 
%    end