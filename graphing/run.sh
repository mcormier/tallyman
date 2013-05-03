
function extractData() {
  cp template extractScript
  sed -i "s/#FILENAME/${1}/g" extractScript
  sed -i "s/#LIFTNAME/${2}/g" extractScript
  sed -i "s/#REPS/${3}/g" extractScript

  sqlite3 ../data/tallyMan2013.db < extractScript

  echo "created data/$1"
  rm extractScript
}

function extractLift() {
  extractData "${1}1RM" "${2}" 1
  extractData "${1}3RM" "${2}" 3
  extractData "${1}5RM" "${2}" 5
}

extractLift deadlift Deadlift
extractLift backsquat "Back Squat"
extractLift overheadsquat "Overhead Squat"
extractLift cleanandjerk "Clean \& Jerk"
extractLift snatch "Snatch"
extractLift clean "Clean"
extractLift frontsquat "Front Squat"
extractLift shoulderpress "Shoulder Press"
extractLift pushpress "Push Press"
extractLift pushjerk "Push Jerk"
extractLift sotspress "Sots Press"

gnuplot input.gpi
