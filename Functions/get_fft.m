function [data_fft,data_abs] = get_fft(data)
    data_fft = fft(data);
    data_abs = abs(data_fft(:,1));
end

