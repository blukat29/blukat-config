TARGET=/etc/apt/sources.list
cp $TARGET $TARGET.bak
cat $TARGET | awk '
$0 !~ /^deb/ { print $0; next; }
$0 ~ /security/ { print $0; next; }
$0 ~ /^deb/ { print $1, "http://kr.archive.ubuntu.com/ubuntu/", $3, $4, $5, $6; }' > $TARGET.new
sed 's/\s\+$//' $TARGET.new > $TARGET
