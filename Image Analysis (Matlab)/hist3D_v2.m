% function valu = hist3D(A, space)
% valu = zeros(length(space(:, 1)), length(space(:, 2)), length(space(:, 3)));
% for i = 1:length(A)
%     pos = zeros(3,1);
%     for j = 1:1:3
%         tempArr = repmat(A(i, j), length(space(:, j)), 1);
%         [~, I] = min(abs(tempArr - space(:, j)));
%         if (tempArr(I) - space(I, j))>= 0
%             pos(j) = I;
%         else
%             pos(j) = I + 1;
%         end
%     end
%     valu(pos(1), pos(2), pos(3)) = valu(pos(1), pos(2), pos(3)) + 1;    
% end
% return
% end

%v2: change length(A) to size(A,1)

function valu = hist3D_v2(A, xspace, yspace, zspace)
valu = zeros(length(xspace), length(yspace), length(zspace));
for i = 1:size(A,1)
%     for j = 1:1:3
        tempArr = repmat(A(i, 1), length(xspace), 1);
        diffarr = abs(tempArr - xspace);
        [~, I] = min(diffarr); % Gets index for minimum value.
%         if (tempAr(I) >0)
        if (tempArr(I) >= xspace(I)) 
            xpos = I;
        else
            xpos = I-1;
        end
        tempArr = repmat(A(i, 2), length(yspace), 1);
        diffarr = abs(tempArr - yspace);
        [~, I] = min(diffarr);
        if (tempArr(I) >= yspace(I)) 
            ypos = I;
        else
            ypos = I-1;
        end
        tempArr = repmat(A(i, 3), length(zspace), 1);
        diffarr = abs(tempArr - zspace);
        [~, I] = min(diffarr);
        if (tempArr(I) >= zspace(I)) 
            zpos = I;
        else
            zpos = I-1;
        end
%     end
    
    % Add 1 count to the histogram at the located position.
    valu(xpos, ypos, zpos) = valu(xpos, ypos, zpos) + 1;    
end
return
end