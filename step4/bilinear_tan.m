x = -pi/2+0.1:0.0001:pi/2-0.1;
x_lin = -pi/10:0.001:pi/10;
y = tan(x);
y_lin = tan(x_lin);

f=figure;
subplot(2,1,1);
plot(x,y);
ylabel('tan(x)');
xlabel('x');
subplot(2,1,2);
plot(x_lin,y_lin);
ylabel('tan(x)');
xlabel('x');

print(f,'-djpeg','-r300','tan_graph');