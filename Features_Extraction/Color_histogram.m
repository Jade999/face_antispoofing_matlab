function H=Color_histogram(im,max_val,min_value,nbins)
nb_element=(max_val-min_value);
H=zeros(1,nbins);
im=double(im);
n_el=nb_element/nbins;
for i=1:numel(im)
pos=floor((im(i)-min_value)/n_el)+1;
if(pos<=0)
    pos=1;
end
if(pos>=nbins)
    pos=nbins;
end
H(pos)=H(pos)+1;
end
