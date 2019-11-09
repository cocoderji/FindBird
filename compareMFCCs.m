function similarity = compareMFCCs(X,Y)
xFrames = size(X,2);
yFrames = size(Y,2);
DP.D = zeros(yFrames,xFrames);
DP.B = zeros(yFrames,xFrames);    %create backtracking matrix
DP.D(:,1) = Inf;
DP.D(1,1) = norm( X(:,1) - Y(:,1) );
DP.B(:,1) = -1;
i = 1;
for j = 2:xFrames
    DP.D(i,j) = DP.D(i,j-i) + norm(X(:,j)-Y(:,i));
    DP.B(i,j) = 0;
end
i = 2;
for j = 2:xFrames    
    t = DP.D(i,j-1);
    min = t ;
    DP.B(i,j) = 0;
    t = DP.D(i-1,j-1);
    if (t < min)
        min = t;
        DP.B(i,j) = 1 ;
    end  
    DP.D(i,j) = min + norm(X(:,j)-Y(:,i)); 
end
for j = 2:xFrames
    for i = 3:yFrames
        t = DP.D(i,j-1);
        min = t ;
        DP.B(i,j) = 0;
        for p = 1:2
            t = DP.D(i-p,j-1);
            if (t < min)
                min = t;
                DP.B(i,j) = p;
            end
        end
           
        DP.D(i,j) = min + norm(X(:,j)-Y(:,i));
        
    end
end
DP.dist = DP.D(yFrames,xFrames);
DP.M = zeros(yFrames,xFrames);

i = yFrames;
j = xFrames;
DP.M(i,j) = 1;

back = DP.B(i,j);
%backtracking
while (back >= 0)
    i = i - back;
    j = j - 1;
    DP.M(i,j) = 1;
    back = DP.B(i,j);
end
n = size(X,2);
d(n)=norm(X(:,n));
for i=2:n
    d(i)=norm(X(:,i));
end
similarity = DP.dist/sum(d);
end