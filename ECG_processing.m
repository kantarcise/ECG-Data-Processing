clc;
clear all;
close all;

% Sampling frequency, record time
Fo=360;
N=2560;
recordTime = N/Fo;
t=(1:N)/Fo;
miliT=1000*t;

% Reading the file.
% x is taken as milivolts.

% You might want to change this line. 
dosya=fopen('C:\Users\...\....dat','rb');
[x, OS]=fscanf(dosya,'%f',inf);
fclose(dosya);

figure(1);
plot(miliT,x);
title('ECG ')
xlabel('Time (mS)')
ylabel('Amplitute (mV)')

% FFT calculation

f=fft(x,OS);
F=abs(f);
w=(0:(OS/2-1))/(OS/2)*(Fo/2);


figure(2);
plot(w,F(1:OS/2));
title('FFT');
xlabel('Frequency (Hz)');
ylabel('Amplitute')


% R peaks
figure(3);
findpeaks(x(:,:),'NPeaks',10, 'SortStr', 'descend');
xlabel('Number of Samples');
ylabel('Amplitute (mV)')
title('R Peaks');

[peakMagnitute,numberOfSample] = findpeaks(x(:,:),'NPeaks',10, 'SortStr', 'descend');
sortedNumbers = sort(numberOfSample);

% timeArray will hold R peaks.
timeArray=zeros(size(sortedNumbers,1)-1,1);
for i =1:9
    
    rrTime = (sortedNumbers(i+1)-sortedNumbers(i)) * 2.7778;
    timeArray(i) = rrTime;
    
end

% RR interval figure, for only 9 of them here.
figure(4)
stem(timeArray);
xlim([0.5 9.5])
xlabel('RR Interval Number');
ylabel('Time (mS)')
title('RR Interval Time');


dcOffset = 1;
y = x + dcOffset;
fSecond=fft(y,OS);
FSecond=abs(fSecond);
w=(0:(OS/2-1))/(OS/2)*(Fo/2);

figure(5);
plot(miliT,y);
title('1 mV DC Offset Added ECG')
xlabel('Time (mS)')
ylabel('Amplitute (mV)')

figure(6);
plot(w,FSecond(1:OS/2));
title('FFT + 1mV DC');
xlabel('Frequency (Hz)');
ylabel('Amplitute')


figure(7);
plot(w,FSecond(1:OS/2));
title('FFT + 1mV DC - First 20 Values');
xlabel('Frequency (Hz)');
xlim([0 20]);
ylabel('Amplitute')


% The End. Yay! 