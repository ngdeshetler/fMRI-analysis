function LSS_cue_probe_corr

SUBS={'502','503','505','507','508','509','510','511','512','513','514','515','516','517','518','519','520','521'};
%
ERS=[];
all_data=[];
load('condensed_data.mat')


num_runs=3;

masks={'rightCA1_fixed', 'leftCA1_fixed', 'rightCA23DG_fixed', 'leftCA23DG_fixed', 'rightSub_fixed', 'leftSub_fixed','rightERC_fixed','leftERC_fixed','rightPHC_fixed','leftPHC_fixed','rightPRC_fixed','leftFus_fixed','rightFus_fixed'};
masks_names={'RCA1', 'LCA1', 'RCA23DG', 'LCA23DG', 'RSub', 'LSub','RERC','LERC','RPHC','LPHC','RPRC','LFus','RFus'};
%masks_names={'VA_mask_clean_brain','L_CA1_fixed_test','L_CA3DG_fixed_test','L_Sub_fixed_test','R_CA1_fixed_test','R_CA3DG_fixed_test','R_Sub_fixed_test'};
%masks_names_text={'VA','LCA1','LCA3DG','LSub','RCA1','RCA3DG','RSub'};


for g=1:length(SUBS)
    sub_ID=sprintf('sub%s',SUBS{g})
    
    %file_name_pre_a=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond1ls_s.nii.gz',sub_ID);
    %file_name_pre_b=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond2ls_s.nii.gz',sub_ID);
    file_name_pre_a=sprintf('/space/raid6/data/knowlton/PS_Reward_Study/Data/%s/analysis/runRUN_memory_value_LSS.feat/stats/cond2ls_s.nii.gz',sub_ID);
    file_name_pre_b=sprintf('/space/raid6/data/knowlton/PS_Reward_Study/Data/%s/analysis/runRUN_test_LSS.feat/stats/cond1ls_s.nii.gz',sub_ID);
    
    %mask_file_pre=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/masks/runRUN/RAD/MASK.nii.gz',sub_ID);
    mask_file_pre=sprintf('/space/raid6/data/knowlton/PS_Reward_Study/Data/ANTS_REG/%s/ROIs/runRUN/MASK.nii.gz',sub_ID);
    
    for c=1:length(masks)
        
        mask_file=strrep(mask_file_pre,'MASK',masks{c});
        
        
        for n=1:num_runs
            file_name_a=strrep(file_name_pre_a,'RUN',num2str(n));
            file_name_b=strrep(file_name_pre_b,'RUN',num2str(n));
            mask_file_name=strrep(mask_file,'RUN',num2str(n))
            
            if exist(file_name_a)~=0
                
                a=load_untouch_nii_zip(file_name_a);
                b=load_untouch_nii_zip(file_name_b);
                datasize_a=size(a.img);
                cond_a=reshape(a.img,[1 (datasize_a(1)*datasize_a(2)*datasize_a(3)) datasize_a(4)]);
                datasize_b=size(b.img);
                cond_b=reshape(b.img,[1 (datasize_b(1)*datasize_b(2)*datasize_b(3)) datasize_b(4)]);
                
                if exist(mask_file_name)~=0
                    mask_load=load_untouch_nii_zip(mask_file_name);
                    datasize_mask=size(mask_load.img);
                    mask_full=reshape(mask_load.img,[1 (datasize_mask(1)*datasize_mask(2)*datasize_mask(3))]);
                    mask=find(mask_full==1);
                    
                    learn_index=all_data.(sub_ID).block(n).Learned_order;
                    repeat_index=all_data.(sub_ID).block(n).Repeat_order_refLearn;
                    lure_index=all_data.(sub_ID).block(n).Lure_order_refLearn;
                    new_index=all_data.(sub_ID).block(n).New_order;
                    
                    
                    for m=1:datasize_a(4)
                        %% Original-Repeat ERS
                        corr_matrix=zeros(length(mask),2);
                        corr_matrix(:,1)=cond_a(1,mask,learn_index(m));
                        corr_matrix(:,2)=cond_b(1,mask,repeat_index(m));
                        holder=corrcoef(corr_matrix);
                        ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(m)=holder(2,1);
                        %% Original-Lure ERS
                        corr_matrix=zeros(length(mask),2);
                        corr_matrix(:,1)=cond_a(1,mask,learn_index(m));
                        corr_matrix(:,2)=cond_b(1,mask,lure_index(m));
                        holder=corrcoef(corr_matrix);
                        ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(m)=holder(2,1);
                        %% Orinial-All new ERS -average
                        for h=1:length(new_indes)
                            corr_matrix=zeros(length(mask),2);
                            corr_matrix(:,1)=cond_a(1,mask,learn_index(m));
                            corr_matrix(:,2)=cond_b(1,mask,new_index(h));
                            holder=corrcoef(corr_matrix);
                            av_holder(h)=holder(2,1);
                        end
                        ERS.(sub_ID).(masks_names{c}).block(n).new_ERS(m)=mean(av_holder);
                    end
                end
            end
            
        end
    end
    
end
save('ERS_all','ERS')

end