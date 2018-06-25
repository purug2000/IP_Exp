%Simple implementation of JPEG compression A little rudimentary, 
%NOT a perfect  code: need color extraction for relevant colors to make
%sure proper compression and aliasing thereafter
%
im1=(imread('4.png'));%Image address
im1=double(rgb2ycbcr(im1));
l=size(im1,1);
h=size(im1,2);
w=size(im1,3);
m1=ones([1 l/8]);
m2=ones([1 h/8]); 
%subplot(1,3,1);imshow(uint8(im1));
D=dctmtx(8)
t=0
rowv=zeros([8,size(im1,1),3]);
fin_mat=zeros(size(im1));
%subplot(1,3,2);imshow(ycbcr2rgb(uint8(im1)));

for k = 0:l/8-1
    for t = 0:h/8-1
        if t*8+8>h
            if k*8+8>l
                y=k*8-l+8;
                x=t*8-h+8;
                t*8
                mat=[im1(k*8+1:l,t*8+1:h,:)]
                zeros(8-y, x,3)
                zeros(y,8-x,3)
                zeros(y,x,3)
            else
                x=t*8-h+8;
                mat=[im1(k*8+1:k*8+8,t*8:h,:) zeros(8,x,3)];
            end
        else
             if k*8+8>l
                y=k*8-l+8;
                mat=[im1(k*8+1:l,t*8+1:t*8+8,:); zeros(y,8,3)];
             else
                mat=[im1(k*8+1:k*8+8,t*8+1:t*8+8,:)];
             end
        end
            mat(:,:,1)=D*(mat(:,:,1))*D';
            mat(:,:,2)=D*(mat(:,:,2))*D';
            mat(:,:,3)=D*(mat(:,:,3))*D';
            rowv(:,t*8+1:t*8+8,:)=mat;
    end
    fin_mat(k*8+1:k*8+8,:,:)=rowv;
end   
fin_mat=double(floor((int16(fin_mat)/200)))*200;
%subplot(1,3,3);
%imshow((fin_mat));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%For decrypting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
for k = 0:l/8-1
    for t = 0:h/8-1
        if t*8+8>h
            if k*8+8>l
                y=k*8-l+8;
                x=t*8-h+8;
                t*8
                mat=[fin_mat(k*8+1:l,t*8+1:h,:)]
                zeros(8-y, x,3)
                zeros(y,8-x,3)
                zeros(y,x,3)
            else
                x=t*8-h+8;
                mat=[fin_mat(k*8+1:k*8+8,t*8:h,:) zeros(8,x,3)];
            end
        else
             if k*8+8>l
                y=k*8-l+8;
                mat=[fin_mat(k*8+1:l,t*8+1:t*8+8,:); zeros(y,8,3)];
             else
                mat=[fin_mat(k*8+1:k*8+8,t*8+1:t*8+8,:)];
             end
        end
            mat(:,:,1)=D'*(mat(:,:,1))*D;
            mat(:,:,2)=D'*(mat(:,:,2))*D;
            mat(:,:,3)=D'*(mat(:,:,3))*D;
            rowv(:,t*8+1:t*8+8,:)=mat;
    end
    fin_mat(k*8+1:k*8+8,:,:)=rowv;
end   
figure;
imshow(ycbcr2rgb(uint8(fin_mat)));%Display IMage
