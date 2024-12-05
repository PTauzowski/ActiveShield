function [xopt,Vmin] = rs(of, dim, N, A, b, c, d, lb, ub, cn)
   
    x = repmat(lb,N,1)+(repmat(ub,N,1)-repmat(lb,N,1)).*rand(N,dim); 
    ofv=zeros(N,1);
    cnv=zeros(N,1);

    parfor k=1:N
        ofv(k)=of(x(k,:));
        cnv(k)=cn(x(k,:));
    end
    
    sc=find(cnv>=0);
    [v,i]=min(cnv(sc));

    xopt=x(sc(i),:);
    Vmin=v;

end

