pageextension 50591 pageextension50591 extends "Qualification Overview Matrix"
{

    //Unsupported feature: Code Modification on "MatrixOnDrillDown(PROCEDURE 1046)".

    //procedure MatrixOnDrillDown();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    EmployeeQualification.SETRANGE("Employee No.","No.");
    EmployeeQualification.SETRANGE("Qualification Code",MatrixRecords[ColumnID].Code);
    PAGE.RUN(PAGE::"Qualified Employees",EmployeeQualification);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //EmployeeQualification.SETRANGE("Employee No.","No."); //Standard Code Commented
    EmployeeQualification.SETRANGE("No.","No.");  //AGNI2017CU8
    EmployeeQualification.SETRANGE("Qualification Code",MatrixRecords[ColumnID].Code);
    PAGE.RUN(PAGE::"Qualified Employees",EmployeeQualification);
    */
    //end;


    //Unsupported feature: Code Modification on ""MATRIX_OnAfterGetRecord"(PROCEDURE 1047)".

    //procedure "MATRIX_OnAfterGetRecord"();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    EmployeeQualification.SETRANGE("Employee No.","No.");
    EmployeeQualification.SETRANGE("Qualification Code",MatrixRecords[ColumnID].Code);
    Qualified := EmployeeQualification.FINDFIRST;
    EmployeeQualification.SETRANGE("Employee No.");
    EmployeeQualification.SETRANGE("Qualification Code");
    MATRIX_CellData[ColumnID] := Qualified;
    SetVisible;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //EmployeeQualification.SETRANGE("Employee No.","No.");  //Standard Code Commented
    EmployeeQualification.SETRANGE("No.","No.");  //AGNI2017CU8
    EmployeeQualification.SETRANGE("Qualification Code",MatrixRecords[ColumnID].Code);
    Qualified := EmployeeQualification.FINDFIRST;
    //EmployeeQualification.SETRANGE("Employee No.");  Standard Code Commented
    EmployeeQualification.SETRANGE("No.");  //AGNI2017CU8
    #5..7
    */
    //end;
}

