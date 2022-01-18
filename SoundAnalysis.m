clc;
close all;
clear all;

addpath('Functions');

%% PARAMETERS
f1=10^2;
f2=10^3;
margin=1; % margin filter, 1s


file_name= 'long2_5.wav';

%% FFT AUDIO

[audio, Fs] = audioread(file_name);
audio = audio(:,1);

N= length(audio);
T= N/Fs;
t=linspace(0,T,N);

[audio_fft, audio_abs]= get_fft(audio);

max_f=[0];
start_max=[];
start_A_vect=[0];
threshold=[0];


for i=Fs:Fs:N
    data=audio(i-Fs+1:i); % window we are going to be studying (ara mateix és fs, 1 segon)
    data_fft = fft(data); 
    data_abs = abs(data_fft);
    
    f_vehicle= data_abs(f1:f2); % get the frequencies that belong to vehicles
   
    max_f(end+1)=max(f_vehicle);
    
    start_max(end+1)= max(f_vehicle);
    
    if i<=Fs*3
        if i == Fs*3
            start_A_vect(2:4)=max(start_max);
            threshold(2:4)=start_A_vect(end);
        end
    else
        if i>=10*Fs
            sA=start_max(end-9:end);
            start_A_vect(end+1)= prctile(sA, 70); 
            mA=median(start_A_vect);
            if start_A_vect(end)<mA
                threshold(end+1)=mA;
            else
                if start_A_vect(end)>2*mA
                    threshold(end+1)=2*mA;
                else
                    threshold(end+1)=start_A_vect(end);
                end
            end
        else
            start_A_vect(end+1)=start_A_vect(end);
            threshold(end+1)=start_A_vect(end);
        end   
    end
end

%% filter

filtered_vect= get_filter_vect(max_f,threshold, margin);

t2=0:length(max_f)-1;

t2=seconds(t2);
t2.Format = 'mm:ss';

%% PLOTS

figure('Name', file_name)
subplot(3,1,1);
plot(t,audio);
title('Audio');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

subplot(3,1,2);
semilogx(audio_abs);
title('FFT Audio');
xlabel('Frequency (Hz)');
ylabel('Amplitude');


subplot(3,1,3);
plot(t2, filtered_vect*max(max_f));
hold on
plot(t2, max_f);
hold on
plot(t2, threshold);
hold off
xlabel('Time (mm:ss)');
ylabel('Amplitude');
title('Sound analysis');
legend('Warning', 'F', 'Threshold');


%% 

result_warn = result_warning(filtered_vect);
result_warn= seconds(result_warn);
result_warn.Format= 'mm:ss';
