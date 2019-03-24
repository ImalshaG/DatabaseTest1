import ballerina/io;
import ballerina/sql;
import ballerinax/jdbc;

jdbc:Client TestDB1 = new({
        url: "jdbc:mysql://localhost:3306/testdb",
        username: "root",
        password: "",
        poolOptions: { maximumPoolSize: 5 },
        dbOptions: { useSSL: false }
    });
type Student record {
    int id;
    int age;
    string name;
};
function handleUpdate(int|error returned, string message) {
    if (returned is int) {
        io:println(message + " status: " + returned);
    } else {
        io:println(message + " failed: " + <string>returned.detail().message);
    }
}

public function main() {
    io:println("\nThe select operation - Select data from a table");
    var selectRet = TestDB1->select("SELECT * FROM student", Student, loadToMemory=true);
    table<Student> dt;
    if (selectRet is table<Student>) {
        var jsonConversionRet = json.convert(selectRet);
        if (jsonConversionRet is json) {
            io:println("JSON: ", io:sprintf("%s", jsonConversionRet));
            foreach var row in selectRet {
                io:println("Student:" + row.id + "|" + row.name + "|" + row.age);
            }
        } else {
            io:println("Error in table to json conversion");
        }
    } else {
        io:println("Select data from student table failed: "
                + <string>selectRet.detail().message);
    }
}
