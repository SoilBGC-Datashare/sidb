if LC_ALL=C grep -r '[![:cntrl:][:print:]]' ../data/; then
  echo "Contain Non-ASCII"
fi
