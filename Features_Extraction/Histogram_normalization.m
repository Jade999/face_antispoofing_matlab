function [Data]=Histogram_normalization(Data,features)
for i=1:size(Data,1)
    for j=1:size(Data,2)
            if(strcmp(features,'LBPTOP'))
                Data{i,j}=Data{i,j}./284456;
            end
            if(strcmp(features,'LBP')||strcmp(features,'LBPOPP'))
               Data{i,j}=Data{i,j}./3844;

            end
            if(strcmp(features,'LPQ'))
                Data{i,j}=Data{i,j}./3364;

            end
            if(strcmp(features,'BSIF'))
                Data{i,j}=Data{i,j}./4096; 
            end
            if(strcmp(features,'CoLBP'))
                Data{i,j}=Data{i,j}./13456; 

            end
            if(strcmp(features,'CoLBP3'))
                Data{i,j}=Data{i,j}./13456; 

            end
            if(strcmp(features,'Color(16 16 16)')||strcmp(features,'Color(32 32 32)')||strcmp(features,'Color(64 64 64)'))
                Data{i,j}=Data{i,j}./4096;
            end            
            if(strcmp(features,'SID'))
                Data{i,j}=Data{i,j}./sum(Data{i,j},2);
            end
     
    end
end