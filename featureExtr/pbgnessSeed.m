function boundary_index = pbgnessSeed( input_im, spnum, superpixels, pb_im)
%% background seeds
% L = imlab(:,:,1);
% A = imlab(:,:,2);
% B = imlab(:,:,3);


[row,col,~] = size(input_im);
row_thes = 0.1*row;
col_thes = 0.1*col;
pos_mat=zeros(spnum,2);
% color_mat=zeros(spnum,3);
pb_weight = zeros(spnum, 1);
STA=regionprops(superpixels,'PixelList','Centroid','Area');
[sx,sy]=vl_grad(double(superpixels), 'type', 'forward') ; s = sx | sy;
for j = 1:spnum
    mask = superpixels == j; 
    %     boundary = edge(mask).*pb_im; %edge(I) matlab��������ͼ���еı�edge(mask)�õ���ǰ�����ؿ��������edge(mask).*pb_im��Ϊpb_im�ڴ˳����ر�Ե�ϴ��ڵ�ͼ���Ե������
    %     idx = find(edge(mask) == 1);%�õ���ǰ�����ؿ�ı�Ե�ж�������
    %     weight = sum(sum(boundary))/length(idx);
    sj = s & mask; boundary = sj .* pb_im;
    weight = sum(sum(boundary))/sum(sum(sj));
    %�ó����ذ���ͼ���Ե��������ռ���������ر�Ե���ı�����ΪȨ�أ������ر�Ե������ͼ���Ե�ı���Խ��Ȩ��Խ��
    pb_weight(j) = weight;
    %     pixelind = STA(j).PixelIdxList;%��ͼ��ȫ���ų�һ�У�Ȼ��洢�˳����ذ������������
    indxy = STA(j).PixelList; %��ǰ�����ذ������������ص� [�к�,�к�]
    pos_mat(j,:) = [mean(indxy(:,1)),mean(indxy(:,2))];
    %��ǰ�����ص�����ֵ �����������STATS(j).Centroid�Ľ����һ����
    %λ�������������Ͻ�Ϊԭ�㣬����ΪX�ᣬ����ΪY���λ��ֵ
    %     color_mat(j,:) = [mean(L(pixelind)),mean(A(pixelind)),mean(B(pixelind))];%������ƽ����ɫ
end
thresh = graythresh(pb_weight);% graythresh ���ڼ������г�����Ȩ��֮������ Otsu �������õ�һ����һ������ֵ
boundary_index = zeros(spnum, 1); ind = 1; %�洢�������ӳ�����
% background_seeds_map=zeros(row,col,3);
% guided_input = ones(row,col);%Ҫ�ձ������ӳ����أ�����������ͼ����ǰ��ͼ������ֵ��Ϊ1
for j = 1: spnum
    center = STA(j).Centroid;
    if (center(2)<row_thes||center(2)>(row-row_thes)||center(1)<col_thes||center(1)>(col-col_thes))
        %�������ӳ���������Ҫ���㳬����������border�Ŀ�ȷ�Χ�ڣ�����������ٿ���һ�������Ƿ�����
        if pb_weight(j)<thresh
            %���Ȩ��С�ڼ������ֵ������Ϊ���Ǳ������ӳ�����
            boundary_index(ind) = j; ind = ind + 1;
            %             pixelind = STA(j).PixelIdxList;
            %             guided_input(pixelind) = 0;%����Щ�������ӳ����ص���������λ�õ�ֵ��Ϊ0
        end
    end
end
boundary_index(ind : end) = [];

% R = input_im(:,:,1);
% G = input_im(:,:,2);
% B1 = input_im(:,:,3);
% background_seeds_map(:,:,1)=R.*guided_input;
% background_seeds_map(:,:,2)=G.*guided_input;
% background_seeds_map(:,:,3)=B1.*guided_input;
% imwrite(background_seeds_map,[background_seeds_map_path,imName(1:end-4),'.jpg']);

end

