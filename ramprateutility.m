jala=ones(1,24);
for i=2:24
    jalal(i-1)=psub2(1,i)-psub2(1,i-1);
    
end
utility_ramp_rate=max(jalal);
jalal
utility_ramp_rate