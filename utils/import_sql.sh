for file in /tmp/sql/*.sql; do

  echo "Importando $file..."

  mysql -u root -p root acis < "$file"

done