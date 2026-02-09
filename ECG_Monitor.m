% Kullanıcıdan bilgi alınır
isim = input('Adınızı giriniz: ', 's');
soyisim = input('Soyadınızı giriniz: ', 's');
tarih = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
% Seri port ayarları (COM portu kendi sistemine göre ayarla)
port = 'COM4';  % STM32 hangi porttaysa onu gir
baudRate = 115200;
s = serialport(port, baudRate);
flush(s);  % Eski verileri temizle
disp('Veri alınıyor. Kayıt için CTRL+C ile durdurabilirsiniz.');
% Veriyi kaydetmek için dizi oluştur
ekgData = [];
bpmData = [];
maxVeri = 75000;
for i = 1:maxVeri
    if s.NumBytesAvailable > 0
        satir = readline(s);
        veri = strsplit(strtrim(satir), ',');
        if numel(veri) == 2
            ekg = str2double(veri{1});
            bpm = str2double(veri{2});
            if ~isnan(ekg) && ~isnan(bpm)
                ekgData(end+1) = ekg;
                bpmData(end+1) = bpm;
            end
        end
    end
end
% Dosya ismini oluştur
dosyaIsmi = sprintf('%s_%s_%s.txt', isim, soyisim, tarih);
dosyaIsmi = strrep(dosyaIsmi, ' ', '_'); % boşlukları temizle
% Dosyaya yaz
fid = fopen(dosyaIsmi, 'w');
fprintf(fid, 'EKG\tBPM\n');
for i = 1:length(ekgData)
    fprintf(fid, '%d\t%d\n', ekgData(i), bpmData(i));
end
fclose(fid);
disp(['Veriler kaydedildi: ' dosyaIsmi]);
% Grafik
subplot(2,1,1);
plot(ekgData);
title('EKG Sinyali');
xlabel(['Kullanıcı: ' isim ' ' soyisim]);subplot(2,1,2);
plot(bpmData);
title('Kalp Atış Hızı (BPM)');
xlabel(['Kullanıcı: ' isim ' ' soyisim])
