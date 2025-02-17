tableextension 50361 tableextension50361 extends "Service Header"
{
    fields
    {
        modify("Bill-to City")
        {
            TableRelation = IF (Bill-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
        }
        modify("Ship-to City")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Bill-to Post Code")
        {
            TableRelation = IF (Bill-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
        }
        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Ship-to Post Code")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Shipped"(Field 5752)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Hours"(Field 5911)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Unallocated Items"(Field 5921)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reallocation Needed"(Field 5934)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Allocations"(Field 5939)".

        modify("Contract No.")
        {
            TableRelation = "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract),
                                                                            Customer No.=FIELD(Customer No.),
                                                                            Ship-to Code=FIELD(Ship-to Code),
                                                                            Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
    }

    //Unsupported feature: Code Modification on "UpdateCust(PROCEDURE 25)".

    //procedure UpdateCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF Cont.GET(ContactNo) THEN BEGIN
          "Contact No." := Cont."No.";
          "Phone No." := Cont."Phone No.";
        #4..8
          EXIT;
        END;

        IF Cont.Type = Cont.Type::Person THEN
          "Contact Name" := Cont.Name
        ELSE
          IF Cust.GET("Customer No.") THEN
        #16..38
           ("Bill-to Customer No." = '')
        THEN
          VALIDATE("Bill-to Contact No.","Contact No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..11
        IF Cont.Type = Cont.Type::Company THEN
        #13..41
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateBillToCust(PROCEDURE 26)".

    //procedure UpdateBillToCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF Cont.GET(ContactNo) THEN BEGIN
          "Bill-to Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Person THEN
            "Bill-to Contact" := Cont.Name
          ELSE
            IF Cust.GET("Bill-to Customer No.") THEN
        #7..25
              ERROR(Text037,Cont."No.",Cont.Name,"Bill-to Customer No.");
        END ELSE
          ERROR(Text039,Cont."No.",Cont.Name);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF Cont.GET(ContactNo) THEN BEGIN
          "Bill-to Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Company THEN
        #4..28
        */
    //end;
}

