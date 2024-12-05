function res = objFn( x )
    res=sum(vecnorm(reshape(x(1:end-2),3,floor(size(x,2)/3))-reshape([x(4:end-2) x(1:3) ] ,3,floor(size(x,2)/3)), 2, 1))* x( end-1 )^2;
end

