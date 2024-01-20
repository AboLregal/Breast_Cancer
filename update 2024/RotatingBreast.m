function Im=RotatingBreast(Im)
    sz=size(Im);
    if length(sz)>2
        if sz(2)>sz(1)
            for k=1:sz(3)
                Imx(:,:,k)=Im(:,:,k)';
            end
            Im=Imx;
        end
    else
        if sz(2)>sz(1)
            Im=Im';
        end
    end
    s1=sum(Im(:,1));
    s2=sum(Im(:,end));
    if s2>s1
        Im=fliplr(Im);
    end
    s1=sum(Im(1,:));
    s2=sum(Im(end,:));
    if s2>s1
        Im=flipud(Im);
    end
end
