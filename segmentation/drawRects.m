function [ dest ] = drawRects( src, rectsnd, c )
%��飺
%��ͼ��������ɫ�Ŀ�ͼ����������ǻҶ�ͼ����ת��Ϊ��ɫͼ���ٻ���ͼ
%----------------------------------------------------------------------
[rim, cim, z] = size(src);

%����ǵ�ͨ���ĻҶ�ͼ��ת��3ͨ����ͼ��
if 1==z, dest(:, : ,1) = src; dest(:, : ,2) = src; dest(:, : ,3) = src; else dest = src; end
[rn, pp] = size(rectsnd);
if pp == 3,
    rects = zeros(rn, 4);
    rects(:, 3 : 4) = rectsnd(:, 2 : 3);
    rects(:, 1 : 2) = ind2sub2([rim, cim],rectsnd(:, 1));
end
%��ʼ����ͼ
for i = 1 : rn,
    y = rects(i, 1); x = rects(i, 2); w = rects(i, 3); h = rects(i, 4);
    x1 = x + w - 1; y1 = y + h -1;
    topl = ((x : x1) - 1) * rim + repmat(y, 1, w);
    leftl = repmat((x - 1) * rim, 1, w) + (y : y1);
    right = repmat((x1 - 1) * rim, 1, w) + (y : y1);
    botml = ((x : x1) - 1) * rim + repmat(y1, 1, w);
    anno = [topl, leftl, right, botml];
    dest(anno) = c(1); dest(anno + rim * cim) = c(2); 
    dest(anno + 2 * rim * cim) = c(3);
end
