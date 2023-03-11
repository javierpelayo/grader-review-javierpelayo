CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

let TESTCNT=0
rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

# TEST 1

FILE=`find student-submission -name "ListExamples.java" -maxdepth 1`
if [[ -f $FILE ]] && [[ $FILE = *ListExamples.java* ]]
then
    echo 'ListExamples.java file exists.'
    let TESTCNT++
else
    echo "ListExamples.java file does not exist."
    echo "Score: (0/5)"
    exit 1
fi


cd student-submission

cp ../TestListExamples.java .
cp -r ../lib lib

javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java &> ../output-compiler.txt
java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples &> ../output-runtime.txt

EXIST_METHOD1=`grep -c "static List<String> filter(List<String> list, StringChecker sc)" ListExamples.java`

EXIST_METHOD2=`grep -c "static List<String> merge(List<String> list1, List<String> list2)" ListExamples.java`

cd ..

INFO=`grep -i "ListExamples.java" output-compiler.txt` 
FAIL=`grep -i -c "FAILURE" output-runtime.txt` 
SUCC=`grep -i -c "OK" output-runtime.txt`

# TEST 2

if [[ $EXIST_METHOD1 -gt 0 ]]
then
	echo "Method Signature one is OK!!!"
    let TESTCNT++
else
    echo "Method signature one is WRONG!!!"
    echo "Score: (1/5)"
    exit 1
fi


# TEST 3

if [[ $EXIST_METHOD2 -gt 0 ]]
then
    echo "Method Signature two is OK!!!"
    let TESTCNT++
else
    echo "Method Signature two is WRONG!!!"
    echo "Score: (2/5)"
    exit 1
fi


# TEST 4 and 5

if [[ $INFO ]]
then
    echo $INFO "- COMPILER ERROR!!!"
    echo "Score: (3/5)"
else
    let TESTCNT++
fi

if [[ $FAIL -gt 0 ]]
then
    echo "Test cases failed. - RUNTIME ERROR!!!"
    echo "Score: (4/5)"
elif [[ $SUCC -gt 0 ]]
then
    echo "Test cases succeeded."
    let TESTCNT++
else
    echo "Something went wrong."
    echo "Score: (4/5)"
fi


echo "All tests completed with a score of $TESTCNT/5!"

































