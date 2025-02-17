tableextension 50265 tableextension50265 extends "Employee Qualification"
{
    DataCaptionFields = "No.";
    fields
    {
        modify("Employee No.")
        {

            //Unsupported feature: Property Modification (Name) on ""Employee No."(Field 1)".

            TableRelation = IF (Table Name=CONST(Employee)) Employee.No.
                            ELSE IF (Table Name=CONST(Application)) Application.No.;
        }

        //Unsupported feature: Property Insertion (AutoIncrement) on ""Line No."(Field 2)".


        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 12)".

        field(50000; "Table Name"; Option)
        {
            OptionMembers = " ",Application,Employee;
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Employee No.,Line No."(Key)".

        key(Key1; "No.", "Line No.", "Table Name")
        {
            Clustered = true;
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Employee.GET("Employee No.");
    "Employee Status" := Employee.Status;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    Employee.GET("No.");
    "Employee Status" := Employee.Status;
    */
    //end;
}

