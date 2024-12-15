
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
RESET="\033[0m"

function run_test()
{
  printf "%-24s" "$1"

  rm -rf $1-test
  make $1-test >/dev/null 2>&1 || true

  failing_test_cases=""

  if [[ ! -e "$1-test" ]]; then
    printf "${YELLOW}ERROR${RESET}  "
    echo "could not compile this test" > $1-test.log
    echo "FAILED" >> $1-test.log
  else
    ./$1-test > $1-test.log
    if grep -q FAILED $1-test.log; then

      failing_test_cases=$(grep 'FAILED' $1-test.log | awk '{print $1}' | sed 's/^test_case_[0-9]*_//' | paste -sd ",")
      if [[ ${#failing_test_cases} -gt 28 ]]; then
        failing_test_cases="${failing_test_cases:0:28}..."
      fi

      printf "${RED}FAILED${RESET} "

    elif grep -q timeout $1-test.log; then
      failing_test_cases=" timeout"
      printf "${RED}FAILED${RESET}"
    else
      printf "${GREEN}passed${RESET} "
    fi
  fi

  printf "${failing_test_cases}\n"
}

echo "Test Bench          submission "

echo "------------------------------"

run_test BinaryToBinCodedDec_GL
run_test BinaryToSevenSeg_GL
run_test Display_GL

echo "------------------------------"

run_test FullAdder_GL
run_test AdderRippleCarry_4b_GL
run_test Mux2_1b_GL
run_test Mux2_4b_GL
run_test AdderCarrySelect_8b_GL

echo "------------------------------"

run_test Mux2_RTL
run_test Mux4_RTL
run_test Mux8_RTL
run_test Register_RTL
run_test Adder_32b_GL
run_test EqComparator_32b_RTL
run_test ALU_32b
run_test Multiplier_32x32b_RTL
run_test ImmGen_RTL
run_test RegfileZ1r1w_32x32b_RTL
run_test RegfileZ2r1w_32x32b_RTL

echo "------------------------------"

