echo "----------------------------------------"
echo "Compiling contracts ... "
echo "----------------------------------------"

SMART_PY_CLI=~/smartpy-cli/SmartPy.sh

OUT_DIR=./build/.tmp_contract_build

if [ ! -f "$SMART_PY_CLI" ]; then
    echo "Fatal: Please install SmartPy CLI at $SMART_PY_CLI" && exit
fi

function processContract {
    CONTRACT_NAME=$1
    OUT_DIR=$2
    CONTRACT_IN="./contracts/${CONTRACT_NAME}.py"
    CONTRACT_OUT="${CONTRACT_NAME}.json"
    STORAGE_OUT="${CONTRACT_NAME}_storage.json"
    CONTRACT_COMPILED="${CONTRACT_NAME}/step_000_cont_0_contract.json"
    STORAGE_COMPILED="${CONTRACT_NAME}/step_000_cont_0_storage.json"

    echo ">> Processing ${CONTRACT_NAME}"

    if [ ! -f "$CONTRACT_IN" ]; then
        echo "Fatal: $CONTRACT_IN not found. Running from wrong dir?" && exit
    fi

    echo ">>> [1 / 3] Testing ${CONTRACT_NAME} ... "
    $SMART_PY_CLI test $CONTRACT_IN $OUT_DIR --html

    echo ">>> [2 / 3] Compiling ${CONTRACT_NAME} ..."
    $SMART_PY_CLI compile $CONTRACT_IN $OUT_DIR --html

    echo ">>> [3 / 3] Extracting Michelson contract ... "
    cp $OUT_DIR/$CONTRACT_COMPILED ./build/$CONTRACT_OUT
    cp $OUT_DIR/$STORAGE_COMPILED ./build/$STORAGE_OUT

    echo ">>> Michelson contract written to ${CONTRACT_OUT}"
}

export PYTHONPATH=$PWD


echo "> [1 / 2] Unit Testing and Compiling Contracts."
for n in $(seq 1 $#); do
  processContract $1 $OUT_DIR
  shift
done

echo "> [2 / 2] Cleaning up ..."
rm -rf $OUT_DIR
rm -rf ./contracts/__pycache__
rm -rf ./__pycache__


echo "> Removed artifacts."