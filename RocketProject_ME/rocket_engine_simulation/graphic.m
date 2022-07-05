function [] = graphic(propellant,Emp,I,Po)

fig = figure('Name',['Propelente P',num2str(propellant)]);
left_color = [0 0 0];
right_color = [0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

hold on;
yyaxis left;

plot(Emp,'b-','LineWidth',2);
plot(I,'r-','LineWidth',2);
xlabel('Tempo (ms)');
ylabel('Empuxo (N) e Impulso (Ns)');

yyaxis right;
plot(Po,'m-','LineWidth',2);
xlabel('Tempo (ms)');
ylabel('Po (Pa)');

legend('Empuxo','Impulso','Po',...
    'Position',[0.718452379045032 0.429365076640296 0.171071430478777 0.12619047891526]);
grid on;
hold off;