#!/bin/bash

m=30
beta=1.0
alpha_reconstructed=0.0
alpha_generated=0.0
neg_dataset='emnist-letters'
base_filter_num=32 # Here it is irrelevant
train_dataset='fashion_mnist'
test_dataset_a='fashion_mnist'
test_dataset_b='mnist'
use_augmented_variance_loss=False
seed=0
normal_class=-1
model_architecture='baseline_mnist'
lr_schedule='constant'
obs_noise_model='bernoulli'
initial_log_gamma=0.0
reg_lambda=1.0

neg_prior=False # this codepath applies margin
mml=False
neg_prior_mean_coeff=0.0
beta_neg=-1.0 #here mml=False, mml=True multiplies beta_neg with -1, this is the AE part
alpha_neg=1.0 #this should be positive as margin already "multiplies" alpha_neg with -1

name_prefix='FIN_2NDP_bernoulli_1_neg_letters_negelbomargo'
for seed in 1 2 3 4 5
do
   name="${name_prefix}_${initial_log_gamma}_${test_dataset_a}_vs_${test_dataset_b}_alpha_rec=${alpha_reconstructed}_alpha_gen=${alpha_generated}_alpha_neg=${alpha_neg}_neg_ds=${neg_dataset}_beta=${beta}_seed=${seed}"
   CUDA_VISIBLE_DEVICES=1 python main.py --beta_neg=${beta_neg} --mml=${mml} --neg_prior_mean_coeff=${neg_prior_mean_coeff} --initial_log_gamma ${initial_log_gamma} --trained_gamma False --optimizer 'rmsprop' --add_obs_noise False --reg_lambda ${reg_lambda} --obs_noise_model ${obs_noise_model} --neg_prior ${neg_prior} --neg_train_size 60000 --neg_test_size 10000 --alpha_neg ${alpha_neg} --neg_dataset ${neg_dataset} --name "${name_prefix}_${test_dataset_a}_vs_${test_dataset_b}_${model_architecture}" --seed ${seed} --color False --use_augmented_variance_loss ${use_augmented_variance_loss} --test_dataset_b ${test_dataset_b} --test_dataset_a ${test_dataset_a} --model_architecture ${model_architecture} --oneclass_eval True --normal_class ${normal_class} --gcnorm None --dataset ${train_dataset} --shape 28,28 --train_size 50000 --test_size 10000 --m ${m} --alpha_reconstructed ${alpha_reconstructed} --alpha_generated ${alpha_generated} --beta ${beta} --latent_dim 10 --batch_size 64 --lr 0.0001 --nb_epoch 100 --prefix pictures/${name} --model_path pictures/${name}/model --save_latent True --base_filter_num ${base_filter_num} --encoder_use_bn False --encoder_wd 0.00000 --generator_use_bn False --generator_wd 0.00000 --frequency 1000 --verbose 2 --resnet_wideness 1 --lr_schedule ${lr_schedule} > pictures/${name}.cout 2> pictures/${name}.cerr
done