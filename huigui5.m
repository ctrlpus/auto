[aa,R] = geotiffread('E:\chongxinjisuan\EVI-Z\EVI200301.tif'); 
info = geotiffinfo('E:\chongxinjisuan\EVI-Z\EVI200301.tif');
[m,n] = size(aa);
tmpsum = zeros(m*n,204); 
presum = zeros(m*n,204); 
evisum = zeros(m*n,204); 
evi1sum = zeros(m*n,204);
twsasum = zeros(m*n,204); 
for year = 2003:2019
    for month = 1:12
        
        tmp_filename = sprintf('E:\\chongxinjisuan\\TEM-Z\\tmp_%d%02d.tif', year, month);
        pre_filename = sprintf('E:\\chongxinjisuan\\PRE-Z\\pre_%d%02d.tif', year, month);
        evi_filename = sprintf('E:\\chongxinjisuan\\EVI-Z\\EVI%d%02d.tif', year, month);
        evi1_filename = sprintf('E:\\chongxinjisuan\\EVI1-Z\\EVI1-%d%02d.tif', year, month);
        twsa_filename = sprintf('E:\\chongxinjisuan\\TWSA-Z\\twsa-%d%02d.tif', year, month);
        
        tmp = imread(tmp_filename);
        pre = imread(pre_filename);
        evi = imread(evi_filename);
        evi1 = imread(evi1_filename);
        twsa = imread(twsa_filename);
        
        tmp(tmp<-100)=NaN; 
        pre(pre<0)=NaN; 
        evi(evi<-1 | evi>1)=NaN; 
        evi1(evi1<-1 | evi1>1)=NaN; 
        twsa(twsa < -100) = NaN; 
       
        tmpsum(:, (year - 2002)*12 + month) = reshape(tmp, m*n, 1);
        presum(:, (year - 2002)*12 + month) = reshape(pre, m*n, 1);
        evisum(:, (year - 2002)*12 + month) = reshape(evi, m*n, 1);
        evi1sum(:, (year - 2002)*12 + month) = reshape(evi1, m*n, 1);
        twsasum(:, (year - 2002)*12 + month) = reshape(twsa', m*n, 1);

    end
end



pre_slope = zeros(m,n) + NaN;
tmp_slope = zeros(m,n) + NaN;
evi_slope = zeros(m,n) + NaN;
evi1_slope = zeros(m,n) + NaN;
twsa_slope = zeros(m,n) + NaN;
pz = zeros(m,n) + NaN;

for i = 1:m*n
pre = presum(i,:)';
if min(pre)>=0
evi = evisum(i,:)';
tem = tmpsum(i,:)';
evi1 = evi1sum(i,:)';
twsa = twsasum(i,:)';
X = [ones(size(evi)), tem, pre, evi1, twsa];
[b,bint,r,rint,stats] = regress(evi,X);
pre_slope(i) = b(3);
tmp_slope(i) = b(2);
evi_slope(i) = b(1);
evi1_slope(i) = b(4);
twsa_slope(i) = b(5);
pz(i) = stats(3);
end
end


filename = 'E:\chongxinjisuan\huiguijieguo\pre_slope.tif';
geotiffwrite(filename,pre_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename = 'E:\chongxinjisuan\huiguijieguo\tem_slope.tif';
geotiffwrite(filename,tmp_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename = 'E:\chongxinjisuan\huiguijieguo\evi_slope.tif';
geotiffwrite(filename,evi_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename = 'E:\chongxinjisuan\huiguijieguo\evi1_slope.tif';
geotiffwrite(filename,evi1_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename = 'E:\chongxinjisuan\huiguijieguo\twsa_slope.tif';
geotiffwrite(filename,twsa_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

filename='E:\chongxinjisuan\huiguijieguo\pz.tif';
geotiffwrite(filename,pz,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

pre_slope(pz>0.05) = NaN;
filename = 'E:\chongxinjisuan\huiguijieguo\通过降水.tif';
geotiffwrite(filename,pre_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

tmp_slope(pz>0.05) = NaN;
filename = 'E:\chongxinjisuan\huiguijieguo\通过气温.tif';
geotiffwrite(filename,tmp_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

evi_slope(pz>0.05) = NaN;
filename = 'E:\chongxinjisuan\huiguijieguo\通过植被.tif';
geotiffwrite(filename,evi_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

evi1_slope(pz>0.05) = NaN;
filename = 'E:\chongxinjisuan\huiguijieguo\通过前植被.tif';
geotiffwrite(filename,evi1_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)

twsa_slope(pz>0.05) = NaN;
filename = 'E:\chongxinjisuan\huiguijieguo\通过储水量.tif';
geotiffwrite(filename,twsa_slope,R,'GeoKeyDirectoryTag',info.GeoTIFFTags.GeoKeyDirectoryTag)