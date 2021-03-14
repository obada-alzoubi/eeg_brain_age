
%%
clc; clear; close all;
addpath(genpath('funcs'))
addpath('/media/cephfs/labs/jbodurka/Obada/Projects/Proc_EEG_BIDS/Script/fucns');
input_dir    = '/media/cephfs/labs/jbodurka/Obada/EEG_T1000_2ICA_ocx';
output_dir   = '/media/cephfs/labs/jbodurka/Obada/EEG_T1000_2ICA_ocx';
%%
feature_set={'spectral_power','spectral_relative_power', 'spectral_flatness',...
    'spectral_entropy', 'spectral_diff', 'spectral_edge_frequency', ...
    'FD', 'amplitude_total_power', 'amplitude_SD', 'amplitude_skew', ...
    'amplitude_kurtosis', 'amplitude_env_mean', 'amplitude_env_SD', 'rEEG_mean', ...
    'rEEG_median', 'rEEG_lower_margin', 'rEEG_upper_margin', 'rEEG_width', ...
    'rEEG_SD', 'rEEG_CV', 'rEEG_asymmetry','connectivity_BSI', 'connectivity_corr', ...
    'connectivity_coh_mean','connectivity_coh_max',...
    'connectivity_coh_freqmax'};

%feature_set={'connectivity_corr',      'connectivity_coh_mean'};

ch_names ={'Fp1';'Fp2';'F3';'F4';'C3';'C4';'P3';'P4';'O1';'O2';'F7';'F8';...
    'T7';'T8';'P7';'P8';'Fz';'Cz';'Pz';'Oz';'FC1';'FC2';'CP1';'CP2';...
    'FC5';'FC6';'CP5';'CP6';'TP9';'TP8';'POz'}';

FS = 250; % Hz


%%
subjList = importfile2('settings/T500_list.csv',2);
%subjList = subjList(2:end);
nSubj    = height(subjList);
sessions = {'T0'};
tasks    = {'REST-R1'};
overwrite=true;
correct_fail=true;
%%
parfor iSubj =1:nSubj
    
    subj_name = subjList.subj(iSubj);
    %fprintf('processing subject %s \n', subj_name);
    
    for sess=sessions

         if strcmp(string(sess),'T0')
            sess_BIDS ='ses-t0';
        elseif strcmp(string(sess), 'T4')
            sess_BIDS ='ses-t4';

        else
            sess_BIDS ='';

        end
        
        subj_folder_in = sprintf('%s/%s/%s/functional_session/%s', input_dir,subj_name,string(sess));
        subj_folder_out = sprintf('%s/sub-%s/%s/%s', output_dir,subj_name,sess_BIDS);        
                
        finished_mark = sprintf('%s/stat-finished-feas30s',subj_folder_out );

        running_mark  = sprintf('%s/stat-running-feas30s',subj_folder_out );
        fail_mark     = sprintf('%s/stat-fail-feas30s',subj_folder_out );

        if(exist(finished_mark,'file')==2 ||exist(running_mark,'file')==2)
            fprintf('already processed or running subject %s \n', subj_name);
            continue;

        end  
        if exist(fail_mark, 'file')==2 && correct_fail
                delete(fail_mark);
        end
        if exist(subj_folder_out,'dir')~=7
           fprintf('No subject folder ......%s \n', subj_name);
            continue;            
        end
        try
        fclose(fopen(running_mark, 'w'));        
            
            for task=tasks
                
                 if strcmp(string(task),'REST-R1')
                    task_BIDS ='task-rest1';
                elseif strcmp(string(task), 'REST-R2')
                    task_BIDS ='task-rest2';

                else
                    task_BIDS ='';

                 end
                EEG_out = sprintf('%s/sub-%s_%s_%s_eeg_ExtractedFeas_30s.mat',subj_folder_out,subj_name,...
                sess_BIDS, task_BIDS); 
            
                EEG_in = sprintf('%s/sub-%s_%s_%s_eeg_eeg_p-1.mat',subj_folder_out,subj_name,...
                        sess_BIDS, task_BIDS);  

                    
                if  (exist(EEG_in,'file')==2) &&(overwrite || (~exist(EEG_out,'file')==2))
                    %subj_task_in = sprintf('%s-%s-%s-RAW',subj_name,...
                    %    string(sess), string(task));
                     fprintf('processing subject %s \n', subj_name);


                    tmp=load_parallel(EEG_in);                    
                    subEEG =[];
                    subEEG.eeg_data = tmp.finalEEG.data;
                    subEEG.Fs = FS;
                    subEEG.eeg_data_ref =[];
                    subEEG.ch_labels_bi ={};
                    subEEG.ch_labels_ref ={};
                    subEEG.ch_labels = ch_names;
                    subEEG.name = subj_name;
                    [feat_st, feat_st_epoch]=generate_all_features(subEEG,[],...
                        feature_set, 1);
                    subEEG.feat_st = feat_st;
                    subEEG.feat_st_epoch = feat_st_epoch;
                    saveEEGx( EEG_out, subEEG);
                    %saveEEG(finalEEG, EEG_out)
                    subEEG   = [];
                    EEG_out  = '';
                    EEG_in   = '';
                    
                end

              end
            fclose(fopen(finished_mark, 'w'));
            if exist(running_mark, 'file')==2
                delete(running_mark);
            end
            
        catch
        fprintf('problem in processingor running subject %s \n', subj_name);
        fclose(fopen(fail_mark, 'w'));

        if exist(running_mark, 'file')==2
            delete(running_mark);
        end
            
        end
    end
end