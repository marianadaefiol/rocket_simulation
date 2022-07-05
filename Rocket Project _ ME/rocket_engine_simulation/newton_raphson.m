function [raiz] = newton_raphson(Ag,Ae,g,Po,x0) 

syms Pef;

q_func = Ag * (2/(g + 1))^(1/(g - 1)) * (Po/Pef)^(1/g)/...
        (sqrt((g + 1)/(g - 1) * (1 - (Po/Pef)^(-(g - 1)/g)))) - Ae;
dq_func = diff(q_func);

[func] = inline(char(q_func),'Pef');
[dfunc] = inline(char(dq_func),'Pef');

x1 = x0 + 1;

while (abs(x1 - x0) > 1e-8)
    x0 = x1;
    df = dfunc(x0);
	f = func(x0);
	x1 = x0 - f/df;
end

raiz = x1;