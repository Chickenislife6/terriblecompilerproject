A terrible compiler with only declerations, expressions inside if statements, and print statements which only take identifiers.
syntax:
identifier: type = corresponding_value;
if(expression) {
    statements;
};
print(identifier);
END

END must be at the end of files to compile properly
run 
make compiler
./compiler
edit compiled.s in any way to rechange encoding to a type gcc likes?
gcc compiled.s
./a

voila!