version=$(cat version.env | grep version | awk -F "=" '{print $2}' | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
rm version.env
echo "version="$version >> version.env