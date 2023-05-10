clc
clear all

data0 = xlsread('new3333.csv');
[rr cc] = size(data0);
data2 = data0(:,2:cc);

kkk = 2;
[dr dc] = size(data2);
k = 0;

row1 = 0;
cl = data2(1:dr,dc);
cl_0 = sum(cl == 0);
cl_1 = sum(cl == 1);

D18 = dc -1;
pcl_0 = cl_0 / (cl_0 + cl_1);
pcl_1 = cl_1 / (cl_0 + cl_1);

for fld  = 1: D18
    f1 = data2(1:dr,fld);
    % feature 1 
    lv  = min(f1);
    hv  = max( f1);
    for fv = lv : hv
    row1 = row1+ 1;
     BP(row1,1) = fld;
     BP(row1,2) = fv;
        r1 = (f1 == fv);
        % class =  0
        r3 = (cl == 0);
        BP(row1,3) = sum((r1 & r3)) / cl_0;
       % class =  1
        r2 = (cl ==1);
        BP(row1,4) = sum((r1 & r2)) / cl_1;


    end
end

%----------------------------- GA 
w10 = rand(10,dc-1) - 0.5;

% Population 

for p = 1: 10 
    
    for k = 1: 1000

        t1 = data2(k,:);
        
        for f = 1 : D18
            v = t1(f);

            tv_0(f)   =(BP((BP(:,1) == f) & (BP(:,2) == v),3)) ^ (w10(p,f) * kkk);
            tv_1(f)   = (BP((BP(:,1) == f) & (BP(:,2) == v),4)) ^ (w10(p,f) * kkk) ;

        end

        ptv_0(p) = prod(tv_0 ) * pcl_0;
        ptv_1(p) = prod(tv_1 ) * pcl_1;


         res1(k,p) = ptv_1(p) >= ptv_0(p);
    end

    acc10(p) = sum(res1(1:1000,p)   ==  cl(1:1000,1))/10;
end

h1 =  figure 
h1

midN = fix(D18 /2);


for gen = 1 : 1000

    gen
            % cross over 
            for i = 1 : 2: 10
                  w20(i, 1:midN) = w10(i,1:midN);
                  w20(i, midN+1:D18) = w10(i+1,midN+1: D18);


                  w20(i + 1, 1:midN) = w10(i+1,1:midN);
                  w20(i + 1, midN+1:D18) = w10(i,midN+1:D18);
             end

            % mutation 

            for i = 10
              if (rand() < .4)
                  w20(i,uint8(rand() * D18-1) +1) = rand();
                  w20(i,uint8(rand() * D18-1) +1) = rand();
                  w20(i,uint8(rand() * D18-1) +1) = rand();
                  w20(i,uint8(rand() * D18-1) +1) = rand();
                  
              end

            end


            for p = 1: 10 
                for k = 1: 1000
                    t1 = data2(k,:);
                    for f = 1 : D18
                        v = t1(f);

                        tv_0(f)   = (BP((BP(:,1) == f) & (BP(:,2) == v),3)) ^ (w20(p,f) * kkk);
                        tv_1(f)   = (BP((BP(:,1) == f) & (BP(:,2) == v),4)) ^ (w20(p,f) * kkk);

                    end

                    ptv_0(p) = prod(tv_0 ) * pcl_0;
                    ptv_1(p) = prod(tv_1 ) * pcl_1;


                     res1(k,p) = ptv_1(p) >= ptv_0(p);
                end

                acc20(p) = sum(res1(1:1000,p)   ==  cl(1:1000,1))/10;
            end
             
            temp(1:10,1) = acc10(1:10);
            temp(11:20,1)  = acc20(1:10);

            temp(1:10, 2:D18+1) = w10(1:10,1:D18);
            temp(11:20,2:D18+1) = w20(1:10,1:D18);

            temp1 = sortrows(temp,-1);
            
            bestr(gen) = temp1(1,1);
                figure(h1)
              subplot(1,2,1)     ,bar(acc20);
                pause(.1);
              subplot(1,2,2)     ,plot(bestr);
            
     
            w10(1:10,1:D18) = temp1(1:10,2:D18+1);
            acc10(1:10) = temp1(1:10,1);
end
