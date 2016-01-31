function LSS_ERS_all

SUBS=8:26;
%
ERS=[];
all_data=[];
load('condensed_data.mat')
load('ERS_all.mat')


num_runs=3;


%masks={'right_CA1_fixed', 'left_CA1_fixed', 'right_CA23DG_fixed', 'left_CA23DG_fixed', 'right_Sub_fixed', 'left_Sub_fixed',...
%    'right_ERC_fixed','left_ERC_fixed','right_PHC_fixed','left_PHC_fixed','right_PRC_fixed','left_Fus_fixed','right_Fus_fixed'};
%masks_names={'RCA1', 'LCA1', 'RCA23DG', 'LCA23DG', 'RSub', 'LSub','RERC','LERC','RPHC','LPHC','RPRC','LFus','RFus'};
%masks={'left_hipp','right_hipp','hipp','left_MTL_cortex','right_MTL_cortex','MTL_cortex','left_MTL','right_MTL','MTL'};
%masks_names={'Lhipp','Rhipp','hipp','LMTL_C','RMTL_C','MTL_C','LMTL','RMTL','MTL'};
%masks={'right_NAcc','left_NAcc'};
%masks_names={'RNAcc','LNAcc'};
masks={'VTA_10','VTA_25','VTA_50','VTA_75','VTA_90','VTA_100'};
masks_names={'VTA_10','VTA_25','VTA_50','VTA_75','VTA_90','VTA_100'};

%masks_names={'VA_mask_clean_brain','L_CA1_fixed_test','L_CA3DG_fixed_test','L_Sub_fixed_test','R_CA1_fixed_test','R_CA3DG_fixed_test','R_Sub_fixed_test'};
%masks_names_text={'VA','LCA1','LCA3DG','LSub','RCA1','RCA3DG','RSub'};


for g=1:length(SUBS)
    sub_ID=sprintf('sub%d',SUBS(g))
    
    %file_name_pre_a=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond1ls_s.nii.gz',sub_ID);
    %file_name_pre_b=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/analysis/LSS/LSS_runRUN.feat/stats/cond2ls_s.nii.gz',sub_ID);
    file_name_pre_a=sprintf('/space/raid6/data/knowlton/PS_Reward_Study/Data/%d/analysis/runRUN_memory_value_LSS.feat/stats/cond2ls_s.nii.gz',SUBS(g));
    file_name_pre_b=sprintf('/space/raid6/data/knowlton/PS_Reward_Study/Data/%d/analysis/runRUN_test_LSS.feat/stats/cond1ls_s.nii.gz',SUBS(g));
    
    %mask_file_pre=sprintf('/space/raid6/data/rissman/Natalie/MATCH_MISMATCH/%s/masks/runRUN/RAD/MASK.nii.gz',sub_ID);
    mask_file_pre=sprintf('/space/raid6/data/knowlton/PS_Reward_Study/Data/ANTS_REG/%d/ROIs/runRUN/MASK.nii.gz',SUBS(g));
    
    for n=1:num_runs
        
        file_name_a=strrep(file_name_pre_a,'RUN',num2str(n));
        file_name_b=strrep(file_name_pre_b,'RUN',num2str(n));
        
        if exist(file_name_a)~=0
            if exist(file_name_b)~=0
                
                a=load_untouch_nii_zip(file_name_a);
                b=load_untouch_nii_zip(file_name_b);
                datasize_a=size(a.img);
                cond_a=reshape(a.img,[1 (datasize_a(1)*datasize_a(2)*datasize_a(3)) datasize_a(4)]);
                datasize_b=size(b.img);
                cond_b=reshape(b.img,[1 (datasize_b(1)*datasize_b(2)*datasize_b(3)) datasize_b(4)]);
                
                for c=1:length(masks)
                    
                    mask_file=strrep(mask_file_pre,'MASK',masks{c});
                    mask_file_name=strrep(mask_file,'RUN',num2str(n))
                    if exist(mask_file_name)~=0
                        mask_load=load_untouch_nii_zip(mask_file_name);
                        datasize_mask=size(mask_load.img);
                        mask_full=reshape(mask_load.img,[1 (datasize_mask(1)*datasize_mask(2)*datasize_mask(3))]);
                        mask=find(mask_full==1);
                        
                        learn_index=all_data.(sub_ID).block(n).Learned_order;
                        repeat_index=all_data.(sub_ID).block(n).Repeat_order_refLearn;
                        lure_index=all_data.(sub_ID).block(n).Lure_order_refLearn;
                        new_index=all_data.(sub_ID).block(n).New_order;
                        
                        if ~isempty(mask)
                            for m=1:datasize_a(4)
                                %% Original-Repeat ERS
                                holder=[];
                                corr_matrix=zeros(length(mask),2);
                                corr_matrix(:,1)=cond_a(1,mask,m);
                                corr_matrix(:,2)=cond_b(1,mask,repeat_index(m));
                                holder=corrcoef(corr_matrix);
                                ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS(m)=holder(2,1);
                                %% Original-Repeat ERS - matrix
                                matrix_holder=zeros(length(repeat_index),1);
                                for t=1:length(repeat_index)
                                    holder=[];
                                    corr_matrix=zeros(length(mask),2);
                                    corr_matrix(:,1)=cond_a(1,mask,m);
                                    corr_matrix(:,2)=cond_b(1,mask,repeat_index(t));
                                    holder=corrcoef(corr_matrix);
                                    matrix_holder(t)=holder(2,1);
                                end
                                ERS.(sub_ID).(masks_names{c}).block(n).repeat_ERS_matrix{m}=matrix_holder;
                                
                                %% Original-Lure ERS
                                corr_matrix=zeros(length(mask),2);
                                corr_matrix(:,1)=cond_a(1,mask,m);
                                corr_matrix(:,2)=cond_b(1,mask,lure_index(m));
                                holder=corrcoef(corr_matrix);
                                ERS.(sub_ID).(masks_names{c}).block(n).lure_ERS(m)=holder(2,1);
                                %% Orinial-All new ERS -average
                                av_holder=zeros(length(new_index),1);
                                for h=1:length(new_index)
                                    corr_matrix=zeros(length(mask),2);
                                    corr_matrix(:,1)=cond_a(1,mask,m);
                                    corr_matrix(:,2)=cond_b(1,mask,new_index(h));
                                    holder=corrcoef(corr_matrix);
                                    av_holder(h)=holder(2,1);
                                end
                                ERS.(sub_ID).(masks_names{c}).block(n).new_ERS(m)=nanmean(av_holder);
                            end
                        end
                    end
                end
                
            end
        end
    end
end
save('ERS_all','ERS')

end