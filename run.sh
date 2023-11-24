#!/bin/bash


set -eux

echo "All Argument: $@"


commons="budgets cloudfront ecrpublic iam organization route53 waf"
excludes="budgets,cloudfront,ecrpublic,iam,organization,route53,waf"


### .env
#profiles="default"

#regions="ap-northeast-1 us-west-2"
#regions="ap-northeast-1"

#services=$(terraformer import aws list)
#services="ec2_instance s3"


function importAWS() {

  echo "================ START =============================" | tee -a $(date +"%Y%m%d").log

  local profile="$1"
  local region="$2"
  local service="$3"

  #region="us-west-2";
  #service="ec2_instance";

  echo "profile=$profile"
  echo "region=$region"
  echo "service=$service"
  echo ""


  if [[ "$region" == "common" ]]; then
    echo "terraformer import aws -r $(echo $service)  --profile=$(echo $profile) -p {provider}/$(echo $profile)/$(echo $region)/{service}/" | tee -a $(date +"%Y%m%d").log
    terraformer import aws -r $(echo $service)  --profile=$(echo $profile) -p {provider}/$(echo $profile)/$(echo $region)/{service}/ | tee -a $(date +"%Y%m%d").log
    echo ""
  else
    echo "terraformer import aws -r $(echo $service) --regions=$(echo $region) --profile=$(echo $profile) --excludes=$(echo $excludes) -p {provider}/$(echo $profile)/$(echo $region)/{service}/" | tee -a $(date +"%Y%m%d").log
    terraformer import aws -r $(echo $service) --regions=$(echo $region) --profile=$(echo $profile) --excludes=$(echo $excludes) -p {provider}/$(echo $profile)/$(echo $region)/{service}/ | tee -a $(date +"%Y%m%d").log
    echo ""
  fi
  
  #infracost breakdown --path ./aws/$(echo $profile)/$(echo $region)/$(echo $service) --format table --out-file ./aws/$(echo $profile)/$(echo $region)/$(echo $service)/infracost.table
  #infracost breakdown --path ./aws/$(echo $profile)/$(echo $region)/$(echo $service) --format json --out-file ./aws/$(echo $profile)/$(echo $region)/$(echo $service)/infracost.json
  #infracost breakdown --path ./aws/$(echo $profile)/$(echo $region)/$(echo $service) --format html --out-file ./aws/$(echo $profile)/$(echo $region)/$(echo $service)/infracost.html

  echo "================ END =============================" | tee -a $(date +"%Y%m%d").log
  echo ""

}


function main() {

  for profile in $profiles
  do
    for region in $regions
    do
      for service in $services
      do
        importAWS $profile $region $service
      done
    done

    for common in $commons
    do
      importAWS $profile common $common
    done
  done

  # 等待所有工作完成
  #wait

}






start_time=$(date +%s);

NOW=$(date +"%Y/%m/%d/%H/%M/%S/%N")
echo "NOW=[$NOW]";


##pip3 install awscli
#aws --version
#aws configure set aws_access_key_id "${AWS_ACCESS_KEY}"
#aws configure set aws_secret_access_key "${AWS_SECRET_KEY}"



main;



function infracostAWS() {


./aws/yowoo/ap-northeast-1/acm/provider.tf
./aws/yowoo/ap-northeast-1/ec2_instance/provider.tf



find . -iname provider.tf


infracost breakdown --path . --format table --out-file ./infracost.table
infracost breakdown --path . --format json --out-file ./infracost.json
infracost breakdown --path . --format html --out-file ./infracost.html

infracost breakdown --path ./aws/yowoo/ap-northeast-1/ec2_instance --format html --out-file infracost.html



}

#infracostAWS;


echo "掰掰";


end_time=$(date +%s)
runtime=$((end_time - start_time));
printf "Execution time: %.6f seconds\n" $runtime




exit 0
