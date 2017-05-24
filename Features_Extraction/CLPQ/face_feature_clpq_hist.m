%Concatenation of CLPQ Histograms of each block for image img
%CDTA/ASM/BSM
%E. BOUTELLAA
%Last modified 27/10/12

function feature=face_feature_clpq_hist(lpq,BlockSize,qlev)
ImSize=size(lpq);
BlockNum=[floor(ImSize(1)/BlockSize),floor(ImSize(2)/BlockSize)];

feature=[];
for a=1:BlockNum(1)
    for b=1:BlockNum(2)
        block = lpq((a-1)*BlockSize+1:a*BlockSize,(b-1)*BlockSize+1:b*BlockSize,:);
        feature = [feature, int2hist(block, qlev)'];
    end
end

