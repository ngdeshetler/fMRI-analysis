function LSS_CA1_CA3DG_corr

SUBS={'502','503','505','507','508','509','510','511','512','513','514','515','516','517','518','519','520','521'};
%
CA1_CA3DG_corr=[];
all_variables=[];
load('ALL_EVs.mat')

%masks_names={'VA_mask_clean_brain','L_CA1_fixed','L_CA3DG_fixed','L_Sub_fixed','R_CA1_fixed','R_CA3DG_fixed','R_Sub_fixed'};
%masks_names_text={'VA','LCA1','LCA3DG','LSub','RCA1','RCA3DG','RSub'};

%% Laterlized ROIs

SIDEs={'R','L'};

for g=1:length(SUBS)
    sub_ID=sprintf('MM_%s',SUBS{g})
    
    %file_name_pre_a=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond1ls_a.nii.gz',sub_ID);
    file_name_pre_b=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond2ls_s.nii.gz',sub_ID);
    
    
    num_runs=8;
    mask_file_pre_a=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/masks/runRUN/RAD/SIDE_CA1_fixed_test.nii.gz',sub_ID);
    mask_file_pre_b=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/masks/runRUN/RAD/SIDE_CA3DG_fixed_test.nii.gz',sub_ID);
    
    for c=1:length(SIDEs)
    
    mask_file_a=strrep(mask_file_pre_a,'SIDE',SIDEs{c});
    mask_file_b=strrep(mask_file_pre_b,'SIDE',SIDEs{c});
    
    
    for n=1:num_runs
        %file_name_a=strrep(file_name_pre_a,'RUN',num2str(n));
        file_name_b=strrep(file_name_pre_b,'RUN',num2str(n));
        mask_file_name_a=strrep(mask_file_a,'RUN',num2str(n));
        mask_file_name_b=strrep(mask_file_b,'RUN',num2str(n));
        
        if exist(file_name_b)~=0
            
            disp(file_name_b)
            
            %a=load_untouch_nii_zip(file_name_a);
            b=load_untouch_nii_zip(file_name_b);
            %datasize_a=size(a.img);
            %cond_a=reshape(a.img,[1 (datasize_a(1)*datasize_a(2)*datasize_a(3)) datasize_a(4)]);
            datasize_b=size(b.img);
            cond_b=reshape(b.img,[1 (datasize_b(1)*datasize_b(2)*datasize_b(3)) datasize_b(4)]);
            
            if exist(mask_file_name_a)~=0
                
                disp(mask_file_name_a)
                disp(mask_file_name_b)
                
                mask_load_a=load_untouch_nii_zip(mask_file_name_a);
                mask_load_b=load_untouch_nii_zip(mask_file_name_b);
                datasize_mask_a=size(mask_load_a.img);
                datasize_mask_b=size(mask_load_b.img);
                mask_full_a=reshape(mask_load_a.img,[1 (datasize_mask_a(1)*datasize_mask_a(2)*datasize_mask_a(3))]);
                mask_a=find(mask_full_a==1);
                
                mask_full_b=reshape(mask_load_b.img,[1 (datasize_mask_b(1)*datasize_mask_b(2)*datasize_mask_b(3))]);
                mask_b=find(mask_full_b==1);
                
                for m=1:datasize_b(4)
                    
                    holder_a=cond_b(1,mask_a,m);
                    holder_b=cond_b(1,mask_b,m);
                    
                    CA1_CA3DG_corr.(sub_ID).(sprintf('%s_CA1',SIDEs{c})).(sprintf('block%d',n)).(sprintf('trial%d',all_variables.(sub_ID).cue.block(n).trials(m)))=mean(holder_a);
                    CA1_CA3DG_corr.(sub_ID).(sprintf('%s_CA3DG',SIDEs{c})).(sprintf('block%d',n)).(sprintf('trial%d',all_variables.(sub_ID).cue.block(n).trials(m)))=mean(holder_b);
                
                end
            end
        end
        
    end
    end
    
end

%% Bilaterial ROIs 

for g=1:length(SUBS)
    sub_ID=sprintf('MM_%s',SUBS{g})
    
    %file_name_pre_a=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond1ls_a.nii.gz',sub_ID);
    file_name_pre_b=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond2ls_s.nii.gz',sub_ID);
    
    
    num_runs=8;
    mask_file_a=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/masks/runRUN/RAD/CA1_fixed_test.nii.gz',sub_ID);
    mask_file_b=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/masks/runRUN/RAD/CA3DG_fixed_test.nii.gz',sub_ID);
    
        
    for n=1:num_runs
        %file_name_a=strrep(file_name_pre_a,'RUN',num2str(n));
        file_name_b=strrep(file_name_pre_b,'RUN',num2str(n));
        mask_file_name_a=strrep(mask_file_a,'RUN',num2str(n));
        mask_file_name_b=strrep(mask_file_b,'RUN',num2str(n));
        
        if exist(file_name_b)~=0
            
            disp(file_name_b)
            
            %a=load_untouch_nii_zip(file_name_a);
            b=load_untouch_nii_zip(file_name_b);
            %datasize_a=size(a.img);
            %cond_a=reshape(a.img,[1 (datasize_a(1)*datasize_a(2)*datasize_a(3)) datasize_a(4)]);
            datasize_b=size(b.img);
            cond_b=reshape(b.img,[1 (datasize_b(1)*datasize_b(2)*datasize_b(3)) datasize_b(4)]);
            
            if exist(mask_file_name_a)~=0
                
                disp(mask_file_name_a)
                disp(mask_file_name_b)
                
                mask_load_a=load_untouch_nii_zip(mask_file_name_a);
                mask_load_b=load_untouch_nii_zip(mask_file_name_b);
                datasize_mask_a=size(mask_load_a.img);
                datasize_mask_b=size(mask_load_b.img);
                mask_full_a=reshape(mask_load_a.img,[1 (datasize_mask_a(1)*datasize_mask_a(2)*datasize_mask_a(3))]);
                mask_a=find(mask_full_a==1);
                
                mask_full_b=reshape(mask_load_b.img,[1 (datasize_mask_b(1)*datasize_mask_b(2)*datasize_mask_b(3))]);
                mask_b=find(mask_full_b==1);
                
                for m=1:datasize_b(4)
                    
                    holder_a=cond_b(1,mask_a,m);
                    holder_b=cond_b(1,mask_b,m);
                    
                    CA1_CA3DG_corr.(sub_ID).CA1.(sprintf('block%d',n)).(sprintf('trial%d',all_variables.(sub_ID).cue.block(n).trials(m)))=mean(holder_a);
                    CA1_CA3DG_corr.(sub_ID).CA3DG.(sprintf('block%d',n)).(sprintf('trial%d',all_variables.(sub_ID).cue.block(n).trials(m)))=mean(holder_b);
                
                end
            end
        end
        
    end
    
end
save('CA1_CA3DG_corr_all','CA1_CA3DG_corr')

end