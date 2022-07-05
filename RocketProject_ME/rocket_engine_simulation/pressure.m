function [raiz] = pressure(delta,theta,x0)

syms Po

Pa = 1.01325e5;

func = Po^2 - Po^(2-delta)*Pa^delta - theta^2;
dfunc = diff(func);

[func] = inline(char(func),'Po');
[dfunc] = inline(char(dfunc),'Po');

x1 = 1 + x0;
while (abs(x1 - x0) > 1e-8)
    x0 = x1;
    df = dfunc(x0);
	f = func(x0);
	x1 = x0 - f/df;
end

raiz = x1;