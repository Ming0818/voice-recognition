%FUNCTION TO inject Wavelet SBC parameters into the database
% intial copy modified on 21-01-08
%to extract wavelet SBC feature and save into a file
%


function SBC_feat_inject(sig,features_sbc_file,na,matchstatus)


No_of_Gaussians=12;
load(features_sbc_file);
% no_of_fe will have the no of saved feature
% fe matrix will have the feature

fe=sbc_2(sig,8000);

if matchstatus == 0
    no_of_fe=no_of_fe+1;
    LEN=length(na);
    name(no_of_fe,1:LEN)=char(na);
    mu_initial = 0;
    sigma_initial = 0;
    c_initial = 0;
    
    [mu_train,sigma_train,c_train]=gmm_estimate(fe(:,5:12)',No_of_Gaussians,20,mu_initial,sigma_initial,c_initial);
    fea{no_of_fe,1}=mu_train;
    fea{no_of_fe,2}=sigma_train;
    fea{no_of_fe,3}=c_train;
else
    %take the initial parameters from the previous sample
    LEN=length(na);
    name(matchstatus,1:LEN)=char(na);    
    mu_initial = fea{matchstatus,1};
    sigma_initial = fea{matchstatus,2};
    c_initial = fea{matchstatus,3};
    [mu_train,sigma_train,c_train]=gmm_estimate(fe(:,5:12)',No_of_Gaussians,20,mu_initial,sigma_initial,c_initial);
    fea{matchstatus,1}=mu_train;
    fea{matchstatus,2}=sigma_train;
    fea{matchstatus,3}=c_train;

end
   
save(features_sbc_file,'no_of_fe','name','fea');

