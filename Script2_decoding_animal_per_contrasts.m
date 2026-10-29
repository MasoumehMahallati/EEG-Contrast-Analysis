%% decod anima:l / nonanimal in each contrast levels
clc;
clear;
close all;
%% Decoding contrasts
eegchannels = {'FP1','FP2','F7','F3','FZ','F4','F8','FT7','FC3','FCZ','FC4','FT8','T7','C3','CZ','C4','T8',...
    'TP7','CP3','CPZ','CP4','TP8','P7','P3','PZ','P4','P8','O2','OZ','O1'};

delete(gcp('nocreate'));
parpool;
short_long = 'long';
for Subject = 1
    All_channels = 1:30;
    file_name=['D:\Paper Analysis2\EEG Analysis\Subject',num2str(Subject,'%02.f'),...
        '_',short_long,'\','Subject',num2str(Subject,'%02.f'), '_',short_long,'_preprocessed_data.mat'];
    load(file_name,'Data_matrix_total','Events_total');

    % Removing incorrect trials from analyses
    % incorrect_trials = (Events_total(:,4)~=Events_total(:,5));
    % Data_matrix_total(:,:,incorrect_trials)=[];
    % Events_total(incorrect_trials,:)=[];

    %% Separating trials into classes
    for contrast = 1:4

        indx = find(Events_total(:,3)==contrast);
        Events_contrast = Events_total(indx,:);
        Data_matrix_contrast = Data_matrix_total(:,:,indx);

        classes=unique(Events_contrast(:,2));   % finding animal & nonanimal

        %% _____ Equalize trials by minimize____
        for clss = classes'
            inx{clss+1} = find(Events_contrast(:,2)==clss);
            clssize(clss+1) = size(inx{clss+1},1);
        end
        mintrial = min(clssize);

        for clss = classes'
            indxx{clss+1} = find(Events_contrast(:,2)==clss);
            indxrnd{clss+1} =  indxx{clss+1}(randperm(size(indxx{clss+1},1),mintrial));
            Classes_data(:,:,1:length(indxrnd{clss+1}),clss+1)=squeeze(Data_matrix_contrast(All_channels,:,indxrnd{clss+1}));
        end

        % for clss = classes'
        %     indxx{clss+1} = find(Events_contrast(:,2)==clss);
        %     Classes_data(:,:,1:length(indxx{clss+1}),clss+1)=squeeze(Data_matrix_contrast(All_channels,:,indxx{clss+1}));
        % end
        %% perform decoding
        combs = [1 2];   % decoding only the two animal & nonanimal
        time_sample = 0;
        for time = 1:size(Classes_data,2)
            time_sample = time_sample + 1;
            ClassA_time = squeeze(Classes_data(:,time,:,combs(1)));
            ClassB_time = squeeze(Classes_data(:,time,:,combs(2)));
            X = [ClassA_time'; ClassB_time'];
            labels = [ones(size(ClassA_time,2),1);zeros(size(ClassB_time,2),1)];

            parfor itr = 1:20
                Classifier_Model = fitcdiscr(X,labels);
                decoding_accitr(itr) = 1-kfoldLoss(crossval(Classifier_Model));
            end
            decoding_acc(time_sample,1) = mean(decoding_accitr);

            % Cross-validation with adjusted partition
            % parfor itr = 1:20
            %     cv = cvpartition(labels, 'KFold', 10);
            %     Classifier_Model = fitcdiscr(X,labels,'CVPartition', cv);
            %     decoding_accitr(itr) = 1-kfoldLoss(Classifier_Model);
            % end
            % decoding_acc(time_sample,1) = mean(decoding_accitr);

            [Subject contrast time_sample]
        end
        decoding_accuracy(:,contrast) = decoding_acc;
        clearvars -except Subject All_channels short_long Events_total Data_matrix_total decoding_accuracy
    end
    file_name=['D:\Paper Analysis2\EEG Analysis\Subject',num2str(Subject,'%02.f'),...
        '_',short_long,'\','Subject',num2str(Subject,'%02.f'),'_',short_long,'_decoding_animal_per_contrast.mat'];
    save(file_name,'decoding_accuracy');
    clearvars -except  All_channels short_long
end
