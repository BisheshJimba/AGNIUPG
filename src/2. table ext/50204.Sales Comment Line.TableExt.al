tableextension 50204 tableextension50204 extends "Sales Comment Line"
{
    fields
    {

        //Unsupported feature: Code Insertion on "Comment(Field 6)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        "Assigned User ID" := USERID; //**SM 31-07-2013 to pass user id in comment lines
        */
        //end;
        field(50000; "Assigned User ID"; Code[20])
        {
        }
    }
}

